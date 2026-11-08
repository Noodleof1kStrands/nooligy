{ self, ... }: {

  flake.modules.nixos.system-first-boot =
    { config, lib, pkgs, ... }:
    let
      normalUsers = lib.filter (
        name: config.users.users.${name}.isNormalUser or false
      ) (lib.attrNames config.users.users);
    in
    lib.mkIf (normalUsers != [ ]) (
      let
        user = lib.head normalUsers;
        account = config.users.users.${user};
        home = account.home;
        firstBoot = pkgs.writeShellApplication {
          name = "ojuny-first-boot";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.gnugrep
          ];
          text = ''
            log="${home}/first-boot.log"
            if [ -e "$log" ]; then
              exit 0
            fi
            mkdir -p "${home}"
            printf 'kernel_start=%s\n' "$(date -u -d "@$(( $(date +%s) - $(cut -d. -f1 /proc/uptime) ))" +%Y-%m-%dT%H:%M:%SZ)" >"$log"
            printf 'display_manager=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >>"$log"
            chown "${toString account.uid}:${account.group}" "$log"
          '';
        };
      in
      {
        systemd.services.ojuny-first-boot = {
          description = "Record the first boot timing";
          wantedBy = [ "multi-user.target" ];
          after = [ "display-manager.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${firstBoot}/bin/ojuny-first-boot";
          };
        };
      }
    );

  flake.modules.nixos.system-multiboot-backend =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.ojuny.multiboot;

      bootMountPoint =
        if config.boot.loader.systemd-boot.xbootldrMountPoint != null then
          config.boot.loader.systemd-boot.xbootldrMountPoint
        else
          config.boot.loader.efi.efiSysMountPoint;

      helperDir = "${bootMountPoint}/EFI/ojuny/multiboot";
      entryFile = "${bootMountPoint}/loader/entries/ojuny-other-systems.conf";

      refindAssets = pkgs.runCommand "ojuny-refind-assets" { } ''
        mkdir -p $out
        cp ${pkgs.refind}/share/refind/refind_x64.efi $out/
        cp -r ${pkgs.refind}/share/refind/icons $out/
        cp -r ${pkgs.refind}/share/refind/fonts $out/
        cp -r ${pkgs.refind}/share/refind/images $out/
      '';

      multiboot = pkgs.writeShellApplication {
        name = "ojuny-multiboot";
        runtimeInputs = with pkgs; [
          coreutils
          cryptsetup
          diffutils
          efibootmgr
          findutils
          gawk
          gnugrep
          gnused
          jq
          sbctl
          util-linux
        ];
        text = builtins.readFile ./multiboot.sh;
      };

      cleanup = pkgs.writeShellApplication {
        name = "ojuny-multiboot-cleanup";
        runtimeInputs = with pkgs; [
          coreutils
        ];
        text = builtins.readFile ./multiboot-cleanup.sh;
      };

      environment = {
        OJUNY_BOOT_MOUNT = bootMountPoint;
        OJUNY_ESP_MOUNT = config.boot.loader.efi.efiSysMountPoint;
        OJUNY_HELPER_DIR = helperDir;
        OJUNY_ENTRY_FILE = entryFile;
        OJUNY_REFIND_ASSETS = refindAssets;
        OJUNY_CAN_TOUCH_EFI = lib.boolToString config.boot.loader.efi.canTouchEfiVariables;
        OJUNY_PKI_BUNDLE =
          if config.boot.lanzaboote.pkiBundle == null then
            ""
          else
            toString config.boot.lanzaboote.pkiBundle;
      };
    in
    {
      options.ojuny.multiboot.enable = lib.mkEnableOption "the rEFInd multiboot helper";

      config = lib.mkMerge [
        (lib.mkIf cfg.enable {
          systemd.services.ojuny-multiboot = {
            description = "Install the rEFInd multiboot helper and scan other systems";
            wantedBy = [ "multi-user.target" ];
            after = [ "local-fs.target" ];
            before = [ "shutdown.target" ];
            environment = environment;
            unitConfig.ConditionPathExists = "/sys/firmware/efi";
            unitConfig.ConditionPathIsMountPoint = bootMountPoint;
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${multiboot}/bin/ojuny-multiboot";
            };
          };
        })
        (lib.mkIf (!cfg.enable) {
          systemd.services.ojuny-multiboot-cleanup = {
            description = "Remove the rEFInd multiboot helper";
            wantedBy = [ "multi-user.target" ];
            after = [ "local-fs.target" ];
            before = [ "shutdown.target" ];
            environment = {
              OJUNY_BOOT_MOUNT = bootMountPoint;
              OJUNY_HELPER_DIR = helperDir;
              OJUNY_ENTRY_FILE = entryFile;
            };
            unitConfig.ConditionPathExists = "/sys/firmware/efi";
            unitConfig.ConditionPathIsMountPoint = bootMountPoint;
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${cleanup}/bin/ojuny-multiboot-cleanup";
            };
          };
        })
      ];
    };

  flake.modules.nixos.system-bootorder =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      bootMountPoint = config.boot.loader.efi.efiSysMountPoint;
      recoveryEnabled = config.ojuny.recovery.enable;
      recoveryFile = "${bootMountPoint}/EFI/ojuny/recovery/ojuny-recovery.efi";

      bootorder = self.packages.${pkgs.system}.ojuny-bootorder;
    in
    {
      systemd.services.ojuny-bootorder = {
        description = "Keep the Ojuny entries first among the internal boot entries";
        wantedBy = [ "multi-user.target" ];
        after =
          [ "local-fs.target" ]
          ++ lib.optional recoveryEnabled "ojuny-recovery.service"
          ++ lib.optional config.ojuny.multiboot.enable "ojuny-multiboot.service";
        before = [ "shutdown.target" ];
        unitConfig.ConditionPathExists = "/sys/firmware/efi";
        environment = {
          OJUNY_BOOT_MOUNT = bootMountPoint;
          OJUNY_RECOVERY_FILE = recoveryFile;
          OJUNY_RECOVERY_ENABLED = lib.boolToString recoveryEnabled;
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${bootorder}/bin/ojuny-bootorder";
        };
      };
    };

  flake.modules.homeManager.first-boot =
    { pkgs, ... }:
    {
      systemd.user.services.ojuny-login-ready = {
        Unit = {
          Description = "Record the login-ready timestamp";
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${
            pkgs.writeShellScript "ojuny-login-ready" ''
              log="$HOME/first-boot.log"
              if [ -e "$log" ] && ! grep -q '^login_ready=' "$log"; then
                printf 'login_ready=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >>"$log"
              fi
            ''
          }";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };

}

{ self, inputs, ... }: {

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

}

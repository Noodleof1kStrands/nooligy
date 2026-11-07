 { self, ... }:

{
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
}

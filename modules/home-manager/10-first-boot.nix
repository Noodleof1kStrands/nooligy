 { pkgs, ... }:

{
  flake.modules.homeManager.first-boot = {
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

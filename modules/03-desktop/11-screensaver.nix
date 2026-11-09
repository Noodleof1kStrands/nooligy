/*
  @menu
  displayname = "Screensaver";
  icon = "preferences-desktop-screensaver-symbolic";
  order = 65;
  description = "ASCII screensaver before the lock screen";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-screensaver =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.ojuny.screensaver;
    in
    {
      options.ojuny.screensaver = {
        enable = lib.mkEnableOption "the ASCII screensaver";
        idleSeconds = lib.mkOption {
          type = lib.types.int;
          default = 120;
        };
        terminal = lib.mkOption {
          type = lib.types.str;
          default = "foot --app-id=org.ojuny.screensaver";
        };
        command = lib.mkOption {
          type = lib.types.str;
          default = "${pkgs.cmatrix}/bin/cmatrix -b";
        };
      };

      config = {
        # @option widget = "switch"; label = "Screensaver"; group = "Screensaver"; description = "Show a terminal screensaver before the DMS lock.";
        ojuny.screensaver.enable = false;

        # @option widget = "spin"; label = "Idle seconds"; group = "Screensaver"; min = 10; description = "Must be lower than the DMS lock timeout.";
        ojuny.screensaver.idleSeconds = 120;

        # @option widget = "text"; label = "Terminal command prefix"; group = "Screensaver"; advanced = true; description = "Flags placed before the command, e.g. foot --app-id=org.ojuny.screensaver.";
        ojuny.screensaver.terminal = "foot --app-id=org.ojuny.screensaver";

        # @option widget = "text"; label = "Screensaver command"; group = "Screensaver"; description = "Command run inside the terminal, e.g. cmatrix -b or pipes.sh.";
        ojuny.screensaver.command = "${pkgs.cmatrix}/bin/cmatrix -b";

        environment.systemPackages = lib.mkIf cfg.enable (
          with pkgs;
          [
            cmatrix
            foot
            swayidle
            (writeShellScriptBin "ojuny-screensaver" ''
              set -euo pipefail
              pid_file="''${XDG_RUNTIME_DIR:-/tmp}/ojuny-screensaver.pid"
              case "''${1:-start}" in
                start)
                  [ -f "$pid_file" ] && exit 0
                  ${cfg.terminal} ${lib.getExe pkgs.bash} -c ${lib.escapeShellArg cfg.command} &
                  echo "$!" > "$pid_file"
                  ;;
                stop)
                  [ -f "$pid_file" ] || exit 0
                  kill "$(cat "$pid_file")" 2>/dev/null || true
                  rm -f "$pid_file"
                  ;;
              esac
            '')
          ]
        );

        desktop.ojuny.mango.rules.window_rule = lib.mkIf cfg.enable [
          {
            app_id = "org.ojuny.screensaver";
            is_fullscreen = 1;
            is_floating = 1;
            no_animation = 1;
            focused_opacity = 1.0;
            unfocused_opacity = 1.0;
          }
        ];

        desktop.ojuny.mango.execOnce = lib.mkIf cfg.enable [
          "${pkgs.swayidle}/bin/swayidle -w timeout ${toString cfg.idleSeconds} 'ojuny-screensaver start' resume 'ojuny-screensaver stop'"
        ];
      };
    };

  flake.modules.homeManager.desktop-screensaver =
    {
      lib,
      osConfig ? { },
      ...
    }:
    {
      config = lib.mkIf (osConfig.ojuny.screensaver.enable or false) {
        programs.foot.enable = true;
      };
    };
}

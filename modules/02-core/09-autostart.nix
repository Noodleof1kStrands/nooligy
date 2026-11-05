/*
  @menu
  displayname = "Startup";
  icon = "system-run-symbolic";
  order = 90;
  description = "Commands run at login and on reload";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-autostart = { ... }: {

    config = {
      # A plain assignment replaces the option's default, so the upstream
      # startup commands are listed here to keep them (and to make them
      # editable). "dms run" resolves to the configured Dux Modular Shell
      # because the session wrapper puts it on PATH.

      # @option widget = "list"; label = "Run once at login"; group = "Session commands"; description = "Started when the session opens.";
      desktop.ojuny.mango.execOnce = [
        "dms run"
        "dcal run -d --hidden"
        "wl-clip-persist --clipboard both"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "ghostty"
        "ydotoold"
      ];

      # @option widget = "list"; label = "Run on every reload"; group = "Session commands"; description = "Started after each mango config reload.";
      desktop.ojuny.mango.exec = [ ];

      # @option widget = "list"; label = "Extra config files"; group = "Session commands"; description = "Additional mango config files sourced after the generated one.";
      desktop.ojuny.mango.source = [ ];

      # @option widget = "raw"; label = "Environment variables"; group = "Environment"; rows = 8; description = "Wayland session variables every mango child process inherits.";
      desktop.ojuny.mango.env = {
        XDG_SESSION_DESKTOP = "wlroots";
        XDG_CURRENT_DESKTOP = "wlroots";
        QT_QPA_PLATFORM = "wayland;xcb";
        MOZ_ENABLE_WAYLAND = "1";
        OZONE_PLATFORM = "wayland";
        NIXOS_OZONE_WL = "1";
        WLR_RENDERER_ALLOW_SOFTWARE = "1";
      };
    };

  };

}

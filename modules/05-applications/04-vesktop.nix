/*
  @menu
  displayname = "Vesktop";
  icon = "internet-chat-symbolic";
  order = 40;
  description = "Discord client";
  category = "05-Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-vesktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      options.ojuny.apps.vesktop.enable = lib.mkEnableOption "the Vesktop Discord client";

      config = {
        # @option widget = "switch"; label = "Vesktop (Discord)"; group = "Vesktop"; groupOrder = 10; order = 1;
        ojuny.apps.vesktop.enable = true;

        environment.systemPackages = lib.mkIf config.ojuny.apps.vesktop.enable [ pkgs.vesktop ];

        # Expose to the launcher and keybinds so `vesktop.desktop` resolves.
        desktop.ojuny.defaultApps = lib.optionals config.ojuny.apps.vesktop.enable [ pkgs.vesktop ];

        # @option widget = "text"; label = "Discord links"; group = "Default applications"; visibleWhen.path = "ojuny.apps.vesktop.enable"; visibleWhen.equals = true; applyCommand = "xdg-mime default %%val%% x-scheme-handler/discord";
        xdg.mime.defaultApplications."x-scheme-handler/discord" = "vesktop.desktop";
      };

    };

  # Vesktop keeps its settings per user, so the fields below live in
  # home-manager and follow the switch above through osConfig. The settings
  # only take effect once programs.vesktop.enable is derived true, so nothing
  # is written while Vesktop is off.
  flake.modules.homeManager.applications-vesktop =
    {
      config,
      lib,
      pkgs,
      osConfig ? { },
      ...
    }:
    {

      config = {
        # Derived, no @option: mirrors the system switch.
        programs.vesktop.enable = osConfig.ojuny.apps.vesktop.enable or false;

        # The system module already installs the package; HM only manages files.
        programs.vesktop.package = null;

        # @option widget = "switch"; label = "Merge settings on activation"; group = "Vesktop"; description = "Write the settings below into a real file so Vesktop can still change them."; visibleWhen.path = "ojuny.apps.vesktop.enable"; visibleWhen.equals = true;
        programs.vesktop.mutableSettings = true;

        # @option widget = "dropdown"; label = "Discord branch"; group = "Vesktop"; choices = [ "stable" "ptb" "canary" ]; visibleWhen.path = "ojuny.apps.vesktop.enable"; visibleWhen.equals = true;
        programs.vesktop.settings.discordBranch = "stable";

        # @option widget = "switch"; label = "Minimize to tray"; group = "Vesktop"; visibleWhen.path = "ojuny.apps.vesktop.enable"; visibleWhen.equals = true;
        programs.vesktop.settings.minimizeToTray = true;

        # @option widget = "switch"; label = "Tray icon"; group = "Vesktop"; visibleWhen.path = "ojuny.apps.vesktop.enable"; visibleWhen.equals = true;
        programs.vesktop.settings.tray = true;

        # @option widget = "switch"; label = "Rich presence (arRPC)"; group = "Vesktop"; description = "Share what you play with friends without the official RPC bridge."; visibleWhen.path = "ojuny.apps.vesktop.enable"; visibleWhen.equals = true;
        programs.vesktop.settings.arRPC = true;

        # @option widget = "switch"; label = "Check for updates"; group = "Vesktop"; description = "Updates arrive through nix rebuilds instead."; visibleWhen.path = "ojuny.apps.vesktop.enable"; visibleWhen.equals = true;
        programs.vesktop.settings.checkUpdates = false;

        # @option widget = "switch"; label = "Hardware acceleration"; group = "Vesktop"; visibleWhen.path = "ojuny.apps.vesktop.enable"; visibleWhen.equals = true;
        programs.vesktop.settings.hardwareAcceleration = true;

        # @option widget = "switch"; label = "Static window title"; group = "Vesktop"; advanced = true; visibleWhen.path = "ojuny.apps.vesktop.enable"; visibleWhen.equals = true;
        programs.vesktop.settings.staticTitle = false;

        # @option widget = "switch"; label = "Custom title bar"; group = "Vesktop"; advanced = true; visibleWhen.path = "ojuny.apps.vesktop.enable"; visibleWhen.equals = true;
        programs.vesktop.settings.customTitleBar = false;
      };

    };

}

/*
  @menu
  displayname = "DMS plugins";
  icon = "application-x-addon-symbolic";
  order = 20;
  description = "DMS plugins that ship with this desktop";
  category = "06-Utility";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-plugins = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "Manage plugin settings"; group = "Plugins"; groupOrder = 10; order = 5;
    desktop.ojuny.dux.managePluginSettings = true;

    # Plugins installed from the DMS plugin registry. The bar, control center
    # and menu ship widgets that need these, so they default to enabled.

    # @option widget = "plugins"; label = "Plugins"; group = "Plugins"; groupOrder = 10; order = 10;
    desktop.ojuny.dux.plugins = {
      dankMenu = {
        enable = true;
      };
      emojiLauncher = {
        enable = true;
        settings.trigger = ":e";
        settings.pasteOnSelect = true;
        settings.useDMS = true;
      };
      dankKDEConnect = {
        enable = true;
        settings.scanSubdirectories = true;
      };
      worldClock = {
        enable = true;
        settings.timezones = [
          {
            timezone = config.time.timeZone;
            label = "";
            showOnBar = true;
          }
        ];
        settings.showAll = true;
        settings.cycleInterval = 15;
        settings.use24h = true;
        settings.iconOnly = false;
      };
      nixMonitor = {
        enable = true;
        settings.showGenerations = true;
        settings.showStoreSize = true;
        settings.updateInterval = 3600;
        settings.updateCheckInterval = 3600;
        settings.gcThresholdGB = 100;
        config.gcCommand = [
          "sh"
          "-c"
          "exec nix-cleaner"
        ];
        config.rebuildCommand = [
          "sh"
          "-c"
          "exec nix-settings-gui"
        ];
      };
      localServices = {
        enable = true;
        settings.ignoredPorts = "";
        settings.exactWatches = "";
        settings.labels = "{}";
      };
      scratchpadHelper = {
        enable = true;
        settings.hideBarWhenEmpty = true;
        settings.namedManagerEnabled = false;
      };
      developerUtilities = {
        enable = true;
      };
      screenCaptureToolbar = {
        enable = true;
        settings.enableAudioRecorder = true;
        settings.multiMonitorScreenshot = true;
        settings.showNotify = false;
        settings.showRecPill = false;
        settings.toolbarOpacity = 1.00;
        settings.pillOpacity = 1.00;
      };
      commandRunner = {
        enable = true;
        settings.terminal = "ghostty";
        settings.trigger = ">";
        settings.execFlag = "-e";
      };
      webSearch = {
        enable = true;
      };
      virtualKeyboard = {
        enable = true;
      };
      dankCalendarAgenda = {
        enable = true;
        settings.barContentWidth = 120;
      };
    };

  };

}

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
        settings = {
          trigger = ":e";
          pasteOnSelect = true;
          useDMS = true;
        };
      };
      dankKDEConnect = {
        enable = true;
        settings = {
          scanSubdirectories = true;
        };
      };
      worldClock = {
        enable = true;
        settings = {
          timezones = [
            {
              timezone = config.time.timeZone;
              label = "";
              showOnBar = true;
            }
          ];
          showAll = true;
          cycleInterval = 15;
          use24h = true;
          iconOnly = false;
        };
      };
      nixMonitor = {
        enable = true;
        settings = {
          showGenerations = true;
          showStoreSize = true;
          updateInterval = 3600;
          updateCheckInterval = 3600;
          gcThresholdGB = 100;
        };
        # Both commands stay blocking argv arrays so nix-monitor's console and
        # Cancel keep working. The plugin only reads these two keys, so the
        # button labels stay "GC" and "Rebuild" whatever the command opens.
        config = {
          gcCommand = [ "sh" "-c" "exec nix-cleaner" ];
          rebuildCommand = [ "sh" "-c" "exec nix-settings-gui" ];
        };
      };
      localServices = {
        enable = true;
        settings = {
          ignoredPorts = "";
          exactWatches = "";
          labels = "{}";
        };
      };
      scratchpadHelper = {
        enable = true;
        settings = {
          hideBarWhenEmpty = true;
          namedManagerEnabled = false;
        };
      };
      developerUtilities = {
        enable = true;
      };
      screenCaptureToolbar = {
        enable = true;
        settings = {
          enableAudioRecorder = true;
          multiMonitorScreenshot = true;
          showNotify = false;
          showRecPill = false;
          toolbarOpacity = 1.0;
          pillOpacity = 1.0;
        };
      };
      commandRunner = {
        enable = true;
        settings = {
          terminal = "ghostty";
          trigger = ">";
          execFlag = "-e";
        };
      };
      webSearch = {
        enable = true;
      };
      virtualKeyboard = {
        enable = true;
      };
      dankCalendarAgenda = {
        enable = true;
        settings = {
          dynamicWidth = true;
          pillDisplayMode = "countdownOnly";
          barContentWidth = 120;
        };
      };
    };

  };

}

/*
  @menu
  displayname = "Lock screen";
  icon = "system-lock-screen-symbolic";
  order = 60;
  description = "Lock behaviour, authentication and screensaver";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-lock =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      u2fModes = {
        "security-key-only" = "or";
        "second-factor" = "and";
      };
    in
    {

      options.ojuny.dux.u2fMode = lib.mkOption {
        type = lib.types.enum (lib.attrNames u2fModes);
        default = "security-key-only";
        description = "DMS u2fMode.";
      };

      options.ojuny.authentication.fingerprint.enable = lib.mkEnableOption "fingerprint authentication";

      config = {

        # @option widget = "switch"; label = "Lock at startup"; group = "Behavior"; groupOrder = 10; order = 10; applyCommand = "dms ipc call settings set lockAtStartup %%val%%";
        desktop.ojuny.dux.settings.lockAtStartup = false;

        # @option widget = "switch"; label = "Lock before suspend"; group = "Behavior"; groupOrder = 10; order = 20; applyCommand = "dms ipc call settings set lockBeforeSuspend %%val%%";
        desktop.ojuny.dux.settings.lockBeforeSuspend = false;

        # @option widget = "switch"; label = "Power off displays on lock"; group = "Behavior"; groupOrder = 10; order = 30; applyCommand = "dms ipc call settings set lockScreenPowerOffMonitorsOnLock %%val%%";
        desktop.ojuny.dux.settings.lockScreenPowerOffMonitorsOnLock = false;

        # @option widget = "switch"; label = "loginctl integration"; group = "Behavior"; groupOrder = 10; order = 40; advanced = true; description = "Lets loginctl lock requests reach the shell."; applyCommand = "dms ipc call settings set loginctlLockIntegration %%val%%";
        desktop.ojuny.dux.settings.loginctlLockIntegration = true;

        # @option widget = "switch"; label = "Fingerprint login and unlock"; group = "Authentication"; groupOrder = 20; order = 10; description = "Enable fprintd and fingerprint prompts for login, greetd, sudo, polkit and the lock screen. Enroll a finger with fprintd-enroll. Password fallback stays enabled.";
        ojuny.authentication.fingerprint.enable = false;

        desktop.ojuny.dux.settings.enableFprint = config.ojuny.authentication.fingerprint.enable;

        # @option widget = "spin"; label = "Fingerprint attempts"; group = "Authentication"; groupOrder = 20; order = 20; min = 1; max = 30; advanced = true; visibleWhen.path = "desktop.ojuny.dux.settings.enableFprint"; visibleWhen.equals = true; description = "Failed attempts before the reader is locked out."; applyCommand = "dms ipc call settings set maxFprintTries %%val%%";
        desktop.ojuny.dux.settings.maxFprintTries = 15;

        # @option widget = "switch"; label = "Security key unlock"; group = "Authentication"; groupOrder = 20; order = 30; description = "Unlock with a FIDO2 security key. Register a key with fido2-token or pamu2fcfg first. The password still works unless the mode below is set to security-key-only."; applyCommand = "dms ipc call settings set enableU2f %%val%%";
        desktop.ojuny.dux.settings.enableU2f = false;

        # @option widget = "dropdown"; label = "Security key mode"; group = "Authentication"; groupOrder = 20; order = 40; choices = [ "security-key-only" "second-factor" ]; visibleWhen.path = "desktop.ojuny.dux.settings.enableU2f"; visibleWhen.equals = true; description = "Security key only unlocks with the key and does not require the password. Second factor requires the password and then the key."; applyCommand = "case %%val%% in security-key-only) v=or;; second-factor) v=and;; esac; dms ipc call settings set u2fMode $v";
        ojuny.dux.u2fMode = "security-key-only";

        desktop.ojuny.dux.settings.u2fMode = u2fModes.${config.ojuny.dux.u2fMode};

        # @option widget = "switch"; label = "Security key shortcut"; group = "Authentication"; groupOrder = 20; order = 50; visibleWhen.path = "desktop.ojuny.dux.settings.enableU2f"; visibleWhen.equals = true; description = "Bind a key combination that asks for the security key instead of the password on the lock screen."; applyCommand = "dms ipc call settings set lockScreenSecurityKeyShortcutEnabled %%val%%";
        desktop.ojuny.dux.settings.lockScreenSecurityKeyShortcutEnabled = false;

        # @option widget = "text"; label = "Key combination"; group = "Authentication"; groupOrder = 20; order = 60; visibleWhen.path = "desktop.ojuny.dux.settings.lockScreenSecurityKeyShortcutEnabled"; visibleWhen.equals = true; description = "Key combination that triggers the security key prompt, for example Ctrl+Q."; applyCommand = "dms ipc call settings set lockScreenSecurityKeyShortcut %%val%%";
        desktop.ojuny.dux.settings.lockScreenSecurityKeyShortcut = "Ctrl+Q";

        # Lock screen surface
        # @option widget = "raw"; label = "Widget layout"; group = "Lock screen"; groupOrder = 25; order = 5; hidden = true; advanced = true; description = "Lock screen widget instances with id, widgetType, enabled and config. Defaults to the clock, date, authentication, notifications, status and power rows. Save and Rebuild is required.";
        desktop.ojuny.dux.settings.lockScreenWidgetInstances = [
          {
            id = "lock_clock";
            widgetType = "desktopClock";
            enabled = true;
            config = {
              displayPreferences = [ "all" ];
              syncPositionAcrossScreens = true;
              colorMode = "default";
              customColor = "#ffffff";
              style = "expressive";
              transparency = 0;
              weight = 0;
              twoTone = true;
              showDate = false;
              showDigitalSeconds = false;
              showAnalogNumbers = false;
              showAnalogSeconds = true;
              autoPosition = true;
            };
          }
          {
            id = "lock_date";
            widgetType = "lockDate";
            enabled = false;
            config = {
              displayPreferences = [ "all" ];
              syncPositionAcrossScreens = true;
              colorMode = "default";
              customColor = "#ffffff";
              format = "short";
            };
          }
          {
            id = "lock_auth";
            widgetType = "lockAuth";
            enabled = true;
            config = {
              style = "expressive";
              profileVisibility = "always";
              passwordVisibility = "always";
            };
          }
          {
            id = "lock_notifications";
            widgetType = "lockNotifications";
            enabled = true;
            config = {
              mode = 2;
            };
          }
          {
            id = "lock_status";
            widgetType = "lockStatus";
            enabled = true;
            config = {
              showMediaPlayer = true;
              showWeather = true;
              background = false;
            };
          }
          {
            id = "lock_power";
            widgetType = "lockPower";
            enabled = false;
            config = {
              shape = "round";
            };
          }
        ];

        # @option widget = "switch"; label = "Show weather"; group = "Lock screen"; groupOrder = 25; order = 10; hidden = true; advanced = true; description = "Show the weather widget on the lock screen."; applyCommand = "dms ipc call settings set lockScreenShowWeather %%val%%";
        desktop.ojuny.dux.settings.lockScreenShowWeather = true;

        # @option widget = "switch"; label = "Show profile image"; group = "Lock screen"; groupOrder = 25; order = 20; hidden = true; advanced = true; description = "Show the user profile image on the lock screen."; applyCommand = "dms ipc call settings set lockScreenShowProfileImage %%val%%";
        desktop.ojuny.dux.settings.lockScreenShowProfileImage = true;

        # @option widget = "switch"; label = "Show power actions"; group = "Lock screen"; groupOrder = 25; order = 30; hidden = true; advanced = true; description = "Show the power action row on the lock screen."; applyCommand = "dms ipc call settings set lockScreenShowPowerActions %%val%%";
        desktop.ojuny.dux.settings.lockScreenShowPowerActions = false;

        # @option widget = "color"; label = "Inactive display color"; group = "Displays"; groupOrder = 30; order = 10; description = "Solid colour for locked-off displays (OLED burn-in protection)."; applyCommand = "dms ipc call settings set lockScreenInactiveColor %%val%%";
        desktop.ojuny.dux.settings.lockScreenInactiveColor = "#000000";

        # @option widget = "path"; label = "Video file"; group = "Video screensaver"; groupOrder = 40; order = 10; description = "Video file played on the lock screen. The path is kept as a runtime string, not a store path."; applyCommand = "dms ipc call settings set lockScreenVideoPath %%val%%";
        desktop.ojuny.dux.settings.lockScreenVideoPath = "";

        # @option widget = "switch"; label = "Play video on lock"; group = "Video screensaver"; groupOrder = 40; order = 20; visibleWhen.path = "desktop.ojuny.dux.settings.lockScreenVideoPath"; description = "Play the selected video while the screen is locked."; applyCommand = "dms ipc call settings set lockScreenVideoEnabled %%val%%";
        desktop.ojuny.dux.settings.lockScreenVideoEnabled = false;

        # @option widget = "switch"; label = "Automatic cycling"; group = "Video screensaver"; groupOrder = 40; order = 30; advanced = true; visibleWhen.path = "desktop.ojuny.dux.settings.lockScreenVideoEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set lockScreenVideoCycling %%val%%";
        desktop.ojuny.dux.settings.lockScreenVideoCycling = false;

        services.fprintd.enable = config.ojuny.authentication.fingerprint.enable;

        environment.systemPackages = lib.mkIf config.ojuny.authentication.fingerprint.enable [
          pkgs.fprintd
          pkgs.libfprint
          (pkgs.writeShellApplication {
            name = "ojuny-fingerprint-detect";
            runtimeInputs = [ pkgs.coreutils pkgs.fprintd ];
            text = ''
              exec fprintd-list "$(id -un)"
            '';
          })
        ];

        security.pam.services = lib.mkIf config.ojuny.authentication.fingerprint.enable {
          login.fprintAuth = true;
          greetd.fprintAuth = true;
          sudo.fprintAuth = true;
          "polkit-1".fprintAuth = true;
          dankshell.fprintAuth = true;
        };

      };
    };

}

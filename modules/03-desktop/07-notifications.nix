/*
  @menu
  displayname = "Notifications";
  icon = "preferences-system-notifications-symbolic";
  order = 70;
  description = "Notification popups. Date, time and recurring notices are created in KAlarm; Nix seeds no alarms. Battery alerts remain on the Power page. Weather is a KAlarm command alarm that displays a weather command's output.";
  category = "03-Desktop";
*/

{ self, inputs, ... }:

let
  popupPositions = {
    "top-right" = 0;
    "top-left" = 2;
    "top-center" = -1;
    "bottom-center" = 5;
    "bottom-right" = 3;
    "bottom-left" = 1;
  };
in
{

  flake.modules.nixos.desktop-notifications =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {

      options.ojuny.dux.notificationPopupPosition = lib.mkOption {
        type = lib.types.enum (lib.attrNames popupPositions);
        default = "top-right";
      };

      options.ojuny.apps.kalarm.enable = lib.mkEnableOption "KAlarm scheduled notices";

      config = {

        # @option widget = "switch"; label = "KAlarm reminder app"; group = "Notices"; groupOrder = 70; order = 10; description = "Install KAlarm and start it in the tray. Create and edit the date, time and recurring reminders inside KAlarm; this switch does not define alarms. Battery alerts remain on the Power page.";
        ojuny.apps.kalarm.enable = false;

        environment.systemPackages = lib.optional config.ojuny.apps.kalarm.enable pkgs.kdePackages.kalarm;

        desktop.ojuny.mango.execOnce =
          lib.optional config.ojuny.apps.kalarm.enable "${pkgs.kdePackages.kalarm}/bin/kalarm --tray";

        # @option widget = "dropdown"; label = "Notification popup position"; group = "Popups"; groupOrder = 10; order = 5; choices = [ "top-right" "top-left" "top-center" "bottom-center" "bottom-right" "bottom-left" ];
        ojuny.dux.notificationPopupPosition = "top-right";

        desktop.ojuny.dux.settings.notificationPopupPosition =
          popupPositions.${config.ojuny.dux.notificationPopupPosition};

        # @option widget = "spin"; label = "Popup duration"; group = "Popups"; groupOrder = 10; order = 10; min = 0; step = 50; unit = "ms";
        desktop.ojuny.dux.settings.notificationAnimationDuration = 400;

        # @option widget = "switch"; label = "Compact mode"; group = "Popups"; groupOrder = 10; order = 20;
        desktop.ojuny.dux.settings.notificationCompactMode = true;

        # @option widget = "switch"; label = "Overlay"; group = "Popups"; groupOrder = 10; order = 30; applyCommand = "dms ipc call settings set notificationOverlayEnabled %%val%%";
        desktop.ojuny.dux.settings.notificationOverlayEnabled = true;

        # @option widget = "switch"; label = "Show timeout bar"; group = "Popups"; groupOrder = 10; order = 40; applyCommand = "dms ipc call settings set notificationShowTimeoutBar %%val%%";
        desktop.ojuny.dux.settings.notificationShowTimeoutBar = true;

        # @option widget = "switch"; label = "Only on focused monitor"; group = "Popups"; groupOrder = 10; order = 50; applyCommand = "dms ipc call settings set notificationFocusedMonitor %%val%%";
        desktop.ojuny.dux.settings.notificationFocusedMonitor = true;

        # @option widget = "spin"; label = "Summary font size"; group = "Popups"; groupOrder = 10; order = 60; min = 6; unit = "pt"; applyCommand = "dms ipc call settings set notificationSummaryFontSize %%val%%";
        desktop.ojuny.dux.settings.notificationSummaryFontSize = 16;

        # @option widget = "spin"; label = "Body font size"; group = "Popups"; groupOrder = 10; order = 70; min = 6; unit = "pt"; applyCommand = "dms ipc call settings set notificationBodyFontSize %%val%%";
        desktop.ojuny.dux.settings.notificationBodyFontSize = 10;

        # @option widget = "switch"; label = "Suppress duplicates"; group = "Popups"; groupOrder = 10; order = 80; applyCommand = "dms ipc call settings set notificationDedupeEnabled %%val%%";
        desktop.ojuny.dux.settings.notificationDedupeEnabled = true;

        # @option widget = "switch"; label = "Body click runs default action"; group = "Popups"; groupOrder = 10; order = 90; applyCommand = "dms ipc call settings set notificationPopupBodyInvokesAction %%val%%";
        desktop.ojuny.dux.settings.notificationPopupBodyInvokesAction = false;

        # @option widget = "switch"; label = "Foreground layers"; group = "Popups"; groupOrder = 10; order = 100; applyCommand = "dms ipc call settings set notificationForegroundLayers %%val%%";
        desktop.ojuny.dux.settings.notificationForegroundLayers = true;

        # @option widget = "switch"; label = "Popup shadow"; group = "Popups"; groupOrder = 10; order = 110; advanced = true; applyCommand = "dms ipc call settings set notificationPopupShadowEnabled %%val%%";
        desktop.ojuny.dux.settings.notificationPopupShadowEnabled = true;

        # @option widget = "spin"; label = "Low timeout"; group = "Timeouts"; groupOrder = 20; order = 10; min = 0; max = 600000; step = 1000; unit = "ms"; advanced = true; description = "0 = never.";
        desktop.ojuny.dux.settings.notificationTimeoutLow = 5000;

        # @option widget = "spin"; label = "Normal timeout"; group = "Timeouts"; groupOrder = 20; order = 20; min = 0; max = 600000; step = 1000; unit = "ms"; advanced = true; description = "0 = never.";
        desktop.ojuny.dux.settings.notificationTimeoutNormal = 5000;

        # @option widget = "spin"; label = "Critical timeout"; group = "Timeouts"; groupOrder = 20; order = 30; min = 0; max = 600000; step = 1000; unit = "ms"; advanced = true; description = "0 = never.";
        desktop.ojuny.dux.settings.notificationTimeoutCritical = 0;

        # @option widget = "switch"; label = "Ignore app-requested timeout"; group = "Timeouts"; groupOrder = 20; order = 40; advanced = true; description = "Use the timeouts above instead of app durations."; applyCommand = "dms ipc call settings set notificationIgnoreAppTimeout %%val%%";
        desktop.ojuny.dux.settings.notificationIgnoreAppTimeout = false;

        # @option widget = "switch"; label = "Automatically enable while screen sharing"; group = "Do not disturb"; groupOrder = 30; order = 10; applyCommand = "dms ipc call settings set notificationDndWhileScreenSharing %%val%%";
        desktop.ojuny.dux.settings.notificationDndWhileScreenSharing = true;

        # @option widget = "switch"; label = "Allow critical"; group = "Do not disturb"; groupOrder = 30; order = 20; description = "Critical notifications still pop up."; applyCommand = "dms ipc call settings set notificationDndAllowCritical %%val%%";
        desktop.ojuny.dux.settings.notificationDndAllowCritical = true;

        # @option widget = "switch"; label = "Privacy mode"; group = "Privacy"; groupOrder = 40; order = 10; advanced = true; description = "Popups hide the message until expanded."; applyCommand = "dms ipc call settings set notificationPopupPrivacyMode %%val%%";
        desktop.ojuny.dux.settings.notificationPopupPrivacyMode = false;

        # @option widget = "switch"; label = "History"; group = "History"; groupOrder = 50; order = 10; applyCommand = "dms ipc call settings set notificationHistoryEnabled %%val%%";
        desktop.ojuny.dux.settings.notificationHistoryEnabled = true;

        # @option widget = "dropdown"; label = "Retention"; group = "History"; groupOrder = 50; order = 20; choices = [ "0" "1" "3" "7" "14" "30" ]; advanced = true; description = "0 = forever."; applyCommand = "dms ipc call settings set notificationHistoryMaxAgeDays %%val%%";
        desktop.ojuny.dux.settings.notificationHistoryMaxAgeDays = 7;

        # @option widget = "spin"; label = "Maximum entries"; group = "History"; groupOrder = 50; order = 30; min = 10; max = 200; step = 10; advanced = true; applyCommand = "dms ipc call settings set notificationHistoryMaxCount %%val%%";
        desktop.ojuny.dux.settings.notificationHistoryMaxCount = 50;

        # @option widget = "switch"; label = "Low"; group = "History"; groupOrder = 50; order = 40; advanced = true; applyCommand = "dms ipc call settings set notificationHistorySaveLow %%val%%";
        desktop.ojuny.dux.settings.notificationHistorySaveLow = true;

        # @option widget = "switch"; label = "Normal"; group = "History"; groupOrder = 50; order = 50; advanced = true; applyCommand = "dms ipc call settings set notificationHistorySaveNormal %%val%%";
        desktop.ojuny.dux.settings.notificationHistorySaveNormal = true;

        # @option widget = "switch"; label = "Critical"; group = "History"; groupOrder = 50; order = 60; advanced = true; applyCommand = "dms ipc call settings set notificationHistorySaveCritical %%val%%";
        desktop.ojuny.dux.settings.notificationHistorySaveCritical = true;

        # @option widget = "raw"; label = "Rules"; group = "Rules"; groupOrder = 60; order = 10; rows = 12; advanced = true; description = "Per-app and per-content rules. Each rule is an object with field, matchType, pattern, action, urgency and bypassDnd; nested conditions are preserved only when edited here. Save and Rebuild is required.";
        desktop.ojuny.dux.settings.notificationRules = [ ];

      };
    };

}

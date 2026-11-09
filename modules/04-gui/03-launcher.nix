/*
  @menu
  displayname = "Launcher";
  icon = "system-search-symbolic";
  order = 30;
  description = "App launcher style, behaviour and plugin triggers";
  category = "04-GUI";
*/

/*
  @snippet
  name = "plugin-trigger";
  label = "Add plugin trigger";
  snippet = ''
    # @option widget = "text"; label = "%%label%%"; group = "Plugin triggers";
    desktop.ojuny.dux.settings.builtInPluginSettings.%%id%%.trigger = "%%trigger%%";
  '';
  placeholders.id.label = "Plugin id";
  placeholders.id.default = "dms_example";
  placeholders.label.label = "Label";
  placeholders.label.default = "My plugin";
  placeholders.trigger.label = "Trigger";
  placeholders.trigger.default = "xx";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-launcher = { config, pkgs, ... }: {

    # @option widget = "dropdown"; label = "Launcher style"; group = "Launcher"; order = 10; choices = [ "full" "spotlight" "island" ]; description = "DMS launcher style. Full is the large app drawer, Spotlight is the small centered search bar, Island opens from the island bar."; applyCommand = "dms ipc call settings set launcherStyle %%val%%";
    desktop.ojuny.dux.settings.launcherStyle = "full";

    # @option widget = "dropdown"; label = "Launcher size"; group = "Launcher"; order = 20; choices = [ "micro" "compact" "medium" "large" ]; visibleWhen.path = "desktop.ojuny.dux.settings.launcherStyle"; visibleWhen.equals = [ "full" "island" ]; description = "Size of the full and island launchers. Spotlight uses its own fixed size."; applyCommand = "dms ipc call settings set dankLauncherV2Size %%val%%";
    desktop.ojuny.dux.settings.dankLauncherV2Size = "compact";

    # @option widget = "switch"; label = "Show mode chips"; group = "Launcher"; applyCommand = "dms ipc call settings set spotlightBarShowModeChips %%val%%";
    desktop.ojuny.dux.settings.spotlightBarShowModeChips = true;

    # @option widget = "dropdown"; label = "Default action"; group = "Launcher"; order = 30; choices = [ "launch" "focus" ]; description = "What Enter does on a matched app."; applyCommand = "dms ipc call settings set launcherEnterAction %%val%%";
    desktop.ojuny.dux.settings.launcherEnterAction = "launch";

    # @option widget = "dropdown"; label = "Bar centering"; group = "Launcher"; order = 40; choices = [ "index" "geometric" ]; description = "How the bar center section resolves its widgets."; applyCommand = "dms ipc call settings set centeringMode %%val%%";
    desktop.ojuny.dux.settings.centeringMode = "index";

    # @option widget = "switch"; label = "Sort apps alphabetically"; group = "Launcher"; order = 50; description = "Sort app results by name instead of usage."; applyCommand = "dms ipc call settings set sortAppsAlphabetically %%val%%";
    desktop.ojuny.dux.settings.sortAppsAlphabetically = false;

    # @option widget = "spin"; label = "App grid columns"; group = "Launcher"; order = 60; min = 1; max = 12; description = "Columns in the app grid of the launcher."; applyCommand = "dms ipc call settings set appLauncherGridColumns %%val%%";
    desktop.ojuny.dux.settings.appLauncherGridColumns = 4;

    # @option widget = "switch"; label = "Search app actions"; group = "Launcher"; order = 70; description = "Match actions apps provide, such as New Window.";
    desktop.ojuny.dux.session.searchAppActions = true;

    # @option widget = "list"; label = "Hidden apps"; group = "Launcher"; order = 80; description = "Application ids hidden from the launcher.";
    desktop.ojuny.dux.session.hiddenApps = [ ];

    # @option widget = "raw"; label = "App overrides"; group = "Launcher"; order = 90; advanced = true; rows = 6; description = "Per-app launcher overrides keyed by application id.";
    desktop.ojuny.dux.session.appOverrides = { };

    # @option widget = "text"; label = "Launch prefix"; group = "Launcher"; order = 100; description = "Added in front of every app launch command, for example uwsm-app."; applyCommand = "dms ipc call settings set launchPrefix %%val%%";
    desktop.ojuny.dux.settings.launchPrefix = "";

    # Plugin triggers: the key you type in the launcher to open a built-in plugin.
    # @option widget = "text"; label = "Clipboard search"; group = "Plugin triggers"; description = "Opens the clipboard history in the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_clipboard_search.trigger = "cb";

    # @option widget = "text"; label = "Power menu"; group = "Plugin triggers"; description = "Opens the power menu in the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_power.trigger = "pw";

    # @option widget = "text"; label = "QR generator"; group = "Plugin triggers"; description = "Generates a QR code from the query.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_qr_generator.trigger = "qrg";

    # @option widget = "text"; label = "Notepad"; group = "Plugin triggers"; description = "Opens the notepad from the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_notepad.trigger = "";

    # @option widget = "text"; label = "System monitor"; group = "Plugin triggers"; description = "Opens the system monitor from the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_sysmon.trigger = "";

    # @option widget = "text"; label = "Color picker"; group = "Plugin triggers"; description = "Opens the color picker from the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_colorpicker.trigger = "";

    # @option widget = "text"; label = "VPN"; group = "Plugin triggers"; description = "Shows VPN connections in the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_vpn.trigger = "";

    # @option widget = "raw"; label = "Plugin visibility"; group = "Plugin triggers"; order = 100; advanced = true; rows = 6; description = "Plugin id to visibility settings such as allowWithoutTrigger.";
    desktop.ojuny.dux.settings.launcherPluginVisibility = { };

    # @option widget = "list"; label = "Plugin order"; group = "Plugin triggers"; order = 110; advanced = true; description = "Plugin ids in the order they appear in the launcher.";
    desktop.ojuny.dux.settings.launcherPluginOrder = [ ];

    /*
      @insert
      name = "plugin-trigger";
      group = "Plugin triggers";
      order = 1000;
    */

    # Built-in plugins: turn each plugin the shell ships with on or off.
    # @option widget = "switch"; label = "Clipboard search"; group = "Built-in plugins"; groupOrder = 50; order = 10; description = "Show the clipboard history plugin in the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_clipboard_search.enabled = true;

    # @option widget = "switch"; label = "Power menu"; group = "Built-in plugins"; groupOrder = 50; order = 20; description = "Show the power menu plugin in the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_power.enabled = true;

    # @option widget = "switch"; label = "QR generator"; group = "Built-in plugins"; groupOrder = 50; order = 30; description = "Show the QR generator plugin in the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_qr_generator.enabled = true;

    desktop.ojuny.dux.settings.builtInPluginSettings.dms_settings_search.enabled = false;
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_settings.enabled = false;

    # @option widget = "switch"; label = "Notepad"; group = "Built-in plugins"; groupOrder = 50; order = 60; description = "Show the notepad plugin in the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_notepad.enabled = true;

    # @option widget = "switch"; label = "System monitor"; group = "Built-in plugins"; groupOrder = 50; order = 70; description = "Show the system monitor plugin in the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_sysmon.enabled = true;

    # @option widget = "switch"; label = "Color picker"; group = "Built-in plugins"; groupOrder = 50; order = 80; description = "Show the color picker plugin in the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_colorpicker.enabled = true;

    # @option widget = "switch"; label = "VPN"; group = "Built-in plugins"; groupOrder = 50; order = 90; description = "Show the VPN plugin in the launcher.";
    desktop.ojuny.dux.settings.builtInPluginSettings.dms_vpn.enabled = true;

    # @option widget = "switch"; label = "Show third-party plugins"; group = "Built-in plugins"; groupOrder = 50; order = 100; description = "Show third-party plugins in the plugin browser.";
    desktop.ojuny.dux.session.showThirdPartyPlugins = false;

    # The dock's own launcher button and logo options live on the Dock page.

    # @option widget = "switch"; label = "Show footer"; group = "Appearance"; groupOrder = 10; order = 20; description = "Footer with mode tabs and shortcut hints."; visibleWhen.path = "desktop.ojuny.dux.settings.dankLauncherV2Size"; visibleWhen.notEquals = "micro"; applyCommand = "dms ipc call settings set dankLauncherV2ShowFooter %%val%%";
    desktop.ojuny.dux.settings.dankLauncherV2ShowFooter = true;

    # @option widget = "switch"; label = "Show package source badges"; group = "Appearance"; groupOrder = 10; order = 30; description = "Flatpak, Snap, AppImage or Nix badge on each app."; applyCommand = "dms ipc call settings set dankLauncherV2ShowSourceBadges %%val%%";
    desktop.ojuny.dux.settings.dankLauncherV2ShowSourceBadges = true;

    # @option widget = "switch"; label = "Border"; group = "Appearance"; groupOrder = 10; order = 40; description = "Draw a border around the launcher."; applyCommand = "dms ipc call settings set dankLauncherV2BorderEnabled %%val%%";
    desktop.ojuny.dux.settings.dankLauncherV2BorderEnabled = false;

    # @option widget = "spin"; label = "Border thickness"; group = "Appearance"; groupOrder = 10; order = 50; min = 1; max = 6; unit = "px"; visibleWhen.path = "desktop.ojuny.dux.settings.dankLauncherV2BorderEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set dankLauncherV2BorderThickness %%val%%";
    desktop.ojuny.dux.settings.dankLauncherV2BorderThickness = 2;

    # @option widget = "dropdown"; label = "Border color"; group = "Appearance"; groupOrder = 10; order = 60; choices = [ "primary" "secondary" "outline" "surfaceText" ]; visibleWhen.path = "desktop.ojuny.dux.settings.dankLauncherV2BorderEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set dankLauncherV2BorderColor %%val%%";
    desktop.ojuny.dux.settings.dankLauncherV2BorderColor = "primary";

    # @option widget = "raw"; label = "App drawer view modes"; group = "Appearance"; groupOrder = 10; order = 70; advanced = true; rows = 6; description = "Section id to view mode for the app drawer.";
    desktop.ojuny.dux.settings.appDrawerSectionViewModes = { };

    # @option widget = "raw"; label = "Spotlight view modes"; group = "Appearance"; groupOrder = 10; order = 80; advanced = true; rows = 6; description = "Section id to view mode for the spotlight launcher.";
    desktop.ojuny.dux.settings.spotlightSectionViewModes = { };

    # @option widget = "switch"; label = "History"; group = "Search"; groupOrder = 20; order = 10; description = "Record app usage and past queries. Turning this off clears what is stored.";
    desktop.ojuny.dux.settings.launcherHistoryEnabled = true;

    # @option widget = "switch"; label = "Remember last mode"; group = "Search"; groupOrder = 20; order = 20; description = "Reopen the launcher on the last used tab."; applyCommand = "dms ipc call settings set rememberLastMode %%val%%";
    desktop.ojuny.dux.settings.rememberLastMode = true;

    # @option widget = "switch"; label = "Include files in All tab"; group = "Search"; groupOrder = 20; order = 30; applyCommand = "dms ipc call settings set dankLauncherV2IncludeFilesInAll %%val%%";
    desktop.ojuny.dux.settings.dankLauncherV2IncludeFilesInAll = false;

    # @option widget = "switch"; label = "Include folders in All tab"; group = "Search"; groupOrder = 20; order = 40; applyCommand = "dms ipc call settings set dankLauncherV2IncludeFoldersInAll %%val%%";
    desktop.ojuny.dux.settings.dankLauncherV2IncludeFoldersInAll = false;

    # @option widget = "switch"; label = "Remember last query"; group = "Search"; groupOrder = 20; order = 50; description = "Keep the previous query when the launcher reopens."; applyCommand = "dms ipc call settings set rememberLastQuery %%val%%";
    desktop.ojuny.dux.settings.rememberLastQuery = false;

    # @option widget = "switch"; label = "Use overlay layer"; group = "Advanced"; groupOrder = 30; order = 10; advanced = true; description = "Show the launcher above fullscreen windows."; applyCommand = "dms ipc call settings set launcherUseOverlayLayer %%val%%";
    desktop.ojuny.dux.settings.launcherUseOverlayLayer = false;

    # @option widget = "switch"; label = "Unload on close"; group = "Advanced"; groupOrder = 30; order = 20; advanced = true; description = "Frees the launcher when closed and rebuilds it on open."; applyCommand = "dms ipc call settings set dankLauncherV2UnloadOnClose %%val%%";
    desktop.ojuny.dux.settings.dankLauncherV2UnloadOnClose = false;

    # @option widget = "dropdown"; label = "App picker view"; group = "Advanced"; groupOrder = 30; order = 30; choices = [ "grid" "list" ]; advanced = true; applyCommand = "dms ipc call settings set appPickerViewMode %%val%%";
    desktop.ojuny.dux.settings.appPickerViewMode = "grid";

    # @option widget = "dropdown"; label = "Browser picker view"; group = "Advanced"; groupOrder = 30; order = 40; choices = [ "grid" "list" ]; advanced = true; applyCommand = "dms ipc call settings set browserPickerViewMode %%val%%";
    desktop.ojuny.dux.settings.browserPickerViewMode = "grid";

    # @option widget = "raw"; label = "Launcher keybinds"; group = "Advanced"; groupOrder = 30; order = 50; advanced = true; rows = 6; description = "Launcher action id to key combos.";
    desktop.ojuny.dux.settings.launcherKeybinds = { };

    # @option widget = "dropdown"; label = "Default mode"; group = "Notepad"; groupOrder = 40; order = 10; choices = [ "slideout" "popout" ]; applyCommand = "dms ipc call settings set notepadDefaultMode %%val%%";
    desktop.ojuny.dux.settings.notepadDefaultMode = "slideout";

    # @option widget = "dropdown"; label = "Open from"; group = "Notepad"; groupOrder = 40; order = 20; choices = [ "right" "left" ]; description = "Screen edge the slideout opens from."; visibleWhen.path = "desktop.ojuny.dux.settings.notepadDefaultMode"; visibleWhen.equals = "slideout"; applyCommand = "dms ipc call settings set notepadSlideoutSide %%val%%";
    desktop.ojuny.dux.settings.notepadSlideoutSide = "right";

    # @option widget = "switch"; label = "Show line numbers"; group = "Notepad"; groupOrder = 40; order = 30; applyCommand = "dms ipc call settings set notepadShowLineNumbers %%val%%";
    desktop.ojuny.dux.settings.notepadShowLineNumbers = false;

    # @option widget = "switch"; label = "Auto-save to disk"; group = "Notepad"; groupOrder = 40; order = 40; description = "Automatically save changes to opened files as you type."; applyCommand = "dms ipc call settings set notepadAutoSave %%val%%";
    desktop.ojuny.dux.settings.notepadAutoSave = false;

    # @option widget = "switch"; label = "Use monospace font"; group = "Notepad"; groupOrder = 40; order = 50; description = "Use the global monospace font from Personalization."; applyCommand = "dms ipc call settings set notepadUseMonospace %%val%%";
    desktop.ojuny.dux.settings.notepadUseMonospace = true;

    # @option widget = "text"; label = "Font family"; group = "Notepad"; groupOrder = 40; order = 60; advanced = true; description = "Empty uses the global UI font."; visibleWhen.path = "desktop.ojuny.dux.settings.notepadUseMonospace"; visibleWhen.equals = false; applyCommand = "dms ipc call settings set notepadFontFamily %%val%%";
    desktop.ojuny.dux.settings.notepadFontFamily = "";

    # @option widget = "spin"; label = "Font size"; group = "Notepad"; groupOrder = 40; order = 70; min = 8; max = 48; unit = "px"; applyCommand = "dms ipc call settings set notepadFontSize %%val%%";
    desktop.ojuny.dux.settings.notepadFontSize = 14;

    # @option widget = "switch"; label = "Auto compositor gaps"; group = "Notepad"; groupOrder = 40; order = 80; description = "Inset the notepad from screen edges using the compositor's configured gaps."; applyCommand = "dms ipc call settings set notepadUseCompositorGap %%val%%";
    desktop.ojuny.dux.settings.notepadUseCompositorGap = false;

    # @option widget = "spin"; label = "Manual edge gap"; group = "Notepad"; groupOrder = 40; order = 90; min = 0; max = 64; unit = "px"; advanced = true; visibleWhen.path = "desktop.ojuny.dux.settings.notepadUseCompositorGap"; visibleWhen.equals = false; applyCommand = "dms ipc call settings set notepadEdgeGap %%val%%";
    desktop.ojuny.dux.settings.notepadEdgeGap = 0;

  };

}

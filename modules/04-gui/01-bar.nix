/*
  @menu
  displayname = "Bar";
  icon = "view-list-symbolic";
  order = 10;
  description = "Bar layout, widgets and island style";
  category = "04-GUI";
*/

/*
  Bar widget catalog. One @widget-preset per widget DMS ships; presets with
  an options file in BarWidgetCatalog.qml also carry @widget-preset-field
  markers describing the settings the editor renders in the cog pop-out.
*/
/*
  @widget-preset
  id = "layout"; label = "Layout";
  description = "Display and switch MangoWC layouts";
  icon = "view-grid-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "launcherButton"; label = "App launcher";
  description = "Quick access to application launcher";
  icon = "view-app-grid-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.launcherLogoMode = "apps";
  defaults.launcherLogoSizeOffset = 0;
*/
/*
  @widget-preset-field
  preset = "launcherButton"; name = "launcherLogoMode";
  widget = "dropdown"; choices = [ "apps" "os" "custom" ];
  label = "Logo"; description = "Which logo the launcher button shows.";
*/
/*
  @widget-preset-field
  preset = "launcherButton"; name = "launcherLogoSizeOffset";
  widget = "spin"; min = -20; max = 20; unit = "px";
  label = "Logo size offset"; description = "Grow or shrink the launcher logo.";
*/
/*
  @widget-preset-field
  preset = "launcherButton"; name = "launcherLogoBrightness";
  widget = "slider"; min = 0.0; max = 1.0; step = 0.05;
  label = "Logo brightness"; description = "Brightness of the launcher logo color.";
*/
/*
  @widget-preset-field
  preset = "launcherButton"; name = "launcherLogoColorOverride";
  widget = "text";
  label = "Logo color override"; description = "Color role name or hex value; empty follows the theme.";
*/
/*
  @widget-preset-field
  preset = "launcherButton"; name = "launcherLogoContrast";
  widget = "slider"; min = 0.0; max = 2.0; step = 0.05;
  label = "Logo contrast"; description = "Contrast of the launcher logo color.";
*/
/*
  @widget-preset-field
  preset = "launcherButton"; name = "launcherLogoCustomPath";
  widget = "text";
  label = "Custom logo path"; description = "Image used when the logo mode is custom.";
*/

/*
  @widget-preset
  id = "workspaceSwitcher"; label = "Workspace switcher";
  description = "Shows current workspace and allows switching";
  icon = "view-dual-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.showOccupiedWorkspacesOnly = true;
  defaults.showWorkspaceIndex = true;
  defaults.showWorkspacePadding = true;
  defaults.workspacePaddingCount = 5;
  defaults.workspaceIndicatorCompact = true;
  defaults.dwlShowAllTags = false;
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "showOccupiedWorkspacesOnly";
  widget = "switch"; label = "Show occupied workspaces only";
  description = "Only list workspaces that have open windows.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "showWorkspaceIndex";
  widget = "switch"; label = "Show workspace index";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspacePaddingCount";
  widget = "spin"; min = 0; max = 20;
  label = "Workspace padding count";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceIndicatorCompact";
  widget = "switch"; label = "Compact indicators";
  description = "Use the compact workspace pill size.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "dwlShowAllTags";
  widget = "switch"; label = "Show all tags";
  description = "DWL only: list every tag instead of occupied ones.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "groupActiveWorkspaceApps";
  widget = "switch";
  label = "Group on active workspace"; description = "Group app icons on the active workspace.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "groupWorkspaceApps";
  widget = "switch";
  label = "Group apps"; description = "Group app icons by application.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "maxWorkspaceIcons";
  widget = "spin"; min = 1; max = 10;
  label = "Max apps to show"; description = "App icons shown per workspace.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "reverseScrolling";
  widget = "switch";
  label = "Reverse scroll direction"; description = "Invert the scroll direction over the switcher.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "showSpecialWorkspaces";
  widget = "switch";
  label = "Show scratchpads"; description = "List special workspaces last.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "showWorkspaceApps";
  widget = "switch";
  label = "Show apps"; description = "Show app icons inside each workspace.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "showWorkspaceName";
  widget = "switch";
  label = "Names"; description = "Show workspace names.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "showWorkspacePadding";
  widget = "switch";
  label = "Pad short lists"; description = "Fill the switcher with empty placeholders up to the minimum count.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceActiveAppHighlightEnabled";
  widget = "switch";
  label = "Highlight focused app"; description = "Highlight the focused app icon.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceAppIconSizeOffset";
  widget = "spin"; min = 0; max = 10; unit = "px";
  label = "Icon size"; description = "Grow or shrink workspace app icons.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceDragReorder";
  widget = "switch";
  label = "Drag to reorder"; description = "Reorder workspaces by dragging.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceFollowFocus";
  widget = "switch";
  label = "Follow display focus"; description = "List workspaces from whichever display has focus.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceIndicatorRoundness";
  widget = "spin"; min = -1; max = 100;
  label = "Indicator roundness"; description = "Corner roundness of the indicator; -1 follows the theme.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceIndicatorStyle";
  widget = "dropdown"; choices = [ "pills" "dots" "lines" "cards" ];
  label = "Style"; description = "Shape drawn for each workspace.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedAppsFullOpacity";
  widget = "switch";
  label = "Don't dim unfocused apps"; description = "Show icons of unfocused apps at full opacity.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorSeparateAppearance";
  widget = "switch";
  label = "Separate appearance"; description = "Use different colors on unfocused displays.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceFocusedBorderEnabled";
  widget = "switch";
  label = "Focused border"; description = "Draw a border around the focused workspace.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceFocusedBorderColor";
  widget = "dropdown"; choices = [ "surfaceText" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "custom" ];
  label = "Focused border color"; description = "Theme role used for the focused workspace border.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceFocusedBorderCustomColor";
  widget = "color";
  label = "Custom focused border color"; description = "Border color used when the focused border color is custom.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceFocusedBorderThickness";
  widget = "spin"; min = 1; max = 10; unit = "px";
  label = "Focused border thickness"; description = "Width of the focused workspace border.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceFocusedCustomColor";
  widget = "color";
  label = "Custom focused color"; description = "Focused color used when the focused color mode is custom.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceOccupiedColorMode";
  widget = "dropdown"; choices = [ "none" "primary" "primaryContainer" "sec" "secondaryContainer" "tertiary" "tertiaryContainer" "s" "sc" "sch" "schh" "custom" ];
  label = "Occupied color"; description = "Theme role used for occupied workspaces.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceOccupiedCustomColor";
  widget = "color";
  label = "Custom occupied color"; description = "Occupied color used when the occupied color mode is custom.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedColorMode";
  widget = "dropdown"; choices = [ "default" "surfaceText" "primary" "secondary" "tertiary" "s" "sc" "sch" "schh" "custom" ];
  label = "Unfocused color"; description = "Theme role used for unfocused workspaces.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedCustomColor";
  widget = "color";
  label = "Custom unfocused color"; description = "Unfocused color used when the unfocused color mode is custom.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUrgentColorMode";
  widget = "dropdown"; choices = [ "default" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "s" "sc" "sch" "custom" ];
  label = "Urgent color"; description = "Theme role used for urgent workspaces.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUrgentCustomColor";
  widget = "color";
  label = "Custom urgent color"; description = "Urgent color used when the urgent color mode is custom.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceColorMode";
  widget = "dropdown"; choices = [ "default" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "s" "sc" "sch" "schh" "none" "custom" ];
  label = "Focused color"; description = "Theme role used for the focused workspace.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorColorMode";
  widget = "dropdown"; choices = [ "default" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "s" "sc" "sch" "schh" "none" "custom" ];
  label = "Unfocused display focused color"; description = "Theme role used for the focused workspace on unfocused displays.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorFocusedCustomColor";
  widget = "color";
  label = "Custom unfocused display focused color"; description = "Color used when the unfocused display focused color is custom.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorOccupiedColorMode";
  widget = "dropdown"; choices = [ "none" "primary" "primaryContainer" "sec" "secondaryContainer" "tertiary" "tertiaryContainer" "s" "sc" "sch" "schh" "custom" ];
  label = "Unfocused display occupied color"; description = "Theme role used for occupied workspaces on unfocused displays.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorOccupiedCustomColor";
  widget = "color";
  label = "Custom unfocused display occupied color"; description = "Color used when the unfocused display occupied color is custom.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorUnfocusedColorMode";
  widget = "dropdown"; choices = [ "default" "surfaceText" "primary" "secondary" "tertiary" "s" "sc" "sch" "schh" "custom" ];
  label = "Unfocused display unfocused color"; description = "Theme role used for unfocused workspaces on unfocused displays.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorUnfocusedCustomColor";
  widget = "color";
  label = "Custom unfocused display unfocused color"; description = "Color used when the unfocused display unfocused color is custom.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorUrgentColorMode";
  widget = "dropdown"; choices = [ "default" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "s" "sc" "sch" "custom" ];
  label = "Unfocused display urgent color"; description = "Theme role used for urgent workspaces on unfocused displays.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorUrgentCustomColor";
  widget = "color";
  label = "Custom unfocused display urgent color"; description = "Color used when the unfocused display urgent color is custom.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorBorderEnabled";
  widget = "switch";
  label = "Unfocused display focused border"; description = "Draw a border around the focused workspace on unfocused displays.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorBorderColor";
  widget = "dropdown"; choices = [ "surfaceText" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "custom" ];
  label = "Unfocused display border color"; description = "Theme role used for the unfocused display border.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorBorderCustomColor";
  widget = "color";
  label = "Custom unfocused display border color"; description = "Border color used when the unfocused display border color is custom.";
*/
/*
  @widget-preset-field
  preset = "workspaceSwitcher"; name = "workspaceUnfocusedMonitorBorderThickness";
  widget = "spin"; min = 1; max = 10; unit = "px";
  label = "Unfocused display border thickness"; description = "Width of the unfocused display border.";
*/

/*
  @widget-preset
  id = "focusedWindow"; label = "Focused window";
  description = "Display currently focused application title";
  icon = "focus-windows-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.focusedWindowCompactMode = false;
  defaults.focusedWindowShowIcon = true;
  defaults.focusedWindowSize = 1;
*/
/*
  @widget-preset-field
  preset = "focusedWindow"; name = "focusedWindowCompactMode";
  widget = "switch"; label = "Compact mode";
*/
/*
  @widget-preset-field
  preset = "focusedWindow"; name = "focusedWindowShowIcon";
  widget = "switch"; label = "Show icon";
*/
/*
  @widget-preset-field
  preset = "focusedWindow"; name = "focusedWindowSize";
  widget = "spin"; min = 0; max = 3; label = "Size";
*/
/*
  @widget-preset
  id = "runningApps"; label = "Running apps";
  description = "Shows all running applications with focus indication";
  icon = "view-app-grid-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
*/
/*
  @widget-preset-field
  preset = "runningApps"; name = "runningAppsCompactMode";
  widget = "switch"; label = "Compact mode";
*/
/*
  @widget-preset-field
  preset = "runningApps"; name = "runningAppsGroupByApp";
  widget = "switch"; label = "Group by app";
*/
/*
  @widget-preset-field
  preset = "runningApps"; name = "runningAppsCurrentWorkspace";
  widget = "switch"; label = "Current workspace";
  description = "Only show apps from the active workspace.";
*/
/*
  @widget-preset-field
  preset = "runningApps"; name = "runningAppsCurrentMonitor";
  widget = "switch"; label = "Current display";
  description = "Only show apps from the same monitor.";
*/
/*
  @widget-preset
  id = "appsDock"; label = "Apps dock";
  description = "Pinned and running apps with drag-and-drop";
  icon = "view-list-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "barMaxVisibleApps";
  widget = "spin"; min = 0; max = 20; label = "Max visible apps";
  description = "0 shows every pinned app.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "barShowOverflowBadge";
  widget = "switch"; label = "Show overflow badge";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "appsDockIconSizePercentage";
  widget = "spin"; min = 50; max = 200; unit = "%"; label = "Icon size";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "appsDockSpacing";
  widget = "spin"; min = 0; max = 32; unit = "px";
  label = "Spacing"; description = "Gap between dock icons.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "barMaxVisibleRunningApps";
  widget = "spin"; min = 0; max = 30;
  label = "Max running apps"; description = "Running apps shown before overflow. 0 shows every app.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "launcherEnabled";
  widget = "switch";
  label = "Show launcher"; description = "Show the launcher button inside the dock.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "launcherLogoBrightness";
  widget = "slider"; min = 0.0; max = 1.0; step = 0.05;
  label = "Logo brightness"; description = "Brightness of the launcher logo color.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "launcherLogoColorOverride";
  widget = "text";
  label = "Logo color override"; description = "Color role name or hex value; empty follows the theme.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "launcherLogoContrast";
  widget = "slider"; min = 0.0; max = 2.0; step = 0.05;
  label = "Logo contrast"; description = "Contrast of the launcher logo color.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "launcherLogoCustomPath";
  widget = "text";
  label = "Custom logo path"; description = "Image used when the logo mode is custom.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "launcherLogoMode";
  widget = "dropdown"; choices = [ "apps" "os" "dank" "compositor" "custom" ];
  label = "Logo"; description = "Which artwork the dock launcher shows.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "launcherLogoSizeOffset";
  widget = "spin"; min = -12; max = 12; unit = "px";
  label = "Logo size offset"; description = "Grow or shrink the dock launcher logo.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "runningAppsCompactMode";
  widget = "switch";
  label = "Compact mode"; description = "Draw running apps as compact icons.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "runningAppsCurrentWorkspace";
  widget = "switch";
  label = "Current workspace"; description = "Only show apps from the active workspace.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "appsDockActiveColorMode";
  widget = "dropdown"; choices = [ "primary" "secondary" "primaryContainer" "error" "success" ];
  label = "Active color"; description = "Theme role used for the active app indicator.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "appsDockColorizeActive";
  widget = "switch";
  label = "Colorize active"; description = "Color the active app icon.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "appsDockEnlargeOnHover";
  widget = "switch";
  label = "Magnification"; description = "Enlarge icons near the cursor.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "appsDockEnlargePercentage";
  widget = "spin"; min = 100; max = 150; step = 5; unit = "%";
  label = "Magnification size"; description = "How large hovered icons grow.";
*/
/*
  @widget-preset-field
  preset = "appsDock"; name = "appsDockHideIndicators";
  widget = "switch";
  label = "Hide indicators"; description = "Hide the running app indicator dots.";
*/

/*
  @widget-preset
  id = "island"; label = "Island";
  description = "Live activities that grow out of the bar";
  icon = "view-pin-symbolic"; sections = [ "left" "right" "center" ];
  hasSettings = true;
  defaults.islandFloating = false;
  defaults.islandPlacement = "edge";
  defaults.islandReserveThickness = 40;
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandFloating";
  widget = "switch"; label = "Floating";
  description = "Detach the island from the bar edge.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandPlacement";
  widget = "dropdown"; choices = [ "edge" "free" ]; label = "Placement";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandReserveThickness";
  widget = "spin"; min = 0; max = 200; unit = "px"; label = "Reserve thickness";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandAlongOffset";
  widget = "spin"; min = -600; max = 600; unit = "px";
  label = "Along offset"; description = "Shift the island along the screen edge.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandBatteryStyle";
  widget = "dropdown"; choices = [ "solid" "outline" "ring" "duo" ];
  label = "Battery style"; description = "Battery meter drawn on the home face.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandChargingPulse";
  widget = "switch";
  label = "Charging pulse"; description = "Pulse the island when the charger is connected or removed.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandCompactThickness";
  widget = "spin"; min = 24; max = 72; unit = "px";
  label = "Compact thickness"; description = "Island thickness in compact mode.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandFreeEdgeMargin";
  widget = "spin"; min = 0; max = 64; unit = "px";
  label = "Edge margin"; description = "Gap kept from the display edge when free floating.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandFreeIcon";
  widget = "text";
  label = "Icon"; description = "Icon name drawn inside a free floating island.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandFreeIconColor";
  widget = "text";
  label = "Icon color"; description = "Color role name or hex value; empty follows the theme.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandFreeIconMode";
  widget = "dropdown"; choices = [ "icon" "os" "dank" "compositor" "custom" ];
  label = "Icon mode"; description = "Which artwork the free floating island shows.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandFreeIconPath";
  widget = "text";
  label = "Icon path"; description = "Image used when the free island icon mode is custom.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandFreeIdleDelay";
  widget = "spin"; min = 0; max = 30000; step = 500; unit = "ms";
  label = "Idle delay"; description = "Time before the free floating island fades. 0 disables fading.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandFreeIdleOpacity";
  widget = "slider"; min = 0.0; max = 1.0; step = 0.05;
  label = "Idle opacity"; description = "Opacity of the free floating island while idle.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandFreeIdleScale";
  widget = "slider"; min = 0.2; max = 1.0; step = 0.01;
  label = "Idle size"; description = "How far the free floating island shrinks while idle.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandFreeSize";
  widget = "spin"; min = 24; max = 160; unit = "px";
  label = "Size"; description = "Diameter of a free floating island.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandHighContrast";
  widget = "switch";
  label = "High contrast"; description = "Draw the island with a higher contrast outline.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandHomeBrightnessDisplay";
  widget = "dropdown"; choices = [ "icon" "percentage" "both" ];
  label = "Brightness style"; description = "How the home face shows brightness.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandHomeClockDisplay";
  widget = "dropdown"; choices = [ "time" "date" "both" ];
  label = "Clock style"; description = "How the home face shows the clock.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandHomeCompactTight";
  widget = "switch";
  label = "Tight compact"; description = "Use the narrower compact home face.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandHomeStatusContent";
  widget = "dropdown"; choices = [ "battery" "connectivity" ];
  label = "Status"; description = "Status group shown on the home face.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandHomeVolumeDisplay";
  widget = "dropdown"; choices = [ "icon" "percentage" "both" ];
  label = "Volume style"; description = "How the home face shows volume.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandHoverCloseDelay";
  widget = "spin"; min = 0; max = 1000; step = 10; unit = "ms";
  label = "Hide delay"; description = "Delay before the hovered island closes.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandHoverOpenDelay";
  widget = "spin"; min = 0; max = 1000; step = 10; unit = "ms";
  label = "Open delay"; description = "Delay before the hovered island opens.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandInteractionMode";
  widget = "dropdown"; choices = [ "click" "hybrid" ];
  label = "Expansion mode"; description = "Click expands on click only, hybrid also peeks on hover.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandMediaAutoSwitch";
  widget = "switch";
  label = "Switch to media"; description = "Switch the compact face to media when playback starts.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandMediaClockVisible";
  widget = "switch";
  label = "Keep clock with media"; description = "Keep the clock visible on the media face.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandMediaLyrics";
  widget = "switch";
  label = "Lyrics"; description = "Show synced lyrics on the media face.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandNotch";
  widget = "switch";
  label = "Notch"; description = "Merge the island with the screen edge as a notch.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandNotificationBadgeClearOnOpen";
  widget = "switch";
  label = "Clear badge on open"; description = "Clear the notification badge when the center opens.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandNotificationExpand";
  widget = "switch";
  label = "Expand by default"; description = "Show arriving notifications expanded.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandNotificationPopups";
  widget = "switch";
  label = "Standard popups"; description = "Show arriving notifications as regular popups instead of inside the island.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandOuterGap";
  widget = "spin"; min = 0; max = 48; unit = "px";
  label = "Outer gap"; description = "Gap between the screen edge and the island.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandPalette";
  widget = "dropdown"; choices = [ "default" "bright" "dim" ];
  label = "Palette"; description = "Surface tone used by the island.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandRouteLauncher";
  widget = "switch";
  label = "Launcher"; description = "Open launcher inside the island instead of its bar popout.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandRouteControlCenter";
  widget = "switch";
  label = "Control Center"; description = "Open control center inside the island instead of its bar popout.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandRouteNotificationCenter";
  widget = "switch";
  label = "Notification Center"; description = "Open notification center inside the island instead of its bar popout.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandRouteClipboard";
  widget = "switch";
  label = "Clipboard"; description = "Open clipboard inside the island instead of its bar popout.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandRoutePowerMenu";
  widget = "switch";
  label = "Power menu"; description = "Open power menu inside the island instead of its bar popout.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandRouteDash";
  widget = "switch";
  label = "Dashboard"; description = "Open dashboard inside the island instead of its bar popout.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandRouteMedia";
  widget = "switch";
  label = "Media"; description = "Open media inside the island instead of its bar popout.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandRouteWeather";
  widget = "switch";
  label = "Weather"; description = "Open weather inside the island instead of its bar popout.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandRouteWallpaper";
  widget = "switch";
  label = "Wallpapers"; description = "Open wallpapers inside the island instead of its bar popout.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSatelliteBackground";
  widget = "switch";
  label = "Background"; description = "Draw a background behind the satellites.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSatelliteFollowInterfaceStyle";
  widget = "switch";
  label = "Follow interface opacity"; description = "Let satellites follow the global interface opacity.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSatelliteGap";
  widget = "spin"; min = 0; max = 48; unit = "px";
  label = "Gap"; description = "Gap between the island and its satellites.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSatelliteGothCorners";
  widget = "switch";
  label = "Goth corners"; description = "Square off the satellite corners.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSatellitePosition";
  widget = "dropdown"; choices = [ "island" "edges" ];
  label = "Position"; description = "Place satellites near the island or at the display edges.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSatelliteTransparency";
  widget = "slider"; min = 0.0; max = 1.0; step = 0.05;
  label = "Opacity"; description = "Opacity of the satellite background.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSatellitesEnabled";
  widget = "switch";
  label = "Show"; description = "Show widget satellites next to the island.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSharedRouting";
  widget = "dropdown"; choices = [ "normal" "always" "last-used" ];
  label = "Shared shortcuts"; description = "Which island handles global shortcuts.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSpringDamping";
  widget = "spin"; min = 10; max = 100; step = 1;
  label = "Spring damping"; description = "Damping of the island spring animation.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSpringMass";
  widget = "slider"; min = 0.25; max = 3.0; step = 0.05;
  label = "Spring mass"; description = "Mass of the island spring animation.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSpringStiffness";
  widget = "spin"; min = 100; max = 1200; step = 10;
  label = "Spring stiffness"; description = "Stiffness of the island spring animation.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandSystemOsd";
  widget = "switch";
  label = "System OSD"; description = "Show volume and brightness changes inside the island.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandUseOverlayLayer";
  widget = "switch";
  label = "Overlay layer"; description = "Draw the island on the overlay layer so windows can overlap it.";
*/
/*
  @widget-preset-field
  preset = "island"; name = "islandWidgetBackground";
  widget = "switch";
  label = "Background"; description = "Draw the bar widget background behind the compact face.";
*/

/*
  @widget-preset
  id = "clock"; label = "Clock";
  description = "Current time and date display";
  icon = "clock-applet-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.clockDateOrder = "timeFirst";
*/
/*
  @widget-preset-field
  preset = "clock"; name = "clockCompactMode";
  widget = "switch"; label = "Compact mode";
*/
/*
  @widget-preset-field
  preset = "clock"; name = "clockDateOrder";
  widget = "dropdown"; choices = [ "timeFirst" "dateFirst" ]; label = "Order";
  description = "Whether the time or the date comes first.";
*/
/*
  @widget-preset-field
  preset = "clock"; name = "clockNotificationBadge";
  widget = "switch"; label = "Notification badge";
  description = "Show the unread notification count next to the time.";
*/
/*
  @widget-preset
  id = "worldClock"; label = "World clock";
  description = "Multiple cities and time zones from the World Clock plugin";
  icon = "public"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "dankCalendarAgenda"; label = "Calendar agenda";
  description = "Dux Calendar next event and agenda";
  icon = "calendar_today"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "weather"; label = "Weather";
  description = "Current weather conditions and temperature";
  icon = "weather-clear-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "music"; label = "Media";
  description = "Now playing and media controls";
  icon = "audio-x-generic-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.mediaStyle = "controls";
  defaults.audioScrollMode = "volume";
*/
/*
  @widget-preset-field
  preset = "music"; name = "mediaStyle";
  widget = "dropdown"; choices = [ "controls" "activity" ]; label = "Style";
*/
/*
  @widget-preset-field
  preset = "music"; name = "mediaSize";
  widget = "spin"; min = 0; max = 3; label = "Size";
*/
/*
  @widget-preset-field
  preset = "music"; name = "audioScrollMode";
  widget = "dropdown"; choices = [ "volume" "song" "nothing" ]; label = "Scroll wheel";
*/
/*
  @widget-preset-field
  preset = "music"; name = "mediaShowCoverArt";
  widget = "switch"; label = "Cover art";
*/
/*
  @widget-preset-field
  preset = "music"; name = "mediaAdaptiveWidthEnabled";
  widget = "switch";
  label = "Adaptive width"; description = "Fit the song title instead of keeping a fixed width.";
*/
/*
  @widget-preset-field
  preset = "music"; name = "mediaShowLyrics";
  widget = "switch";
  label = "Lyrics"; description = "Show the line being sung while synced lyrics are available.";
*/

/*
  @widget-preset
  id = "clipboard"; label = "Clipboard manager";
  description = "Access clipboard history";
  icon = "edit-paste-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "cpuUsage"; label = "CPU usage";
  description = "CPU usage indicator";
  icon = "cpu-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.minimumWidth = true;
*/
/*
  @widget-preset-field
  preset = "cpuUsage"; name = "minimumWidth";
  widget = "switch"; label = "Force padding";
  description = "Keep a dynamic minimum width.";
*/
/*
  @widget-preset
  id = "memUsage"; label = "Memory usage";
  description = "Memory usage indicator";
  icon = "memory-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.minimumWidth = true;
*/
/*
  @widget-preset-field
  preset = "memUsage"; name = "minimumWidth";
  widget = "switch"; label = "Force padding";
*/
/*
  @widget-preset-field
  preset = "memUsage"; name = "showSwap";
  widget = "switch"; label = "Show swap";
*/
/*
  @widget-preset-field
  preset = "memUsage"; name = "showInGb";
  widget = "switch"; label = "Show in GB";
*/
/*
  @widget-preset
  id = "diskUsage"; label = "Disk usage";
  description = "Percentage";
  icon = "drive-harddisk-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.mountPath = "/";
  defaults.showMountPath = true;
*/
/*
  @widget-preset-field
  preset = "diskUsage"; name = "minimumWidth";
  widget = "switch"; label = "Force padding";
*/
/*
  @widget-preset-field
  preset = "diskUsage"; name = "mountPath";
  widget = "text"; label = "Mount";
  description = "Filesystem path to report.";
*/
/*
  @widget-preset-field
  preset = "diskUsage"; name = "diskUsageMode";
  widget = "spin"; min = 0; max = 3; label = "Disk usage format";
*/
/*
  @widget-preset-field
  preset = "diskUsage"; name = "showMountPath";
  widget = "switch"; label = "Show mount path";
*/
/*
  @widget-preset
  id = "cpuTemp"; label = "CPU temperature";
  description = "CPU temperature display";
  icon = "temp-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.minimumWidth = true;
*/
/*
  @widget-preset-field
  preset = "cpuTemp"; name = "minimumWidth";
  widget = "switch"; label = "Force padding";
*/
/*
  @widget-preset
  id = "gpuTemp"; label = "GPU temperature";
  description = "GPU temperature display";
  icon = "sensors-temperature-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.minimumWidth = true;
  defaults.selectedGpuIndex = 0;
*/
/*
  @widget-preset-field
  preset = "gpuTemp"; name = "minimumWidth";
  widget = "switch"; label = "Force padding";
*/
/*
  @widget-preset-field
  preset = "gpuTemp"; name = "selectedGpuIndex";
  widget = "spin"; min = 0; max = 8; label = "GPU";
  description = "Index of the GPU to monitor.";
*/
/*
  @widget-preset-field
  preset = "gpuTemp"; name = "pciId";
  widget = "text"; label = "PCI id";
  description = "Stable GPU identifier; set automatically when the index changes.";
*/
/*
  @widget-preset
  id = "systemTray"; label = "System tray";
  description = "System notification area icons";
  icon = "notifications-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.trayPopupSingleLine = true;
  defaults.trayAutoOverflow = true;
*/
/*
  @widget-preset-field
  preset = "systemTray"; name = "trayUseInlineExpansion";
  widget = "switch"; label = "Use inline expansion";
  description = "Hidden icons expand in place instead of in a popup.";
*/
/*
  @widget-preset-field
  preset = "systemTray"; name = "trayPopupSingleLine";
  widget = "switch"; label = "Single-line popup";
*/
/*
  @widget-preset-field
  preset = "systemTray"; name = "trayAutoOverflow";
  widget = "switch"; label = "Auto overflow";
*/
/*
  @widget-preset-field
  preset = "systemTray"; name = "trayMaxVisibleItems";
  widget = "spin"; min = 0; max = 20; label = "Max visible";
  description = "0 lets the tray decide.";
*/
/*
  @widget-preset-field
  preset = "systemTray"; name = "trayIconSpacing";
  widget = "spin"; min = 0; max = 20; unit = "px"; label = "Icon spacing";
*/
/*
  @widget-preset
  id = "privacyIndicator"; label = "Privacy indicator";
  description = "Shows when microphone, camera, or screen sharing is active";
  icon = "media-record-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
*/
/*
  @widget-preset-field
  preset = "privacyIndicator"; name = "privacyShowMicIcon";
  widget = "switch"; label = "Microphone";
*/
/*
  @widget-preset-field
  preset = "privacyIndicator"; name = "privacyShowCameraIcon";
  widget = "switch"; label = "Camera";
*/
/*
  @widget-preset-field
  preset = "privacyIndicator"; name = "privacyShowScreenShareIcon";
  widget = "switch"; label = "Screen sharing";
*/
/*
  @widget-preset
  id = "controlCenterButton"; label = "Control Center";
  description = "Access to system controls and settings";
  icon = "preferences-system-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.showAudioPercent = true;
  defaults.showBatteryIcon = true;
  defaults.showBrightnessIcon = true;
  defaults.showBrightnessPercent = true;
  defaults.showDoNotDisturbIcon = true;
  defaults.showIdleInhibitorIcon = true;
  defaults.showMicIcon = true;
  defaults.showMicPercent = true;
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showNetworkIcon";
  widget = "switch"; label = "Show network icon";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showVpnIcon";
  widget = "switch"; label = "Show VPN icon";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showBluetoothIcon";
  widget = "switch"; label = "Show Bluetooth icon";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showAudioIcon";
  widget = "switch"; label = "Show audio icon";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showAudioPercent";
  widget = "switch"; label = "Show audio percent";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showMicIcon";
  widget = "switch"; label = "Show microphone icon";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showMicPercent";
  widget = "switch"; label = "Show microphone percent";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showBrightnessIcon";
  widget = "switch"; label = "Show brightness icon";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showBrightnessPercent";
  widget = "switch"; label = "Show brightness percent";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showBatteryIcon";
  widget = "switch"; label = "Show battery icon";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showPrinterIcon";
  widget = "switch"; label = "Show printer icon";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showScreenSharingIcon";
  widget = "switch"; label = "Show screen sharing icon";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showIdleInhibitorIcon";
  widget = "switch"; label = "Show idle inhibitor icon";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "showDoNotDisturbIcon";
  widget = "switch"; label = "Show do not disturb icon";
*/
/*
  @widget-preset-field
  preset = "controlCenterButton"; name = "controlCenterGroupOrder";
  widget = "list";
  label = "Indicator order"; description = "Order of the status indicators shown in the control center button.";
*/

/*
  @widget-preset
  id = "notificationButton"; label = "Notification Center";
  description = "Access to notifications and do not disturb";
  icon = "notifications-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "battery"; label = "Battery";
  description = "Battery and power management";
  icon = "battery-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
  defaults.showBatteryPercent = true;
  defaults.batteryStyle = "icon";
*/
/*
  @widget-preset-field
  preset = "battery"; name = "showBatteryPercent";
  widget = "switch"; label = "Show percentage";
*/
/*
  @widget-preset-field
  preset = "battery"; name = "showBatteryPercentOnlyOnBattery";
  widget = "switch"; label = "Only on battery";
  description = "Hide the percentage while charging.";
*/
/*
  @widget-preset-field
  preset = "battery"; name = "showBatteryTime";
  widget = "switch"; label = "Show remaining time";
*/
/*
  @widget-preset-field
  preset = "battery"; name = "batteryStyle";
  widget = "dropdown"; choices = [ "icon" "solid" "outline" "ring" "duo" ];
  label = "Battery style";
*/
/*
  @widget-preset-field
  preset = "battery"; name = "showBatteryPowerCharging";
  widget = "switch";
  label = "Show charge rate"; description = "Show how many watts are going into the battery while charging.";
*/
/*
  @widget-preset-field
  preset = "battery"; name = "showBatteryPowerDischarging";
  widget = "switch";
  label = "Show discharge rate"; description = "Show how many watts the system is drawing from the battery.";
*/
/*
  @widget-preset-field
  preset = "battery"; name = "showBatteryTimeOnlyOnBattery";
  widget = "switch";
  label = "Time only on battery"; description = "Hide the remaining time while charging.";
*/

/*
  @widget-preset
  id = "vpn"; label = "VPN";
  description = "VPN status and quick connect";
  icon = "network-vpn-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "idleInhibitor"; label = "Idle inhibitor";
  description = "Prevent screen timeout";
  icon = "my-caffeine-on-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "capsLockIndicator"; label = "Caps Lock indicator";
  description = "Shows when caps lock is active";
  icon = "caps-lock-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "spacer"; label = "Spacer";
  description = "Customizable empty space";
  icon = "view-more-horizontal-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
  defaults.size = 20;
*/
/*
  @widget-preset-field
  preset = "spacer"; name = "size";
  widget = "spin"; min = 0; max = 200; unit = "px";
  label = "Size"; description = "Width or height of the empty space.";
*/

/*
  @widget-preset
  id = "separator"; label = "Separator";
  description = "Visual divider between widgets";
  icon = "list-remove-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "network_speed_monitor"; label = "Network speed monitor";
  description = "Network download and upload speed display";
  icon = "network-transmit-receive-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
*/
/*
  @widget-preset-field
  preset = "network_speed_monitor"; name = "hideWhenIdle";
  widget = "switch"; label = "Hide when idle";
  description = "While download and upload are both under 1 KB/s.";
*/
/*
  @widget-preset-field
  preset = "network_speed_monitor"; name = "compactMode";
  widget = "switch"; label = "Compact mode";
  description = "Whole numbers, at most three digits.";
*/
/*
  @widget-preset
  id = "keyboard_layout_name"; label = "Keyboard layout";
  description = "Displays the active keyboard layout and allows switching";
  icon = "input-keyboard-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
*/
/*
  @widget-preset-field
  preset = "keyboard_layout_name"; name = "keyboardLayoutNameCompactMode";
  widget = "switch"; label = "Compact mode";
*/
/*
  @widget-preset-field
  preset = "keyboard_layout_name"; name = "keyboardLayoutNameShowIcon";
  widget = "switch"; label = "Show icon";
*/
/*
  @widget-preset-field
  preset = "keyboard_layout_name"; name = "keyboardLayoutNameLabelOverrides";
  widget = "raw";
  label = "Label overrides"; description = "Map of displayed layout labels to replacement labels.";
*/

/*
  @widget-preset
  id = "notepadButton"; label = "Notepad";
  description = "Quick access to notepad";
  icon = "text-editor-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "colorPicker"; label = "Color Picker";
  description = "Quick access to color picker";
  icon = "color-select-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/
/*
  @widget-preset
  id = "systemUpdate"; label = "System update";
  description = "Check for system updates";
  icon = "software-update-available-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = true;
*/
/*
  @widget-preset-field
  preset = "systemUpdate"; name = "hideWhenIdle";
  widget = "switch"; label = "Hide when no updates";
*/
/*
  @widget-preset
  id = "powerMenuButton"; label = "Power";
  description = "Display the power system menu";
  icon = "system-shutdown-symbolic"; sections = [ "left" "right" "center" "dock" ];
  hasSettings = false;
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-bar =
    { config, lib, ... }:

    {
      options.ojuny.dux.barPreset = lib.mkOption {
        type = lib.types.enum [
          "default"
          "taskbar"
          "status"
          "sidebar-left"
          "sidebar-right"
          "caelestia"
          "goth"
          "simple-island"
          "simple-bar"
          "custom"
          "none"
        ];
        default = "default";
        description = "Active bar preset. Apply with Save and Rebuild.";
      };

      options.ojuny.dux.customBar = lib.mkOption {
        type = lib.types.toml;
        default = inputs.ojuny-desktop.barPresets.customBase;
        description = "Editable settings for the custom bar preset.";
      };

      config = {

        # @option widget = "dropdown"; label = "Preset"; order = 1; choices = [ "default" "taskbar" "status" "sidebar-left" "sidebar-right" "caelestia" "goth" "simple-island" "simple-bar" "custom" "none" ]; description = "Active bar preset. Apply with Save and Rebuild.";
        ojuny.dux.barPreset = "taskbar";

        desktop.ojuny.dux.barPreset = config.ojuny.dux.barPreset;

        desktop.ojuny.dux.barPresets = lib.recursiveUpdate inputs.ojuny-desktop.barPresets.presets {
          default.leftWidgets.dankCalendarAgenda = {
            enabled = config.desktop.ojuny.dux.plugins.dankCalendarAgenda.enable;
            _order = 35;
          };
          taskbar.rightWidgets.worldClock = {
            enabled = false;
            _order = 35;
          };
          status.rightWidgets.worldClock = {
            enabled = config.desktop.ojuny.dux.plugins.worldClock.enable;
            _order = 35;
          };
        };

        # @option widget = "bar"; label = "Custom bar"; visibleWhen.path = "ojuny.dux.barPreset"; visibleWhen.equals = "custom";
        ojuny.dux.customBar = {

          # @option widget = "text"; label = "Name"; group = "Bar"; groupOrder = 10; description = "Display name for this bar.";
          name = "Custom bar";

          # @option widget = "dropdown"; label = "Position"; group = "Bar"; groupOrder = 10; choices = [ "0" "1" "2" "3" ]; description = "Screen edge: 0 = top, 1 = bottom, 2 = left, 3 = right."; applyCommand = "case %%val%% in 0) p=top;; 1) p=bottom;; 2) p=left;; 3) p=right;; esac; dms ipc call bar setPosition id custom \"$p\"";
          position = 0;

          # @option widget = "switch"; label = "Show on last display"; group = "Bar"; groupOrder = 10; description = "Keep the bar on the display it was last shown on.";
          showOnLastDisplay = true;

          # @option widget = "list"; label = "Screens"; group = "Bar"; groupOrder = 10; hidden = true; description = "Screen names, or \"all\".";
          screenPreferences = [ "all" ];

          # @option label = "Center widgets"; description = "Widgets shown in the bar centre. Position is the tile order. The island widget displaces centre widgets.";
          centerWidgets = [
            "music"
            "clock"
            "weather"
          ];

          # @option widget = "switch"; label = "Show on overview"; group = "Bar"; groupOrder = 10; description = "Keep the bar visible while the overview is open.";
          openOnOverview = false;

          # @option widget = "spin"; label = "Order"; group = "Bar"; groupOrder = 10; min = 1; max = 1000; hidden = true; description = "Sort order when several bars exist.";
          _order = 10;

          # @option widget = "switch"; label = "Auto hide"; group = "Auto hide"; groupOrder = 20; description = "Hide the bar until the pointer reaches the screen edge."; applyCommand = "if test %%val%% = true; then dms ipc call bar autoHide id custom; else dms ipc call bar manualHide id custom; fi";
          autoHide = false;

          # @option widget = "spin"; label = "Auto hide delay"; group = "Auto hide"; groupOrder = 20; min = 0; max = 5000; unit = "ms"; description = "Delay before the bar hides again."; visibleWhen.path = "ojuny.dux.customBar.autoHide"; visibleWhen.equals = true;
          autoHideDelay = 250;

          # @option widget = "switch"; label = "Attach to screen edge"; group = "Bar"; groupOrder = 10; description = "Snap the bar flush to the screen edge instead of floating.";
          attachToScreenEdge = false;

          # @option widget = "switch"; label = "Use overlay layer"; group = "Bar"; groupOrder = 10; advanced = true; description = "Draw the bar on the overlay layer so windows can overlap it.";
          useOverlayLayer = false;

          # @option widget = "slider"; label = "Transparency"; group = "Transparency"; groupOrder = 30; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the bar background.";
          transparency = 1;

          # @option widget = "slider"; label = "Widget transparency"; group = "Transparency"; groupOrder = 30; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the bar widgets.";
          widgetTransparency = 1;

          followInterfaceStyle = false;
          surfaceColor = "sch";
          widgetFollowInterfaceStyle = true;

          # @option widget = "slider"; label = "Icon scale"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0.5; max = 2.0; step = 0.05; description = "Multiplier for widget icon sizes.";
          iconScale = 0.9;

          # @option widget = "slider"; label = "Font scale"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0.5; max = 2.0; step = 0.05; description = "Multiplier for bar font sizes.";
          fontScale = 0.9;

          # @option widget = "spin"; label = "Spacing"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0; max = 40; unit = "px"; description = "Gap between widgets.";
          spacing = 0;

          # @option widget = "spin"; label = "Bottom gap"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0; max = 100; unit = "px"; description = "Gap between the bar and its screen edge.";
          bottomGap = 0;

          # @option widget = "spin"; label = "Inner padding"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0; max = 40; unit = "px"; description = "Padding inside the bar around its content.";
          innerPadding = 0;

          # @option widget = "spin"; label = "Widget padding"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0; max = 40; unit = "px"; description = "Padding around each widget.";
          widgetPadding = 9;

          # @option widget = "switch"; label = "Square corners"; group = "Appearance"; groupOrder = 35; description = "Use square bar corners instead of rounded ones.";
          squareCorners = true;

          # @option widget = "switch"; label = "No background"; group = "Appearance"; groupOrder = 35; description = "Draw no background surface; widgets sit directly on the wallpaper.";
          noBackground = false;

          # @option widget = "switch"; label = "Widget outline"; group = "Appearance"; groupOrder = 35; description = "Draw an outline around each widget.";
          widgetOutlineEnabled = true;

          # @option widget = "switch"; label = "Border"; group = "Appearance"; groupOrder = 35; description = "Draw a border around the bar.";
          borderEnabled = false;

          # @option widget = "dropdown"; label = "Border color"; group = "Appearance"; groupOrder = 35; choices = [ "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role used for the bar border. sch = scheme high surface, s = surface."; visibleWhen.path = "ojuny.dux.customBar.borderEnabled"; visibleWhen.equals = true;
          borderColor = "primary";

          # @option widget = "slider"; label = "Border opacity"; group = "Appearance"; groupOrder = 35; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the bar border."; visibleWhen.path = "ojuny.dux.customBar.borderEnabled"; visibleWhen.equals = true;
          borderOpacity = 1;

          borderThickness = 1;

          # @option widget = "spin"; label = "Shadow intensity"; group = "Appearance"; groupOrder = 35; min = 0; max = 100; description = "Strength of the bar drop shadow.";
          shadowIntensity = 0;

          # @option widget = "spin"; label = "Shadow opacity"; group = "Appearance"; groupOrder = 35; min = 0; max = 100; unit = "%"; description = "Opacity of the bar drop shadow in percent.";
          shadowOpacity = 60;

          # @option widget = "switch"; label = "Automatic popup gaps"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; description = "Compute popup gap size from the bar layout automatically.";
          popupGapsAuto = true;

          # @option widget = "spin"; label = "Popup gap"; group = "Scale and spacing"; groupOrder = 25; horizontal = true; min = 0; max = 40; unit = "px"; description = "Popup gap size when automatic gaps are off."; visibleWhen.path = "ojuny.dux.customBar.popupGapsAuto"; visibleWhen.equals = false;
          popupGapsManual = 4;

          # @option widget = "switch"; label = "Island"; group = "Island"; groupOrder = 40; description = "Draw the bar as a floating island detached from the screen edge.";
          island = true;

          # @option widget = "spin"; label = "Compact thickness"; group = "Island"; groupOrder = 40; min = 0; max = 200; unit = "px"; description = "Island thickness in compact mode.";
          islandCompactThickness = 31;

          # @option widget = "spin"; label = "Outer gap"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px"; description = "Gap between the island and the screen edge.";
          islandOuterGap = 3;

          # @option widget = "spin"; label = "Satellite gap"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px"; description = "Gap between the island and its satellite popouts.";
          islandSatelliteGap = 4;

          # @option widget = "switch"; label = "Satellite background"; group = "Island"; hidden = true;
          islandSatelliteBackground = false;

          # @option widget = "switch"; label = "Satellite goth corners"; group = "Island"; hidden = true;
          islandSatelliteGothCorners = false;

          # @option widget = "spin"; label = "Satellite hover gap"; group = "Island"; groupOrder = 40; min = 0; max = 100; unit = "px"; description = "Extra satellite gap while the island is hovered.";
          islandSatelliteHoverGap = 5;

          # @option widget = "spin"; label = "Hover open delay"; group = "Island"; groupOrder = 40; min = 0; max = 2000; unit = "ms"; description = "Delay before a hovered satellite opens.";
          islandHoverOpenDelay = 350;

          # @option widget = "spin"; label = "Hover close delay"; group = "Island"; groupOrder = 40; min = 0; max = 2000; unit = "ms"; description = "Delay before a hovered satellite closes.";
          islandHoverCloseDelay = 350;

          # @option widget = "spin"; label = "Spring stiffness"; group = "Island motion"; hidden = true; min = 0;
          islandSpringStiffness = 760;

          # @option widget = "spin"; label = "Spring damping"; group = "Island motion"; hidden = true; min = 0;
          islandSpringDamping = 47;

          # @option widget = "spin"; label = "Spring mass"; group = "Island motion"; hidden = true; min = 1;
          islandSpringMass = 2;

          # @option widget = "spin"; label = "Widget padding"; group = "Island"; groupOrder = 40; min = 0; max = 40; unit = "px"; description = "Padding around widgets inside the island.";
          islandWidgetPadding = 0;

          # @option widget = "switch"; label = "Widget outline"; group = "Island"; groupOrder = 40; description = "Outline the widgets inside the island.";
          islandWidgetOutlineEnabled = true;

          # @option widget = "dropdown"; label = "Widget outline color"; group = "Island"; groupOrder = 40; choices = [ "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role used for the island widget outline. surfaceText = on-background text."; visibleWhen.path = "ojuny.dux.customBar.islandWidgetOutlineEnabled"; visibleWhen.equals = true;
          islandWidgetOutlineColor = "surfaceText";

          # @option widget = "slider"; label = "Widget outline opacity"; group = "Island"; groupOrder = 40; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the island widget outline."; visibleWhen.path = "ojuny.dux.customBar.islandWidgetOutlineEnabled"; visibleWhen.equals = true;
          islandWidgetOutlineOpacity = 0.5;

          # @option widget = "switch"; label = "Bar goth corners"; group = "Appearance"; groupOrder = 35; description = "Square off the regular (non-island) bar corners instead of rounding them.";
          gothCornersEnabled = false;

          # @option widget = "switch"; label = "Override bar goth corner radius"; group = "Appearance"; groupOrder = 35; description = "Use a custom radius for the bar's goth corners."; visibleWhen.path = "ojuny.dux.customBar.gothCornersEnabled"; visibleWhen.equals = true;
          gothCornerRadiusOverride = false;

          # @option widget = "spin"; label = "Bar goth corner radius"; group = "Appearance"; groupOrder = 35; min = 0; max = 100; unit = "px"; description = "Radius of the bar's goth corners."; visibleWhen.path = "ojuny.dux.customBar.gothCornerRadiusOverride"; visibleWhen.equals = true;
          gothCornerRadiusValue = 12;

          # @option widget = "spin"; label = "Inset padding"; group = "Scale and spacing"; groupOrder = 25; min = -1; max = 48; unit = "px"; horizontal = true; description = "Gap between the bar ends and the outermost widgets. -1 uses the default.";
          barInsetPadding = -1;

          # @option widget = "dropdown"; label = "Battery color"; group = "Appearance"; groupOrder = 35; choices = [ "theme" "level" ]; description = "Theme uses the accent color, level colors the battery by charge level.";
          batteryColorMode = "theme";

          # @option widget = "switch"; label = "Maximize widget icons"; group = "Scale and spacing"; groupOrder = 25; description = "Stretch widget icons to fill the bar.";
          maximizeWidgetIcons = false;

          # @option widget = "switch"; label = "Maximize widget text"; group = "Scale and spacing"; groupOrder = 25; description = "Stretch widget text to fill the bar.";
          maximizeWidgetText = false;

          # @option widget = "dropdown"; label = "Shadow color"; group = "Appearance"; groupOrder = 35; choices = [ "default" "surface" "primary" "custom" ]; description = "Source of the bar drop shadow color.";
          shadowColorMode = "default";

          # @option widget = "color"; label = "Custom shadow color"; group = "Appearance"; groupOrder = 35; visibleWhen.path = "ojuny.dux.customBar.shadowColorMode"; visibleWhen.equals = "custom"; description = "Shadow color used when the shadow color is set to custom.";
          shadowCustomColor = "#000000";

          # @option widget = "dropdown"; label = "Shadow direction source"; group = "Appearance"; groupOrder = 35; choices = [ "inherit" "autoBar" "manual" ]; description = "Inherit the global shadow direction, derive it from the bar, or set it manually.";
          shadowDirectionMode = "inherit";

          # @option widget = "dropdown"; label = "Shadow direction"; group = "Appearance"; groupOrder = 35; choices = [ "top" "topLeft" "topRight" "bottom" ]; visibleWhen.path = "ojuny.dux.customBar.shadowDirectionMode"; visibleWhen.equals = "manual"; description = "Shadow direction used when the direction source is manual.";
          shadowDirection = "top";

          # @option widget = "color"; label = "Custom background color"; group = "Appearance"; groupOrder = 35; visibleWhen.path = "ojuny.dux.customBar.surfaceColor"; visibleWhen.equals = "custom"; description = "Bar background color used when the background color is set to custom.";
          surfaceCustomColor = "#6750A4";

          # @option widget = "dropdown"; label = "Widget outline color"; group = "Appearance"; groupOrder = 35; choices = [ "surfaceText" "secondary" "primary" ]; description = "Theme role used for the widget outline.";
          widgetOutlineColor = "primary";

          # @option widget = "slider"; label = "Widget outline opacity"; group = "Appearance"; groupOrder = 35; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the widget outline.";
          widgetOutlineOpacity = 1.0;

          # @option widget = "spin"; label = "Widget outline thickness"; group = "Appearance"; groupOrder = 35; min = 1; max = 10; unit = "px"; description = "Outline width around each widget.";
          widgetOutlineThickness = 1;

          # @option widget = "dropdown"; label = "Widget style"; group = "Appearance"; groupOrder = 35; choices = [ "pills" "segments" "flat" ]; description = "How widgets are drawn inside the bar.";
          widgetStyle = "pills";

          # @option widget = "spin"; label = "Island along offset"; group = "Island"; groupOrder = 40; min = -600; max = 600; unit = "px"; description = "Shift the island along the screen edge.";
          islandAlongOffset = 0;

          # @option widget = "dropdown"; label = "Island battery style"; group = "Island"; groupOrder = 40; choices = [ "solid" "outline" "ring" "duo" ]; description = "Battery meter drawn on the island home face.";
          islandBatteryStyle = "duo";

          # @option widget = "switch"; label = "Charging pulse"; group = "Island"; groupOrder = 40; description = "Pulse the island when the charger is connected or removed.";
          islandChargingPulse = true;

          # @option widget = "switch"; label = "Island floating"; group = "Island"; groupOrder = 40; description = "Detach the island from the screen edge.";
          islandFloating = false;

          # @option widget = "spin"; label = "Island edge margin"; group = "Island"; groupOrder = 40; min = 0; max = 64; unit = "px"; description = "Gap kept from the display edge when the island is free floating.";
          islandFreeEdgeMargin = 2;

          # @option widget = "text"; label = "Island free icon"; group = "Island"; groupOrder = 40; description = "Icon name drawn inside a free floating island.";
          islandFreeIcon = "blur_on";

          # @option widget = "text"; label = "Island free icon color"; group = "Island"; groupOrder = 40; description = "Color role name or hex value for the free floating island icon.";
          islandFreeIconColor = "primary";

          # @option widget = "dropdown"; label = "Island free icon mode"; group = "Island"; groupOrder = 40; choices = [ "icon" "os" "dank" "compositor" "custom" ]; description = "Which artwork the free floating island shows.";
          islandFreeIconMode = "icon";

          # @option widget = "text"; label = "Island free icon path"; group = "Island"; groupOrder = 40; description = "Image path used when the free island icon mode is custom.";
          islandFreeIconPath = "";

          # @option widget = "spin"; label = "Island idle delay"; group = "Island"; groupOrder = 40; min = 0; max = 30000; unit = "ms"; description = "Time before the free floating island fades while idle. 0 disables fading.";
          islandFreeIdleDelay = 2500;

          # @option widget = "slider"; label = "Island idle opacity"; group = "Island"; groupOrder = 40; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the free floating island while idle.";
          islandFreeIdleOpacity = 0.45;

          # @option widget = "slider"; label = "Island idle size"; group = "Island"; groupOrder = 40; min = 0.2; max = 1.0; step = 0.01; description = "How far the free floating island shrinks while idle.";
          islandFreeIdleScale = 0.4;

          # @option widget = "spin"; label = "Island free size"; group = "Island"; groupOrder = 40; min = 24; max = 160; unit = "px"; description = "Diameter of a free floating island.";
          islandFreeSize = 48;

          # @option widget = "switch"; label = "Island high contrast"; group = "Island"; groupOrder = 40; description = "Draw the island with a higher contrast outline.";
          islandHighContrast = false;

          # @option widget = "dropdown"; label = "Island brightness style"; group = "Island"; groupOrder = 40; choices = [ "icon" "percentage" "both" ]; description = "How the home face shows brightness.";
          islandHomeBrightnessDisplay = "both";

          # @option widget = "dropdown"; label = "Island clock style"; group = "Island"; groupOrder = 40; choices = [ "time" "date" "both" ]; description = "How the home face shows the clock.";
          islandHomeClockDisplay = "both";

          # @option widget = "switch"; label = "Island tight compact"; group = "Island"; groupOrder = 40; description = "Use the narrower compact home face.";
          islandHomeCompactTight = false;

          # @option widget = "dropdown"; label = "Island status content"; group = "Island"; groupOrder = 40; choices = [ "battery" "connectivity" ]; description = "Status group shown on the home face.";
          islandHomeStatusContent = "battery";

          # @option widget = "dropdown"; label = "Island volume style"; group = "Island"; groupOrder = 40; choices = [ "icon" "percentage" "both" ]; description = "How the home face shows volume.";
          islandHomeVolumeDisplay = "both";

          # @option widget = "dropdown"; label = "Island expansion mode"; group = "Island"; groupOrder = 40; choices = [ "click" "hybrid" ]; description = "Click expands on click only, hybrid also peeks on hover.";
          islandInteractionMode = "hybrid";

          # @option widget = "switch"; label = "Island media auto switch"; group = "Island"; groupOrder = 40; description = "Switch the compact face to media when playback starts.";
          islandMediaAutoSwitch = false;

          # @option widget = "switch"; label = "Island media clock"; group = "Island"; groupOrder = 40; description = "Keep the clock visible on the media face.";
          islandMediaClockVisible = true;

          # @option widget = "switch"; label = "Island media lyrics"; group = "Island"; groupOrder = 40; description = "Show synced lyrics on the media face.";
          islandMediaLyrics = false;

          # @option widget = "switch"; label = "Island notch"; group = "Island"; groupOrder = 40; description = "Merge the island with the screen edge as a notch.";
          islandNotch = false;

          # @option widget = "switch"; label = "Island clear badge on open"; group = "Island"; groupOrder = 40; description = "Clear the notification badge when the notification center opens.";
          islandNotificationBadgeClearOnOpen = false;

          # @option widget = "switch"; label = "Island expand notifications"; group = "Island"; groupOrder = 40; description = "Show arriving notifications expanded.";
          islandNotificationExpand = false;

          # @option widget = "switch"; label = "Island standard popups"; group = "Island"; groupOrder = 40; description = "Show arriving notifications as regular popups instead of inside the island.";
          islandNotificationPopups = false;

          # @option widget = "dropdown"; label = "Island palette"; group = "Island"; groupOrder = 40; choices = [ "default" "bright" "dim" ]; description = "Surface tone used by the island.";
          islandPalette = "default";

          # @option widget = "dropdown"; label = "Island placement"; group = "Island"; groupOrder = 40; choices = [ "edge" "free" ]; description = "Dock the island to the edge or let it float freely.";
          islandPlacement = "edge";

          # @option widget = "spin"; label = "Island reserve thickness"; group = "Island"; groupOrder = 40; min = 24; max = 128; unit = "px"; description = "Reserved strip kept free for the island.";
          islandReserveThickness = 40;

          # @option widget = "dropdown"; label = "Island clipboard route"; group = "Island"; groupOrder = 40; choices = [ "island" "follow" ]; description = "Send the clipboard shortcut to the island or leave it on the bar popout.";
          islandRouteClipboard = "follow";

          # @option widget = "dropdown"; label = "Island control center route"; group = "Island"; groupOrder = 40; choices = [ "island" "follow" ]; description = "Send the control center shortcut to the island or leave it on the bar popout.";
          islandRouteControlCenter = "follow";

          # @option widget = "dropdown"; label = "Island dashboard route"; group = "Island"; groupOrder = 40; choices = [ "island" "follow" ]; description = "Send the dashboard shortcut to the island or leave it on the bar popout.";
          islandRouteDash = "island";

          # @option widget = "dropdown"; label = "Island launcher route"; group = "Island"; groupOrder = 40; choices = [ "island" "follow" ]; description = "Send the launcher shortcut to the island or leave it on the bar popout.";
          islandRouteLauncher = "follow";

          # @option widget = "dropdown"; label = "Island media route"; group = "Island"; groupOrder = 40; choices = [ "island" "follow" ]; description = "Send the media shortcut to the island or leave it on the bar popout.";
          islandRouteMedia = "island";

          # @option widget = "dropdown"; label = "Island notification center route"; group = "Island"; groupOrder = 40; choices = [ "island" "follow" ]; description = "Send the notification center shortcut to the island or leave it on the bar popout.";
          islandRouteNotificationCenter = "follow";

          # @option widget = "dropdown"; label = "Island power menu route"; group = "Island"; groupOrder = 40; choices = [ "island" "follow" ]; description = "Send the power menu shortcut to the island or leave it on the bar popout.";
          islandRoutePowerMenu = "follow";

          # @option widget = "dropdown"; label = "Island wallpaper route"; group = "Island"; groupOrder = 40; choices = [ "island" "follow" ]; description = "Send the wallpaper shortcut to the island or leave it on the bar popout.";
          islandRouteWallpaper = "island";

          # @option widget = "dropdown"; label = "Island weather route"; group = "Island"; groupOrder = 40; choices = [ "island" "follow" ]; description = "Send the weather shortcut to the island or leave it on the bar popout.";
          islandRouteWeather = "island";

          # @option widget = "switch"; label = "Island satellites follow interface"; group = "Island"; groupOrder = 40; description = "Let satellites follow the global interface opacity.";
          islandSatelliteFollowInterfaceStyle = true;

          # @option widget = "dropdown"; label = "Island satellite position"; group = "Island"; groupOrder = 40; choices = [ "island" "edges" ]; description = "Place satellites near the island or at the display edges.";
          islandSatellitePosition = "edges";

          # @option widget = "slider"; label = "Island satellite opacity"; group = "Island"; groupOrder = 40; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of the satellite background.";
          islandSatelliteTransparency = 1.0;

          # @option widget = "switch"; label = "Island satellites"; group = "Island"; groupOrder = 40; description = "Show widget satellites next to the island.";
          islandSatellitesEnabled = true;

          # @option widget = "dropdown"; label = "Island shared shortcuts"; group = "Island"; groupOrder = 40; choices = [ "normal" "always" "last-used" ]; description = "Which island handles global shortcuts.";
          islandSharedRouting = "normal";

          # @option widget = "switch"; label = "Island system OSD"; group = "Island"; groupOrder = 40; description = "Show volume and brightness changes inside the island.";
          islandSystemOsd = true;

          # @option widget = "switch"; label = "Island overlay layer"; group = "Island"; groupOrder = 40; description = "Draw the island on the overlay layer so windows can overlap it.";
          islandUseOverlayLayer = false;

          # @option widget = "switch"; label = "Strict auto hide"; group = "Auto hide"; groupOrder = 20; description = "Hide the bar whenever the pointer leaves even if a popout is open.";
          autoHideStrict = false;

          # @option widget = "dropdown"; label = "Bar length"; group = "Scale and spacing"; groupOrder = 25; choices = [ "full" "percent" "fit" ]; description = "Span the whole edge, a percentage of it, or only the widgets.";
          barLengthMode = "full";

          # @option widget = "spin"; label = "Length padding"; group = "Scale and spacing"; groupOrder = 25; min = 0; max = 512; unit = "px"; description = "Shorten the bar at both ends when it spans the full edge.";
          barLengthPadding = 0;

          # @option widget = "spin"; label = "Bar length percent"; group = "Scale and spacing"; groupOrder = 25; min = 10; max = 100; unit = "%"; visibleWhen.path = "ojuny.dux.customBar.barLengthMode"; visibleWhen.equals = "percent"; description = "Percentage of the edge the bar spans.";
          barLengthPercent = 80;

          # @option widget = "text"; label = "Center overflow mode"; group = "Behavior"; groupOrder = 50; advanced = true; description = "How overflowing centre widgets are handled. Not part of the recorded settings defaults.";
          centerOverflowMode = "";

          # @option widget = "switch"; label = "Follow mouse"; group = "Behavior"; groupOrder = 50; description = "Open the control center at the cursor instead of the widget.";
          clickActionFollowMouse = false;

          # @option widget = "switch"; label = "Click through"; group = "Behavior"; groupOrder = 50; description = "Let clicks on empty bar space reach the windows below.";
          clickThrough = false;

          # @option widget = "spin"; label = "Hover popout delay"; group = "Behavior"; groupOrder = 50; min = 0; max = 1000; unit = "ms"; description = "Delay before a hovered popout opens.";
          hoverPopoutDelay = 150;

          # @option widget = "switch"; label = "Hover popouts"; group = "Behavior"; groupOrder = 50; description = "Open popouts when the pointer hovers a widget.";
          hoverPopouts = false;

          # @option widget = "text"; label = "Left overflow mode"; group = "Behavior"; groupOrder = 50; advanced = true; description = "How overflowing left widgets are handled. Not part of the recorded settings defaults.";
          leftOverflowMode = "";

          # @option widget = "switch"; label = "Maximize detection"; group = "Behavior"; groupOrder = 50; description = "Track maximized windows so the bar can react to them.";
          maximizeDetection = true;

          # @option widget = "dropdown"; label = "Middle click"; group = "Behavior"; groupOrder = 50; choices = [ "none" "control-center" "spotlight" "close-window" "settings" ]; description = "What middle clicking empty bar space does.";
          middleClickAction = "none";

          # @option widget = "dropdown"; label = "Right click"; group = "Behavior"; groupOrder = 50; choices = [ "none" "control-center" "spotlight" "close-window" "settings" ]; description = "What right clicking empty bar space does.";
          rightClickAction = "none";

          # @option widget = "text"; label = "Right overflow mode"; group = "Behavior"; groupOrder = 50; advanced = true; description = "How overflowing right widgets are handled. Not part of the recorded settings defaults.";
          rightOverflowMode = "";

          # @option widget = "switch"; label = "Scroll wheel"; group = "Behavior"; groupOrder = 50; description = "Change workspaces or focus by scrolling over the bar.";
          scrollEnabled = true;

          # @option widget = "dropdown"; label = "Scroll X axis"; group = "Behavior"; groupOrder = 50; choices = [ "none" "workspace" "focusWindow" ]; description = "What horizontal scrolling over the bar does.";
          scrollXBehavior = "focusWindow";

          # @option widget = "dropdown"; label = "Scroll Y axis"; group = "Behavior"; groupOrder = 50; choices = [ "none" "workspace" "focusWindow" ]; description = "What vertical scrolling over the bar does.";
          scrollYBehavior = "workspace";

          # @option widget = "switch"; label = "Show when windows open"; group = "Auto hide"; groupOrder = 20; description = "Reveal the bar when a window opens.";
          showOnWindowsOpen = false;
          # @option label = "Left widgets"; description = "Widgets shown on the left of the bar. Position is the tile order.";
          leftWidgets = {

            workspaceSwitcher = {
              enabled = true;
              _order = 10;
              showOccupiedWorkspacesOnly = true;
              showWorkspaceIndex = true;
              showWorkspacePadding = true;
              workspacePaddingCount = 5;
              workspaceIndicatorCompact = true;
              dwlShowAllTags = false;
            };

            dankKDEConnect = {
              enabled = true;
              _order = 20;
            };

            layout = {
              enabled = true;
              _order = 30;
            };

            dankCalendarAgenda = {
              enabled = config.desktop.ojuny.dux.plugins.dankCalendarAgenda.enable;
              _order = 35;
            };

            scratchpadHelper = {
              enabled = true;
              _order = 40;
            };

          };

          # @option label = "Right widgets"; description = "Widgets shown on the right of the bar. Position is the tile order.";
          rightWidgets = {

            systemTray = {
              enabled = true;
              _order = 10;
            };

            clipboard = {
              enabled = true;
              _order = 20;
            };

            developerUtilities = {
              enabled = true;
              _order = 30;
            };

            nixMonitor = {
              enabled = true;
              _order = 40;
            };

            localServices = {
              enabled = true;
              _order = 50;
            };

            controlCenterButton = {
              enabled = true;
              showAudioPercent = true;
              showBatteryIcon = true;
              showBrightnessIcon = true;
              showBrightnessPercent = true;
              showDoNotDisturbIcon = true;
              showIdleInhibitorIcon = true;
              showMicIcon = true;
              showMicPercent = true;
              _order = 60;
            };

          };

        };

        desktop.ojuny.dux.barConfigs.custom = config.ojuny.dux.customBar // {
          enabled = config.ojuny.dux.barPreset == "custom";
          visible = config.ojuny.dux.barPreset == "custom";
        };

        # @option widget = "switch"; label = "Elevation shadow"; group = "Bar"; advanced = true; description = "Draw a drop shadow under the bar."; applyCommand = "dms ipc call settings set barElevationEnabled %%val%%";
        desktop.ojuny.dux.settings.barElevationEnabled = false;

        # @option widget = "spin"; label = "Shared inset padding"; group = "Bar"; groupOrder = 10; min = -1; max = 48; unit = "px"; advanced = true; description = "Inset padding applied to every bar when sync is on."; applyCommand = "dms ipc call settings set barInsetPaddingShared %%val%%";
        desktop.ojuny.dux.settings.barInsetPaddingShared = -1;

        # @option widget = "switch"; label = "Sync inset padding"; group = "Bar"; groupOrder = 10; advanced = true; description = "Apply one inset padding value to every bar."; applyCommand = "dms ipc call settings set barInsetPaddingSyncAll %%val%%";
        desktop.ojuny.dux.settings.barInsetPaddingSyncAll = false;

        # @option widget = "color"; label = "Custom card surface color"; group = "Surfaces"; groupOrder = 60; visibleWhen.path = "desktop.ojuny.dux.settings.cardSurfaceColor"; visibleWhen.equals = "custom"; description = "Card surface color used when the card surface color is custom."; applyCommand = "dms ipc call settings set cardSurfaceCustomColor %%val%%";
        desktop.ojuny.dux.settings.cardSurfaceCustomColor = "#6750a4";

        # @option widget = "color"; label = "Custom chip surface color"; group = "Surfaces"; groupOrder = 60; visibleWhen.path = "desktop.ojuny.dux.settings.chipSurfaceColor"; visibleWhen.equals = "custom"; description = "Chip surface color used when the chip surface color is custom."; applyCommand = "dms ipc call settings set chipSurfaceCustomColor %%val%%";
        desktop.ojuny.dux.settings.chipSurfaceCustomColor = "#6750a4";

        # @option widget = "dropdown"; label = "Nested chip surface color"; group = "Surfaces"; groupOrder = 60; choices = [ "default" "s" "sc" "sch" "schh" "inverseSurface" "primaryContainer" "secondaryContainer" "tertiaryContainer" "custom" ]; description = "Color role used for controls nested inside a chip."; applyCommand = "dms ipc call settings set chipSurfaceNestedColor %%val%%";
        desktop.ojuny.dux.settings.chipSurfaceNestedColor = "default";

        # @option widget = "color"; label = "Custom nested chip color"; group = "Surfaces"; groupOrder = 60; visibleWhen.path = "desktop.ojuny.dux.settings.chipSurfaceNestedColor"; visibleWhen.equals = "custom"; description = "Nested chip surface color used when the nested chip color is custom."; applyCommand = "dms ipc call settings set chipSurfaceNestedCustomColor %%val%%";
        desktop.ojuny.dux.settings.chipSurfaceNestedCustomColor = "#6750A4";

        # @option widget = "spin"; label = "Frame bar inset padding"; group = "Frame"; groupOrder = 55; min = -1; max = 100; unit = "px"; advanced = true; description = "Inset padding used when the bar is drawn by the frame."; applyCommand = "dms ipc call settings set frameBarInsetPadding %%val%%";
        desktop.ojuny.dux.settings.frameBarInsetPadding = -1;

        # @option widget = "spin"; label = "Frame bar size"; group = "Frame"; groupOrder = 55; min = 24; max = 100; unit = "px"; advanced = true; description = "Thickness of the bar strip drawn by the frame."; applyCommand = "dms ipc call settings set frameBarSize %%val%%";
        desktop.ojuny.dux.settings.frameBarSize = 40;

        # @option widget = "switch"; label = "Frame blur"; group = "Frame"; groupOrder = 55; advanced = true; description = "Blur the background behind the frame bar."; applyCommand = "dms ipc call settings set frameBlurEnabled %%val%%";
        desktop.ojuny.dux.settings.frameBlurEnabled = true;

        # @option widget = "spin"; label = "Frame radius"; group = "Frame"; groupOrder = 55; min = 0; max = 100; unit = "px"; advanced = true; description = "Corner radius of the frame."; applyCommand = "dms ipc call settings set frameRounding %%val%%";
        desktop.ojuny.dux.settings.frameRounding = 23;

        # @option widget = "spin"; label = "Frame thickness"; group = "Frame"; groupOrder = 55; min = 2; max = 100; unit = "px"; advanced = true; description = "Border thickness of the frame."; applyCommand = "dms ipc call settings set frameThickness %%val%%";
        desktop.ojuny.dux.settings.frameThickness = 16;

        # @option widget = "color"; label = "Custom host surface color"; group = "Surfaces"; groupOrder = 60; visibleWhen.path = "desktop.ojuny.dux.settings.hostSurfaceColor"; visibleWhen.equals = "custom"; description = "Host surface color used when the host surface color is custom."; applyCommand = "dms ipc call settings set hostSurfaceCustomColor %%val%%";
        desktop.ojuny.dux.settings.hostSurfaceCustomColor = "#6750a4";

        # @option widget = "dropdown"; label = "Tooltip surface color"; group = "Surfaces"; groupOrder = 60; choices = [ "default" "s" "sc" "sch" "schh" "inverseSurface" "primaryContainer" "secondaryContainer" "tertiaryContainer" "custom" ]; advanced = true; description = "Color role used for tooltips."; applyCommand = "dms ipc call settings set tooltipSurfaceColor %%val%%";
        desktop.ojuny.dux.settings.tooltipSurfaceColor = "default";

        # @option widget = "color"; label = "Custom tooltip surface color"; group = "Surfaces"; groupOrder = 60; visibleWhen.path = "desktop.ojuny.dux.settings.tooltipSurfaceColor"; visibleWhen.equals = "custom"; advanced = true; description = "Tooltip surface color used when the tooltip surface color is custom."; applyCommand = "dms ipc call settings set tooltipSurfaceCustomColor %%val%%";
        desktop.ojuny.dux.settings.tooltipSurfaceCustomColor = "#6750A4";

        # @option widget = "color"; label = "Custom widget background"; group = "Surfaces"; groupOrder = 60; visibleWhen.path = "desktop.ojuny.dux.settings.widgetBackgroundColor"; visibleWhen.equals = "custom"; description = "Widget background color used when the widget background color is custom."; applyCommand = "dms ipc call settings set widgetBackgroundCustomColor %%val%%";
        desktop.ojuny.dux.settings.widgetBackgroundCustomColor = "#6750a4";

        # @option widget = "slider"; label = "Custom background strength"; group = "Surfaces"; groupOrder = 60; min = 0.0; max = 1.0; step = 0.05; description = "How strongly the custom widget background color is applied."; applyCommand = "dms ipc call settings set widgetBackgroundCustomStrength %%val%%";
        desktop.ojuny.dux.settings.widgetBackgroundCustomStrength = 0.5;

        # @option widget = "switch"; label = "Frame close gaps"; group = "Frame"; groupOrder = 55; advanced = true; description = "Fill the gaps between the frame strips."; applyCommand = "dms ipc call settings set frameCloseGaps %%val%%";
        desktop.ojuny.dux.settings.frameCloseGaps = true;

        # @option widget = "switch"; label = "Frame launcher arc extender"; group = "Frame"; groupOrder = 55; advanced = true; description = "Extend the launcher arc into the frame bar."; applyCommand = "dms ipc call settings set frameLauncherArcExtender %%val%%";
        desktop.ojuny.dux.settings.frameLauncherArcExtender = false;

        # @option widget = "switch"; label = "Frame launcher edge hover"; group = "Frame"; groupOrder = 55; advanced = true; description = "Open the launcher when hovering the frame edge."; applyCommand = "dms ipc call settings set frameLauncherEdgeHover %%val%%";
        desktop.ojuny.dux.settings.frameLauncherEdgeHover = false;

        # @option widget = "dropdown"; label = "Frame launcher emerge side"; group = "Frame"; groupOrder = 55; choices = [ "bottom" "top" ]; advanced = true; description = "Edge the frame launcher emerges from."; applyCommand = "dms ipc call settings set frameLauncherEmergeSide %%val%%";
        desktop.ojuny.dux.settings.frameLauncherEmergeSide = "bottom";

        # @option widget = "dropdown"; label = "Frame mode"; group = "Frame"; groupOrder = 55; choices = [ "connected" "separate" ]; advanced = true; description = "Draw the frame as one connected surface or as separate strips."; applyCommand = "dms ipc call settings set frameMode %%val%%";
        desktop.ojuny.dux.settings.frameMode = "connected";

        # @option widget = "switch"; label = "Frame on overview"; group = "Frame"; groupOrder = 55; advanced = true; description = "Keep the frame visible while the overview is open."; applyCommand = "dms ipc call settings set frameShowOnOverview %%val%%";
        desktop.ojuny.dux.settings.frameShowOnOverview = false;

        # @option widget = "spin"; label = "Tray tint saturation"; group = "System tray"; groupOrder = 65; min = 0; max = 100; advanced = true; description = "Saturation applied to tinted tray icons."; applyCommand = "dms ipc call settings set systemTrayIconTintSaturation %%val%%";
        desktop.ojuny.dux.settings.systemTrayIconTintSaturation = 50;

        # @option widget = "spin"; label = "Tray tint strength"; group = "System tray"; groupOrder = 65; min = 0; max = 200; advanced = true; description = "Strength applied to tinted tray icons."; applyCommand = "dms ipc call settings set systemTrayIconTintStrength %%val%%";
        desktop.ojuny.dux.settings.systemTrayIconTintStrength = 135;

        # @option widget = "list"; label = "Frame screens"; group = "Frame"; groupOrder = 55; advanced = true; description = "Screen names the frame is drawn on, or \"all\". Settings IPC rejects object values; write this one in the settings file.";
        desktop.ojuny.dux.settings.frameScreenPreferences = [ "all" ];

      };

    };

}

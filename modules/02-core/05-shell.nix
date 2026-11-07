/*
  @menu
  displayname = "Shell looks";
  icon = "preferences-desktop-theme-symbolic";
  order = 53;
  description = "Shape, surfaces, motion and color modes for Dux Modular Shell";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-style-shell =
    { config, ... }:
    {
      config = {
        desktop.ojuny.dux.session.terminalOverride = "ghostty";
        environment.variables.TERMINAL = "ghostty";

        # Shape and surface
        # @option widget = "dropdown"; label = "Interface style"; group = "Shape and surface"; groupOrder = 65; order = 10; choices = [ "expressive" "classic" ]; description = "Controls whether controls use expressive shape morphing or one fixed corner radius."; applyCommand = "dms ipc call settings set interfaceStyle %%val%%";
        desktop.ojuny.dux.settings.interfaceStyle = "expressive";

        # @option widget = "dropdown"; label = "Interface density"; group = "Shape and surface"; groupOrder = 65; order = 20; choices = [ "spacious" "comfortable" "compact" "dense" ]; description = "Spacing and row height used across shell surfaces."; applyCommand = "dms ipc call settings set density %%val%%";
        desktop.ojuny.dux.settings.density = "comfortable";

        # @option widget = "slider"; label = "Section divider opacity"; group = "Shape and surface"; groupOrder = 65; order = 30; min = 0.0; max = 1.0; step = 0.01; visibleWhen.path = "desktop.ojuny.dux.settings.interfaceStyle"; visibleWhen.equals = "classic"; description = "Strength of dividers between rows in classic style."; applyCommand = "dms ipc call settings set sectionDividerOpacity %%val%%";
        desktop.ojuny.dux.settings.sectionDividerOpacity = 0.1;

        # @option widget = "dropdown"; label = "Corner style"; group = "Shape and surface"; groupOrder = 65; order = 40; choices = [ "scale" "fixed" ]; description = "Material shape scale or a single fixed corner radius."; applyCommand = "dms ipc call settings set radiusMode %%val%%";
        desktop.ojuny.dux.settings.radiusMode = "scale";

        # @option widget = "slider"; label = "Radius strength"; group = "Shape and surface"; groupOrder = 65; order = 45; min = 0; max = 100; step = 1; visibleWhen.path = "desktop.ojuny.dux.settings.radiusMode"; visibleWhen.equals = "scale"; description = "50 uses Material shapes; lower values reduce rounding and higher values increase it."; applyCommand = "dms ipc call settings set radiusStrength %%val%%";
        desktop.ojuny.dux.settings.radiusStrength = 50;

        # @option widget = "spin"; label = "Fixed corner radius"; group = "Shape and surface"; groupOrder = 65; order = 50; min = 0; max = 32; unit = "px"; visibleWhen.path = "desktop.ojuny.dux.settings.radiusMode"; visibleWhen.equals = "fixed"; description = "Corner radius applied when the corner style is fixed."; applyCommand = "dms ipc call settings set fixedRadius %%val%%";
        desktop.ojuny.dux.settings.fixedRadius = 16;

        # @option widget = "switch"; label = "Focus ring"; group = "Shape and surface"; groupOrder = 65; order = 60; description = "Draw a focus ring around the keyboard-focused control."; applyCommand = "dms ipc call settings set focusRingEnabled %%val%%";
        desktop.ojuny.dux.settings.focusRingEnabled = true;

        # @option widget = "spin"; label = "Focus ring width"; group = "Shape and surface"; groupOrder = 65; order = 70; min = 1; max = 4; step = 0.5; unit = "px"; visibleWhen.path = "desktop.ojuny.dux.settings.focusRingEnabled"; visibleWhen.equals = true; description = "Thickness of the focus ring."; applyCommand = "dms ipc call settings set focusRingWidth %%val%%";
        desktop.ojuny.dux.settings.focusRingWidth = 1.5;

        # @option widget = "dropdown"; label = "Focus ring color"; group = "Shape and surface"; groupOrder = 65; order = 80; choices = [ "primary" "secondary" "outline" "surfaceText" ]; visibleWhen.path = "desktop.ojuny.dux.settings.focusRingEnabled"; visibleWhen.equals = true; description = "Theme role used to draw the focus ring."; applyCommand = "dms ipc call settings set focusRingColor %%val%%";
        desktop.ojuny.dux.settings.focusRingColor = "primary";

        # @option widget = "slider"; label = "Container saturation"; group = "Shape and surface"; groupOrder = 65; order = 90; min = 0; max = 200; step = 5; unit = "%"; description = "Saturation of tinted accent containers."; applyCommand = "dms ipc call settings set containerSaturation %%val%%";
        desktop.ojuny.dux.settings.containerSaturation = 100;

        # @option widget = "switch"; label = "Scrollbars"; group = "Shape and surface"; groupOrder = 65; order = 100; description = "Show scrollbars on lists and pages."; applyCommand = "dms ipc call settings set scrollbarsEnabled %%val%%";
        desktop.ojuny.dux.settings.scrollbarsEnabled = true;

        # @option widget = "dropdown"; label = "Control center tile color"; group = "Shape and surface"; groupOrder = 65; order = 110; choices = [ "primary" "primaryContainer" "secondary" "surfaceVariant" ]; description = "Theme role used for active control center tile buttons."; applyCommand = "dms ipc call settings set controlCenterTileColorMode %%val%%";
        desktop.ojuny.dux.settings.controlCenterTileColorMode = "primary";

        # @option widget = "slider"; label = "Control center icon scale"; group = "Shape and surface"; groupOrder = 65; order = 120; min = 0.5; max = 1.5; step = 0.05; description = "Multiplier applied to control center icons."; applyCommand = "dms ipc call settings set controlCenterIconScale %%val%%";
        desktop.ojuny.dux.settings.controlCenterIconScale = 1.0;

        # @option widget = "switch"; label = "Ripple effects"; group = "Shape and surface"; groupOrder = 65; order = 130; description = "Animate a ripple when a control is pressed."; applyCommand = "dms ipc call settings set enableRippleEffects %%val%%";
        desktop.ojuny.dux.settings.enableRippleEffects = true;

        # Surface blur
        # @option widget = "switch"; label = "Background blur"; group = "Surface blur"; groupOrder = 72; order = 10; advanced = true; description = "Blur shell surfaces behind popups and modals."; applyCommand = "dms ipc call settings set blurEnabled %%val%%";
        desktop.ojuny.dux.settings.blurEnabled = false;

        # @option widget = "spin"; label = "Blur strength"; group = "Surface blur"; groupOrder = 72; order = 20; min = 0; max = 160; unit = "px"; advanced = true; visibleWhen.path = "desktop.ojuny.dux.settings.blurEnabled"; visibleWhen.equals = true; description = "0 uses the compositor default reach."; applyCommand = "dms ipc call settings set blurStrength %%val%%";
        desktop.ojuny.dux.settings.blurStrength = 0;

        # @option widget = "switch"; label = "Surface border"; group = "Surface blur"; groupOrder = 72; order = 30; advanced = true; description = "Draw a border around blurred surface edges."; applyCommand = "dms ipc call settings set blurBorderEnabled %%val%%";
        desktop.ojuny.dux.settings.blurBorderEnabled = false;

        # @option widget = "dropdown"; label = "Surface border color"; group = "Surface blur"; groupOrder = 72; order = 40; advanced = true; choices = [ "outline" "primary" "secondary" "surfaceText" ]; visibleWhen.path = "desktop.ojuny.dux.settings.blurBorderEnabled"; visibleWhen.equals = true; description = "Theme role used for the surface border."; applyCommand = "dms ipc call settings set blurBorderColor %%val%%";
        desktop.ojuny.dux.settings.blurBorderColor = "outline";

        # @option widget = "color"; label = "Custom surface border color"; group = "Surface blur"; groupOrder = 72; order = 45; advanced = true; visibleWhen.path = "desktop.ojuny.dux.settings.blurBorderColor"; visibleWhen.equals = "custom"; description = "Color used when the surface border color is custom."; applyCommand = "dms ipc call settings set blurBorderCustomColor %%val%%";
        desktop.ojuny.dux.settings.blurBorderCustomColor = "#ffffff";

        # @option widget = "slider"; label = "Surface border opacity"; group = "Surface blur"; groupOrder = 72; order = 50; advanced = true; min = 0.0; max = 1.0; step = 0.05; visibleWhen.path = "desktop.ojuny.dux.settings.blurBorderEnabled"; visibleWhen.equals = true; description = "Opacity of the surface border."; applyCommand = "dms ipc call settings set blurBorderOpacity %%val%%";
        desktop.ojuny.dux.settings.blurBorderOpacity = 0.35;

        # @option widget = "switch"; label = "Blur foreground layers"; group = "Surface blur"; groupOrder = 72; order = 60; advanced = true; description = "Let foreground cards and widgets use translucent surfaces."; applyCommand = "dms ipc call settings set blurForegroundLayers %%val%%";
        desktop.ojuny.dux.settings.blurForegroundLayers = true;

        # @option widget = "slider"; label = "Foreground layer transparency"; group = "Surface blur"; groupOrder = 72; order = 70; advanced = true; min = 0.0; max = 1.0; step = 0.05; visibleWhen.path = "desktop.ojuny.dux.settings.blurForegroundLayers"; visibleWhen.equals = true; description = "Opacity of foreground layers."; applyCommand = "dms ipc call settings set foregroundLayerTransparency %%val%%";
        desktop.ojuny.dux.settings.foregroundLayerTransparency = 1.0;

        # @option widget = "slider"; label = "Layer outline opacity"; group = "Surface blur"; groupOrder = 72; order = 80; advanced = true; min = 0.0; max = 1.0; step = 0.01; description = "0 turns the outline off."; applyCommand = "dms ipc call settings set blurLayerOutlineOpacity %%val%%";
        desktop.ojuny.dux.settings.blurLayerOutlineOpacity = 0;

        # @option widget = "switch"; label = "Blurred wallpaper layer"; group = "Surface blur"; groupOrder = 72; order = 90; advanced = true; description = "Render the wallpaper through a blurred layer."; applyCommand = "dms ipc call settings set blurredWallpaperLayer %%val%%";
        desktop.ojuny.dux.settings.blurredWallpaperLayer = false;

        # @option widget = "switch"; label = "Blur wallpaper on overview"; group = "Surface blur"; groupOrder = 72; order = 100; advanced = true; description = "Blur the wallpaper while the overview is open."; applyCommand = "dms ipc call settings set blurWallpaperOnOverview %%val%%";
        desktop.ojuny.dux.settings.blurWallpaperOnOverview = false;

        # @option widget = "switch"; label = "Surface border auto-seeded"; group = "Surface blur"; groupOrder = 72; order = 110; advanced = true; hidden = true; description = "Set once when background blur first turns the surface border on."; applyCommand = "dms ipc call settings set blurBorderSeeded %%val%%";
        desktop.ojuny.dux.settings.blurBorderSeeded = false;

        # Floating windows
        # @option widget = "switch"; label = "Follow global surface settings"; group = "Floating windows"; groupOrder = 75; order = 10; description = "Use the global surface opacity and foreground layer settings for floating windows."; applyCommand = "dms ipc call settings set floatingWindowSyncGlobal %%val%%";
        desktop.ojuny.dux.settings.floatingWindowSyncGlobal = true;

        # @option widget = "slider"; label = "Opacity"; group = "Floating windows"; groupOrder = 75; order = 20; min = 0.0; max = 1.0; step = 0.05; visibleWhen.path = "desktop.ojuny.dux.settings.floatingWindowSyncGlobal"; visibleWhen.equals = false; description = "Opacity of floating windows such as Settings and Notepad."; applyCommand = "dms ipc call settings set floatingWindowTransparency %%val%%";
        desktop.ojuny.dux.settings.floatingWindowTransparency = 1.0;

        # @option widget = "switch"; label = "Foreground layers"; group = "Floating windows"; groupOrder = 75; order = 30; visibleWhen.path = "desktop.ojuny.dux.settings.floatingWindowSyncGlobal"; visibleWhen.equals = false; description = "Let floating window cards and widgets use translucent surfaces."; applyCommand = "dms ipc call settings set floatingWindowForegroundLayers %%val%%";
        desktop.ojuny.dux.settings.floatingWindowForegroundLayers = true;

        # @option widget = "slider"; label = "Foreground layer transparency"; group = "Floating windows"; groupOrder = 75; order = 40; min = 0.0; max = 1.0; step = 0.05; visibleWhen.path = "desktop.ojuny.dux.settings.floatingWindowForegroundLayers"; visibleWhen.equals = true; description = "Opacity of floating window foreground layers."; applyCommand = "dms ipc call settings set floatingWindowForegroundTransparency %%val%%";
        desktop.ojuny.dux.settings.floatingWindowForegroundTransparency = 1.0;

        # @option widget = "switch"; label = "Title bars"; group = "Floating windows"; groupOrder = 75; order = 50; description = "Off lets the compositor decorate DMS windows. Open windows update when reopened."; applyCommand = "dms ipc call settings set floatingWindowTitleBars %%val%%";
        desktop.ojuny.dux.settings.floatingWindowTitleBars = true;

        # Desktop shell
        # @option widget = "spin"; label = "Shell animation duration"; group = "Desktop shell"; min = 0; max = 2000; step = 10; unit = "ms"; groupOrder = 130; order = 10; applyCommand = "dms ipc call settings set animationDuration %%val%%";
        desktop.ojuny.dux.settings.animationDuration = 350;

        # @option widget = "spin"; label = "Modal animation duration"; group = "Desktop shell"; min = 0; max = 2000; step = 10; unit = "ms"; hidden = true; groupOrder = 130; order = 20; applyCommand = "dms ipc call settings set modalAnimationDuration %%val%%";
        desktop.ojuny.dux.settings.modalAnimationDuration = 231;

        # @option widget = "spin"; label = "Popout animation duration"; group = "Desktop shell"; min = 0; max = 2000; step = 10; unit = "ms"; hidden = true; groupOrder = 130; order = 30; applyCommand = "dms ipc call settings set popoutAnimationDuration %%val%%";
        desktop.ojuny.dux.settings.popoutAnimationDuration = 476;

        # @option widget = "spin"; label = "Motion effect"; group = "Desktop shell"; min = 0; max = 3; hidden = true; groupOrder = 130; order = 40; applyCommand = "dms ipc call settings set motionEffect %%val%%";
        desktop.ojuny.dux.settings.motionEffect = 1;

        # @option widget = "switch"; label = "Sync component animation speeds"; group = "Desktop shell"; hidden = true; groupOrder = 130; order = 50; applyCommand = "dms ipc call settings set syncComponentAnimationSpeeds %%val%%";
        desktop.ojuny.dux.settings.syncComponentAnimationSpeeds = false;

        # @option widget = "text"; label = "System tray icon tint"; group = "Desktop shell"; description = "e.g. primary, secondary, none."; hidden = true; groupOrder = 130; order = 60; applyCommand = "dms ipc call settings set systemTrayIconTintMode %%val%%";
        desktop.ojuny.dux.settings.systemTrayIconTintMode = "primary";

        # @option widget = "text"; label = "Widget background color"; group = "Desktop shell"; description = "A theme role name, e.g. sch for the scheme background."; hidden = true; groupOrder = 130; order = 70; applyCommand = "dms ipc call settings set widgetBackgroundColor %%val%%";
        desktop.ojuny.dux.settings.widgetBackgroundColor = "sch";

        # Motion. The switch lives on the Accessibility page.
        desktop.ojuny.dux.settings.reduceMotion = config.ojuny.accessibility.reduceMotion;

        # @option widget = "dropdown"; label = "Spring bounce"; group = "Motion"; groupOrder = 150; order = 20; choices = [ "0" "1" "2" ]; advanced = true; description = "0 = smooth, 1 = balanced, 2 = playful."; applyCommand = "dms ipc call settings set springBounce %%val%%";
        desktop.ojuny.dux.settings.springBounce = 1;

        # Surfaces
        # @option widget = "switch"; label = "Darken modal background"; group = "Surfaces"; groupOrder = 160; order = 20; applyCommand = "dms ipc call settings set modalDarkenBackground %%val%%";
        desktop.ojuny.dux.settings.modalDarkenBackground = true;

        # @option widget = "dropdown"; label = "Card surface color"; group = "Surfaces"; groupOrder = 160; order = 30; choices = [ "default" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role; default = the card fallback (sc)."; applyCommand = "dms ipc call settings set cardSurfaceColor %%val%%";
        desktop.ojuny.dux.settings.cardSurfaceColor = "default";

        # @option widget = "dropdown"; label = "Chip surface color"; group = "Surfaces"; groupOrder = 160; order = 40; choices = [ "default" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role; default = the chip fallback (sch)."; applyCommand = "dms ipc call settings set chipSurfaceColor %%val%%";
        desktop.ojuny.dux.settings.chipSurfaceColor = "default";

        # @option widget = "dropdown"; label = "Host surface color"; group = "Surfaces"; groupOrder = 160; order = 50; choices = [ "default" "primary" "primaryContainer" "secondary" "secondaryContainer" "tertiary" "tertiaryContainer" "surfaceText" "surfaceVariant" "s" "scll" "scl" "sc" "sch" "schh" "sth" "error" ]; description = "Theme role; default = the host fallback (s)."; applyCommand = "dms ipc call settings set hostSurfaceColor %%val%%";
        desktop.ojuny.dux.settings.hostSurfaceColor = "default";

        # Color modes
        # @option widget = "dropdown"; label = "Widget text style"; group = "Color modes"; groupOrder = 170; order = 10; choices = [ "default" "colorful" ]; description = "Whether or not to use colorful widget text"; applyCommand = "dms ipc call settings set widgetColorMode %%val%%";
        desktop.ojuny.dux.settings.widgetColorMode = "default";

        # @option widget = "dropdown"; label = "Button color"; group = "Color modes"; groupOrder = 170; order = 20; choices = [ "primary" "primaryContainer" "secondary" "surfaceVariant" ]; description = "DMS resolves only these four; any other value renders as primary."; applyCommand = "dms ipc call settings set buttonColorMode %%val%%";
        desktop.ojuny.dux.settings.buttonColorMode = "primary";

        # @option widget = "dropdown"; label = "Avatar ring"; group = "Color modes"; groupOrder = 170; order = 30; choices = [ "none" "outline" "primary" "secondary" "tertiary" ]; advanced = true; applyCommand = "dms ipc call settings set avatarRing %%val%%";
        desktop.ojuny.dux.settings.avatarRing = "none";
      };
    };

}

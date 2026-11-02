/*
  @menu
  displayname = "Compositor looks";
  icon = "preferences-desktop-display-symbolic";
  order = 52;
  description = "Window gaps, borders, blur, shadows, animations and app theming";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-style-compositor =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      colors = self.colors config.lib.stylix.colors;

      # mango appearance flags (0/1) exposed as switches.
      flagDefaults = {
        blur = true;
        blur_layer = false;
        blur_optimized = false;
        shadows = false;
        layer_shadows = false;
        shadow_only_floating = true;
        dim_enable = false;
        no_border_when_single = false;
        no_radius_when_single = false;
        smart_gaps = false;
        animations = true;
        layer_animations = false;
        animation_fade_in = true;
        animation_fade_out = true;
        always_show_group_bar = false;
        group_bar_close_button_enable = true;
      };

      # mango appearance strings and mode integers exposed as named choices.
      enumSpecs = {
        animation_type_open = {
          default = "zoom";
          choices = {
            "slide" = "slide";
            "zoom" = "zoom";
            "fade" = "fade";
            "none" = "none";
          };
        };
        animation_type_close = {
          default = "zoom";
          choices = {
            "slide" = "slide";
            "zoom" = "zoom";
            "fade" = "fade";
            "none" = "none";
          };
        };
        layer_animation_type_open = {
          default = "zoom";
          choices = {
            "slide" = "slide";
            "zoom" = "zoom";
            "fade" = "fade";
            "none" = "none";
          };
        };
        layer_animation_type_close = {
          default = "zoom";
          choices = {
            "slide" = "slide";
            "zoom" = "zoom";
            "fade" = "fade";
            "none" = "none";
          };
        };
        tag_animation_direction = {
          default = "vertical";
          choices = {
            "vertical" = 0;
            "horizontal" = 1;
          };
        };
      };
    in
    {
      options.ojuny.style = {
        customGaps = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use per-edge gaps instead of the single unified gap size.";
        };
        gaps = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Unified gap size used for every edge unless customGaps is on.";
        };
        gapInnerHorizontal = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Inner horizontal gap.";
        };
        gapInnerVertical = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Inner vertical gap.";
        };
        gapOuterHorizontal = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Outer horizontal gap.";
        };
        gapOuterVertical = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "Outer vertical gap.";
        };
        customBorders = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use per-surface border thickness instead of the single unified thickness.";
        };
        borderThickness = lib.mkOption {
          type = lib.types.int;
          default = 1;
          description = "Unified border thickness used by mango, the bar and the dock unless customBorders is on.";
        };
        mangoBorderThickness = lib.mkOption {
          type = lib.types.int;
          default = 3;
          description = "mango window border thickness.";
        };
        barBorderThickness = lib.mkOption {
          type = lib.types.int;
          default = 1;
          description = "Bar border thickness.";
        };
        dockBorderThickness = lib.mkOption {
          type = lib.types.int;
          default = 1;
          description = "Dock border thickness.";
        };
      };

      options.ojuny.mango.flag = lib.mapAttrs (
        name: default:
        lib.mkOption {
          type = lib.types.bool;
          inherit default;
          description = "mango global ${name}, stored as 0/1.";
        }
      ) flagDefaults;

      options.ojuny.mango.enum = lib.mapAttrs (
        name: spec:
        lib.mkOption {
          type = lib.types.enum (lib.attrNames spec.choices);
          default = spec.default;
          description = "mango global ${name}.";
        }
      ) enumSpecs;

      config = {
        # App theming
        # @option widget = "switch"; label = "Apply matugen templates"; group = "App theming"; advanced = true; groupOrder = 35; order = 10; description = "Render the enabled matugen templates when the palette changes."; applyCommand = "dms ipc call settings set runDmsMatugenTemplates %%val%%";
        desktop.ojuny.dux.settings.runDmsMatugenTemplates = true;

        # @option widget = "switch"; label = "GTK"; group = "App theming"; advanced = true; groupOrder = 35; order = 20; applyCommand = "dms ipc call settings set matugenTemplateGtk %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateGtk = true;

        # @option widget = "switch"; label = "Niri"; group = "App theming"; advanced = true; groupOrder = 35; order = 30; applyCommand = "dms ipc call settings set matugenTemplateNiri %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateNiri = true;

        # @option widget = "switch"; label = "Hyprland"; group = "App theming"; advanced = true; groupOrder = 35; order = 40; applyCommand = "dms ipc call settings set matugenTemplateHyprland %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateHyprland = true;

        # @option widget = "switch"; label = "MangoWC"; group = "App theming"; advanced = true; groupOrder = 35; order = 50; applyCommand = "dms ipc call settings set matugenTemplateMangowc %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateMangowc = true;

        # @option widget = "switch"; label = "Qt5ct"; group = "App theming"; advanced = true; groupOrder = 35; order = 60; applyCommand = "dms ipc call settings set matugenTemplateQt5ct %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateQt5ct = true;

        # @option widget = "switch"; label = "Qt6ct"; group = "App theming"; advanced = true; groupOrder = 35; order = 70; applyCommand = "dms ipc call settings set matugenTemplateQt6ct %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateQt6ct = true;

        # @option widget = "switch"; label = "Fcitx5"; group = "App theming"; advanced = true; groupOrder = 35; order = 80; applyCommand = "dms ipc call settings set matugenTemplateFcitx5 %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateFcitx5 = true;

        # @option widget = "switch"; label = "Qtengine"; group = "App theming"; advanced = true; groupOrder = 35; order = 90; applyCommand = "dms ipc call settings set matugenTemplateQtengine %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateQtengine = true;

        # @option widget = "switch"; label = "Firefox"; group = "App theming"; advanced = true; groupOrder = 35; order = 100; applyCommand = "dms ipc call settings set matugenTemplateFirefox %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateFirefox = true;

        # @option widget = "switch"; label = "PywalFox"; group = "App theming"; advanced = true; groupOrder = 35; order = 110; applyCommand = "dms ipc call settings set matugenTemplatePywalfox %%val%%";
        desktop.ojuny.dux.settings.matugenTemplatePywalfox = true;

        # @option widget = "switch"; label = "Zen Browser"; group = "App theming"; advanced = true; groupOrder = 35; order = 120; applyCommand = "dms ipc call settings set matugenTemplateZenBrowser %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateZenBrowser = true;

        # @option widget = "switch"; label = "Vesktop"; group = "App theming"; advanced = true; groupOrder = 35; order = 130; applyCommand = "dms ipc call settings set matugenTemplateVesktop %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateVesktop = true;

        # @option widget = "switch"; label = "Vencord"; group = "App theming"; advanced = true; groupOrder = 35; order = 140; applyCommand = "dms ipc call settings set matugenTemplateVencord %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateVencord = true;

        # @option widget = "switch"; label = "Equibop"; group = "App theming"; advanced = true; groupOrder = 35; order = 150; applyCommand = "dms ipc call settings set matugenTemplateEquibop %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateEquibop = true;

        # @option widget = "switch"; label = "Ghostty"; group = "App theming"; advanced = true; groupOrder = 35; order = 160; applyCommand = "dms ipc call settings set matugenTemplateGhostty %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateGhostty = true;

        # @option widget = "switch"; label = "Kitty"; group = "App theming"; advanced = true; groupOrder = 35; order = 170; applyCommand = "dms ipc call settings set matugenTemplateKitty %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateKitty = true;

        # @option widget = "switch"; label = "Foot"; group = "App theming"; advanced = true; groupOrder = 35; order = 180; applyCommand = "dms ipc call settings set matugenTemplateFoot %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateFoot = true;

        # @option widget = "switch"; label = "Neovim"; group = "App theming"; advanced = true; groupOrder = 35; order = 190; applyCommand = "dms ipc call settings set matugenTemplateNeovim %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateNeovim = false;

        # @option widget = "switch"; label = "Alacritty"; group = "App theming"; advanced = true; groupOrder = 35; order = 200; applyCommand = "dms ipc call settings set matugenTemplateAlacritty %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateAlacritty = true;

        # @option widget = "switch"; label = "WezTerm"; group = "App theming"; advanced = true; groupOrder = 35; order = 210; applyCommand = "dms ipc call settings set matugenTemplateWezterm %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateWezterm = true;

        # @option widget = "switch"; label = "dgop"; group = "App theming"; advanced = true; groupOrder = 35; order = 220; applyCommand = "dms ipc call settings set matugenTemplateDgop %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateDgop = true;

        # @option widget = "switch"; label = "KColorScheme"; group = "App theming"; advanced = true; groupOrder = 35; order = 230; applyCommand = "dms ipc call settings set matugenTemplateKcolorscheme %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateKcolorscheme = true;

        # @option widget = "switch"; label = "VS Code"; group = "App theming"; advanced = true; groupOrder = 35; order = 240; applyCommand = "dms ipc call settings set matugenTemplateVscode %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateVscode = true;

        # @option widget = "switch"; label = "Emacs"; group = "App theming"; advanced = true; groupOrder = 35; order = 250; applyCommand = "dms ipc call settings set matugenTemplateEmacs %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateEmacs = true;

        # @option widget = "switch"; label = "Zed"; group = "App theming"; advanced = true; groupOrder = 35; order = 260; applyCommand = "dms ipc call settings set matugenTemplateZed %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateZed = true;

        # @option widget = "switch"; label = "Neovim background"; group = "App theming"; advanced = true; groupOrder = 35; order = 270; applyCommand = "dms ipc call settings set matugenTemplateNeovimSetBackground %%val%%";
        desktop.ojuny.dux.settings.matugenTemplateNeovimSetBackground = true;

        # Gaps
        # @option widget = "spin"; label = "Gap size"; group = "Gaps"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.style.customGaps"; visibleWhen.equals = false; groupOrder = 40; order = 20; applyCommand = "mmsg dispatch setoption,gap_inner_horizontal,%%val%%; mmsg dispatch setoption,gap_inner_vertical,%%val%%; mmsg dispatch setoption,gap_outer_horizontal,%%val%%; mmsg dispatch setoption,gap_outer_vertical,%%val%%";
        ojuny.style.gaps = 4;

        # @option widget = "switch"; label = "Set gaps per edge"; group = "Gaps"; groupOrder = 40; order = 10;
        ojuny.style.customGaps = false;

        # @option widget = "spin"; label = "Inner horizontal"; group = "Gaps"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.style.customGaps"; visibleWhen.equals = true; groupOrder = 40; order = 30; applyCommand = "mmsg dispatch setoption,gap_inner_horizontal,%%val%%";
        ojuny.style.gapInnerHorizontal = 4;

        # @option widget = "spin"; label = "Inner vertical"; group = "Gaps"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.style.customGaps"; visibleWhen.equals = true; groupOrder = 40; order = 40; applyCommand = "mmsg dispatch setoption,gap_inner_vertical,%%val%%";
        ojuny.style.gapInnerVertical = 4;

        # @option widget = "spin"; label = "Outer horizontal"; group = "Gaps"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.style.customGaps"; visibleWhen.equals = true; groupOrder = 40; order = 50; applyCommand = "mmsg dispatch setoption,gap_outer_horizontal,%%val%%";
        ojuny.style.gapOuterHorizontal = 4;

        # @option widget = "spin"; label = "Outer vertical"; group = "Gaps"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.style.customGaps"; visibleWhen.equals = true; groupOrder = 40; order = 60; applyCommand = "mmsg dispatch setoption,gap_outer_vertical,%%val%%";
        ojuny.style.gapOuterVertical = 4;

        # @option widget = "switch"; label = "Smart gaps (off for single window)"; group = "Gaps"; hidden = true; groupOrder = 40; order = 70;
        ojuny.mango.flag.smart_gaps = false;

        # Borders
        # @option widget = "spin"; label = "Border thickness"; group = "Borders"; min = 0; max = 20; unit = "px"; visibleWhen.path = "ojuny.style.customBorders"; visibleWhen.equals = false; groupOrder = 50; order = 20; applyCommand = "mmsg dispatch setoption,border_px,%%val%%";
        ojuny.style.borderThickness = 1;

        # @option widget = "switch"; label = "Set border thickness per surface"; group = "Borders"; groupOrder = 50; order = 10;
        ojuny.style.customBorders = false;

        # @option widget = "spin"; label = "Window border"; group = "Borders"; min = 0; max = 20; unit = "px"; visibleWhen.path = "ojuny.style.customBorders"; visibleWhen.equals = true; groupOrder = 50; order = 30; applyCommand = "mmsg dispatch setoption,border_px,%%val%%";
        ojuny.style.mangoBorderThickness = 3;

        # @option widget = "spin"; label = "Bar border"; group = "Borders"; min = 0; max = 20; unit = "px"; visibleWhen.path = "ojuny.style.customBorders"; visibleWhen.equals = true; groupOrder = 50; order = 40;
        ojuny.style.barBorderThickness = 1;

        # @option widget = "spin"; label = "Dock border"; group = "Borders"; min = 0; max = 20; unit = "px"; visibleWhen.path = "ojuny.style.customBorders"; visibleWhen.equals = true; groupOrder = 50; order = 50;
        ojuny.style.dockBorderThickness = 1;

        # @option widget = "switch"; label = "No border for single window"; group = "Borders"; hidden = true; groupOrder = 50; order = 60; applyCommand = "mmsg dispatch setoption,no_border_when_single,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.no_border_when_single = false;

        # Corners and opacity
        # @option widget = "spin"; label = "Corner radius"; group = "Corners and opacity"; min = 0; max = 40; unit = "px"; groupOrder = 60; order = 10; applyCommand = "mmsg dispatch setoption,border_radius,%%val%%";
        desktop.ojuny.mango.global.border_radius = 12;

        # @option widget = "switch"; label = "No radius for single window"; group = "Corners and opacity"; hidden = true; groupOrder = 60; order = 20; applyCommand = "mmsg dispatch setoption,no_radius_when_single,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.no_radius_when_single = false;

        # @option widget = "slider"; label = "Focused opacity"; group = "Corners and opacity"; min = 0.0; max = 1.0; step = 0.05; groupOrder = 60; order = 30;
        desktop.ojuny.mango.global.focused_opacity = 1.0;

        # @option widget = "slider"; label = "Unfocused opacity"; group = "Corners and opacity"; min = 0.0; max = 1.0; step = 0.05; groupOrder = 60; order = 40;
        desktop.ojuny.mango.global.unfocused_opacity = 1.0;

        # Blur
        # @option widget = "switch"; label = "Blur windows"; group = "Blur"; groupOrder = 70; order = 10; applyCommand = "mmsg dispatch setoption,blur,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.blur = true;

        # @option widget = "switch"; label = "Blur layer surfaces"; group = "Blur"; hidden = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 20; applyCommand = "mmsg dispatch setoption,blur_layer,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.blur_layer = false;

        # @option widget = "switch"; label = "Optimized blur"; group = "Blur"; hidden = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 30; applyCommand = "mmsg dispatch setoption,blur_optimized,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.blur_optimized = false;

        # @option widget = "spin"; label = "Radius"; group = "Blur"; min = 0; max = 20; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 40; applyCommand = "mmsg dispatch setoption,blur_params_radius,%%val%%";
        desktop.ojuny.mango.global.blur_params_radius = 4;

        # @option widget = "spin"; label = "Passes"; group = "Blur"; min = 1; max = 6; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 50; applyCommand = "mmsg dispatch setoption,blur_params_num_passes,%%val%%";
        desktop.ojuny.mango.global.blur_params_num_passes = 2;

        # @option widget = "slider"; label = "Noise"; group = "Blur"; min = 0.0; max = 1.0; step = 0.01; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 60; applyCommand = "mmsg dispatch setoption,blur_params_noise,%%val%%";
        desktop.ojuny.mango.global.blur_params_noise = 0.02;

        # @option widget = "slider"; label = "Brightness"; group = "Blur"; min = 0.0; max = 2.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 70; applyCommand = "mmsg dispatch setoption,blur_params_brightness,%%val%%";
        desktop.ojuny.mango.global.blur_params_brightness = 0.8;

        # @option widget = "slider"; label = "Contrast"; group = "Blur"; min = 0.0; max = 2.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 80; applyCommand = "mmsg dispatch setoption,blur_params_contrast,%%val%%";
        desktop.ojuny.mango.global.blur_params_contrast = 0.9;

        # @option widget = "slider"; label = "Saturation"; group = "Blur"; min = 0.0; max = 2.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.blur"; visibleWhen.equals = true; groupOrder = 70; order = 90; applyCommand = "mmsg dispatch setoption,blur_params_saturation,%%val%%";
        desktop.ojuny.mango.global.blur_params_saturation = 1.1;

        # Shadows
        # @option widget = "switch"; label = "Shadows"; group = "Shadows"; groupOrder = 80; order = 10; applyCommand = "mmsg dispatch setoption,shadows,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.shadows = false;

        # @option widget = "switch"; label = "Layer shadows"; group = "Shadows"; groupOrder = 80; order = 15; description = "Draw shadows under layer surfaces such as the bar."; applyCommand = "mmsg dispatch setoption,layer_shadows,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.layer_shadows = false;

        # @option widget = "switch"; label = "Shadows on floating windows only"; group = "Shadows"; groupOrder = 80; order = 16; description = "Restrict window shadows to floating windows."; applyCommand = "mmsg dispatch setoption,shadow_only_floating,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.shadow_only_floating = true;

        # @option widget = "spin"; label = "Size"; group = "Shadows"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.mango.flag.shadows"; visibleWhen.equals = true; groupOrder = 80; order = 20; applyCommand = "mmsg dispatch setoption,shadows_size,%%val%%";
        desktop.ojuny.mango.global.shadows_size = 10;

        # @option widget = "spin"; label = "Blur"; group = "Shadows"; min = 0; max = 64; unit = "px"; visibleWhen.path = "ojuny.mango.flag.shadows"; visibleWhen.equals = true; groupOrder = 80; order = 30;
        desktop.ojuny.mango.global.shadows_blur = 15;

        # @option widget = "spin"; label = "X offset"; group = "Shadows"; min = -64; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.shadows"; visibleWhen.equals = true; groupOrder = 80; order = 40; applyCommand = "mmsg dispatch setoption,shadows_position_x,%%val%%";
        desktop.ojuny.mango.global.shadows_position_x = 0;

        # @option widget = "spin"; label = "Y offset"; group = "Shadows"; min = -64; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.shadows"; visibleWhen.equals = true; groupOrder = 80; order = 50; applyCommand = "mmsg dispatch setoption,shadows_position_y,%%val%%";
        desktop.ojuny.mango.global.shadows_position_y = 0;

        # @option widget = "switch"; label = "Material elevation"; group = "Shadows"; groupOrder = 80; order = 60; description = "Draw Material 3 elevation shadows under shell surfaces."; applyCommand = "dms ipc call settings set m3ElevationEnabled %%val%%";
        desktop.ojuny.dux.settings.m3ElevationEnabled = true;

        # @option widget = "slider"; label = "Elevation intensity"; group = "Shadows"; groupOrder = 80; order = 70; min = 0; max = 100; step = 1; visibleWhen.path = "desktop.ojuny.dux.settings.m3ElevationEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set m3ElevationIntensity %%val%%";
        desktop.ojuny.dux.settings.m3ElevationIntensity = 12;

        # @option widget = "slider"; label = "Elevation opacity"; group = "Shadows"; groupOrder = 80; order = 80; min = 0; max = 100; step = 1; visibleWhen.path = "desktop.ojuny.dux.settings.m3ElevationEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set m3ElevationOpacity %%val%%";
        desktop.ojuny.dux.settings.m3ElevationOpacity = 30;

        # @option widget = "dropdown"; label = "Elevation color"; group = "Shadows"; groupOrder = 80; order = 90; choices = [ "default" "text" "primary" "surfaceVariant" "custom" ]; visibleWhen.path = "desktop.ojuny.dux.settings.m3ElevationEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set m3ElevationColorMode %%val%%";
        desktop.ojuny.dux.settings.m3ElevationColorMode = "default";

        # @option widget = "color"; label = "Custom elevation color"; group = "Shadows"; groupOrder = 80; order = 100; visibleWhen.path = "desktop.ojuny.dux.settings.m3ElevationColorMode"; visibleWhen.equals = "custom"; applyCommand = "dms ipc call settings set m3ElevationCustomColor %%val%%";
        desktop.ojuny.dux.settings.m3ElevationCustomColor = "#000000";

        # @option widget = "dropdown"; label = "Elevation light direction"; group = "Shadows"; groupOrder = 80; order = 110; advanced = true; choices = [ "autoBar" "top" "topLeft" "topRight" "bottom" ]; visibleWhen.path = "desktop.ojuny.dux.settings.m3ElevationEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set m3ElevationLightDirection %%val%%";
        desktop.ojuny.dux.settings.m3ElevationLightDirection = "top";

        # @option widget = "switch"; label = "Modal elevation"; group = "Shadows"; groupOrder = 80; order = 120; description = "Draw elevation shadows under modal dialogs."; applyCommand = "dms ipc call settings set modalElevationEnabled %%val%%";
        desktop.ojuny.dux.settings.modalElevationEnabled = true;

        # @option widget = "switch"; label = "Popout elevation"; group = "Shadows"; groupOrder = 80; order = 130; description = "Draw elevation shadows under popouts."; applyCommand = "dms ipc call settings set popoutElevationEnabled %%val%%";
        desktop.ojuny.dux.settings.popoutElevationEnabled = true;

        # Dim overlay
        # @option widget = "switch"; label = "Dim overlay"; group = "Dim"; hidden = true; groupOrder = 90; order = 10; applyCommand = "mmsg dispatch setoption,dim_enable,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.dim_enable = false;

        # Decoration
        # @option widget = "switch"; label = "Always show group bar"; group = "Decoration"; hidden = true; groupOrder = 100; order = 10; applyCommand = "mmsg dispatch setoption,always_show_group_bar,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.always_show_group_bar = false;

        # @option widget = "switch"; label = "Group bar close button"; group = "Decoration"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 20; applyCommand = "mmsg dispatch setoption,group_bar_close_button_enable,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.group_bar_close_button_enable = true;

        # @option widget = "spin"; label = "Group bar height"; group = "Decoration"; min = 0; max = 100; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 30; applyCommand = "mmsg dispatch setoption,group_bar_height,%%val%%";
        desktop.ojuny.mango.global.group_bar_height = 30;

        # @option widget = "spin"; label = "Group bar button size"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 40; applyCommand = "mmsg dispatch setoption,group_bar_button_size,%%val%%";
        desktop.ojuny.mango.global.group_bar_button_size = 16;

        # @option widget = "spin"; label = "Group bar button margin"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 50; applyCommand = "mmsg dispatch setoption,group_bar_button_margin,%%val%%";
        desktop.ojuny.mango.global.group_bar_button_margin = 4;

        # @option widget = "spin"; label = "Group bar border width"; group = "Decoration"; min = 0; max = 20; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 60; applyCommand = "mmsg dispatch setoption,group_bar_decorate_border_width,%%val%%";
        desktop.ojuny.mango.global.group_bar_decorate_border_width = 2;

        # @option widget = "spin"; label = "Group bar corner radius"; group = "Decoration"; min = 0; max = 40; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 70; applyCommand = "mmsg dispatch setoption,group_bar_decorate_corner_radius,%%val%%";
        desktop.ojuny.mango.global.group_bar_decorate_corner_radius = 10;

        # @option widget = "text"; label = "Group bar font"; group = "Decoration"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 80; applyCommand = "mmsg dispatch setoption,group_bar_decorate_font_desc,%%val%%";
        desktop.ojuny.mango.global.group_bar_decorate_font_desc = "CaskaydiaCove Nerd Font Mono 14";

        # @option widget = "spin"; label = "Group bar padding (horizontal)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 90; applyCommand = "mmsg dispatch setoption,group_bar_decorate_padding_x,%%val%%";
        desktop.ojuny.mango.global.group_bar_decorate_padding_x = 0;

        # @option widget = "spin"; label = "Group bar padding (vertical)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.always_show_group_bar"; visibleWhen.equals = true; groupOrder = 100; order = 100; applyCommand = "mmsg dispatch setoption,group_bar_decorate_padding_y,%%val%%";
        desktop.ojuny.mango.global.group_bar_decorate_padding_y = 0;

        # @option widget = "spin"; label = "Tab bar height"; group = "Decoration"; min = 0; max = 100; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 130; applyCommand = "mmsg dispatch setoption,tab_bar_height,%%val%%";
        desktop.ojuny.mango.global.tab_bar_height = 30;

        # @option widget = "spin"; label = "Tab bar border width"; group = "Decoration"; min = 0; max = 20; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 140; applyCommand = "mmsg dispatch setoption,tab_bar_decorate_border_width,%%val%%";
        desktop.ojuny.mango.global.tab_bar_decorate_border_width = 2;

        # @option widget = "spin"; label = "Tab bar corner radius"; group = "Decoration"; min = 0; max = 40; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 150; applyCommand = "mmsg dispatch setoption,tab_bar_decorate_corner_radius,%%val%%";
        desktop.ojuny.mango.global.tab_bar_decorate_corner_radius = 10;

        # @option widget = "text"; label = "Tab bar font"; group = "Decoration"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 160; applyCommand = "mmsg dispatch setoption,tab_bar_decorate_font_desc,%%val%%";
        desktop.ojuny.mango.global.tab_bar_decorate_font_desc = "CaskaydiaCove Nerd Font Mono 14";

        # @option widget = "spin"; label = "Tab bar padding (horizontal)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 170; applyCommand = "mmsg dispatch setoption,tab_bar_decorate_padding_x,%%val%%";
        desktop.ojuny.mango.global.tab_bar_decorate_padding_x = 0;

        # @option widget = "spin"; label = "Tab bar padding (vertical)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; visibleWhen.path = "ojuny.mango.flag.monocle_tab_mode"; visibleWhen.equals = true; groupOrder = 100; order = 180; applyCommand = "mmsg dispatch setoption,tab_bar_decorate_padding_y,%%val%%";
        desktop.ojuny.mango.global.tab_bar_decorate_padding_y = 0;

        # @option widget = "spin"; label = "Jump label border width"; group = "Decoration"; min = 0; max = 20; unit = "px"; hidden = true; groupOrder = 100; order = 190; applyCommand = "mmsg dispatch setoption,jump_label_decorate_border_width,%%val%%";
        desktop.ojuny.mango.global.jump_label_decorate_border_width = 2;

        # @option widget = "spin"; label = "Jump label corner radius"; group = "Decoration"; min = 0; max = 40; unit = "px"; hidden = true; groupOrder = 100; order = 200; applyCommand = "mmsg dispatch setoption,jump_label_decorate_corner_radius,%%val%%";
        desktop.ojuny.mango.global.jump_label_decorate_corner_radius = 5;

        # @option widget = "text"; label = "Jump label font"; group = "Decoration"; hidden = true; groupOrder = 100; order = 210; applyCommand = "mmsg dispatch setoption,jump_label_decorate_font_desc,%%val%%";
        desktop.ojuny.mango.global.jump_label_decorate_font_desc = "CaskaydiaCove Nerd Font Mono 16";

        # @option widget = "spin"; label = "Jump label padding (horizontal)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; groupOrder = 100; order = 220; applyCommand = "mmsg dispatch setoption,jump_label_decorate_padding_x,%%val%%";
        desktop.ojuny.mango.global.jump_label_decorate_padding_x = 10;

        # @option widget = "spin"; label = "Jump label padding (vertical)"; group = "Decoration"; min = 0; max = 64; unit = "px"; hidden = true; groupOrder = 100; order = 230; applyCommand = "mmsg dispatch setoption,jump_label_decorate_padding_y,%%val%%";
        desktop.ojuny.mango.global.jump_label_decorate_padding_y = 10;

        # Animations
        # @option widget = "switch"; label = "Window animations"; group = "Animations"; groupOrder = 110; order = 10; applyCommand = "mmsg dispatch setoption,animations,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.animations = true;

        # @option widget = "switch"; label = "Layer animations"; group = "Animations"; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 60; applyCommand = "mmsg dispatch setoption,layer_animations,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.layer_animations = false;

        # @option widget = "dropdown"; label = "Open animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 20; applyCommand = "mmsg dispatch setoption,animation_type_open,%%val%%";
        ojuny.mango.enum.animation_type_open = "zoom";

        # @option widget = "dropdown"; label = "Close animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 30; applyCommand = "mmsg dispatch setoption,animation_type_close,%%val%%";
        ojuny.mango.enum.animation_type_close = "zoom";

        # @option widget = "dropdown"; label = "Layer open animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.layer_animations"; visibleWhen.equals = true; groupOrder = 110; order = 70; applyCommand = "mmsg dispatch setoption,layer_animation_type_open,%%val%%";
        ojuny.mango.enum.layer_animation_type_open = "zoom";

        # @option widget = "dropdown"; label = "Layer close animation"; group = "Animations"; choices = [ "slide" "zoom" "fade" "none" ]; visibleWhen.path = "ojuny.mango.flag.layer_animations"; visibleWhen.equals = true; groupOrder = 110; order = 80; applyCommand = "mmsg dispatch setoption,layer_animation_type_close,%%val%%";
        ojuny.mango.enum.layer_animation_type_close = "zoom";

        # @option widget = "switch"; label = "Fade in"; group = "Animations"; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 40; applyCommand = "mmsg dispatch setoption,animation_fade_in,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.animation_fade_in = true;

        # @option widget = "switch"; label = "Fade out"; group = "Animations"; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 50; applyCommand = "mmsg dispatch setoption,animation_fade_out,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.animation_fade_out = true;

        # @option widget = "slider"; label = "Fade in start opacity"; group = "Animations"; min = 0.0; max = 1.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.animation_fade_in"; visibleWhen.equals = true; groupOrder = 110; order = 90; applyCommand = "mmsg dispatch setoption,fade_in_begin_opacity,%%val%%";
        desktop.ojuny.mango.global.fade_in_begin_opacity = 0.5;

        # @option widget = "slider"; label = "Fade out start opacity"; group = "Animations"; min = 0.0; max = 1.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.animation_fade_out"; visibleWhen.equals = true; groupOrder = 110; order = 100; applyCommand = "mmsg dispatch setoption,fade_out_begin_opacity,%%val%%";
        desktop.ojuny.mango.global.fade_out_begin_opacity = 0.5;

        # @option widget = "slider"; label = "Zoom start ratio"; group = "Animations"; min = 0.0; max = 1.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 110; applyCommand = "mmsg dispatch setoption,zoom_initial_ratio,%%val%%";
        desktop.ojuny.mango.global.zoom_initial_ratio = 0.4;

        # @option widget = "slider"; label = "Zoom end ratio"; group = "Animations"; min = 0.0; max = 1.0; step = 0.05; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 120; applyCommand = "mmsg dispatch setoption,zoom_end_ratio,%%val%%";
        desktop.ojuny.mango.global.zoom_end_ratio = 0.9;

        # @option widget = "spin"; label = "Move duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 130; applyCommand = "mmsg dispatch setoption,animation_duration_move,%%val%%";
        desktop.ojuny.mango.global.animation_duration_move = 500;

        # @option widget = "spin"; label = "Open duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 140; applyCommand = "mmsg dispatch setoption,animation_duration_open,%%val%%";
        desktop.ojuny.mango.global.animation_duration_open = 400;

        # @option widget = "spin"; label = "Tag switch duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 150; applyCommand = "mmsg dispatch setoption,animation_duration_tag,%%val%%";
        desktop.ojuny.mango.global.animation_duration_tag = 300;

        # @option widget = "spin"; label = "Close duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 160; applyCommand = "mmsg dispatch setoption,animation_duration_close,%%val%%";
        desktop.ojuny.mango.global.animation_duration_close = 300;

        # @option widget = "spin"; label = "Focus duration"; group = "Animations"; min = 0; max = 2000; step = 50; unit = "ms"; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 170; applyCommand = "mmsg dispatch setoption,animation_duration_focus,%%val%%";
        desktop.ojuny.mango.global.animation_duration_focus = 200;

        # @option widget = "dropdown"; label = "Tag animation direction"; group = "Animations"; choices = [ "vertical" "horizontal" ]; hidden = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 110; order = 180; applyCommand = "case %%val%% in vertical) v=0;; horizontal) v=1;; esac; mmsg dispatch setoption,tag_animation_direction,$v";
        ojuny.mango.enum.tag_animation_direction = "vertical";

        # @option widget = "raw"; label = "Open curve"; group = "Animation curves"; description = "Cubic bezier as a list of four numbers. Save and Rebuild."; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 10;
        desktop.ojuny.mango.global.animation_curve_open = [ 0.46 1.0 0.29 0.99 ];

        # @option widget = "raw"; label = "Move curve"; group = "Animation curves"; description = "Cubic bezier as a list of four numbers. Save and Rebuild."; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 20;
        desktop.ojuny.mango.global.animation_curve_move = [ 0.46 1.0 0.29 0.99 ];

        # @option widget = "raw"; label = "Tag curve"; group = "Animation curves"; description = "Cubic bezier as a list of four numbers. Save and Rebuild."; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 30;
        desktop.ojuny.mango.global.animation_curve_tag = [ 0.46 1.0 0.29 0.99 ];

        # @option widget = "raw"; label = "Close curve"; group = "Animation curves"; description = "Cubic bezier as a list of four numbers. Save and Rebuild."; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 40;
        desktop.ojuny.mango.global.animation_curve_close = [ 0.46 1.0 0.29 0.99 ];

        # @option widget = "raw"; label = "Focus curve"; group = "Animation curves"; description = "Cubic bezier as a list of four numbers. Save and Rebuild."; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 50;
        desktop.ojuny.mango.global.animation_curve_focus = [ 0.46 1.0 0.29 0.99 ];

        # @option widget = "raw"; label = "Fade in opacity curve"; group = "Animation curves"; description = "Cubic bezier as a list of four numbers. Save and Rebuild."; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 60;
        desktop.ojuny.mango.global.animation_curve_opacity_fade_in = [ 0.46 1.0 0.29 1.0 ];

        # @option widget = "raw"; label = "Fade out opacity curve"; group = "Animation curves"; description = "Cubic bezier as a list of four numbers. Save and Rebuild."; advanced = true; visibleWhen.path = "ojuny.mango.flag.animations"; visibleWhen.equals = true; groupOrder = 120; order = 70;
        desktop.ojuny.mango.global.animation_curve_opacity_fade_out = [ 0.5 0.5 0.5 0.5 ];

        # Derived mango values (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.blur = if config.ojuny.mango.flag.blur then 1 else 0;
        desktop.ojuny.mango.global.blur_layer = if config.ojuny.mango.flag.blur_layer then 1 else 0;
        desktop.ojuny.mango.global.blur_optimized = if config.ojuny.mango.flag.blur_optimized then 1 else 0;
        desktop.ojuny.mango.global.shadows = if config.ojuny.mango.flag.shadows then 1 else 0;
        desktop.ojuny.mango.global.dim_enable = if config.ojuny.mango.flag.dim_enable then 1 else 0;
        desktop.ojuny.mango.global.no_border_when_single =
          if config.ojuny.mango.flag.no_border_when_single then 1 else 0;
        desktop.ojuny.mango.global.no_radius_when_single =
          if config.ojuny.mango.flag.no_radius_when_single then 1 else 0;
        desktop.ojuny.mango.global.smart_gaps = if config.ojuny.mango.flag.smart_gaps then 1 else 0;
        desktop.ojuny.mango.global.animations =
          if config.ojuny.accessibility.reduceMotion then
            0
          else if config.ojuny.mango.flag.animations then
            1
          else
            0;
        desktop.ojuny.mango.global.layer_animations =
          if config.ojuny.mango.flag.layer_animations then 1 else 0;
        desktop.ojuny.mango.global.animation_fade_in =
          if config.ojuny.mango.flag.animation_fade_in then 1 else 0;
        desktop.ojuny.mango.global.animation_fade_out =
          if config.ojuny.mango.flag.animation_fade_out then 1 else 0;
        desktop.ojuny.mango.global.always_show_group_bar =
          if config.ojuny.mango.flag.always_show_group_bar then 1 else 0;
        desktop.ojuny.mango.global.group_bar_close_button_enable =
          if config.ojuny.mango.flag.group_bar_close_button_enable then 1 else 0;
        desktop.ojuny.mango.global.layer_shadows =
          if config.ojuny.mango.flag.layer_shadows then 1 else 0;
        desktop.ojuny.mango.global.shadow_only_floating =
          if config.ojuny.mango.flag.shadow_only_floating then 1 else 0;

        desktop.ojuny.mango.global.animation_type_open =
          enumSpecs.animation_type_open.choices.${config.ojuny.mango.enum.animation_type_open};
        desktop.ojuny.mango.global.animation_type_close =
          enumSpecs.animation_type_close.choices.${config.ojuny.mango.enum.animation_type_close};
        desktop.ojuny.mango.global.layer_animation_type_open =
          enumSpecs.layer_animation_type_open.choices.${config.ojuny.mango.enum.layer_animation_type_open};
        desktop.ojuny.mango.global.layer_animation_type_close =
          enumSpecs.layer_animation_type_close.choices.${config.ojuny.mango.enum.layer_animation_type_close};
        desktop.ojuny.mango.global.tag_animation_direction =
          enumSpecs.tag_animation_direction.choices.${config.ojuny.mango.enum.tag_animation_direction};

        desktop.ojuny.mango.global.gap_inner_horizontal =
          if config.ojuny.style.customGaps then
            config.ojuny.style.gapInnerHorizontal
          else
            config.ojuny.style.gaps;
        desktop.ojuny.mango.global.gap_inner_vertical =
          if config.ojuny.style.customGaps then
            config.ojuny.style.gapInnerVertical
          else
            config.ojuny.style.gaps;
        desktop.ojuny.mango.global.gap_outer_horizontal =
          if config.ojuny.style.customGaps then
            config.ojuny.style.gapOuterHorizontal
          else
            config.ojuny.style.gaps;
        desktop.ojuny.mango.global.gap_outer_vertical =
          if config.ojuny.style.customGaps then
            config.ojuny.style.gapOuterVertical
          else
            config.ojuny.style.gaps;
        desktop.ojuny.mango.global.tab_bar_decorate_bg_color = colors.defaultBackground.rgba "ff";
        desktop.ojuny.mango.global.border_px =
          if config.ojuny.style.customBorders then
            config.ojuny.style.mangoBorderThickness
          else
            config.ojuny.style.borderThickness;
        desktop.ojuny.dux.barConfigs.default.borderThickness =
          if config.ojuny.style.customBorders then
            config.ojuny.style.barBorderThickness
          else
            config.ojuny.style.borderThickness;
        desktop.ojuny.dux.dockConfigs.dock.borderThickness =
          if config.ojuny.style.customBorders then
            config.ojuny.style.dockBorderThickness
          else
            config.ojuny.style.borderThickness;
      };
    };

}

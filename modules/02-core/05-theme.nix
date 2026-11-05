/*
  @menu
  displayname = "Theme";
  icon = "applications-graphics-symbolic";
  order = 50;
  description = "Palette, polarity and wallpaper";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-style-theme =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      presetNames = builtins.attrNames inputs.ojuny-desktop.wallpaperPresets;
      wallpaperValue = config.ojuny.style.wallpaperPreset;
      wallpaperIsPreset = builtins.isString wallpaperValue && builtins.elem wallpaperValue presetNames;
    in
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      options.ojuny.style = {
        palette = lib.mkOption {
          type = lib.types.str;
          default = "everforest-dark-hard";
          description = "base16 scheme name from pkgs.base16-schemes, without the .yaml suffix.";
        };
        wallpaperPreset = lib.mkOption {
          type = lib.types.nullOr (
            lib.types.oneOf [
              (lib.types.enum presetNames)
              lib.types.path
            ]
          );
          default = null;
          description = "Bundled wallpaper preset name, a custom image path, or null for the default preset. Presets are recolored with the active palette; paths are used as-is.";
        };
        wallpaperCycleIncludeBuiltins = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Include bundled presets when DMS cycles through wallpapers.";
        };
        wallpaper = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Deprecated and ignored; use wallpaperPreset.";
        };
      };

      config = {
        # @option widget = "switch"; label = "Theme mango from stylix"; group = "Theme"; advanced = true; groupOrder = 10; order = 10;
        desktop.ojuny.stylix.enable = true;

        # @option widget = "switch"; label = "Stylix"; group = "Theme"; advanced = true; groupOrder = 10; order = 20;
        stylix.enable = true;

        stylix.targets.gtksourceview.enable = false;

        # @option widget = "dropdown"; label = "Polarity"; group = "Theme"; choices = [ "dark" "light" ]; groupOrder = 10; order = 30; applyCommand = "gsettings set org.gnome.desktop.interface color-scheme prefer-%%val%%; dms ipc call theme %%val%%";
        stylix.polarity = "dark";

        # @option widget = "theme"; label = "Color palette"; group = "Theme"; description = "A base16 scheme."; groupOrder = 10; order = 40;
        ojuny.style.palette = "aztec";

        # Derived from the palette name; no @option so a GUI edit cannot lose the store path.
        stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${
          if config.ojuny.accessibility.highContrast then
            config.ojuny.accessibility.highContrastPalette
          else
            config.ojuny.style.palette
        }.yaml";

        # @option widget = "slider"; label = "Popup opacity"; group = "Theme"; groupOrder = 10; order = 50; min = 0.0; max = 1.0; step = 0.05; description = "Opacity of Dux Modular Shell popups and overlays."; applyCommand = "dms ipc call settings set popupTransparency %%val%%";
        stylix.opacity.popups = 1.0;

        # @option widget = "wallpaper"; wallpaperDir = "./wallpapers"; presetSource = "ojuny-desktop"; label = "Wallpaper"; group = "Wallpaper"; nullable = true; groupOrder = 15; order = 10; applyCommand = "case %%val%% in */*) dms ipc call wallpaper set %%val%% ;; esac";
        ojuny.style.wallpaperPreset = "floyd";

        # @option widget = "switch"; label = "Include bundled wallpapers in cycling"; group = "Wallpaper"; groupOrder = 15; order = 20;
        ojuny.style.wallpaperCycleIncludeBuiltins = lib.mkDefault true;

        desktop.ojuny.wallpaper.image = if wallpaperIsPreset then null else wallpaperValue;
        desktop.ojuny.wallpaper.preset = lib.mkIf wallpaperIsPreset wallpaperValue;
        desktop.ojuny.wallpaper.userDirectory = ./wallpapers;
        desktop.ojuny.wallpaper.cycleIncludeBuiltins = config.ojuny.style.wallpaperCycleIncludeBuiltins;

        # @option widget = "switch"; label = "Automatic cycling"; group = "Wallpaper"; groupOrder = 15; order = 30;
        desktop.ojuny.dux.session.wallpaperCyclingEnabled = false;

        # @option widget = "dropdown"; label = "Cycling mode"; group = "Wallpaper"; groupOrder = 15; order = 40; choices = [ "interval" "time" ];
        desktop.ojuny.dux.session.wallpaperCyclingMode = "interval";

        # @option widget = "spin"; label = "Cycling interval"; group = "Wallpaper"; groupOrder = 15; order = 50; min = 5; max = 86400; unit = "s"; visibleWhen.path = "desktop.ojuny.dux.session.wallpaperCyclingMode"; visibleWhen.equals = "interval";
        desktop.ojuny.dux.session.wallpaperCyclingInterval = 300;

        # @option widget = "text"; label = "Cycling time"; group = "Wallpaper"; groupOrder = 15; order = 60; description = "HH:MM in 24-hour time."; visibleWhen.path = "desktop.ojuny.dux.session.wallpaperCyclingMode"; visibleWhen.equals = "time";
        desktop.ojuny.dux.session.wallpaperCyclingTime = "06:00";

        # @option widget = "switch"; label = "Random order"; group = "Wallpaper"; groupOrder = 15; order = 70;
        desktop.ojuny.dux.session.wallpaperCyclingRandom = false;

        # @option widget = "dropdown"; label = "Transition"; group = "Wallpaper"; groupOrder = 15; order = 80; choices = [ "random" "none" "fade" "wipe" "disc" "stripes" "iris bloom" "pixelate" "portal" ];
        desktop.ojuny.dux.session.wallpaperTransition = "fade";

        # @option widget = "list"; label = "Included transitions"; group = "Wallpaper"; groupOrder = 15; order = 90; advanced = true; visibleWhen.path = "desktop.ojuny.dux.session.wallpaperTransition"; visibleWhen.equals = "random"; description = "Transitions used when the transition is set to random.";
        desktop.ojuny.dux.session.includedTransitions = [
          "fade"
          "wipe"
          "disc"
          "stripes"
          "iris bloom"
          "pixelate"
          "portal"
        ];

        # @option widget = "dropdown"; label = "Fill mode"; group = "Wallpaper"; groupOrder = 15; order = 100; choices = [ "Stretch" "Fit" "Fill" "Scrolling" "Tile" "TileVertically" "TileHorizontally" "Pad" ];
        desktop.ojuny.dux.settings.wallpaperFillMode = "Fill";

        # @option widget = "dropdown"; label = "Background color"; group = "Wallpaper"; groupOrder = 15; order = 110; choices = [ "black" "white" "primary" "surface" "custom" ];
        desktop.ojuny.dux.settings.wallpaperBackgroundColorMode = "black";

        # @option widget = "color"; label = "Custom background color"; group = "Wallpaper"; groupOrder = 15; order = 120; visibleWhen.path = "desktop.ojuny.dux.settings.wallpaperBackgroundColorMode"; visibleWhen.equals = "custom";
        desktop.ojuny.dux.settings.wallpaperBackgroundCustomColor = "#000000";
      };
    };

}

/*
  @menu
  displayname = "Typography";
  icon = "preferences-desktop-font-symbolic";
  order = 51;
  description = "Fonts, text rendering, icons and cursors";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-style-typography =
    { config, lib, pkgs, ... }:
    let
      cfg = config.ojuny.fonts.fallbacks;

      sansFallbacks =
        lib.optionals cfg.cjk [ "Noto Sans CJK SC" ]
        ++ lib.optionals cfg.arabic [ "Noto Sans Arabic" ]
        ++ lib.optionals cfg.hebrew [ "Noto Sans Hebrew" ]
        ++ lib.optionals cfg.devanagari [ "Noto Sans Devanagari" ]
        ++ lib.optionals cfg.thai [ "Noto Sans Thai" ]
        ++ lib.optionals cfg.emoji [ "Noto Color Emoji" ];

      serifFallbacks =
        lib.optionals cfg.cjk [ "Noto Serif CJK SC" ]
        ++ lib.optionals cfg.arabic [ "Noto Naskh Arabic" ]
        ++ lib.optionals cfg.hebrew [ "Noto Serif Hebrew" ]
        ++ lib.optionals cfg.devanagari [ "Noto Serif Devanagari" ]
        ++ lib.optionals cfg.thai [ "Noto Serif Thai" ]
        ++ lib.optionals cfg.emoji [ "Noto Color Emoji" ];

      monospaceFallbacks =
        lib.optionals cfg.cjk [ "Noto Sans Mono CJK SC" ]
        ++ lib.optionals cfg.arabic [ "Noto Sans Arabic" ]
        ++ lib.optionals cfg.hebrew [ "Noto Sans Hebrew" ]
        ++ lib.optionals cfg.devanagari [ "Noto Sans Devanagari" ]
        ++ lib.optionals cfg.thai [ "Noto Sans Thai" ]
        ++ lib.optionals cfg.emoji [ "Noto Color Emoji" ];
    in
    {
      options.ojuny.fonts.fallbacks = lib.mkOption {
        type = lib.types.submodule {
          options = {
            cjk = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Install Noto CJK sans and serif and append them after the selected family.";
            };
            arabic = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Install Noto Arabic and append it after the selected family.";
            };
            hebrew = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Install Noto Hebrew and append it after the selected family.";
            };
            devanagari = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Install Noto Devanagari and append it after the selected family.";
            };
            thai = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Install Noto Thai and append it after the selected family.";
            };
            emoji = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Install Noto Color Emoji and append it after the selected family.";
            };
          };
        };
        default = { };
        description = "Script fallback families appended after the selected Stylix family.";
      };

      config = {
        # Fonts
        # @option widget = "font"; label = "Monospace font"; packageOption = "stylix.fonts.monospace.package"; monospace = true; group = "Fonts"; groupOrder = 20; order = 10; applyCommand = "gsettings set org.gnome.desktop.interface monospace-font-name %%val%%";
        stylix.fonts.monospace.name = "CaskaydiaCove Nerd Font";

        # @option widget = "package"; label = "Monospace package"; group = "Fonts"; hidden = true; groupOrder = 20; order = 20;
        stylix.fonts.monospace.package = pkgs.nerd-fonts.caskaydia-cove;

        # @option widget = "font"; label = "Sans-serif font"; packageOption = "stylix.fonts.sansSerif.package"; group = "Fonts"; groupOrder = 20; order = 30; applyCommand = "gsettings set org.gnome.desktop.interface font-name %%val%%";
        stylix.fonts.sansSerif.name = "CaskaydiaCove Nerd Font";

        # @option widget = "package"; label = "Sans-serif package"; group = "Fonts"; hidden = true; groupOrder = 20; order = 40;
        stylix.fonts.sansSerif.package = pkgs.nerd-fonts.caskaydia-cove;

        # @option widget = "font"; label = "Serif font"; packageOption = "stylix.fonts.serif.package"; hidden = true; groupOrder = 20; order = 50; applyCommand = "gsettings set org.gnome.desktop.interface document-font-name %%val%%";
        stylix.fonts.serif.name = "CaskaydiaCove Nerd Font";

        # @option widget = "package"; label = "Serif package"; group = "Fonts"; hidden = true; groupOrder = 20; order = 60;
        stylix.fonts.serif.package = pkgs.nerd-fonts.caskaydia-cove;

        # @option widget = "submodule"; label = "Script fallbacks"; group = "Fallbacks"; groupOrder = 25; order = 10;
        ojuny.fonts.fallbacks = {
          # @option widget = "switch"; label = "CJK (Chinese, Japanese, Korean)";
          cjk = false;

          # @option widget = "switch"; label = "Arabic";
          arabic = false;

          # @option widget = "switch"; label = "Hebrew";
          hebrew = false;

          # @option widget = "switch"; label = "Devanagari";
          devanagari = false;

          # @option widget = "switch"; label = "Thai";
          thai = false;

          # @option widget = "switch"; label = "Emoji"; hidden = true;
          emoji = false;
        };

        fonts.packages =
          [ pkgs.material-symbols ]
          ++ lib.optionals cfg.cjk [
            pkgs.noto-fonts-cjk-sans
            pkgs.noto-fonts-cjk-serif
          ]
          ++ lib.optionals (cfg.arabic || cfg.hebrew || cfg.devanagari || cfg.thai) [ pkgs.noto-fonts ]
          ++ lib.optionals cfg.emoji [ pkgs.noto-fonts-emoji ];

        fonts.fontconfig.defaultFonts.sansSerif = lib.mkAfter sansFallbacks;
        fonts.fontconfig.defaultFonts.serif = lib.mkAfter serifFallbacks;
        fonts.fontconfig.defaultFonts.monospace = lib.mkAfter monospaceFallbacks;

        # Shell typography
        # @option widget = "slider"; label = "Font scale"; group = "Shell typography"; groupOrder = 25; order = 40; min = 0.8; max = 1.4; step = 0.05; description = "Multiplier applied to shell text sizes."; applyCommand = "dms ipc call settings set fontScale %%val%%";
        desktop.ojuny.dux.settings.fontScale = 1.0;

        # @option widget = "dropdown"; label = "Font weight"; group = "Shell typography"; groupOrder = 25; order = 50; choices = [ "100" "200" "300" "400" "500" "600" "700" "800" "900" ]; description = "Numeric font weight used for shell text."; applyCommand = "dms ipc call settings set fontWeight %%val%%";
        desktop.ojuny.dux.settings.fontWeight = 400;

        # @option widget = "dropdown"; label = "Text renderer"; group = "Shell typography"; groupOrder = 25; order = 60; advanced = true; choices = [ "0" "1" "2" ]; description = "0 = Qt, 1 = Native, 2 = Curve."; applyCommand = "dms ipc call settings set textRenderType %%val%%";
        desktop.ojuny.dux.settings.textRenderType = 0;

        # @option widget = "dropdown"; label = "Text render quality"; group = "Shell typography"; groupOrder = 25; order = 70; advanced = true; choices = [ "0" "1" "2" "3" "4" ]; description = "0 = Default, 1 = Low, 2 = Normal, 3 = High, 4 = Very high."; applyCommand = "dms ipc call settings set textRenderQuality %%val%%";
        desktop.ojuny.dux.settings.textRenderQuality = 0;

        # @option widget = "switch"; label = "Icon theme"; group = "Icons and cursor"; groupOrder = 30; order = 10; hidden = true;
        stylix.icons.enable = true;

        # @option widget = "icon-theme"; label = "Icon theme (dark)"; packageOption = "stylix.icons.package"; variant = "dark"; group = "Icons and cursor"; groupOrder = 30; order = 20; applyCommand = "gsettings set org.gnome.desktop.interface icon-theme %%val%%";
        stylix.icons.dark = "Papirus-Dark";

        # @option widget = "icon-theme"; label = "Icon theme (light)"; packageOption = "stylix.icons.package"; variant = "light"; group = "Icons and cursor"; groupOrder = 30; order = 30; applyCommand = "gsettings set org.gnome.desktop.interface icon-theme %%val%%";
        stylix.icons.light = "Papirus-Light";

        # @option widget = "package"; label = "Icon theme package"; group = "Icons and cursor"; hidden = true; groupOrder = 30; order = 40;
        stylix.icons.package = pkgs.papirus-icon-theme;

        # @option widget = "cursor-theme"; label = "Cursor theme"; packageOption = "stylix.cursor.package"; group = "Icons and cursor"; groupOrder = 30; order = 50; applyCommand = "gsettings set org.gnome.desktop.interface cursor-theme %%val%%; mmsg dispatch setoption,cursor_theme,%%val%%";
        stylix.cursor.name = "Bibata-Modern-Classic";

        # @option widget = "package"; label = "Cursor package"; group = "Icons and cursor"; hidden = true; groupOrder = 30; order = 60;
        stylix.cursor.package = pkgs.bibata-cursors;

        # @option widget = "spin"; label = "Cursor size"; group = "Icons and cursor"; min = 16; max = 64; groupOrder = 30; order = 70; applyCommand = "gsettings set org.gnome.desktop.interface cursor-size %%val%%; mmsg dispatch setoption,cursor_size,%%val%%";
        stylix.cursor.size = 24;
      };
    };

}

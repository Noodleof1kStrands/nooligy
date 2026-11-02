/*
  @menu
  displayname = "Accessibility";
  icon = "preferences-desktop-accessibility-symbolic";
  order = 65;
  description = "Screen reader, braille, on-screen keyboard, color profiles and accessibility binds";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-accessibility =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      highContrastPalettes = [
        "windows-highcontrast"
        "windows-highcontrast-light"
        "penumbra-dark-contrast-plus-plus"
        "penumbra-light-contrast-plus-plus"
      ];

      bindModule = lib.types.submodule {
        options = {
          modifier = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "SUPER" ];
          };
          keys = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };
          dispatcher = lib.mkOption {
            type = lib.types.str;
            default = "spawn";
          };
          args = lib.mkOption {
            type = lib.types.either (lib.types.listOf lib.types.str) lib.types.str;
            default = [ ];
          };
          description = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
          group = lib.mkOption {
            type = lib.types.str;
            default = "Other";
          };
          subcat = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
        };
      };

      bindGroup = lib.types.attrsOf (lib.types.attrsOf bindModule);

      screenReaderToggle = pkgs.writeShellScript "ojuny-screen-reader-toggle" ''
        export PATH=${lib.makeBinPath [ pkgs.procps ]}:$PATH

        orca="${config.services.orca.package}/bin/orca"
        pid=$(pgrep -f "$orca" | head -n 1)
        if [ -n "$pid" ]; then
          kill "$pid"
        else
          "$orca" --replace >/dev/null 2>&1 &
        fi
      '';

      mouseModeToggle = pkgs.writeShellScript "ojuny-mouse-mode-toggle" ''
        mode=$(mmsg get keymode 2>/dev/null)
        case "$mode" in
          *mouse*) mmsg dispatch setkeymode,default ;;
          *) mmsg dispatch setkeymode,mouse ;;
        esac
      '';

      accessibilityBinds = {
        common =
          (
            lib.optionalAttrs config.services.orca.enable {
              accessibilityScreenReader = {
                modifier = [
                  "SUPER"
                  "ALT"
                ];
                keys = [ "s" ];
                dispatcher = "spawn";
                args = "${screenReaderToggle}";
                description = "Toggle the Orca screen reader";
                group = "Accessibility";
                subcat = "Screen reader";
              };
            }
            // lib.optionalAttrs config.desktop.ojuny.dux.plugins.virtualKeyboard.enable {
              accessibilityKeyboard = {
                modifier = [
                  "SUPER"
                  "ALT"
                ];
                keys = [ "k" ];
                dispatcher = "spawn";
                args = "dms ipc call virtualKeyboard toggle";
                description = "Toggle the on-screen keyboard";
                group = "Accessibility";
                subcat = "Keyboard";
              };
            }
          )
          // {
            accessibilityMouseMode = {
              modifier = [
                "SUPER"
                "ALT"
              ];
              keys = [ "m" ];
              dispatcher = "spawn";
              args = "${mouseModeToggle}";
              description = "Toggle the keyboard mouse mode";
              group = "Accessibility";
              subcat = "Mouse mode";
            };
          };

        mouse = {
          mouseUpW = {
            modifier = [ "NONE" ];
            keys = [ "w" ];
            dispatcher = "spawn";
            args = "ydotool mousemove -x 0 -y -15";
            description = "Move the pointer up";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseUpArrow = {
            modifier = [ "NONE" ];
            keys = [ "Up" ];
            dispatcher = "spawn";
            args = "ydotool mousemove -x 0 -y -15";
            description = "Move the pointer up";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseDownS = {
            modifier = [ "NONE" ];
            keys = [ "s" ];
            dispatcher = "spawn";
            args = "ydotool mousemove -x 0 -y 15";
            description = "Move the pointer down";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseDownArrow = {
            modifier = [ "NONE" ];
            keys = [ "Down" ];
            dispatcher = "spawn";
            args = "ydotool mousemove -x 0 -y 15";
            description = "Move the pointer down";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseLeftA = {
            modifier = [ "NONE" ];
            keys = [ "a" ];
            dispatcher = "spawn";
            args = "ydotool mousemove -x -15 -y 0";
            description = "Move the pointer left";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseLeftArrow = {
            modifier = [ "NONE" ];
            keys = [ "Left" ];
            dispatcher = "spawn";
            args = "ydotool mousemove -x -15 -y 0";
            description = "Move the pointer left";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseRightD = {
            modifier = [ "NONE" ];
            keys = [ "d" ];
            dispatcher = "spawn";
            args = "ydotool mousemove -x 15 -y 0";
            description = "Move the pointer right";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseRightArrow = {
            modifier = [ "NONE" ];
            keys = [ "Right" ];
            dispatcher = "spawn";
            args = "ydotool mousemove -x 15 -y 0";
            description = "Move the pointer right";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseClickLeft = {
            modifier = [ "NONE" ];
            keys = [ "space" ];
            dispatcher = "spawn";
            args = "ydotool click 0x00";
            description = "Left click";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseClickRight = {
            modifier = [ "NONE" ];
            keys = [ "Return" ];
            dispatcher = "spawn";
            args = "ydotool click 0x01";
            description = "Right click";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseClickMiddle = {
            modifier = [ "NONE" ];
            keys = [ "BackSpace" ];
            dispatcher = "spawn";
            args = "ydotool click 0x02";
            description = "Middle click";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseScrollUp = {
            modifier = [ "NONE" ];
            keys = [ "Page_Up" ];
            dispatcher = "spawn";
            args = "ydotool mousemove -w -y -1";
            description = "Scroll up";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseScrollDown = {
            modifier = [ "NONE" ];
            keys = [ "Page_Down" ];
            dispatcher = "spawn";
            args = "ydotool mousemove -w -y 1";
            description = "Scroll down";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
          mouseExit = {
            modifier = [ "NONE" ];
            keys = [ "Escape" ];
            dispatcher = "setkeymode";
            args = "default";
            description = "Exit the mouse mode";
            group = "Accessibility";
            subcat = "Mouse mode";
          };
        };
      };
    in
    {
      options.ojuny.accessibility = {
        highContrast = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use a high-contrast base16 palette instead of the normal palette.";
        };
        highContrastPalette = lib.mkOption {
          type = lib.types.enum highContrastPalettes;
          default = "windows-highcontrast";
          description = "High-contrast base16 scheme.";
        };
        iccProfile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "ICC profile applied to every monitor as a build-time output color transform. HDR must be off for the output.";
        };
        reduceMotion = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Disable Dux shell and Mango window animations.";
        };
        binds = lib.mkOption {
          type = bindGroup;
          default = { };
          description = "Accessibility keybinds, merged into common binds. This is not a keymode.";
        };
      };

      config = {

        # @option widget = "switch"; label = "Screen reader (Orca)"; group = "Vision"; groupOrder = 10; order = 10; description = "Install Orca, Speech Dispatcher and AT-SPI, and enable Qt and Dux accessibility. Save and rebuild; Orca starts with the session.";
        services.orca.enable = false;

        # @option widget = "switch"; label = "Braille (BRLTTY)"; group = "Vision"; groupOrder = 10; order = 20; description = "Enable the BRLTTY daemon. Requires a refreshable braille display.";
        services.brltty.enable = false;

        # @option widget = "switch"; label = "High contrast"; group = "Vision"; groupOrder = 10; order = 30; description = "Use a high-contrast base16 palette instead of the normal palette. Save and rebuild.";
        ojuny.accessibility.highContrast = false;

        # @option widget = "dropdown"; label = "High-contrast palette"; group = "Vision"; groupOrder = 10; order = 40; choices = [ "windows-highcontrast" "windows-highcontrast-light" "penumbra-dark-contrast-plus-plus" "penumbra-light-contrast-plus-plus" ]; visibleWhen.path = "ojuny.accessibility.highContrast"; visibleWhen.equals = true; description = "High-contrast base16 scheme used while the switch is on.";
        ojuny.accessibility.highContrastPalette = "windows-highcontrast";

        # @option widget = "path"; label = "ICC color profile"; group = "Vision"; groupOrder = 10; order = 50; nullable = true; description = "ICC profile applied to every monitor as a build-time output color transform. HDR must be off for the output. A color inversion or colorblindness profile goes here. Save and rebuild.";
        ojuny.accessibility.iccProfile = null;

        # @option widget = "switch"; label = "Mono audio"; group = "Hearing"; groupOrder = 20; order = 10; description = "Mix all stereo content into a single channel.";
        desktop.ojuny.dux.settings.audioMono = false;

        # @option widget = "switch"; label = "Reduce motion"; group = "Motion"; groupOrder = 30; order = 10; applyCommand = "dms ipc call settings set reduceMotion %%val%%"; description = "Disable Dux shell motion and force Mango window animations off. Window animations apply on rebuild.";
        ojuny.accessibility.reduceMotion = false;

        # @option widget = "keybinds"; label = "Accessibility binds"; group = "Keybinds"; groupOrder = 40; order = 10; description = "Accessibility actions are stored in common binds and are always active. The screen reader bind appears when Orca is enabled; the on-screen keyboard bind appears when the plugin is enabled. The mouse mode toggle is always here.";
        ojuny.accessibility.binds.common = accessibilityBinds.common;

        # @option widget = "keybinds"; label = "Mouse mode binds"; group = "Mouse mode"; groupOrder = 45; order = 10; description = "Pointer controls for the mouse keymode. Enter with SUPER+ALT+M; the mode is active only while set. Movement is 15 px per press; edit the commands to change speed. Escape or the toggle exits.";
        ojuny.accessibility.binds.mouse = accessibilityBinds.mouse;

        environment.sessionVariables.QT_ACCESSIBILITY =
          lib.mkIf config.services.orca.enable "1";

        desktop.ojuny.mango.binds.common = config.ojuny.accessibility.binds.common;
        desktop.ojuny.mango.binds.mouse = config.ojuny.accessibility.binds.mouse;
      };
    };

}

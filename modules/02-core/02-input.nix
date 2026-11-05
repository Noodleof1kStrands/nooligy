/*
  @menu
  displayname = "Input";
  icon = "input-keyboard-symbolic";
  order = 20;
  description = "Keyboard, mouse, trackpad and touch. Switch layouts by setting Layout to a comma-separated list such as us,de and pressing SUPER+ALT+K; an XKB grp: option in Options is an alternative, not an addition. DMS writes ~/.config/mango/dms/input.conf, but Ojuny launches mango -c ojuny.toml, so the DMS keyboard page is inert unless dms/input.conf is added to desktop.ojuny.mango.source.";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-input =
    { config, lib, ... }:

    let
      # mango stores these as 0/1 integers; see the derived assignments at the end.
      flagDefaults = {
        numlock_on = true;
        mouse_natural_scrolling = false;
        mouse_left_handed = false;
        mouse_middle_button_emulation = false;
        disable_trackpad = false;
        tap_to_click = true;
        tap_and_drag = true;
        drag_lock = true;
        trackpad_natural_scrolling = true;
        trackpad_disable_while_typing = true;
        trackpad_left_handed = false;
        trackpad_middle_button_emulation = false;
        touch_enable = true;
        touch_enable_mouse_emulation = true;
        cursor_hide_on_keypress = false;
        drag_tile_to_tile = true;
        drag_tile_small = true;
        drag_warp_cursor = true;
      };

      # mango mode integers, exposed as named choices and mapped back below.
      enumSpecs = {
        mouse_accel_profile = {
          default = "flat";
          choices = {
            "none" = 0;
            "flat" = 1;
            "adaptive" = 2;
          };
        };
        mouse_scroll_method = {
          default = "two-finger";
          choices = {
            "never" = 0;
            "two-finger" = 1;
            "edge" = 2;
            "button" = 4;
          };
        };
        mouse_click_method = {
          default = "button-areas";
          choices = {
            "none" = 0;
            "button-areas" = 1;
            "clickfinger" = 2;
          };
        };
        mouse_send_events_mode = {
          default = "enabled";
          choices = {
            "enabled" = 0;
            "disabled" = 1;
            "disabled-with-external-mouse" = 2;
          };
        };
        trackpad_accel_profile = {
          default = "adaptive";
          choices = {
            "none" = 0;
            "flat" = 1;
            "adaptive" = 2;
          };
        };
        trackpad_scroll_method = {
          default = "two-finger";
          choices = {
            "never" = 0;
            "two-finger" = 1;
            "edge" = 2;
            "button" = 4;
          };
        };
        trackpad_click_method = {
          default = "button-areas";
          choices = {
            "none" = 0;
            "button-areas" = 1;
            "clickfinger" = 2;
          };
        };
        trackpad_send_events_mode = {
          default = "enabled";
          choices = {
            "enabled" = 0;
            "disabled" = 1;
            "disabled-with-external-mouse" = 2;
          };
        };
        button_map = {
          default = "left-middle-right";
          choices = {
            "left-right-middle" = 0;
            "left-middle-right" = 1;
          };
        };
      };
    in
    {

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

      options.ojuny.input.devices = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Device name or identifier to match.";
              };
              type = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Device type to match.";
              };
              kb_layout = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "XKB layout for this device.";
              };
              kb_variant = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "XKB variant for this device.";
              };
              kb_options = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "XKB options for this device.";
              };
              kb_model = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "XKB model for this device.";
              };
              monitor = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Monitor to pin a touch or tablet device to.";
              };
              send_events_mode = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "libinput send-events mode: empty, 0, 1 or 2.";
              };
              calibration = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "libinput calibration matrix for a touch row; six space-separated numbers, empty for the default.";
              };
            };
          }
        );
        default = [ ];
        description = "Per-device mango device_rule rows shared by keyboard and touch.";
      };

      config = {

        # Keyboard
        # @option widget = "spin"; label = "Repeat rate"; group = "Keyboard"; min = 1; unit = "Hz"; applyCommand = "mmsg dispatch setoption,repeat_rate,%%val%%";
        desktop.ojuny.mango.global.repeat_rate = 25;

        # @option widget = "spin"; label = "Repeat delay"; group = "Keyboard"; min = 100; step = 50; unit = "ms"; applyCommand = "mmsg dispatch setoption,repeat_delay,%%val%%";
        desktop.ojuny.mango.global.repeat_delay = 600;

        # @option widget = "switch"; label = "Num lock on start"; group = "Keyboard";
        ojuny.mango.flag.numlock_on = true;
        
        # @option widget = "text"; label = "Layout"; group = " XKB Keyboard layout"; description = "xkb layout codes, comma separated, e.g. us,de."; applyCommand = "mmsg dispatch setoption,xkb_rules_layout,%%val%%";
        desktop.ojuny.mango.global.xkb_rules_layout = "us";

        # @option widget = "text"; label = "Variant"; group = "Keyboard"; hidden = true; applyCommand = "mmsg dispatch setoption,xkb_rules_variant,%%val%%";
        desktop.ojuny.mango.global.xkb_rules_variant = "";

        # @option widget = "text"; label = "Options"; group = "Keyboard"; hidden = true; description = "xkb options, comma separated, e.g. caps:escape."; applyCommand = "mmsg dispatch setoption,xkb_rules_options,%%val%%";
        desktop.ojuny.mango.global.xkb_rules_options = "";

        # @option widget = "text"; label = "Model"; group = "Keyboard"; hidden = true; applyCommand = "mmsg dispatch setoption,xkb_rules_model,%%val%%";
        desktop.ojuny.mango.global.xkb_rules_model = "";

        # @option widget = "text"; label = "Rules file"; group = "Keyboard"; hidden = true; description = "Usually auto-detected."; applyCommand = "mmsg dispatch setoption,xkb_rules_rules,%%val%%";
        desktop.ojuny.mango.global.xkb_rules_rules = "";

        # Mouse
        # @option widget = "switch"; label = "Natural scrolling"; group = "Mouse"; applyCommand = "mmsg dispatch setoption,mouse_natural_scrolling,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.mouse_natural_scrolling = false;

        # @option widget = "dropdown"; label = "Acceleration profile"; group = "Mouse"; choices = [ "none" "flat" "adaptive" ]; applyCommand = "case %%val%% in none) v=0;; flat) v=1;; adaptive) v=2;; esac; mmsg dispatch setoption,mouse_accel_profile,$v";
        ojuny.mango.enum.mouse_accel_profile = "flat";

        # @option widget = "slider"; label = "Sensitivity"; group = "Mouse"; min = -1.0; max = 1.0; step = 0.05; description = "Negative = slower, 0 = default, positive = faster. Acceleration profile picks the curve; this only offsets it."; applyCommand = "mmsg dispatch setoption,mouse_accel_speed,%%val%%";
        desktop.ojuny.mango.global.mouse_accel_speed = 0.0;

        # @option widget = "switch"; label = "Left handed"; group = "Mouse"; applyCommand = "mmsg dispatch setoption,mouse_left_handed,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.mouse_left_handed = false;

        # @option widget = "switch"; label = "Middle button emulation"; group = "Mouse"; hidden = true; applyCommand = "mmsg dispatch setoption,mouse_middle_button_emulation,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.mouse_middle_button_emulation = false;

        # @option widget = "dropdown"; label = "Mouse scroll method"; group = "Mouse"; choices = [ "never" "two-finger" "edge" "button" ]; applyCommand = "case %%val%% in never) v=0;; two-finger) v=1;; edge) v=2;; button) v=4;; esac; mmsg dispatch setoption,mouse_scroll_method,$v";
        ojuny.mango.enum.mouse_scroll_method = "two-finger";

        # @option widget = "spin"; label = "Scroll button"; group = "Mouse"; min = 272; max = 279; advanced = true; applyCommand = "mmsg dispatch setoption,mouse_scroll_button,%%val%%";
        desktop.ojuny.mango.global.mouse_scroll_button = 274;

        # @option widget = "dropdown"; label = "Click method"; group = "Mouse"; choices = [ "none" "button-areas" "clickfinger" ]; hidden = true; applyCommand = "case %%val%% in none) v=0;; button-areas) v=1;; clickfinger) v=2;; esac; mmsg dispatch setoption,mouse_click_method,$v";
        ojuny.mango.enum.mouse_click_method = "button-areas";

        # @option widget = "dropdown"; label = "Send events"; group = "Mouse"; choices = [ "enabled" "disabled" "disabled-with-external-mouse" ]; hidden = true; applyCommand = "case %%val%% in enabled) v=0;; disabled) v=1;; disabled-with-external-mouse) v=2;; esac; mmsg dispatch setoption,mouse_send_events_mode,$v";
        ojuny.mango.enum.mouse_send_events_mode = "enabled";

        # @option widget = "spin"; label = "Axis scroll factor"; group = "Mouse"; min = 0.1; max = 10.0; step = 0.1; advanced = true; applyCommand = "mmsg dispatch setoption,axis_scroll_factor,%%val%%";
        desktop.ojuny.mango.global.axis_scroll_factor = 1.0;

        # @option widget = "spin"; label = "Axis bind apply timeout"; group = "Mouse"; min = 0; max = 1000; step = 10; unit = "ms"; advanced = true; applyCommand = "mmsg dispatch setoption,axis_bind_apply_timeout,%%val%%";
        desktop.ojuny.mango.global.axis_bind_apply_timeout = 100;

        # Trackpad
        # @option widget = "switch"; label = "Disable trackpad"; group = "Trackpad"; applyCommand = "mmsg dispatch setoption,disable_trackpad,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.disable_trackpad = false;

        # @option widget = "switch"; label = "Tap to click"; group = "Trackpad"; applyCommand = "mmsg dispatch setoption,tap_to_click,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.tap_to_click = true;

        # @option widget = "switch"; label = "Tap and drag"; group = "Trackpad"; applyCommand = "mmsg dispatch setoption,tap_and_drag,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.tap_and_drag = true;

        # @option widget = "switch"; label = "Drag lock"; group = "Trackpad"; hidden = true; applyCommand = "mmsg dispatch setoption,drag_lock,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.drag_lock = true;

        # @option widget = "switch"; label = "Natural scrolling"; group = "Trackpad"; applyCommand = "mmsg dispatch setoption,trackpad_natural_scrolling,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.trackpad_natural_scrolling = true;

        # @option widget = "dropdown"; label = "Acceleration profile"; group = "Trackpad"; choices = [ "none" "flat" "adaptive" ]; applyCommand = "case %%val%% in none) v=0;; flat) v=1;; adaptive) v=2;; esac; mmsg dispatch setoption,trackpad_accel_profile,$v";
        ojuny.mango.enum.trackpad_accel_profile = "adaptive";

        # @option widget = "slider"; label = "Sensitivity"; group = "Trackpad"; min = -1.0; max = 1.0; step = 0.05; description = "Negative = slower, 0 = default, positive = faster. Acceleration profile picks the curve; this only offsets it."; applyCommand = "mmsg dispatch setoption,trackpad_accel_speed,%%val%%";
        desktop.ojuny.mango.global.trackpad_accel_speed = 0.0;

        # @option widget = "dropdown"; label = " Trackpad scroll method"; group = "Trackpad"; choices = [ "never" "two-finger" "edge" "button" ]; applyCommand = "case %%val%% in never) v=0;; two-finger) v=1;; edge) v=2;; button) v=4;; esac; mmsg dispatch setoption,trackpad_scroll_method,$v";
        ojuny.mango.enum.trackpad_scroll_method = "two-finger";

        # @option widget = "spin"; label = "Scroll button"; group = "Trackpad"; min = 272; max = 279; advanced = true; applyCommand = "mmsg dispatch setoption,trackpad_scroll_button,%%val%%";
        desktop.ojuny.mango.global.trackpad_scroll_button = 274;

        # @option widget = "dropdown"; label = "Click method"; group = "Trackpad"; choices = [ "none" "button-areas" "clickfinger" ]; hidden = true; applyCommand = "case %%val%% in none) v=0;; button-areas) v=1;; clickfinger) v=2;; esac; mmsg dispatch setoption,trackpad_click_method,$v";
        ojuny.mango.enum.trackpad_click_method = "button-areas";

        # @option widget = "dropdown"; label = "Send events"; group = "Trackpad"; choices = [ "enabled" "disabled" "disabled-with-external-mouse" ]; hidden = true; applyCommand = "case %%val%% in enabled) v=0;; disabled) v=1;; disabled-with-external-mouse) v=2;; esac; mmsg dispatch setoption,trackpad_send_events_mode,$v";
        ojuny.mango.enum.trackpad_send_events_mode = "enabled";

        # @option widget = "switch"; label = "Disable while typing"; group = "Trackpad"; applyCommand = "mmsg dispatch setoption,trackpad_disable_while_typing,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.trackpad_disable_while_typing = true;

        # @option widget = "switch"; label = "Left handed"; group = "Trackpad"; applyCommand = "mmsg dispatch setoption,trackpad_left_handed,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.trackpad_left_handed = false;

        # @option widget = "switch"; label = "Middle button emulation"; group = "Trackpad"; hidden = true; applyCommand = "mmsg dispatch setoption,trackpad_middle_button_emulation,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.trackpad_middle_button_emulation = false;

        # @option widget = "dropdown"; label = "Button map"; group = "Trackpad"; choices = [ "left-right-middle" "left-middle-right" ]; hidden = true; applyCommand = "case %%val%% in left-right-middle) v=0;; left-middle-right) v=1;; esac; mmsg dispatch setoption,button_map,$v";
        ojuny.mango.enum.button_map = "left-middle-right";

        # @option widget = "spin"; label = "Scroll factor"; group = "Trackpad"; min = 0.1; max = 10.0; step = 0.1; advanced = true; applyCommand = "mmsg dispatch setoption,trackpad_scroll_factor,%%val%%";
        desktop.ojuny.mango.global.trackpad_scroll_factor = 1.0;

        # Cursor
        # @option widget = "spin"; label = "Hide cursor after"; group = "Cursor"; min = 0; unit = "s"; applyCommand = "mmsg dispatch setoption,cursor_hide_timeout,%%val%%";
        desktop.ojuny.mango.global.cursor_hide_timeout = 30;

        # @option widget = "switch"; label = "Hide cursor on keypress"; group = "Cursor"; hidden = true; applyCommand = "mmsg dispatch setoption,cursor_hide_on_keypress,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.cursor_hide_on_keypress = false;

        # Dragging
        # @option widget = "switch"; label = "Tiled windows re-tile on drag-and-drop"; group = "Dragging"; applyCommand = "mmsg dispatch setoption,drag_tile_to_tile,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.drag_tile_to_tile = true;

        # @option widget = "switch"; label = "Allow small drag preview"; group = "Dragging"; hidden = true; applyCommand = "mmsg dispatch setoption,drag_tile_small,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.drag_tile_small = true;

        # @option widget = "spin"; label = "Drag-to-tile corner"; group = "Dragging"; min = 0; max = 4; description = "0 none, 1-3 corner, 4 auto-detect."; advanced = true; applyCommand = "mmsg dispatch setoption,drag_corner,%%val%%";
        desktop.ojuny.mango.global.drag_corner = 0;

        # @option widget = "switch"; label = "Warp cursor while dragging"; group = "Dragging"; hidden = true; applyCommand = "mmsg dispatch setoption,drag_warp_cursor,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.drag_warp_cursor = true;

        # Swipe gesture tuning lives on the Gestures page (17-gestures.nix).

        # Touch
        # @option widget = "switch"; label = "Enable touchscreen"; group = "Touch"; description = "Touch input for clients that support touch. On by default.";
        ojuny.mango.flag.touch_enable = true;

        # @option widget = "switch"; label = "Mouse emulation for touch"; group = "Touch"; description = "Turn touches on surfaces that do not accept touch, including XWayland clients, into pointer clicks. Off means those touches are ignored.";
        ojuny.mango.flag.touch_enable_mouse_emulation = true;

        # Device rules, shared by keyboard and touch rows
        # @option widget = "table-list"; label = "Device rules"; group = "Devices"; advanced = true; firstValueEditable = true; columns = [ "name" "type" "kb_layout" "kb_variant" "kb_options" "kb_model" "monitor" "send_events_mode" "calibration" ]; columnTypes = [ "str" "str" "str" "str" "str" "str" "str" "str" "str" ]; description = "Per-device mango device_rule rows. Empty fields are omitted from the generated rule. type accepts keyboard, pointer, trackpad, touch, switch, tablet or pad. Every row needs a name or a type. Touch is on by default; add a row only to pin a panel or to calibrate one. Use type = touch for the built-in panel, or name to target one device. monitor is an output name from the Monitors page. calibration is six libinput numbers, touch rows only, matched by the device name rather than the vendor:product identifier; a wrong matrix can make the panel unusable, and clearing the cell restores the default.";
        ojuny.input.devices = [ ];

        desktop.ojuny.mango.rules.device_rule = map (
          device:
          lib.filterAttrs (_: value: value != "") {
            inherit (device) name type kb_layout kb_variant kb_options kb_model monitor;
            send_events_mode =
              if device.send_events_mode == "" then "" else lib.toInt device.send_events_mode;
          }
        ) config.ojuny.input.devices;

        services.udev.extraRules = lib.concatStringsSep "\n" (
          let
            calibrated = lib.filter (
              device: device.type == "touch" && device.calibration != ""
            ) config.ojuny.input.devices;

            ruleFor = device:
              let
                match =
                  if device.name == ""
                  then ''ENV{ID_INPUT_TOUCHSCREEN}=="1"''
                  else ''ATTRS{name}=="${device.name}"'';
              in
              ''ACTION!="remove", KERNEL=="event[0-9]*", SUBSYSTEM=="input", ${match}, ENV{LIBINPUT_CALIBRATION_MATRIX}="${device.calibration}"'';

            unnamed = lib.filter (device: device.name == "") calibrated;
            named = lib.filter (device: device.name != "") calibrated;
          in
          map ruleFor (unnamed ++ named)
        );

        assertions = [
          {
            assertion = lib.all (device: device.name != "" || device.type != "") config.ojuny.input.devices;
            message = "ojuny.input.devices: every row needs a name or a type.";
          }
          {
            assertion = lib.all (
              device:
              device.type == ""
              || lib.elem device.type [
                "keyboard"
                "pointer"
                "trackpad"
                "touch"
                "switch"
                "tablet"
                "pad"
              ]
            ) config.ojuny.input.devices;
            message = "ojuny.input.devices: type must be keyboard, pointer, trackpad, touch, switch, tablet or pad.";
          }
          {
            assertion = lib.all (
              device: lib.elem device.send_events_mode [ "" "0" "1" "2" ]
            ) config.ojuny.input.devices;
            message = "ojuny.input.devices: send_events_mode must be empty, 0, 1 or 2.";
          }
          {
            assertion = lib.all (
              device:
              device.calibration == ""
              || builtins.match "-?[0-9]+(\\.[0-9]+)?( -?[0-9]+(\\.[0-9]+)?){5}" device.calibration != null
            ) config.ojuny.input.devices;
            message = "ojuny.input.devices: calibration must be six space-separated numbers.";
          }
          {
            assertion = lib.all (
              device: device.calibration == "" || device.type == "touch"
            ) config.ojuny.input.devices;
            message = "ojuny.input.devices: calibration is only allowed on touch rows.";
          }
          {
            assertion =
              lib.count (device: device.calibration != "" && device.name == "")
                config.ojuny.input.devices
              <= 1;
            message = "ojuny.input.devices: only one unnamed touch row may set calibration; give additional rows a name.";
          }
          {
            assertion = lib.all (
              device: device.calibration == "" || !(lib.hasInfix "\"" device.name)
            ) config.ojuny.input.devices;
            message = "ojuny.input.devices: a calibration row name must not contain a double quote.";
          }
        ];

        # Derived mango integers (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.numlock_on = if config.ojuny.mango.flag.numlock_on then 1 else 0;
        desktop.ojuny.mango.global.mouse_natural_scrolling =
          if config.ojuny.mango.flag.mouse_natural_scrolling then 1 else 0;
        desktop.ojuny.mango.global.mouse_left_handed =
          if config.ojuny.mango.flag.mouse_left_handed then 1 else 0;
        desktop.ojuny.mango.global.mouse_middle_button_emulation =
          if config.ojuny.mango.flag.mouse_middle_button_emulation then 1 else 0;
        desktop.ojuny.mango.global.disable_trackpad =
          if config.ojuny.mango.flag.disable_trackpad then 1 else 0;
        desktop.ojuny.mango.global.tap_to_click = if config.ojuny.mango.flag.tap_to_click then 1 else 0;
        desktop.ojuny.mango.global.tap_and_drag = if config.ojuny.mango.flag.tap_and_drag then 1 else 0;
        desktop.ojuny.mango.global.drag_lock = if config.ojuny.mango.flag.drag_lock then 1 else 0;
        desktop.ojuny.mango.global.trackpad_natural_scrolling =
          if config.ojuny.mango.flag.trackpad_natural_scrolling then 1 else 0;
        desktop.ojuny.mango.global.trackpad_disable_while_typing =
          if config.ojuny.mango.flag.trackpad_disable_while_typing then 1 else 0;
        desktop.ojuny.mango.global.trackpad_left_handed =
          if config.ojuny.mango.flag.trackpad_left_handed then 1 else 0;
        desktop.ojuny.mango.global.trackpad_middle_button_emulation =
          if config.ojuny.mango.flag.trackpad_middle_button_emulation then 1 else 0;
        desktop.ojuny.mango.global.touch_enable = if config.ojuny.mango.flag.touch_enable then 1 else 0;
        desktop.ojuny.mango.global.touch_enable_mouse_emulation =
          if config.ojuny.mango.flag.touch_enable_mouse_emulation then 1 else 0;
        desktop.ojuny.mango.global.cursor_hide_on_keypress =
          if config.ojuny.mango.flag.cursor_hide_on_keypress then 1 else 0;
        desktop.ojuny.mango.global.drag_tile_to_tile =
          if config.ojuny.mango.flag.drag_tile_to_tile then 1 else 0;
        desktop.ojuny.mango.global.drag_tile_small =
          if config.ojuny.mango.flag.drag_tile_small then 1 else 0;
        desktop.ojuny.mango.global.drag_warp_cursor =
          if config.ojuny.mango.flag.drag_warp_cursor then 1 else 0;

        desktop.ojuny.mango.global.mouse_accel_profile =
          enumSpecs.mouse_accel_profile.choices.${config.ojuny.mango.enum.mouse_accel_profile};
        desktop.ojuny.mango.global.mouse_scroll_method =
          enumSpecs.mouse_scroll_method.choices.${config.ojuny.mango.enum.mouse_scroll_method};
        desktop.ojuny.mango.global.mouse_click_method =
          enumSpecs.mouse_click_method.choices.${config.ojuny.mango.enum.mouse_click_method};
        desktop.ojuny.mango.global.mouse_send_events_mode =
          enumSpecs.mouse_send_events_mode.choices.${config.ojuny.mango.enum.mouse_send_events_mode};
        desktop.ojuny.mango.global.trackpad_accel_profile =
          enumSpecs.trackpad_accel_profile.choices.${config.ojuny.mango.enum.trackpad_accel_profile};
        desktop.ojuny.mango.global.trackpad_scroll_method =
          enumSpecs.trackpad_scroll_method.choices.${config.ojuny.mango.enum.trackpad_scroll_method};
        desktop.ojuny.mango.global.trackpad_click_method =
          enumSpecs.trackpad_click_method.choices.${config.ojuny.mango.enum.trackpad_click_method};
        desktop.ojuny.mango.global.trackpad_send_events_mode =
          enumSpecs.trackpad_send_events_mode.choices.${config.ojuny.mango.enum.trackpad_send_events_mode};
        desktop.ojuny.mango.global.button_map =
          enumSpecs.button_map.choices.${config.ojuny.mango.enum.button_map};
      };
    };

  flake.modules.nixos.desktop-input-method =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = config.ojuny.inputMethod;

      cjkEngines = {
        none = null;
        japanese = {
          name = "mozc";
          package = pkgs.fcitx5-mozc;
        };
        korean = {
          name = "hangul";
          package = pkgs.fcitx5-hangul;
        };
        simplified-chinese = {
          name = "pinyin";
          package = pkgs.fcitx5-chinese-addons;
        };
        traditional-chinese = {
          name = "chewing";
          package = pkgs.fcitx5-chewing;
        };
      };

      cjkEngine = cjkEngines.${cfg.cjkForms};

      knownEngineNames = {
        fcitx5-mozc = "mozc";
        fcitx5-hangul = "hangul";
        fcitx5-chinese-addons = "pinyin";
        fcitx5-chewing = "chewing";
      };

      extraEngineNames = lib.filter (name: name != null) (
        map (package: knownEngineNames.${lib.getName package} or null) cfg.engines
      );

      profileEngines = lib.unique (
        [ "keyboard-us" ]
        ++ lib.optional (cjkEngine != null) cjkEngine.name
        ++ extraEngineNames
      );

      profileItems = lib.listToAttrs (
        lib.imap0 (
          index: name: {
            name = "Groups/0/Items/${toString index}";
            value = {
              Name = name;
              Layout = "";
            };
          }
        ) profileEngines
      );

      profile = profileItems // {
        "Groups/0" = {
          Name = cfg.defaultGroup;
          "Default Layout" = "us";
          DefaultIM = "keyboard-us";
        };
        GroupOrder = {
          "0" = cfg.defaultGroup;
        };
      };
    in
    {
      imports = [ self.modules.nixos.desktop-input-method-backend ];

      options.ojuny.inputMethod = {
        enable = lib.mkEnableOption "Fcitx5 input method support";

        engines = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Extra Fcitx5 engine packages to install.";
        };

        defaultGroup = lib.mkOption {
          type = lib.types.nonEmptyStr;
          default = "Default";
          description = "Fcitx5 input method group name in the generated profile.";
        };

        cjkForms = lib.mkOption {
          type = lib.types.enum [
            "none"
            "japanese"
            "korean"
            "simplified-chinese"
            "traditional-chinese"
          ];
          default = "none";
          description = "Curated CJK engine and Noto CJK font set.";
        };
      };

      config = {

          # @option widget = "switch"; label = "Enable Fcitx5"; group = "Input method"; groupOrder = 10; order = 10; description = "Install and start Fcitx5. Off by default.";
          ojuny.inputMethod.enable = false;

          # @option widget = "packages"; label = "Extra engines"; group = "Input method"; groupOrder = 10; order = 20; visibleWhen.path = "ojuny.inputMethod.enable"; visibleWhen.equals = true; description = "Additional Fcitx5 engine packages. The keyboard engine is always available.";
          ojuny.inputMethod.engines = [ ];

          # @option widget = "text"; label = "Default group"; group = "Input method"; groupOrder = 10; order = 30; visibleWhen.path = "ojuny.inputMethod.enable"; visibleWhen.equals = true; description = "Fcitx5 input method group name. A user profile takes precedence.";
          ojuny.inputMethod.defaultGroup = "Default";

          # @option widget = "dropdown"; label = "CJK form"; group = "Input method"; groupOrder = 10; order = 40; choices = [ "none" "japanese" "korean" "simplified-chinese" "traditional-chinese" ]; visibleWhen.path = "ojuny.inputMethod.enable"; visibleWhen.equals = true; description = "Adds the matching engine and Noto CJK fonts.";
          ojuny.inputMethod.cjkForms = "none";

      };
    };

  flake.modules.nixos.desktop-input-method-backend =
    { config, lib, pkgs, ... }:
    let
      cfg = config.ojuny.inputMethod;

      cjkEngines = {
        none = null;
        japanese = {
          name = "mozc";
          package = pkgs.fcitx5-mozc;
        };
        korean = {
          name = "hangul";
          package = pkgs.fcitx5-hangul;
        };
        simplified-chinese = {
          name = "pinyin";
          package = pkgs.fcitx5-chinese-addons;
        };
        traditional-chinese = {
          name = "chewing";
          package = pkgs.fcitx5-chewing;
        };
      };

      cjkEngine = cjkEngines.${cfg.cjkForms};

      knownEngineNames = {
        fcitx5-mozc = "mozc";
        fcitx5-hangul = "hangul";
        fcitx5-chinese-addons = "pinyin";
        fcitx5-chewing = "chewing";
      };

      extraEngineNames = lib.filter (name: name != null) (
        map (package: knownEngineNames.${lib.getName package} or null) cfg.engines
      );

      profileEngines = lib.unique (
        [ "keyboard-us" ]
        ++ lib.optional (cjkEngine != null) cjkEngine.name
        ++ extraEngineNames
      );

      profileItems = lib.listToAttrs (
        lib.imap0 (
          index: name: {
            name = "Groups/0/Items/${toString index}";
            value = {
              Name = name;
              Layout = "";
            };
          }
        ) profileEngines
      );

      profile = profileItems // {
        "Groups/0" = {
          Name = cfg.defaultGroup;
          "Default Layout" = "us";
          DefaultIM = "keyboard-us";
        };
        GroupOrder = {
          "0" = cfg.defaultGroup;
        };
      };
    in
    {
      config = lib.mkIf cfg.enable {
          i18n.inputMethod.enable = true;
          i18n.inputMethod.type = "fcitx5";

          i18n.inputMethod.fcitx5.addons =
            lib.optional (cjkEngine != null) cjkEngine.package ++ cfg.engines;

          i18n.inputMethod.fcitx5.settings.inputMethod = profile;

          environment.variables = {
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
            XMODIFIERS = "@im=fcitx";
            SDL_IM_MODULE = "fcitx";
          };

          fonts.packages = lib.optionals (cfg.cjkForms != "none") [
            pkgs.noto-fonts-cjk-sans
            pkgs.noto-fonts-cjk-serif
          ];
      };
    };

}

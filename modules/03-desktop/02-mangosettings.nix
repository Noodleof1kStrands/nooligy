/*
  @menu
  displayname = "Window management";
  icon = "preferences-system-windows-symbolic";
  order = 20;
  description = "Layouts, focus, tiling and workspaces";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-mangosettings =
    { config, lib, ... }:

    let
      # mango stores booleans as the integers 0 and 1, so these are exposed as
      # switches under ojuny.mango.* and written back as 0/1 in the derived
      # assignments at the bottom of this module.
      flagDefaults = {
        focus_on_activate = false;
        sloppy_focus = true;
        warp_cursor = true;
        allow_lock_transparent = true;
        focus_cross_monitor = true;
        focus_cross_tag = false;
        focus_direction_only_zone_overlap = true;
        exchange_cross_monitor = true;
        view_current_to_back = true;
        enable_floating_snap = true;
        float_full_to_top = false;
        enable_border_resize = true;
        enable_hotarea = false;
        hotarea_disable_on_fullscreen = true;
        allow_shortcuts_inhibit = true;
        auto_reload_config = true;
        disable_middle_paste = false;
        sync_obj_enable = true;
        xwayland_persistence = true;
        idle_inhibit_ignore_visible = false;
        idle_inhibit_when_fullscreen = false;
      };

      # mango mode integers, exposed as named choices under ojuny.mango.enum and
      # mapped back to their integers in the derived assignments below.
      enumSpecs = {
        hotarea_corner = {
          default = "bottom-left";
          choices = {
            "top-left" = 0;
            "top-right" = 1;
            "bottom-left" = 2;
            "bottom-right" = 3;
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

      config = {

        # Master/stack and Dwindle layouts moved to their own pages
        # (02-mangomaster.nix and 02-mangodwindle.nix).

        # Focus
        # @option widget = "switch"; label = "Focus on activate"; group = "Focus"; applyCommand = "mmsg dispatch setoption,focus_on_activate,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.focus_on_activate = false;

        # @option widget = "switch"; label = "Sloppy focus (follow cursor)"; group = "Focus"; applyCommand = "mmsg dispatch setoption,sloppy_focus,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.sloppy_focus = true;

        # @option widget = "switch"; label = "Warp cursor on keyboard focus"; group = "Focus"; applyCommand = "mmsg dispatch setoption,warp_cursor,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.warp_cursor = true;

        # @option widget = "switch"; label = "Allow transparency over lock screen"; group = "Focus"; hidden = true;
        ojuny.mango.flag.allow_lock_transparent = true;

        # @option widget = "switch"; label = "Focus across monitors"; group = "Focus"; applyCommand = "mmsg dispatch setoption,focus_cross_monitor,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.focus_cross_monitor = true;

        # @option widget = "switch"; label = "Exchange across monitors"; group = "Focus"; applyCommand = "mmsg dispatch setoption,exchange_cross_monitor,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.exchange_cross_monitor = true;

        # @option widget = "switch"; label = "Toggle returns to previous tag"; group = "Focus"; applyCommand = "mmsg dispatch setoption,view_current_to_back,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.view_current_to_back = true;

        # @option widget = "switch"; label = "Focus across tags"; group = "Focus"; hidden = true; applyCommand = "mmsg dispatch setoption,focus_cross_tag,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.focus_cross_tag = false;

        # @option widget = "switch"; label = "Directional focus requires overlap"; group = "Focus"; hidden = true; applyCommand = "mmsg dispatch setoption,focus_direction_only_zone_overlap,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.focus_direction_only_zone_overlap = true;

        # Windows
        # @option widget = "switch"; label = "Snap floating windows"; group = "Windows"; applyCommand = "mmsg dispatch setoption,enable_floating_snap,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.enable_floating_snap = true;

        # @option widget = "spin"; label = "Snap distance"; group = "Windows"; min = 0; max = 200; unit = "px"; applyCommand = "mmsg dispatch setoption,snap_distance,%%val%%";
        desktop.ojuny.mango.global.snap_distance = 30;

        # @option widget = "switch"; label = "Resize by dragging border"; group = "Windows"; applyCommand = "mmsg dispatch setoption,enable_border_resize,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.enable_border_resize = true;

        # @option widget = "switch"; label = "Share fullscreen and floating top layer"; group = "Windows"; hidden = true; applyCommand = "mmsg dispatch setoption,float_full_to_top,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.float_full_to_top = false;

        # @option widget = "spin"; label = "Border grab strip"; group = "Windows"; min = 0; max = 64; unit = "px"; advanced = true; applyCommand = "mmsg dispatch setoption,border_resize_size,%%val%%";
        desktop.ojuny.mango.global.border_resize_size = 10;

        # Workspaces and Special workspace groups moved to their own page (06-mangoworkspaces.nix).

        # Overview
        # @option widget = "switch"; label = "Enable hot corner"; group = "Overview"; applyCommand = "mmsg dispatch setoption,enable_hotarea,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.enable_hotarea = false;

        # @option widget = "dropdown"; label = "Hot corner"; group = "Overview"; choices = [ "top-left" "top-right" "bottom-left" "bottom-right" ]; applyCommand = "case %%val%% in top-left) v=0;; top-right) v=1;; bottom-left) v=2;; bottom-right) v=3;; esac; mmsg dispatch setoption,hotarea_corner,$v";
        ojuny.mango.enum.hotarea_corner = "bottom-left";

        # @option widget = "switch"; label = "Disable hot corner when fullscreen"; group = "Overview"; hidden = true; applyCommand = "mmsg dispatch setoption,hotarea_disable_on_fullscreen,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.hotarea_disable_on_fullscreen = true;

        # @option widget = "spin"; label = "Hot corner size"; group = "Overview"; min = 0; max = 100; unit = "px"; hidden = true; applyCommand = "mmsg dispatch setoption,hotarea_size,%%val%%";
        desktop.ojuny.mango.global.hotarea_size = 0;

        # @option widget = "spin"; label = "Inner gap"; group = "Overview"; min = 0; max = 200; unit = "px"; advanced = true; applyCommand = "mmsg dispatch setoption,overview_gap_inner,%%val%%";
        desktop.ojuny.mango.global.overview_gap_inner = 5;

        # @option widget = "spin"; label = "Outer gap"; group = "Overview"; min = 0; max = 200; unit = "px"; advanced = true; applyCommand = "mmsg dispatch setoption,overview_gap_outer,%%val%%";
        desktop.ojuny.mango.global.overview_gap_outer = 30;

        # @option widget = "slider"; label = "Overcircle center ratio"; group = "Overview"; min = 0.1; max = 0.9; step = 0.05; advanced = true; applyCommand = "mmsg dispatch setoption,overcircle_center_ratio,%%val%%";
        desktop.ojuny.mango.global.overcircle_center_ratio = 0.5;

        # @option widget = "text"; label = "Jump label characters"; group = "Overview"; advanced = true; applyCommand = "mmsg dispatch setoption,jump_labels,%%val%%";
        desktop.ojuny.mango.global.jump_labels = "HJKLASDFGQWERTYUIOPZXCVBNM";

        # Rules (structured tables, edited in Nix)
        # @option widget = "raw"; label = "Window rules"; group = "Rules"; rows = 8; advanced = true; description = "mango window_rule tables.";
        desktop.ojuny.mango.rules.window_rule = [
          {
            app_id = "foot";
            focused_opacity = 0.7;
            unfocused_opacity = 0.7;
          }
          {
            title = "Floating-Menu";
            is_floating = 1;
            height = 0.6;
            width = 0.6;
          }
        ];

        # @option widget = "raw"; label = "Layer rules"; group = "Rules"; rows = 4; advanced = true; description = "mango layer_rule tables.";
        desktop.ojuny.mango.rules.layer_rule = [ ];

        # System
        # @option widget = "switch"; label = "Allow shortcut inhibition"; group = "System"; groupOrder = 90; description = "Let clients inhibit keyboard shortcuts."; applyCommand = "mmsg dispatch setoption,allow_shortcuts_inhibit,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.allow_shortcuts_inhibit = true;

        # @option widget = "switch"; label = "Auto reload config"; group = "System"; groupOrder = 90; description = "Reload mango when the generated config or a sourced file changes."; applyCommand = "mmsg dispatch setoption,auto_reload_config,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.auto_reload_config = true;

        # @option widget = "switch"; label = "Disable middle-click paste"; group = "System"; groupOrder = 90; advanced = true; description = "Turn off the primary selection used for middle-click paste in Wayland clients."; applyCommand = "mmsg dispatch setoption,disable_middle_paste,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.disable_middle_paste = false;

        # @option widget = "switch"; label = "DRM syncobj timeline"; group = "System"; groupOrder = 90; advanced = true; description = "Enable drm_syncobj timeline support. Requires restart."; applyCommand = "mmsg dispatch setoption,sync_obj_enable,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.sync_obj_enable = true;

        # @option widget = "switch"; label = "Keep XWayland running"; group = "System"; groupOrder = 90; advanced = true; description = "Keep XWayland alive when no X11 clients are open."; applyCommand = "mmsg dispatch setoption,xwayland_persistence,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.xwayland_persistence = true;

        # Derived mango integers (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.focus_on_activate =
          if config.ojuny.mango.flag.focus_on_activate then 1 else 0;
        desktop.ojuny.mango.global.sloppy_focus = if config.ojuny.mango.flag.sloppy_focus then 1 else 0;
        desktop.ojuny.mango.global.warp_cursor = if config.ojuny.mango.flag.warp_cursor then 1 else 0;
        desktop.ojuny.mango.global.allow_lock_transparent =
          if config.ojuny.mango.flag.allow_lock_transparent then 1 else 0;
        desktop.ojuny.mango.global.focus_cross_monitor =
          if config.ojuny.mango.flag.focus_cross_monitor then 1 else 0;
        desktop.ojuny.mango.global.focus_cross_tag =
          if config.ojuny.mango.flag.focus_cross_tag then 1 else 0;
        desktop.ojuny.mango.global.focus_direction_only_zone_overlap =
          if config.ojuny.mango.flag.focus_direction_only_zone_overlap then 1 else 0;
        desktop.ojuny.mango.global.exchange_cross_monitor =
          if config.ojuny.mango.flag.exchange_cross_monitor then 1 else 0;
        desktop.ojuny.mango.global.view_current_to_back =
          if config.ojuny.mango.flag.view_current_to_back then 1 else 0;
        desktop.ojuny.mango.global.enable_floating_snap =
          if config.ojuny.mango.flag.enable_floating_snap then 1 else 0;
        desktop.ojuny.mango.global.float_full_to_top =
          if config.ojuny.mango.flag.float_full_to_top then 1 else 0;
        desktop.ojuny.mango.global.enable_border_resize =
          if config.ojuny.mango.flag.enable_border_resize then 1 else 0;
        desktop.ojuny.mango.global.idle_inhibit_ignore_visible =
          if config.ojuny.mango.flag.idle_inhibit_ignore_visible then 1 else 0;
        desktop.ojuny.mango.global.idle_inhibit_when_fullscreen =
          if config.ojuny.mango.flag.idle_inhibit_when_fullscreen then 1 else 0;
        desktop.ojuny.mango.global.enable_hotarea = if config.ojuny.mango.flag.enable_hotarea then 1 else 0;
        desktop.ojuny.mango.global.hotarea_disable_on_fullscreen =
          if config.ojuny.mango.flag.hotarea_disable_on_fullscreen then 1 else 0;
        desktop.ojuny.mango.global.allow_shortcuts_inhibit =
          if config.ojuny.mango.flag.allow_shortcuts_inhibit then 1 else 0;
        desktop.ojuny.mango.global.auto_reload_config =
          if config.ojuny.mango.flag.auto_reload_config then 1 else 0;
        desktop.ojuny.mango.global.disable_middle_paste =
          if config.ojuny.mango.flag.disable_middle_paste then 1 else 0;
        desktop.ojuny.mango.global.sync_obj_enable =
          if config.ojuny.mango.flag.sync_obj_enable then 1 else 0;
        desktop.ojuny.mango.global.xwayland_persistence =
          if config.ojuny.mango.flag.xwayland_persistence then 1 else 0;

        desktop.ojuny.mango.global.hotarea_corner =
          enumSpecs.hotarea_corner.choices.${config.ojuny.mango.enum.hotarea_corner};
      };
    };

}

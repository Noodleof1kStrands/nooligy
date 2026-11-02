/*
  @menu
  displayname = "Workspaces";
  icon = "preferences-desktop-workspaces-symbolic";
  order = 60;
  description = "Workspace and tag settings. Named scratchpads summon on the active tag, and their commands cannot contain commas.";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-mangoworkspaces =
    { config, lib, ... }:

    let
      # mango stores booleans as the integers 0 and 1, so these are exposed as
      # switches under ojuny.mango.* and written back as 0/1 in the derived
      # assignments at the bottom of this module.
      flagDefaults = {
        tag_gather = true;
        tag_carousel = false;
        scratchpad_cross_monitor = true;
        single_scratchpad = false;
      };

      layoutChoices = [
        "tile"
        "dwindle"
        "scroller"
        "monocle"
        "deck"
        "grid"
        "fair"
        "vertical_scroller"
        "vertical_tile"
        "vertical_fair"
        "vertical_grid"
        "vertical_deck"
        "right_tile"
        "center_tile"
      ];

      tagRuleSpec = lib.types.submodule {
        options = {
          tag = lib.mkOption {
            type = lib.types.ints.between 0 99;
            default = 0;
            description = "Tag id. 0 is the special workspace.";
          };

          name = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Display name for the table row. Not sent to Mango.";
          };

          layout = lib.mkOption {
            type = lib.types.enum layoutChoices;
            default = "tile";
            description = "Mango layout name.";
          };
        };
      };

      scratchpadFields = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Generate the bind and window rule for this scratchpad.";
        };

        appId = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Window app_id. Empty sends none to Mango.";
        };

        title = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Window title. Empty sends none to Mango.";
        };

        command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Launch command. It cannot contain commas.";
        };

        chord = lib.mkOption {
          type = lib.types.str;
          default = "SUPER+grave";
          description = "MOD+KEY chord. It must be unique.";
        };
      };

      scratchpadSpec = lib.types.submodule {
        options = scratchpadFields;
      };

      cfg = config.ojuny.workspaces;
      tagNum = config.desktop.ojuny.mango.global.tag_num or 10;
      tagRules = map (rule: {
        id = rule.tag;
        layout_name = rule.layout;
      }) cfg.tags;

      scratchpadRows = lib.mapAttrsToList (name: row: row // { inherit name; }) config.ojuny.scratchpads;

      quakeScratchpadRow = {
        name = "quake";
        enable = true;
        appId = "org.ojuny.quake";
        title = "";
        command = "ghostty --class=org.ojuny.quake";
        chord = lib.concatStringsSep "+" (config.ojuny.quake.modifier ++ config.ojuny.quake.keys);
      };

      allScratchpads = scratchpadRows ++ lib.optional config.ojuny.quake.enable quakeScratchpadRow;

      activeScratchpads = lib.filter (row: row.enable) allScratchpads;

      splitChord =
        chord:
        let
          parts = lib.splitString "+" chord;
          modifiers = lib.init parts;
        in
        {
          keys = [ (lib.last parts) ];
          modifier = if modifiers == [ ] then [ "none" ] else modifiers;
        };

      scratchpadBind =
        row:
        {
          inherit (splitChord row.chord) modifier keys;
          dispatcher = "toggle_named_scratchpad";
          args = "${if row.appId != "" then row.appId else "none"},${if row.title != "" then row.title else "none"},${row.command}";
          description = "Toggle ${row.name} scratchpad";
          group = "Windows";
          subcat = "Scratchpad";
        };

      scratchpadBinds = lib.listToAttrs (
        map (row: {
          name = row.name;
          value = scratchpadBind row;
        }) activeScratchpads
      );

      scratchpadWindowRule =
        row:
        { is_named_scratchpad = 1; }
        // lib.optionalAttrs (row.appId != "") { app_id = row.appId; }
        // lib.optionalAttrs (row.title != "") { title = row.title; };
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

      options.ojuny.quake = {
        enable = lib.mkEnableOption "the quake-style scratchpad terminal";
        widthRatio = lib.mkOption {
          type = lib.types.float;
          default = 0.7;
          description = "Width of the quake scratchpad as a fraction of the screen.";
        };
        heightRatio = lib.mkOption {
          type = lib.types.float;
          default = 0.55;
          description = "Height of the quake scratchpad as a fraction of the screen. This is global, so it also affects other named scratchpads.";
        };
        modifier = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "SUPER" ];
          description = "Modifier keys that open the quake console.";
        };
        keys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "grave" ];
          description = "Keys that toggle the quake console with the modifiers above.";
        };
      };

      options.ojuny.scratchpads = lib.mkOption {
        type = lib.types.attrsOf scratchpadSpec;
        default = { };
        description = "Named scratchpads, keyed by a stable name. Each enabled row generates one bind and one window rule.";
      };

      options.ojuny.workspaces.tags = lib.mkOption {
        type = lib.types.listOf tagRuleSpec;
        default = [ ];
        description = "Tag rules in application order. Specific tags override the wildcard rule.";
      };

      config = {
        # @option widget = "switch"; label = "Quake console"; group = "Quake"; description = "Enable the quake-style scratchpad terminal and its keybind.";
        ojuny.quake.enable = true;

        # @option widget = "slider"; label = "Width ratio"; group = "Quake"; min = 0.1; max = 1.0; step = 0.05; description = "Width of the quake scratchpad as a fraction of the screen.";
        ojuny.quake.widthRatio = 0.7;

        # @option widget = "slider"; label = "Height ratio"; group = "Quake"; min = 0.1; max = 1.0; step = 0.05; description = "Height of the quake scratchpad as a fraction of the screen. This is global, so it also affects other named scratchpads.";
        ojuny.quake.heightRatio = 0.55;

        # @option widget = "list"; label = "Modifiers"; group = "Quake"; itemLabel = "Modifier"; addLabel = "Add modifier"; description = "Modifier keys that open the quake console, for example SUPER.";
        ojuny.quake.modifier = [ "SUPER" ];

        # @option widget = "list"; label = "Keys"; group = "Quake"; itemLabel = "Key"; addLabel = "Add key"; description = "Keys that toggle the quake console with the modifiers above.";
        ojuny.quake.keys = [ "grave" ];

        # @option widget = "table-attrset"; label = "Scratchpads"; group = "Scratchpads"; groupOrder = 15; columns = [ "enable" "appId" "title" "command" "chord" ]; columnTypes = [ "bool" "str" "str" "str" "str" ]; keyEditable = true; firstValueEditable = true; description = "One row per named scratchpad, keyed by a stable name. Set appId, title, or both to identify the window; an empty field is sent to Mango as none. command must launch the app with that class or title. chord is MOD+KEY and must be unique. A named scratchpad opens on the tag that is active when you toggle it; Mango has no per-tag pinning. Dimensions are global. Commands cannot contain commas because bind arguments and rule fields are comma-separated.";
        ojuny.scratchpads = { };

        # @option widget = "switch"; label = "Single scratchpad at a time"; group = "Scratchpads"; groupOrder = 15; order = 20; description = "Global Mango option. Only one scratchpad, named or standard, is visible at a time; it applies to every row, not one row."; applyCommand = "mmsg dispatch setoption,single_scratchpad,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.single_scratchpad = false;

        desktop.ojuny.mango.global.scratchpad_width_ratio = config.ojuny.quake.widthRatio;
        desktop.ojuny.mango.global.scratchpad_height_ratio = config.ojuny.quake.heightRatio;

        desktop.ojuny.mango.binds.common = scratchpadBinds;

        # Workspaces
        # @option widget = "spin"; label = "Tag count"; group = "Workspaces"; min = 1;
        desktop.ojuny.mango.global.tag_num = 10;

        # @option widget = "switch"; label = "Gather occupied tags"; group = "Workspaces"; applyCommand = "mmsg dispatch setoption,tag_gather,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.tag_gather = true;

        # @option widget = "switch"; label = "Share scratchpad across monitors"; group = "Workspaces"; applyCommand = "mmsg dispatch setoption,scratchpad_cross_monitor,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.scratchpad_cross_monitor = true;

        # @option widget = "switch"; label = "Tag carousel"; group = "Workspaces"; hidden = true; applyCommand = "mmsg dispatch setoption,tag_carousel,$(case %%val%% in true) echo 1;; *) echo 0;; esac)";
        ojuny.mango.flag.tag_carousel = false;

        # Tag rules
        # @option widget = "table-list"; label = "Tag rules"; group = "Tag rules"; groupOrder = 20; columns = [ "tag" "name" "layout" ]; columnTypes = [ "int" "str" "str" ]; firstValueEditable = true; description = "One row per tag. tag is 0 for the special workspace or a number up to the tag count. name is a display label only. layout is the Mango layout. Rows apply in table order after the default wildcard rule, so a specific tag overrides the wildcard.";
        ojuny.workspaces.tags = [
          {
            tag = 0;
            name = "special";
            layout = "tile";
          }
          {
            tag = 1;
            name = "";
            layout = "tile";
          }
          {
            tag = 2;
            name = "";
            layout = "tile";
          }
          {
            tag = 3;
            name = "";
            layout = "tile";
          }
        ];

        assertions = [
          {
            assertion = lib.all (rule: rule.tag <= tagNum) cfg.tags;
            message = "ojuny.workspaces.tags contains a tag id above desktop.ojuny.mango.global.tag_num.";
          }
          {
            assertion =
              let
                tags = map (rule: rule.tag) cfg.tags;
              in
              lib.length tags == lib.length (lib.unique tags);
            message = "ojuny.workspaces.tags has duplicate tag ids.";
          }
          {
            assertion = lib.all (row: row.appId != "" || row.title != "") allScratchpads;
            message = "ojuny.scratchpads rows must set appId, title, or both.";
          }
          {
            assertion = lib.all (row: row.command != "") allScratchpads;
            message = "ojuny.scratchpads rows must set a non-empty command.";
          }
          {
            assertion = lib.all (
              row:
              lib.all (value: !lib.hasInfix "," value) [
                row.name
                row.appId
                row.title
                row.command
                row.chord
              ]
            ) allScratchpads;
            message = "ojuny.scratchpads values cannot contain commas; bind arguments and rule fields are comma-separated.";
          }
          {
            assertion =
              let
                pairs = map (row: [ row.appId row.title ]) allScratchpads;
              in
              lib.length pairs == lib.length (lib.unique pairs);
            message = "ojuny.scratchpads has a duplicate appId and title pair, including the quake row.";
          }
          {
            assertion =
              let
                chords = map (row: row.chord) activeScratchpads;
              in
              lib.length chords == lib.length (lib.unique chords);
            message = "ojuny.scratchpads chords must be unique across enabled rows and the quake row.";
          }
        ];

        desktop.ojuny.mango.rules.window_rule = lib.mkAfter (map scratchpadWindowRule activeScratchpads);

        desktop.ojuny.mango.rules.tag_rule = tagRules;

        # Special workspace (tag 0)
        # @option widget = "slider"; label = "Background dim"; group = "Special workspace"; min = 0.0; max = 1.0; step = 0.05; applyCommand = "mmsg dispatch setoption,special_dim,%%val%%";
        desktop.ojuny.mango.global.special_dim = 0.5;

        # @option widget = "spin"; label = "Inner gap (horizontal)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true; applyCommand = "mmsg dispatch setoption,special_gap_inner_horizontal,%%val%%";
        desktop.ojuny.mango.global.special_gap_inner_horizontal = 5;

        # @option widget = "spin"; label = "Inner gap (vertical)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true; applyCommand = "mmsg dispatch setoption,special_gap_inner_vertical,%%val%%";
        desktop.ojuny.mango.global.special_gap_inner_vertical = 5;

        # @option widget = "spin"; label = "Outer gap (horizontal)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true; applyCommand = "mmsg dispatch setoption,special_gap_outer_horizontal,%%val%%";
        desktop.ojuny.mango.global.special_gap_outer_horizontal = 30;

        # @option widget = "spin"; label = "Outer gap (vertical)"; group = "Special workspace"; min = 0; max = 64; unit = "px"; advanced = true; applyCommand = "mmsg dispatch setoption,special_gap_outer_vertical,%%val%%";
        desktop.ojuny.mango.global.special_gap_outer_vertical = 30;

        # Derived mango integers (no @option, hidden in the GUI).
        desktop.ojuny.mango.global.tag_gather = if config.ojuny.mango.flag.tag_gather then 1 else 0;
        desktop.ojuny.mango.global.tag_carousel = if config.ojuny.mango.flag.tag_carousel then 1 else 0;
        desktop.ojuny.mango.global.scratchpad_cross_monitor =
          if config.ojuny.mango.flag.scratchpad_cross_monitor then 1 else 0;
        desktop.ojuny.mango.global.single_scratchpad =
          if config.ojuny.mango.flag.single_scratchpad then 1 else 0;
      };
    };
}

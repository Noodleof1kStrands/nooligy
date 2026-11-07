/*
  @menu
  displayname = "Keybinds";
  icon = "preferences-desktop-keyboard-symbolic";
  order = 30;
  description = "Key, mouse, axis and gesture bindings";
  category = "02-Core";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-binds =
    { config, lib, pkgs, ... }:
    let
      ojunySrc = inputs.ojuny-desktop.outPath;
      pasteScript = builtins.path {
        name = "paste.sh";
        path = ojunySrc + "/lib/scripts/paste.sh";
      };
    in
    {

      # @option widget = "keybinds"; label = "Default binds"; group = "Binds"; groupOrder = 10; order = 10;
      desktop.ojuny.mango.binds.default = {
        focusDown = {
          modifier = [ "SUPER" ];
          keys = [ "S" ];
          dispatcher = "focusdir";
          args = "down";
          description = "Focus window in direction";
          group = "Navigation";
        };
        focusLeft = {
          modifier = [ "SUPER" ];
          keys = [ "A" ];
          dispatcher = "focusdir";
          args = "left";
          description = "Focus window in direction";
          group = "Navigation";
        };
        focusRight = {
          modifier = [ "SUPER" ];
          keys = [ "D" ];
          dispatcher = "focusdir";
          args = "right";
          description = "Focus window in direction";
          group = "Navigation";
        };
        focusUp = {
          modifier = [ "SUPER" ];
          keys = [ "W" ];
          dispatcher = "focusdir";
          args = "up";
          description = "Focus window in direction";
          group = "Navigation";
        };
        moveDown = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "S" ];
          dispatcher = "move_client";
          args = "down";
          description = "Move window in direction";
          group = "Navigation";
        };
        moveLeft = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "A" ];
          dispatcher = "move_client";
          args = "left";
          description = "Move window in direction";
          group = "Navigation";
        };
        moveRight = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "D" ];
          dispatcher = "move_client";
          args = "right";
          description = "Move window in direction";
          group = "Navigation";
        };
        moveUp = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "W" ];
          dispatcher = "move_client";
          args = "up";
          description = "Move window in direction";
          group = "Navigation";
        };
        tagsilent1 = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "1" ];
          dispatcher = "tagsilent";
          args = "1";
          description = "Move window to workspace";
          group = "Navigation";
        };
        tagsilent10 = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "0" ];
          dispatcher = "tagsilent";
          args = "10";
          description = "Move window to workspace";
          group = "Navigation";
        };
        tagsilent2 = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "2" ];
          dispatcher = "tagsilent";
          args = "2";
          description = "Move window to workspace";
          group = "Navigation";
        };
        tagsilent3 = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "3" ];
          dispatcher = "tagsilent";
          args = "3";
          description = "Move window to workspace";
          group = "Navigation";
        };
        tagsilent4 = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "4" ];
          dispatcher = "tagsilent";
          args = "4";
          description = "Move window to workspace";
          group = "Navigation";
        };
        tagsilent5 = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "5" ];
          dispatcher = "tagsilent";
          args = "5";
          description = "Move window to workspace";
          group = "Navigation";
        };
        tagsilent6 = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "6" ];
          dispatcher = "tagsilent";
          args = "6";
          description = "Move window to workspace";
          group = "Navigation";
        };
        tagsilent7 = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "7" ];
          dispatcher = "tagsilent";
          args = "7";
          description = "Move window to workspace";
          group = "Navigation";
        };
        tagsilent8 = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "8" ];
          dispatcher = "tagsilent";
          args = "8";
          description = "Move window to workspace";
          group = "Navigation";
        };
        tagsilent9 = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "9" ];
          dispatcher = "tagsilent";
          args = "9";
          description = "Move window to workspace";
          group = "Navigation";
        };
        workspace1 = {
          modifier = [ "SUPER" ];
          keys = [ "1" ];
          dispatcher = "comboview";
          args = "1";
          description = "Switch to workspace, hold for multi-tag";
          group = "Navigation";
        };
        workspace10 = {
          modifier = [ "SUPER" ];
          keys = [ "0" ];
          dispatcher = "comboview";
          args = "10";
          description = "Switch to workspace, hold for multi-tag";
          group = "Navigation";
        };
        workspace2 = {
          modifier = [ "SUPER" ];
          keys = [ "2" ];
          dispatcher = "comboview";
          args = "2";
          description = "Switch to workspace, hold for multi-tag";
          group = "Navigation";
        };
        workspace3 = {
          modifier = [ "SUPER" ];
          keys = [ "3" ];
          dispatcher = "comboview";
          args = "3";
          description = "Switch to workspace, hold for multi-tag";
          group = "Navigation";
        };
        workspace4 = {
          modifier = [ "SUPER" ];
          keys = [ "4" ];
          dispatcher = "comboview";
          args = "4";
          description = "Switch to workspace, hold for multi-tag";
          group = "Navigation";
        };
        workspace5 = {
          modifier = [ "SUPER" ];
          keys = [ "5" ];
          dispatcher = "comboview";
          args = "5";
          description = "Switch to workspace, hold for multi-tag";
          group = "Navigation";
        };
        workspace6 = {
          modifier = [ "SUPER" ];
          keys = [ "6" ];
          dispatcher = "comboview";
          args = "6";
          description = "Switch to workspace, hold for multi-tag";
          group = "Navigation";
        };
        workspace7 = {
          modifier = [ "SUPER" ];
          keys = [ "7" ];
          dispatcher = "comboview";
          args = "7";
          description = "Switch to workspace, hold for multi-tag";
          group = "Navigation";
        };
        workspace8 = {
          modifier = [ "SUPER" ];
          keys = [ "8" ];
          dispatcher = "comboview";
          args = "8";
          description = "Switch to workspace, hold for multi-tag";
          group = "Navigation";
        };
        workspace9 = {
          modifier = [ "SUPER" ];
          keys = [ "9" ];
          dispatcher = "comboview";
          args = "9";
          description = "Switch to workspace, hold for multi-tag";
          group = "Navigation";
        };
      };

      # @option widget = "keybinds"; label = "Common binds"; group = "Binds"; groupOrder = 10; order = 20;
      desktop.ojuny.mango.binds.common = {
        keymodeDefault = {
          modifier = [ "SUPER" ];
          keys = [ "BackSpace" ];
          dispatcher = "setkeymode";
          args = "default";
          description = "Enter default mode";
          group = "Alt Modes";
          subcat = "Common";
        };
        keymodeGroups = {
          modifier = [ "SUPER" ];
          keys = [ "F2" ];
          dispatcher = "setkeymode";
          args = "groups";
          description = "Enter groups mode";
          group = "Alt Modes";
          subcat = "Common";
        };
        keymodeMovement = {
          modifier = [ "SUPER" ];
          keys = [ "F1" ];
          dispatcher = "setkeymode";
          args = "movement";
          description = "Enter movement mode";
          group = "Alt Modes";
          subcat = "Common";
        };
        keymodeResize = {
          modifier = [ "SUPER" ];
          keys = [ "F3" ];
          dispatcher = "setkeymode";
          args = "resize";
          description = "Enter resize mode";
          group = "Alt Modes";
          subcat = "Common";
        };
        browser = {
          modifier = [ "SUPER" ];
          keys = [ "B" ];
          dispatcher = "spawn";
          args = config.ojuny.browser.command;
          description = "Open default browser";
          group = "Applications";
          subcat = "Launch";
        };
        files = {
          modifier = [ "SUPER" ];
          keys = [ "E" ];
          dispatcher = "spawn";
          args = config.desktop.ojuny.fileManager.command;
          description = "Open default file manager";
          group = "Applications";
          subcat = "Launch";
        };
        launcher = {
          modifier = [ "SUPER" ];
          keys = [ "SPACE" ];
          dispatcher = "spawn";
          args = "dms ipc call spotlight toggle";
          description = "Toggle launcher";
          group = "Applications";
          subcat = "Launch";
        };
        emoji = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "E" ];
          dispatcher = "spawn";
          args = "dms ipc call spotlight toggleQuery ':e '";
          description = "Emoji picker";
          group = "Applications";
          subcat = "Utilities";
        };

        settings = {
          modifier = [ "SUPER" ];
          keys = [ "X" ];
          dispatcher = "spawn";
          args = "dms ipc call dankMenu toggle root";
          description = "Toggle Menu";
          group = "Applications";
          subcat = "Launch";
        };
        settingsAlt = {
          modifier = [ "SUPER" ];
          keys = [ "Escape" ];
          dispatcher = "spawn";
          args = "dms ipc call dankMenu toggle root";
          description = "Toggle Menu";
          group = "Applications";
          subcat = "Launch";
        };
        terminal = {
          modifier = [ "SUPER" ];
          keys = [ "Return" ];
          dispatcher = "spawn";
          args = "ghostty";
          description = "Open terminal";
          group = "Applications";
          subcat = "Launch";
        };
        terminalAlt = {
          modifier = [ "SUPER" ];
          keys = [ "Tab" ];
          dispatcher = "spawn";
          args = "ghostty";
          description = "Open terminal";
          group = "Applications";
          subcat = "Launch";
        };
        viewDown = {
          modifier = [ "SUPER" ];
          keys = [ "Down" ];
          dispatcher = "viewtoright";
          args = "0";
          description = "Next Workspace";
          group = "Navigation";
        };
        viewLeft = {
          modifier = [ "SUPER" ];
          keys = [ "Left" ];
          dispatcher = "viewtoleft";
          args = "0";
          description = "Previous Workspace";
          group = "Navigation";
        };
        viewRight = {
          modifier = [ "SUPER" ];
          keys = [ "Right" ];
          dispatcher = "viewtoright";
          args = "0";
          description = "Next Workspace";
          group = "Navigation";
        };
        viewUp = {
          modifier = [ "SUPER" ];
          keys = [ "Up" ];
          dispatcher = "viewtoleft";
          args = "0";
          description = "Previous Workspace";
          group = "Navigation";
        };
        keybinds = {
          modifier = [ "SUPER" ];
          keys = [ "K" ];
          dispatcher = "spawn";
          args = "dms ipc call keybinds open binds";
          description = "Show Keybinds";
          group = "Applications";
          subcat = "Utilities";
        };
        switchKeyboardLayout = {
          modifier = [
            "SUPER"
            "ALT"
          ];
          keys = [ "K" ];
          dispatcher = "switch_keyboard_layout";
          args = [ ];
          description = "Switch keyboard layout";
          group = "System";
          subcat = "Keyboard";
        };
        overview = {
          modifier = [ "ALT" ];
          keys = [ "Tab" ];
          dispatcher = "overcircle";
          args = "next";
          description = "Toggle/cycle overview";
          group = "Navigation";
        };
        quit = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "Escape" ];
          dispatcher = "quit";
          args = "";
          description = "Quit Mango";
          group = "System";
          subcat = "Common";
        };
        reload = {
          modifier = [ "SUPER" ];
          keys = [ "R" ];
          dispatcher = "reload_config";
          args = "";
          description = "Reload configuration";
          group = "System";
          subcat = "Common";
        };
        groupleave = {
          modifier = [ "SUPER" ];
          keys = [ "Z" ];
          dispatcher = "groupleave";
          args = "";
          description = "Leave group";
          group = "Windows";
          subcat = "Groups";
        };
        brightnessUp = {
          modifier = [ ];
          keys = [ "XF86MonBrightnessUp" ];
          dispatcher = "spawn";
          args = [ "brightnessctl set +5%" ];
          description = "Increase screen brightness";
          group = "Media";
          subcat = "Hardware";
        };
        brightnessDown = {
          modifier = [ ];
          keys = [ "XF86MonBrightnessDown" ];
          dispatcher = "spawn";
          args = [ "brightnessctl set 5%-" ];
          description = "Decrease screen brightness";
          group = "Media";
          subcat = "Hardware";
        };
        volumeUp = {
          modifier = [ ];
          keys = [ "XF86AudioRaiseVolume" ];
          dispatcher = "spawn";
          args = [ "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+" ];
          description = "Raise output volume";
          group = "Media";
          subcat = "Hardware";
        };
        volumeDown = {
          modifier = [ ];
          keys = [ "XF86AudioLowerVolume" ];
          dispatcher = "spawn";
          args = [ "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" ];
          description = "Lower output volume";
          group = "Media";
          subcat = "Hardware";
        };
        mute = {
          modifier = [ ];
          keys = [ "XF86AudioMute" ];
          dispatcher = "spawn";
          args = [ "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" ];
          description = "Mute output";
          group = "Media";
          subcat = "Hardware";
        };
        micMute = {
          modifier = [ ];
          keys = [ "XF86AudioMicMute" ];
          dispatcher = "spawn";
          args = [ "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ];
          description = "Mute microphone";
          group = "Media";
          subcat = "Hardware";
        };
        playPause = {
          modifier = [ ];
          keys = [ "XF86AudioPlay" ];
          dispatcher = "spawn";
          args = [ "playerctl play-pause" ];
          description = "Play or pause media";
          group = "Media";
          subcat = "Playback";
        };
        nextTrack = {
          modifier = [ ];
          keys = [ "XF86AudioNext" ];
          dispatcher = "spawn";
          args = [ "playerctl next" ];
          description = "Next track";
          group = "Media";
          subcat = "Playback";
        };
        previousTrack = {
          modifier = [ ];
          keys = [ "XF86AudioPrev" ];
          dispatcher = "spawn";
          args = [ "playerctl previous" ];
          description = "Previous track";
          group = "Media";
          subcat = "Playback";
        };
        stopTrack = {
          modifier = [ ];
          keys = [ "XF86AudioStop" ];
          dispatcher = "spawn";
          args = [ "playerctl stop" ];
          description = "Stop playback";
          group = "Media";
          subcat = "Playback";
        };
        clipboardHistory = {
          modifier = [
            "SUPER"
            "SHIFT"
          ];
          keys = [ "V" ];
          dispatcher = "spawn";
          args = [ "dms ipc call clipboard toggle" ];
          description = "Clipboard history (Super+Shift+V)";
          group = "Applications";
          subcat = "Utilities";
        };
        snap = {
          modifier = [ "SUPER" ];
          keys = [ "H" ];
          dispatcher = "spawn_shell";
          args = "ojuny-snap";
          description = "Float, unfloat or snap the focused window";
          group = "Windows";
          subcat = "Layout";
        };
        close = {
          modifier = [ "SUPER" ];
          keys = [ "Q" ];
          dispatcher = "killclient";
          args = "";
          description = "Kill client";
          group = "Windows";
          subcat = "Management";
        };
        fullscreen = {
          modifier = [ "SUPER" ];
          keys = [ "F11" ];
          dispatcher = "togglefullscreen";
          args = "";
          description = "Toggle fullscreen";
          group = "Windows";
          subcat = "Management";
        };
        maximize = {
          modifier = [ "SUPER" ];
          keys = [ "F" ];
          dispatcher = "togglemaximizescreen";
          args = "";
          description = "Toggle maximize";
          group = "Windows";
          subcat = "Management";
        };
        paste = {
          modifier = [ "SUPER" ];
          keys = [ "V" ];
          dispatcher = "spawn_shell";
          args = "\${pasteScript}";
          description = "Paste clipboard";
          group = "Windows";
          subcat = "Management";
        };
        specialTagToggle = {
          modifier = [
            "SUPER"
            "ALT"
          ];
          keys = [ "SPACE" ];
          dispatcher = "toggle_special_tag";
          args = "";
          description = "Toggle Special Workspace";
          group = "Windows";
          subcat = "Special Workspace";
        };
        specialTagWindow = {
          modifier = [ "SUPER" ];
          keys = [ "T" ];
          dispatcher = "tag_special_tag";
          args = "";
          description = "Move window into or out of special workspace";
          group = "Windows";
          subcat = "Special Workspace";
        };
      };

      # @option widget = "keybinds"; label = "Group binds"; group = "Binds"; groupOrder = 10; order = 30; description = "Group and workspace-visibility mode. Enter with SUPER+F2; press Backspace to return to default.";
      desktop.ojuny.mango.binds.groups = {
        groupFocusNext = {
          modifier = [ "none" ];
          keys = [ "L" ];
          dispatcher = "groupfocus";
          args = "next";
          description = "Focus next window in group";
          group = "Windows";
          subcat = "Groups";
        };
        groupFocusPrev = {
          modifier = [ "none" ];
          keys = [ "H" ];
          dispatcher = "groupfocus";
          args = "prev";
          description = "Focus previous window in group";
          group = "Windows";
          subcat = "Groups";
        };
        groupLeave = {
          modifier = [ "none" ];
          keys = [ "Z" ];
          dispatcher = "groupleave";
          args = "";
          description = "Remove focused window from group";
          group = "Windows";
          subcat = "Groups";
        };
        groupSmartDown = {
          modifier = [ "none" ];
          keys = [ "S" ];
          dispatcher = "groupjoin";
          args = "down";
          description = "Join the group in the direction below";
          group = "Windows";
          subcat = "Groups";
        };
        groupSmartLeft = {
          modifier = [ "none" ];
          keys = [ "A" ];
          dispatcher = "groupjoin";
          args = "left";
          description = "Join the group to the left";
          group = "Windows";
          subcat = "Groups";
        };
        groupSmartRight = {
          modifier = [ "none" ];
          keys = [ "D" ];
          dispatcher = "groupjoin";
          args = "right";
          description = "Join the group to the right";
          group = "Windows";
          subcat = "Groups";
        };
        groupSmartUp = {
          modifier = [ "none" ];
          keys = [ "W" ];
          dispatcher = "groupjoin";
          args = "up";
          description = "Join the group above";
          group = "Windows";
          subcat = "Groups";
        };
        leaveGroupsMode = {
          modifier = [ "none" ];
          keys = [ "BackSpace" ];
          dispatcher = "setkeymode";
          args = "default";
          description = "Return to default mode";
          group = "Windows";
          subcat = "Groups";
        };
        toggleGroupBar = {
          modifier = [ "none" ];
          keys = [ "B" ];
          dispatcher = "togglegroupbar";
          args = "";
          description = "Toggle the group bar";
          group = "Windows";
          subcat = "Groups";
        };
        toggleview1 = {
          modifier = [ "none" ];
          keys = [ "1" ];
          dispatcher = "toggleview";
          args = "1";
          description = "Toggle workspace visibility";
          group = "Navigation";
          subcat = "Workspaces";
        };
        toggleview10 = {
          modifier = [ "none" ];
          keys = [ "0" ];
          dispatcher = "toggleview";
          args = "10";
          description = "Toggle workspace visibility";
          group = "Navigation";
          subcat = "Workspaces";
        };
        toggleview2 = {
          modifier = [ "none" ];
          keys = [ "2" ];
          dispatcher = "toggleview";
          args = "2";
          description = "Toggle workspace visibility";
          group = "Navigation";
          subcat = "Workspaces";
        };
        toggleview3 = {
          modifier = [ "none" ];
          keys = [ "3" ];
          dispatcher = "toggleview";
          args = "3";
          description = "Toggle workspace visibility";
          group = "Navigation";
          subcat = "Workspaces";
        };
        toggleview4 = {
          modifier = [ "none" ];
          keys = [ "4" ];
          dispatcher = "toggleview";
          args = "4";
          description = "Toggle workspace visibility";
          group = "Navigation";
          subcat = "Workspaces";
        };
        toggleview5 = {
          modifier = [ "none" ];
          keys = [ "5" ];
          dispatcher = "toggleview";
          args = "5";
          description = "Toggle workspace visibility";
          group = "Navigation";
          subcat = "Workspaces";
        };
        toggleview6 = {
          modifier = [ "none" ];
          keys = [ "6" ];
          dispatcher = "toggleview";
          args = "6";
          description = "Toggle workspace visibility";
          group = "Navigation";
          subcat = "Workspaces";
        };
        toggleview7 = {
          modifier = [ "none" ];
          keys = [ "7" ];
          dispatcher = "toggleview";
          args = "7";
          description = "Toggle workspace visibility";
          group = "Navigation";
          subcat = "Workspaces";
        };
        toggleview8 = {
          modifier = [ "none" ];
          keys = [ "8" ];
          dispatcher = "toggleview";
          args = "8";
          description = "Toggle workspace visibility";
          group = "Navigation";
          subcat = "Workspaces";
        };
        toggleview9 = {
          modifier = [ "none" ];
          keys = [ "9" ];
          dispatcher = "toggleview";
          args = "9";
          description = "Toggle workspace visibility";
          group = "Navigation";
          subcat = "Workspaces";
        };
      };

      # @option widget = "keybinds"; label = "Movement binds"; group = "Binds"; groupOrder = 10; order = 40;
      desktop.ojuny.mango.binds.movement = {
        exchangeDown = {
          modifier = [ "none" ];
          keys = [ "S" ];
          dispatcher = "exchange_client";
          args = "down";
          description = "Move window";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        exchangeLeft = {
          modifier = [ "none" ];
          keys = [ "A" ];
          dispatcher = "exchange_client";
          args = "left";
          description = "Move window";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        exchangeRight = {
          modifier = [ "none" ];
          keys = [ "D" ];
          dispatcher = "exchange_client";
          args = "right";
          description = "Move window";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        exchangeUp = {
          modifier = [ "none" ];
          keys = [ "W" ];
          dispatcher = "exchange_client";
          args = "up";
          description = "Move window";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        tagsilent1 = {
          modifier = [ "none" ];
          keys = [ "1" ];
          dispatcher = "tagsilent";
          args = "1";
          description = "Send window to workspace";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        tagsilent10 = {
          modifier = [ "none" ];
          keys = [ "0" ];
          dispatcher = "tagsilent";
          args = "10";
          description = "Send window to workspace";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        tagsilent2 = {
          modifier = [ "none" ];
          keys = [ "2" ];
          dispatcher = "tagsilent";
          args = "2";
          description = "Send window to workspace";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        tagsilent3 = {
          modifier = [ "none" ];
          keys = [ "3" ];
          dispatcher = "tagsilent";
          args = "3";
          description = "Send window to workspace";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        tagsilent4 = {
          modifier = [ "none" ];
          keys = [ "4" ];
          dispatcher = "tagsilent";
          args = "4";
          description = "Send window to workspace";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        tagsilent5 = {
          modifier = [ "none" ];
          keys = [ "5" ];
          dispatcher = "tagsilent";
          args = "5";
          description = "Send window to workspace";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        tagsilent6 = {
          modifier = [ "none" ];
          keys = [ "6" ];
          dispatcher = "tagsilent";
          args = "6";
          description = "Send window to workspace";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        tagsilent7 = {
          modifier = [ "none" ];
          keys = [ "7" ];
          dispatcher = "tagsilent";
          args = "7";
          description = "Send window to workspace";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        tagsilent8 = {
          modifier = [ "none" ];
          keys = [ "8" ];
          dispatcher = "tagsilent";
          args = "8";
          description = "Send window to workspace";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
        tagsilent9 = {
          modifier = [ "none" ];
          keys = [ "9" ];
          dispatcher = "tagsilent";
          args = "9";
          description = "Send window to workspace";
          group = "Alt Modes";
          subcat = "Movement Mode";
        };
      };

      # @option widget = "keybinds"; label = "Resize binds"; group = "Binds"; groupOrder = 10; order = 50;
      desktop.ojuny.mango.binds.resize = {
        smartresizeDown = {
          modifier = [ "none" ];
          keys = [ "S" ];
          dispatcher = "smartresizewin";
          args = "down";
          description = "Resize window";
          group = "Alt Modes";
          subcat = "Resize Mode";
        };
        smartresizeLeft = {
          modifier = [ "none" ];
          keys = [ "A" ];
          dispatcher = "smartresizewin";
          args = "left";
          description = "Resize window";
          group = "Alt Modes";
          subcat = "Resize Mode";
        };
        smartresizeRight = {
          modifier = [ "none" ];
          keys = [ "D" ];
          dispatcher = "smartresizewin";
          args = "right";
          description = "Resize window";
          group = "Alt Modes";
          subcat = "Resize Mode";
        };
        smartresizeUp = {
          modifier = [ "none" ];
          keys = [ "W" ];
          dispatcher = "smartresizewin";
          args = "up";
          description = "Resize window";
          group = "Alt Modes";
          subcat = "Resize Mode";
        };
      };

      # Move window (mouse)
      # @option widget = "list"; label = "Move window (mouse): Modifiers"; group = "Mouse";
      desktop.ojuny.mango.mousebind.default.move.modifier = [ "SUPER" ];
      # @option widget = "text"; label = "Move window (mouse): Button"; group = "Mouse";
      desktop.ojuny.mango.mousebind.default.move.keys = [ "btn_left" ];
      # @option widget = "text"; label = "Move window (mouse): Dispatcher"; group = "Mouse"; hidden = true;
      desktop.ojuny.mango.mousebind.default.move.dispatcher = "moveresize";
      # @option widget = "text"; label = "Move window (mouse): Arguments"; group = "Mouse"; hidden = true;
      desktop.ojuny.mango.mousebind.default.move.args = "curmove";
      # @option widget = "text"; label = "Move window (mouse): Description"; group = "Mouse"; hidden = true;
      desktop.ojuny.mango.mousebind.default.move.description = "Move window";
      desktop.ojuny.mango.mousebind.default.move.group = "Mouse";

      # Maximize (middle click)
      # @option widget = "list"; label = "Maximize (middle click): Modifiers"; group = "Mouse";
      desktop.ojuny.mango.mousebind.default.maximize.modifier = [ ];
      # @option widget = "text"; label = "Maximize (middle click): Button"; group = "Mouse";
      desktop.ojuny.mango.mousebind.default.maximize.keys = [ "btn_middle" ];
      # @option widget = "text"; label = "Maximize (middle click): Dispatcher"; group = "Mouse"; hidden = true;
      desktop.ojuny.mango.mousebind.default.maximize.dispatcher = "togglemaximizescreen";
      # @option widget = "text"; label = "Maximize (middle click): Arguments"; group = "Mouse"; hidden = true;
      desktop.ojuny.mango.mousebind.default.maximize.args = "0";
      # @option widget = "text"; label = "Maximize (middle click): Description"; group = "Mouse"; hidden = true;
      desktop.ojuny.mango.mousebind.default.maximize.description = "Maximize window";
      desktop.ojuny.mango.mousebind.default.maximize.group = "Mouse";

      # Resize window (mouse)
      # @option widget = "list"; label = "Resize window (mouse): Modifiers"; group = "Mouse";
      desktop.ojuny.mango.mousebind.default.resize.modifier = [ "SUPER" ];
      # @option widget = "text"; label = "Resize window (mouse): Button"; group = "Mouse";
      desktop.ojuny.mango.mousebind.default.resize.keys = [ "btn_right" ];
      # @option widget = "text"; label = "Resize window (mouse): Dispatcher"; group = "Mouse"; hidden = true;
      desktop.ojuny.mango.mousebind.default.resize.dispatcher = "moveresize";
      # @option widget = "text"; label = "Resize window (mouse): Arguments"; group = "Mouse"; hidden = true;
      desktop.ojuny.mango.mousebind.default.resize.args = "curresize";
      # @option widget = "text"; label = "Resize window (mouse): Description"; group = "Mouse"; hidden = true;
      desktop.ojuny.mango.mousebind.default.resize.description = "Resize window";
      desktop.ojuny.mango.mousebind.default.resize.group = "Mouse";

      # Previous tag (scroll)
      # @option widget = "list"; label = "Previous tag (scroll): Modifiers"; group = "Scroll";
      desktop.ojuny.mango.axisbind.default.viewPrev.modifier = [ "SUPER" ];
      # @option widget = "text"; label = "Previous tag (scroll): Axis"; group = "Scroll";
      desktop.ojuny.mango.axisbind.default.viewPrev.keys = [ "UP" ];
      # @option widget = "text"; label = "Previous tag (scroll): Dispatcher"; group = "Scroll"; hidden = true;
      desktop.ojuny.mango.axisbind.default.viewPrev.dispatcher = "viewtoleft_have_client";
      # @option widget = "text"; label = "Previous tag (scroll): Arguments"; group = "Scroll"; hidden = true;
      desktop.ojuny.mango.axisbind.default.viewPrev.args = [ ];
      # @option widget = "text"; label = "Previous tag (scroll): Description"; group = "Scroll"; hidden = true;
      desktop.ojuny.mango.axisbind.default.viewPrev.description = "Scroll views left";
      desktop.ojuny.mango.axisbind.default.viewPrev.group = "Mouse";
      desktop.ojuny.mango.axisbind.default.viewPrev.subcat = "Scroll";

      # Next tag (scroll)
      # @option widget = "list"; label = "Next tag (scroll): Modifiers"; group = "Scroll";
      desktop.ojuny.mango.axisbind.default.viewNext.modifier = [ "SUPER" ];
      # @option widget = "text"; label = "Next tag (scroll): Axis"; group = "Scroll";
      desktop.ojuny.mango.axisbind.default.viewNext.keys = [ "DOWN" ];
      # @option widget = "text"; label = "Next tag (scroll): Dispatcher"; group = "Scroll"; hidden = true;
      desktop.ojuny.mango.axisbind.default.viewNext.dispatcher = "viewtoright_have_client";
      # @option widget = "text"; label = "Next tag (scroll): Arguments"; group = "Scroll"; hidden = true;
      desktop.ojuny.mango.axisbind.default.viewNext.args = [ ];
      # @option widget = "text"; label = "Next tag (scroll): Description"; group = "Scroll"; hidden = true;
      desktop.ojuny.mango.axisbind.default.viewNext.description = "Scroll views right";
      desktop.ojuny.mango.axisbind.default.viewNext.group = "Mouse";
      desktop.ojuny.mango.axisbind.default.viewNext.subcat = "Scroll";

      # Touch gestures (desktop.ojuny.mango.gesturebind) live on the Gestures page.

      # @option widget = "spin"; label = "Snap zone width"; group = "Window snap"; groupOrder = 20; order = 10; min = 20; max = 500; step = 10; unit = "px"; description = "Width of each edge and corner zone used by the Super+H float and snap bind.";
      desktop.ojuny.mango.snap.range = 150;
      # @option widget = "spin"; label = "Left inset"; group = "Window snap"; groupOrder = 20; order = 20; min = 0; max = 200; unit = "px"; description = "Gap between the left screen edge and a snapped window.";
      desktop.ojuny.mango.snap.leftInset = 3;
      # @option widget = "spin"; label = "Right inset"; group = "Window snap"; groupOrder = 20; order = 30; min = 0; max = 200; unit = "px"; description = "Gap between the right screen edge and a snapped window.";
      desktop.ojuny.mango.snap.rightInset = 3;
      # @option widget = "spin"; label = "Top inset"; group = "Window snap"; groupOrder = 20; order = 40; min = 0; max = 200; unit = "px"; description = "Gap between the top screen edge and a snapped window, usually the bar height.";
      desktop.ojuny.mango.snap.topInset = 45;
      # @option widget = "spin"; label = "Bottom inset"; group = "Window snap"; groupOrder = 20; order = 50; min = 0; max = 200; unit = "px"; description = "Gap between the bottom screen edge and a snapped window.";
      desktop.ojuny.mango.snap.bottomInset = 5;

    };

}

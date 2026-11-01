/*
  @menu
  displayname = "Ojuny menu";
  icon = "open-menu-symbolic";
  order = 60;
  description = "Nix managed application menu. Patches add entries through desktop.ojuny.dankMenu.extraEntries.";
  category = "04-GUI";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-menu = { config, pkgs, ... }: {

    desktop.ojuny.dankMenu.enable = true;

    /* @option
       widget = "menu";
       label = "Menu tree";
       group = "Menu";
       groupOrder = 10;
       order = 10;
       description = "Entries shown in the Ojuny application menu. A toggle is a Run Command row with checked set. A patch entry is a Run Command row that calls a command the installed patch provides. Patches and non-GUI modules add entries with desktop.ojuny.dankMenu.extraEntries.<id>, merged over this tree when the menu JSON is generated; this editor only reads and writes desktop.ojuny.dankMenu.menu, so a save never removes an extra entry. A top-level row with provider = \"apps\" keeps no children.";
    */
    desktop.ojuny.dankMenu.menu = {
      apps = {
        icon = "apps";
        label = "Apps";
        aliases = [
          "app"
          "applications"
        ];
        provider = "apps";
      };
      learn = {
        icon = "school";
        label = "Learn";
      };
      trigger = {
        icon = "bolt";
        label = "Utils";
      };
      setup = {
        icon = "settings";
        label = "Settings";
        aliases = [ "settings" ];
      };
      system = {
        icon = "power_settings_new";
        label = "System";
        aliases = [ "power-menu" ];
      };
      "learn.keybinds" = {
        icon = "keyboard";
        label = "Keybinds";
        aliases = [
          "keys"
          "bindings"
        ];
        action = "dms ipc call keybinds open binds";
      };
      "learn.nixos" = {
        icon = "menu_book";
        label = "NixOS Manual";
        target = "https://nixos.org/manual/nixos/stable/";
      };
      "learn.home-manager" = {
        icon = "home";
        label = "Home Manager Options";
        target = "https://nix-community.github.io/home-manager/options.xhtml";
      };
      "learn.packages" = {
        icon = "search";
        label = "Search Packages";
        target = "https://search.nixos.org/packages";
      };
      "learn.options" = {
        icon = "search";
        label = "Search options";
        target = "https://search.nixos.org/options";
      };
      "trigger.capture" = {
        icon = "screenshot_region";
        label = "Capture";
        aliases = [
          "screenshot"
          "screenrecord"
        ];
        action = "dms ipc call screenCaptureToolbar toggle";
      };
      "trigger.capture.edit" = {
        icon = "edit";
        label = "Capture and Annotate";
        aliases = [
          "annotate"
          "satty"
        ];
        action = "ojuny-screenshot-edit region";
      };
      "trigger.capture.ocr" = {
        icon = "document_scanner";
        label = "Capture Text (OCR)";
        aliases = [
          "ocr"
          "text"
        ];
        action = "ojuny-capture-text";
      };
      "trigger.capture.qr" = {
        icon = "qr_code_scanner";
        label = "Decode QR Code";
        aliases = [
          "qr"
          "qrcode"
        ];
        action = "ojuny-capture-qr";
      };
      "trigger.capture.scroll" = {
        icon = "scrollable_header";
        label = "Scroll Capture";
        aliases = [ "scroll" ];
        action = "dms screenshot scroll";
      };
      "trigger.emoji" = {
        icon = "emoji_emotions";
        label = "Emoji";
        aliases = [
          "emoji"
          "unicode"
        ];
        action = "dms ipc call spotlight toggleQuery ':e '";
      };
      "trigger.clipboard" = {
        icon = "content_paste";
        label = "Clipboard";
        aliases = [ "clip" ];
        action = "dms ipc call clipboard toggle";
      };
      "trigger.notepad" = {
        icon = "edit_note";
        label = "Notepad";
        aliases = [ "notes" ];
        action = "dms ipc call notepad toggle";
      };
      "trigger.websearch" = {
        icon = "search";
        label = "Web Search";
        aliases = [
          "google"
          "search"
        ];
        action = "dms ipc call spotlight toggleQuery '@ '";
      };
      "trigger.toggle" = {
        icon = "toggle_on";
        label = "Toggle";
        aliases = [
          "toggle"
          "toggles"
        ];
      };
      "trigger.toggle.idle" = {
        icon = "coffee";
        label = "Stay Awake";
        aliases = [
          "caffeine"
          "inhibit"
        ];
        action = "dms ipc call inhibit toggle";
        checked = "dms ipc call inhibit status | grep -q enabled";
      };
      "trigger.toggle.night" = {
        icon = "nightlight";
        label = "Night Mode";
        aliases = [ "nightlight" ];
        action = "dms ipc call night toggle";
        checked = "dms ipc call night status | grep -q enabled";
      };
      "trigger.toggle.battery" = {
        icon = "battery_std";
        label = "Battery Percentage";
        action = "dms ipc call bar toggle";
        when = "test -d /sys/class/power_supply/BAT0";
      };
      "trigger.toggle.float" = {
        icon = "picture_in_picture_alt";
        label = "Float Window";
        aliases = [
          "float"
          "hover"
        ];
        action = "sleep 0.5 && mmsg dispatch togglefloating";
      };
      "trigger.toggle.maximize" = {
        icon = "open_in_full";
        label = "Maximize Window";
        action = "sleep 0.5 && mmsg dispatch togglemaximizescreen";
      };
      "trigger.toggle.floatall" = {
        icon = "picture_in_picture";
        label = "Float All Windows";
        aliases = [
          "floatall"
          "hoverall"
        ];
        action = "sleep 0.5 && mmsg dispatch toggle_all_floating";
      };
      "trigger.toggle.fullscreen" = {
        icon = "fullscreen";
        label = "Fullscreen Window";
        aliases = [
          "full"
          "screen"
        ];
        action = "sleep 0.5 && mmsg dispatch togglefullscreen";
      };
      "trigger.toggle.minimize" = {
        icon = "minimize";
        label = "Minimize Window";
        aliases = [
          "scratchpad"
          "hide"
        ];
        action = "sleep 0.5 && mmsg dispatch minimized";
      };
      "trigger.toggle.recover" = {
        icon = "settings_backup_restore";
        label = "Restore Minimized Window";
        aliases = [
          "restore"
          "recover"
        ];
        action = "sleep 0.5 && mmsg dispatch restore_minimized";
      };
      "setup.network" = {
        icon = "wifi";
        label = "Network";
        aliases = [
          "wifi"
          "wlan"
        ];
        action = "nm-connection-editor";
      };
      "setup.control-center" = {
        icon = "tune";
        label = "Control Center";
        aliases = [
          "audio"
          "bluetooth"
        ];
        action = "dms ipc call control-center toggle";
      };
      "setup.rebuild" = {
        icon = "restart_alt";
        label = "Rebuild System";
        action = "ghostty -e zsh -c sudo nixos-rebuild switch --flake $OJUNY_REPO_PATH#$(hostname)";
        title = "Rebuild System";
      };
      "setup.dev-link" = {
        icon = "science";
        label = "Test Rebuild (Development)";
        aliases = [
          "test"
          "dev"
        ];
        action = "ghostty -e zsh -c sudo nixos-rebuild test --flake $OJUNY_REPO_PATH#$(hostname)";
        title = "Test Rebuild (Development)";
      };
      "system.lock" = {
        icon = "lock";
        label = "Lock";
        action = "loginctl lock-session";
      };
      "system.suspend" = {
        icon = "bedtime";
        label = "Suspend";
        action = "systemctl suspend";
      };
      "system.logout" = {
        icon = "logout";
        label = "Logout";
        action = "loginctl terminate-session \"$XDG_SESSION_ID\"";
      };
      "system.reboot" = {
        icon = "restart_alt";
        label = "Reboot";
        action = "systemctl reboot";
      };
      "system.shutdown" = {
        icon = "power_settings_new";
        label = "Shutdown";
        action = "systemctl poweroff";
      };
      "setup.settings-menu" = {
        icon = "settings";
        label = "System Settings";
        action = "nix-settings-gui";
      };
    };

    # @option widget = "raw"; label = "Extra plugin settings"; group = "Menu"; rows = 6; groupOrder = 20; order = 20; description = "Raw settings passed through to menu plugins.";
    desktop.ojuny.dankMenu.settings = { };

  };

}

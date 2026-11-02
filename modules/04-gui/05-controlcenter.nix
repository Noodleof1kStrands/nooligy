/*
  @menu
  displayname = "Control center";
  icon = "preferences-system-symbolic";
  order = 50;
  description = "Control center widgets and layout";
  category = "04-GUI";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-controlcenter = { config, pkgs, ... }: {

    # @option widget = "grid-configuration"; label = "Widget layout"; group = "Widgets"; groupOrder = 10; order = 10; gridColumns = 8;
    desktop.ojuny.dux.controlCenterWidgets = {
      user = {
        enabled = true;
        _order = 10;
        col = 0;
        row = 0;
        w = 4;
        h = 1;
        # @option widget = "dropdown"; label = "User shape"; group = "Widgets"; groupOrder = 10; order = 20; choices = [ "circle" "cookie4" "cookie7" "cookie12" "clover4" "clover8" "sunny" "pentagon" "arch" "slanted" "gem" "square" ]; description = "Avatar shape on the user tile.";
        shape = "circle";
      };
      battery = {
        enabled = true;
        _order = 20;
        col = 4;
        row = 0;
        w = 1;
        h = 1;
        # @option widget = "dropdown"; label = "Battery style"; group = "Widgets"; groupOrder = 10; order = 21; choices = [ "icon" "solid" "outline" "ring" "duo" ]; description = "Battery tile gauge style.";
        batteryStyle = "icon";
        # @option widget = "dropdown"; label = "Battery color"; group = "Widgets"; groupOrder = 10; order = 22; choices = [ "level" "theme" ]; description = "level colors the gauge by charge level, theme uses the accent color.";
        batteryColorMode = "level";
      };
      lock = {
        enabled = true;
        _order = 30;
        col = 6;
        row = 0;
        w = 1;
        h = 1;
        small = true;
      };
      power = {
        enabled = true;
        _order = 40;
        col = 7;
        row = 0;
        w = 1;
        h = 1;
        small = true;
      };
      brightnessSlider = {
        enabled = true;
        _order = 60;
        col = 0;
        row = 1;
        w = 1;
        h = 5;
      };
      volumeSlider = {
        enabled = true;
        _order = 70;
        col = 1;
        row = 1;
        w = 1;
        h = 5;
      };
      inputVolumeSlider = {
        enabled = true;
        _order = 80;
        col = 2;
        row = 1;
        w = 1;
        h = 5;
      };
      wifi = {
        enabled = true;
        _order = 90;
        col = 3;
        row = 1;
        w = 5;
        h = 1;
      };
      bluetooth = {
        enabled = true;
        _order = 100;
        col = 3;
        row = 2;
        w = 5;
        h = 1;
      };
      builtin_vpn = {
        enabled = true;
        _order = 110;
        col = 3;
        row = 3;
        w = 5;
        h = 1;
      };
      plugin_dankKDEConnect = {
        enabled = true;
        _order = 120;
        col = 3;
        row = 4;
        w = 5;
        h = 1;
      };
      diskUsage = {
        enabled = true;
        _order = 130;
        col = 3;
        row = 5;
        w = 5;
        h = 1;
        # @option widget = "text"; label = "Mount"; group = "Widgets"; groupOrder = 10; order = 23; description = "Filesystem path to report.";
        mountPath = "/";
      };
      quickTiles = {
        enabled = true;
        _order = 140;
        col = 0;
        row = 6;
        w = 8;
        h = 1;
        small = true;
        instanceId = "quickTiles";
      };
      idleInhibitor = {
        enabled = true;
        _order = 150;
        w = 1;
        h = 1;
        small = true;
        group = "quickTiles";
      };
      nightMode = {
        enabled = true;
        _order = 160;
        w = 1;
        h = 1;
        small = false;
        group = "quickTiles";
      };
      doNotDisturb = {
        enabled = true;
        _order = 170;
        w = 1;
        h = 1;
        small = true;
        group = "quickTiles";
      };
      runningApps = {
        enabled = true;
        _order = 180;
        w = 4;
        h = 1;
        small = true;
        group = "quickTiles";
      };
      # The edit action is part of the saved layout but the GUI keeps it locked,
      # hidden and permanently disabled so it cannot be removed or rearranged.
      edit = {
        enabled = false;
        _order = 190;
        w = 1;
        h = 1;
        small = true;
        group = "quickTiles";
      };
    };

  };

}

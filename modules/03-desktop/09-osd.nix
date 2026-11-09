/*
  @menu
  displayname = "On-screen display";
  icon = "video-display-symbolic";
  order = 90;
  description = "On-screen display popups";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-osd = { config, lib, pkgs, ... }:
    let
      positions = {
        "top-left" = 2;
        "top-center" = 4;
        "top-right" = 0;
        "left-center" = 6;
        "right-center" = 7;
        "bottom-left" = 1;
        "bottom-center" = 5;
        "bottom-right" = 3;
      };
    in
    {

    options.ojuny.dux.osdPosition = lib.mkOption {
      type = lib.types.enum (lib.attrNames positions);
      default = "bottom-center";
      description = "On-screen display position.";
    };

    config = {

    # @option widget = "dropdown"; label = "Position"; group = "General"; groupOrder = 10; order = 10; choices = [ "top-left" "top-center" "top-right" "left-center" "right-center" "bottom-left" "bottom-center" "bottom-right" ];
    ojuny.dux.osdPosition = "bottom-center";

    desktop.ojuny.dux.settings.osdPosition = positions.${config.ojuny.dux.osdPosition};

    # @option widget = "switch"; label = "Always show percentage"; group = "General"; groupOrder = 10; order = 20; description = "Keep the on-screen volume and brightness readout visible.";
    desktop.ojuny.dux.settings.osdAlwaysShowValue = true;

    # @option widget = "switch"; label = "Volume"; group = "Events"; groupOrder = 20; order = 10; applyCommand = "dms ipc call settings set osdVolumeEnabled %%val%%";
    desktop.ojuny.dux.settings.osdVolumeEnabled = true;

    # @option widget = "switch"; label = "Media volume"; group = "Events"; groupOrder = 20; order = 20; applyCommand = "dms ipc call settings set osdMediaVolumeEnabled %%val%%";
    desktop.ojuny.dux.settings.osdMediaVolumeEnabled = true;

    # @option widget = "switch"; label = "Media playback"; group = "Events"; groupOrder = 20; order = 30; applyCommand = "dms ipc call settings set osdMediaPlaybackEnabled %%val%%";
    desktop.ojuny.dux.settings.osdMediaPlaybackEnabled = false;

    # @option widget = "switch"; label = "Brightness"; group = "Events"; groupOrder = 20; order = 40;
    desktop.ojuny.dux.settings.osdBrightnessEnabled = true;

    # @option widget = "switch"; label = "Idle inhibitor"; group = "Events"; groupOrder = 20; order = 50; applyCommand = "dms ipc call settings set osdIdleInhibitorEnabled %%val%%";
    desktop.ojuny.dux.settings.osdIdleInhibitorEnabled = true;

    # @option widget = "switch"; label = "Microphone mute"; group = "Events"; groupOrder = 20; order = 60; applyCommand = "dms ipc call settings set osdMicMuteEnabled %%val%%";
    desktop.ojuny.dux.settings.osdMicMuteEnabled = true;

    # @option widget = "switch"; label = "Microphone volume"; group = "Events"; groupOrder = 20; order = 70; applyCommand = "dms ipc call settings set osdMicVolumeEnabled %%val%%";
    desktop.ojuny.dux.settings.osdMicVolumeEnabled = true;

    # @option widget = "switch"; label = "Caps lock"; group = "Events"; groupOrder = 20; order = 80; applyCommand = "dms ipc call settings set osdCapsLockEnabled %%val%%";
    desktop.ojuny.dux.settings.osdCapsLockEnabled = true;

    # @option widget = "switch"; label = "Touchpad"; group = "Events"; groupOrder = 20; order = 90; description = "Niri only."; applyCommand = "dms ipc call settings set osdTouchpadEnabled %%val%%";
    desktop.ojuny.dux.settings.osdTouchpadEnabled = true;

    # @option widget = "switch"; label = "Power profile"; group = "Events"; groupOrder = 20; order = 100; applyCommand = "dms ipc call settings set osdPowerProfileEnabled %%val%%";
    desktop.ojuny.dux.settings.osdPowerProfileEnabled = false;

    # @option widget = "switch"; label = "Audio output switch"; group = "Events"; groupOrder = 20; order = 110; applyCommand = "dms ipc call settings set osdAudioOutputEnabled %%val%%";
    desktop.ojuny.dux.settings.osdAudioOutputEnabled = true;

    # @option widget = "switch"; label = "Workspace switch"; group = "Events"; groupOrder = 20; order = 120; applyCommand = "dms ipc call settings set osdWorkspaceEnabled %%val%%";
    desktop.ojuny.dux.settings.osdWorkspaceEnabled = false;

    };
  };

}

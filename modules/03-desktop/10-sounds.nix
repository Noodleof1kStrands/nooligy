/*
  @menu
  displayname = "Sounds";
  icon = "preferences-desktop-sound-symbolic";
  order = 100;
  description = "System sound effects";
  category = "03-Desktop";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.desktop-sounds = { config, pkgs, ... }: {

    # @option widget = "switch"; label = "System sounds"; group = "Sounds"; groupOrder = 10; order = 10;
    desktop.ojuny.dux.settings.soundsEnabled = true;

    # @option widget = "switch"; label = "Use system sound theme"; group = "Sounds"; groupOrder = 10; order = 20; visibleWhen.path = "desktop.ojuny.dux.settings.soundsEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set useSystemSoundTheme %%val%%";
    desktop.ojuny.dux.settings.useSystemSoundTheme = false;

    # @option widget = "switch"; label = "Login"; group = "Sounds"; groupOrder = 10; order = 30; visibleWhen.path = "desktop.ojuny.dux.settings.soundsEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set soundLogin %%val%%";
    desktop.ojuny.dux.settings.soundLogin = false;

    # @option widget = "switch"; label = "New notification"; group = "Sounds"; groupOrder = 10; order = 40; visibleWhen.path = "desktop.ojuny.dux.settings.soundsEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set soundNewNotification %%val%%";
    desktop.ojuny.dux.settings.soundNewNotification = true;

    # @option widget = "switch"; label = "Volume changed"; group = "Sounds"; groupOrder = 10; order = 50; visibleWhen.path = "desktop.ojuny.dux.settings.soundsEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set soundVolumeChanged %%val%%";
    desktop.ojuny.dux.settings.soundVolumeChanged = true;

    # @option widget = "switch"; label = "Plugged in"; group = "Sounds"; groupOrder = 10; order = 60; description = "Needs a battery."; visibleWhen.path = "desktop.ojuny.dux.settings.soundsEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set soundPluggedIn %%val%%";
    desktop.ojuny.dux.settings.soundPluggedIn = true;

    # @option widget = "switch"; label = "Mute during media playback"; group = "Sounds"; groupOrder = 10; order = 70; visibleWhen.path = "desktop.ojuny.dux.settings.soundsEnabled"; visibleWhen.equals = true; applyCommand = "dms ipc call settings set muteSoundsWhenMediaPlaying %%val%%";
    desktop.ojuny.dux.settings.muteSoundsWhenMediaPlaying = true;

    # @option widget = "switch"; label = "Show virtual devices"; group = "Advanced audio"; groupOrder = 20; order = 20; advanced = true; applyCommand = "dms ipc call settings set audioShowStreamDevices %%val%%";
    desktop.ojuny.dux.settings.audioShowStreamDevices = false;

    # @option widget = "switch"; label = "Audio visualizer"; group = "Advanced audio"; groupOrder = 20; order = 30; advanced = true; applyCommand = "dms ipc call settings set audioVisualizerEnabled %%val%%";
    desktop.ojuny.dux.settings.audioVisualizerEnabled = true;

    # @option widget = "spin"; label = "Volume step"; group = "Advanced audio"; groupOrder = 20; order = 40; min = 0; max = 99; advanced = true; description = "Wheel scroll volume increment.";
    desktop.ojuny.dux.settings.audioWheelScrollAmount = 5;

    # @option widget = "raw"; label = "Lyrics providers"; group = "Media"; groupOrder = 30; order = 10; rows = 10; description = "Lyrics providers with id and enabled. Sends the track, artist and album to the enabled providers.";
    desktop.ojuny.dux.settings.mediaLyricsProviders = [
      {
        id = "betterlyrics";
        enabled = true;
      }
      {
        id = "unison";
        enabled = true;
      }
      {
        id = "lyricsplus";
        enabled = true;
      }
      {
        id = "kugou";
        enabled = true;
      }
      {
        id = "lrclib";
        enabled = true;
      }
      {
        id = "youtubemusic";
        enabled = true;
      }
    ];

    # @option widget = "switch"; label = "Scroll long titles"; group = "Media"; groupOrder = 30; order = 20; description = "Scroll media titles and labels that do not fit instead of eliding them."; applyCommand = "dms ipc call settings set scrollTitleEnabled %%val%%";
    desktop.ojuny.dux.settings.scrollTitleEnabled = true;

  };

}

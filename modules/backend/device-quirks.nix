{ ... }: {

  flake.modules.nixos.ojuny-asus-expertbook-b9406 =
    { lib, ... }:
    {
      boot.kernelParams = [
        "xe.enable_panel_replay=0"
        "xe.enable_dpcd_backlight=1"
      ];

      environment.etc."libinput/local-overrides.quirks".text = ''
        [ASUS ExpertBook B9406 Touchpad]
        MatchBus=i2c
        MatchUdevType=touchpad
        MatchVendor=0x093A
        MatchProduct=0x4F05
        MatchDMIModalias=dmi:*svnASUS*:pn*B9406*
        AttrEventCode=-ABS_MT_PRESSURE;-ABS_PRESSURE;
      '';
    };

  flake.modules.nixos.ojuny-asus-rog-z13-gz302 =
    { ... }:
    {
      services.udev.extraRules = ''
        ACTION=="add|change", KERNEL=="event*", ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="1a30", ENV{ID_INPUT_TOUCHPAD}=="1", ENV{ID_INPUT_TOUCHPAD_INTEGRATION}="internal"
      '';
    };

  flake.modules.nixos.ojuny-asus-zenbook-ux5406aa =
    { ... }:
    {
      boot.kernelParams = [ "xe.enable_dpcd_backlight=1" ];
    };

  flake.modules.nixos.ojuny-lenovo-yoga-pro-7-14iah10 =
    { ... }:
    {
      boot.extraModprobeConfig = ''
        options snd-sof-intel-hda-generic hda_model=alc287-yoga9-bass-spk-pin
      '';
    };

}

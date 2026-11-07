{ self, ... }: {

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

}

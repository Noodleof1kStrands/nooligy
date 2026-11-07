{ self, ... }: {

  flake.modules.nixos.ojuny-asus-zenbook-ux5406aa =
    { ... }:
    {
      boot.kernelParams = [ "xe.enable_dpcd_backlight=1" ];
    };

}

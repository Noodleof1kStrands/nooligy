{ lib, ... }: {

  flake.modules.nixos.system-bootloader-limits = {
    boot.loader.systemd-boot.configurationLimit = lib.mkDefault 50;
  };

}

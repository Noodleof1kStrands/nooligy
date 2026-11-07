{ self, ... }: {

  flake.modules.nixos.ojuny-lenovo-yoga-pro-7-14iah10 =
    { ... }:
    {
      boot.extraModprobeConfig = ''
        options snd-sof-intel-hda-generic hda_model=alc287-yoga9-bass-spk-pin
      '';
    };

}

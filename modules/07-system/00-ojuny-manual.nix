{ inputs, ... }: {

  flake.modules.nixos.system-ojuny-manual = { pkgs, ... }: {

    environment.systemPackages = [
      inputs.ojuny-manual.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  };

}

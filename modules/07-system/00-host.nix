{ self, inputs, ... }: {

  flake.nixosConfigurations.ojuny = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.host-imports
      ({ lib, ... }: {
        services.simple-nix-update-gui.flakeUri = lib.mkDefault "git+https://github.com/OWNER/REPO?dir=HOST";
      })
    ];
  };

  flake.nixosConfigurations.fixture = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.modules.nixos.host-imports
      ({ lib, ... }: {
        services.simple-nix-update-gui.flakeUri = lib.mkDefault "path:.";
        networking.hostName = lib.mkDefault "ojuny-fixture";
        fileSystems = lib.mkForce {
          "/" = {
            device = "/dev/vda1";
            fsType = "ext4";
          };
          "/boot" = {
            device = "/dev/vda2";
            fsType = "vfat";
            options = [ "fmask=0077" "dmask=0077" ];
          };
        };
        swapDevices = lib.mkForce [ ];
        boot.initrd.availableKernelModules = [
          "virtio_pci"
          "virtio_blk"
          "virtio_net"
          "virtio_console"
        ];
        users.mutableUsers = lib.mkForce true;
        users.users.user.hashedPassword = lib.mkForce null;
        users.users.user.initialPassword = lib.mkForce "fixture";
      })
    ];
  };

}

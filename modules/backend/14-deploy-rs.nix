{ self, inputs, ... }:

{
  flake.modules.nixos.system-deploy-rs =
    { config, lib, pkgs, ... }:
    {
      config = lib.mkIf config.ojuny.network.deploy-rs.enable {
        environment.systemPackages = [
          inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.disko
          inputs.deploy-rs.packages.${pkgs.stdenv.hostPlatform.system}.default
          inputs.nixos-anywhere.packages.${pkgs.stdenv.hostPlatform.system}.default
          pkgs.git
          pkgs.openssh
        ];

        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "prohibit-password";
            PasswordAuthentication = false;
          };
        };

        networking.firewall.allowedTCPPorts = lib.mkAfter [ 22 ];
      };
    };
}

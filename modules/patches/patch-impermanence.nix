/*
  @menu
  displayname = "Impermanence";
  icon = "drive-harddisk-symbolic";
  order = 90;
  description = "Ephemeral root with persisted paths";
  category = "Patches";
  systems = [ "all" ];
*/

{ self, inputs, ... }:

{
  flake.modules.nixos.patch-impermanence =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.ojuny.patch.impermanence;
    in
    {
      options.ojuny.patch.impermanence = {
        enable = lib.mkEnableOption "the impermanence patch";
        persistPath = lib.mkOption {
          type = lib.types.str;
          default = "/persist";
          description = "Mount point that contains the persisted paths.";
        };
      };

      imports = [ inputs.impermanence.nixosModules.impermanence ];

      config = lib.mkIf cfg.enable {
        environment.persistence.${cfg.persistPath}.hideMounts = true;
      };
    };

}

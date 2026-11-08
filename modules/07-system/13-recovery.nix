/*
  @menu
  displayname = "Recovery";
  icon = "system-reboot-symbolic";
  order = 86;
  description = "Optional recovery UKI firmware entry";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-recovery =
    { lib, ... }:
    {
      options.ojuny.recovery.enable = lib.mkEnableOption "the recovery UKI";

      config = {
        # @option widget = "switch"; label = "Enable recovery UKI"; group = "Recovery"; groupOrder = 10; order = 10; description = "Build a signed recovery UKI and add an Ojuny Recovery firmware entry. It boots the installed system without systemd-boot or rEFInd.";
        ojuny.recovery.enable = true;
      };
    };

}

/*
  @menu
  displayname = "Multiboot";
  icon = "system-reboot-symbolic";
  order = 85;
  description = "Optional rEFInd helper for other operating systems";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-multiboot =
    { lib, ... }:
    {
      options.ojuny.multiboot.enable = lib.mkEnableOption "the rEFInd multiboot helper";

      config = {
        # @option widget = "switch"; label = "Other systems"; group = "Multiboot"; groupOrder = 10; order = 10; description = "Install a rEFInd helper on the boot partition and add an Other systems entry. The helper scans internal drives at every boot. Off by default. The installer enables it when another internal system is found.";
        ojuny.multiboot.enable = false;
      };
    };

}

{ self, ... }:

{
  flake.modules.nixos.system-overflow-layout =
    { config, lib, pkgs, ... }:
    let
      cfg = config.ojuny.workspaces.overflow;
      overflowLayout = pkgs.writeShellApplication {
        name = "ojuny-overflow-layout";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.jq
        ];
        text = builtins.readFile ./overflow-layout.sh;
      };
    in
    {
      config = lib.mkIf (cfg.windowCount > 0) {
        desktop.ojuny.mango.execOnce = [
          "${overflowLayout}/bin/ojuny-overflow-layout ${toString cfg.windowCount} ${cfg.layout}"
        ];
      };
    };
}

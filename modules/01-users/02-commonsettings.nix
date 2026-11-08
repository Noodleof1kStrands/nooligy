/*
  @menu
  displayname = "Common settings";
  icon = "emblem-system-symbolic";
  order = 20;
  description = "Defaults every user account inherits";
  category = "01-Users";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.users-commonsettings = { config, lib, pkgs, ... }:
    let
      backupScript = pkgs.writeShellApplication {
        name = "ojuny-home-manager-backup";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          if [ "$#" -ne 1 ]; then
            echo "usage: ojuny-home-manager-backup FILE" >&2
            exit 2
          fi
          target="$1"
          rm -f -- "$target"-* "$target".bck-old-file
          mv -- "$target" "$target-$(date +%Y%m%d-%H%M%S)-$RANDOM"
        '';
      };
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      options.ojuny.backup = {
        enable = lib.mkEnableOption "timestamped Home Manager backups";
      };

      config = {
        home-manager.useGlobalPkgs = true;

        home-manager.useUserPackages = true;

        # @option widget = "switch"; label = "Timestamped Home Manager backups"; group = "Home Manager"; description = "Before Home Manager replaces an existing file, remove older timestamped backups and move the current file aside with a timestamp and random suffix.";
        ojuny.backup.enable = true;

        home-manager.backupCommand = lib.mkIf config.ojuny.backup.enable backupScript;

        # @option widget = "switch"; label = "Mutable users"; group = "Accounts"; description = "Allow passwords and other account details to be changed at runtime.";
        users.mutableUsers = false;

        # Shell configuration and aliases live on the Terminal page.
      };
    };

}

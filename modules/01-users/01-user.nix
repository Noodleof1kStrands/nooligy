/*
  @menu
  displayname = "Users";
  icon = "avatar-default-symbolic";
  order = 10;
  description = "User Accounts";
  category = "01-Users";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.users = { pkgs, ... }: {

    imports = [ inputs.home-manager.nixosModules.home-manager ];

    config = {
      # The editor default is global and set by the shared Home Manager module.
      # To override it for one account, put
      #   home.sessionVariables.EDITOR = "<editor>";
      # in that account's "Extra home-manager options" field. It overrides the
      # shared default for that account only and survives a rebuild.
      # @option widget = "users"; label = "Accounts"; homeManager = true; description = "Accounts and their home-manager settings. The editor default is global. To override EDITOR for one account, put home.sessionVariables.EDITOR = \"<editor>\"; in that account's Extra home-manager options field.";
      users.users = {
        user = {
          isNormalUser = true;
          uid = 1000;
          description = "Primary account";
          extraGroups = [
            "networkmanager"
            "wheel"
            "video"
            "input"
          ];
          hashedPassword = "$y$j9T$E8EmnxzkCLsphRMZbqKW/1$estItGAST4R1l5OTZaSUJLWUYvlAEGVLRTGar5d0osC";
          openssh.authorizedKeys.keys = [ ];
          shell = pkgs.zsh;
        };
      };

      home-manager.users = {
        user = {
          home.stateVersion = "26.11";
        };
      };

      # scripts/setup.sh fills in the home wiring for this account, e.g.
      # home-manager.users.user.imports = [ ... ];
    };

  };

}

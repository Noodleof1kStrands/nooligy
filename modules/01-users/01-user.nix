/* @menu
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
      /* @option widget = "users"; label = "Accounts"; homeManager = true; */
      users.users = {
        noodle = {
          isNormalUser = true;
          uid = 1000;
          description = "Riley";
          extraGroups = [ "networkmanager" "wheel" "video" "input" ];
          hashedPassword = "$y$j9T$uMPyv7ywlGKFI6iyndQ2b0$HdGzXskpY5fx3VnB2uIIxIrTX0t9hW4Ta5I4Randzy7";
          openssh.authorizedKeys.keys = [ ];
          shell = pkgs.zsh;
        };
      };

      home-manager.users = {
        noodle = {
          home.stateVersion = "26.11";
        };
      };
    };

  };

}

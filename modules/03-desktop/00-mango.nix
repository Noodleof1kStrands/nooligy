{ self, inputs, ... }: {

  flake.modules.nixos.desktop-mango = { config, pkgs, ... }: {

    imports = [ inputs.ojuny-desktop.nixosModules.default ];

    # The single switch that pulls in mangoWM + Dux Modular Shell as the
    # session. Deliberately not a menu page; every other Desktop page only
    # takes effect while this is on.
    desktop.ojuny.enable = true;

    xdg.portal.config.common.default = "*";
  };

}

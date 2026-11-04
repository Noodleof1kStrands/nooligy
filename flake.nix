{
  description = "Ojuny template - a NixOS config edited through nix-settings-gui";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:vic/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ojuny-desktop = {
      url = "github:ojuny-project/ojuny-desktop";
      inputs.flake-parts.follows = "flake-parts";
      inputs.home-manager.follows = "home-manager";
      inputs.stylix.follows = "stylix";
    };

    dux-greeter = {
      url = "github:duxlabs-dev/dux-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-settings-gui = {
      url = "github:ojuny-project/nix-settings-gui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-regedit = {
      url = "github:ojuny-project/nix-regedit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-shell-gui = {
      url = "github:ojuny-project/nix-shell-gui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-nix-update-gui = {
      url = "github:ojuny-project/simple-nix-update-gui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    craftapps = {
      url = "github:olafkfreund/nix-craftapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chromium-webapps = {
      url = "github:chobbledotcom/nix-chromium-webapps";
    };

    firefox-addons = {
      url = "git+https://gitlab.com/rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ojuny-cli = {
      url = "github:ojuny-project/ojuny-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ojuny-manual = {
      url = "github:ojuny-project/ojuny-manual";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ojuny-cli-binary = {
      url = "tarball+https://github.com/ojuny-project/ojuny-cli/releases/download/v0.1.0-hotfix-1/ojuny-cli-flake.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ojuny-manual-binary = {
      url = "tarball+https://github.com/ojuny-project/ojuny-manual/releases/download/v0.1.0-hotfix-1/ojuny-manual-flake.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cleaner-binary = {
      url = "tarball+https://github.com/ojuny-project/nix-cleaner/releases/download/v0.1.0-hotfix-1/nix-cleaner-flake.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cache-discovery-binary = {
      url = "tarball+https://github.com/ojuny-project/nix-cache-discovery/releases/download/v0.1.0-hotfix-1/nix-cache-discovery-flake.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-regedit-binary = {
      url = "tarball+https://github.com/ojuny-project/nix-regedit/releases/download/v0.1.0-hotfix-4/nix-regedit-flake.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-settings-gui-binary = {
      url = "tarball+https://github.com/ojuny-project/nix-settings-gui/releases/download/v0.1.0-hotfix-1/nix-settings-gui-flake.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-shell-gui-binary = {
      url = "tarball+https://github.com/ojuny-project/nix-shell-gui/releases/download/v0.1.0-hotfix-1/nix-shell-gui-flake.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-nix-update-gui-binary = {
      url = "tarball+https://github.com/ojuny-project/simple-nix-update-gui/releases/download/v0.1.0-hotfix-1/simple-nix-update-gui-flake.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cache-discovery = {
      url = "github:ojuny-project/nix-cache-discovery";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cleaner = {
      url = "github:ojuny-project/nix-cleaner";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-anywhere = {
      url = "github:numtide/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (inputs.import-tree ./modules)
        inputs.flake-parts.flakeModules.modules
        inputs.home-manager.flakeModules.home-manager
      ];

      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, system, ... }:
        let
          prepare-repo = pkgs.writeShellApplication {
            name = "prepare-repo";
            runtimeInputs = [ pkgs.python3 ];
            text = ''
              exec python3 ${./scripts/prepare-repo.py} "$@"
            '';
          };

          regenerate-hardware = pkgs.writeShellApplication {
            name = "regenerate-hardware";
            runtimeInputs = [
              pkgs.python3
              pkgs.nixos-install-tools
              pkgs.nixos-facter
              pkgs.util-linux
              pkgs.coreutils
              pkgs.gnused
              pkgs.gnugrep
            ];
            text = ''
              exec python3 ${./scripts/regenerate-hardware.py} "$@"
            '';
          };
        in
        {
          packages = {
            inherit prepare-repo regenerate-hardware;

            nix-settings-gui = inputs.nix-settings-gui.packages.${system}.default;
            nix-regedit = inputs.nix-regedit.packages.${system}.default;
            nix-shell-gui = inputs.nix-shell-gui.packages.${system}.default;
            nix-cache-discovery = inputs.nix-cache-discovery.packages.${system}.default;
            nix-cleaner = inputs.nix-cleaner.packages.${system}.default;
            simple-nix-update-gui = inputs.simple-nix-update-gui.packages.${system}.default;
            simple-nix-update-gui-daemon = inputs.simple-nix-update-gui.packages.${system}.daemon;
            mango = inputs.ojuny-desktop.inputs.mangowm.packages.${system}.mango;
            dux = inputs.ojuny-desktop.inputs.dux-shell.packages.${system}.default;
            dms-greeter = inputs.dux-greeter.packages.${system}.dms-greeter;
            ojuny-cli = inputs.ojuny-cli.packages.${system}.ojuny-cli;
            ojuny-patches-cli = inputs.ojuny-cli.packages.${system}.ojuny-patches-cli;
            ojuny-manual = inputs.ojuny-manual.packages.${system}.default;
          };

          apps.prepare-repo = {
            type = "app";
            program = "${prepare-repo}/bin/prepare-repo";
          };

          apps.regenerate-hardware = {
            type = "app";
            program = "${regenerate-hardware}/bin/regenerate-hardware";
          };

          apps.remote-setup = {
            type = "app";
            program = "${
              pkgs.writeShellApplication {
                name = "remote-setup";
                runtimeInputs = [
                  pkgs.coreutils
                  pkgs.git
                  pkgs.openssh
                  pkgs.nix
                  inputs.deploy-rs.packages.${system}.default
                ];
                text = ''
                  export OJUNY_TEMPLATE_SOURCE="${inputs.self}"
                  export OJUNY_DEPLOY_RS="${inputs.deploy-rs.packages.${system}.default}/bin/deploy"
                  ${builtins.readFile ./scripts/remote-setup.sh}
                '';
              }
            }/bin/remote-setup";
          };

          apps.prepare-remote-repository = {
            type = "app";
            program = "${
              pkgs.writeShellApplication {
                name = "prepare-remote-repository";
                runtimeInputs = [
                  pkgs.coreutils
                  pkgs.git
                  pkgs.gnused
                  pkgs.mkpasswd
                  pkgs.nix
                ];
                text = ''
                  export OJUNY_TEMPLATE_SOURCE="${inputs.self}"
                  ${builtins.readFile ./scripts/prepare-remote-repository.sh}
                '';
              }
            }/bin/prepare-remote-repository";
          };

          apps.remote-install = {
            type = "app";
            program = "${
              pkgs.writeShellApplication {
                name = "remote-install";
                runtimeInputs = [
                  pkgs.coreutils
                  pkgs.git
                  pkgs.gnused
                  pkgs.nix
                  pkgs.openssh
                  inputs.disko.packages.${system}.disko
                  inputs.nixos-anywhere.packages.${system}.default
                ];
                text = ''
                  export OJUNY_TEMPLATE_SOURCE="${inputs.self}"
                  export OJUNY_DISKO="${inputs.disko.packages.${system}.disko}/bin/disko"
                  export OJUNY_NIXOS_ANYWHERE="${inputs.nixos-anywhere.packages.${system}.default}/bin/nixos-anywhere"
                  ${builtins.readFile ./scripts/remote-install.sh}
                '';
              }
            }/bin/remote-install";
          };

          apps.setup = {
            type = "app";
            program = "${
              pkgs.writeShellApplication {
                name = "setup";
                runtimeInputs = [
                  pkgs.nixos-install-tools
                  pkgs.nixos-rebuild
                  pkgs.mkpasswd
                  pkgs.nix
                  pkgs.git
                  pkgs.coreutils
                  pkgs.gnused
                  (pkgs.writeShellApplication {
                    name = "generate-hw";
                    runtimeInputs = [
                      pkgs.nixos-install-tools
                      pkgs.nixos-facter
                      pkgs.coreutils
                      pkgs.gnused
                      pkgs.gnugrep
                      pkgs.util-linux
                    ];
                    text = builtins.readFile ./scripts/generate-hw.sh;
                  })
                  (pkgs.writeShellApplication {
                    name = "generate-user";
                    runtimeInputs = [
                      pkgs.mkpasswd
                      pkgs.coreutils
                    ];
                    text = builtins.readFile ./scripts/generate-user.sh;
                  })
                  (pkgs.writeShellApplication {
                    name = "create-new-system";
                    runtimeInputs = [
                      pkgs.gnused
                      pkgs.coreutils
                    ];
                    text = builtins.readFile ./scripts/create-new-system.sh;
                  })
                ];
                text = builtins.readFile ./scripts/setup.sh;
              }
            }/bin/setup";
          };
          checks.hardware-profile =
            let
              source = pkgs.lib.cleanSource ./.;
            in
            pkgs.runCommand "check-hardware-profile"
              {
                nativeBuildInputs = [ pkgs.python3 ];
              }
              ''
                python3 ${./tests/check-hardware-profile.py} --root ${source}
                touch $out
              '';
        };

      flake = {
        nixosModules.default = inputs.ojuny-desktop.nixosModules.default;
        homeManagerModules.default = inputs.ojuny-desktop.homeManagerModules.default;

        deploy.nodes = builtins.mapAttrs (name: configuration: {
          hostname = name;
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos configuration;
          };
        }) self.nixosConfigurations;
      };
      # nixosConfigurations.<host> is registered by scripts/setup.sh, which also
      # writes modules/07-system/01-configuration.nix.
    };
}

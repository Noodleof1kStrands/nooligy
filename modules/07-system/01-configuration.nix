/*
  @menu
  displayname = "System";
  icon = "computer-symbolic";
  order = 10;
  description = "Hostname, locale, time, keyboard and package sources";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-configuration =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      userHome = user: user.home or null;
      primaryUser =
        if config.users.users ? user && userHome config.users.users.user != null then
          config.users.users.user
        else
          lib.findFirst (entry: userHome entry != null) null (lib.attrValues config.users.users);
      primaryHome = if primaryUser != null then userHome primaryUser else "/home/user";
      repoPathAbsolute =
        if lib.hasPrefix "/" config.ojuny.repoPath then
          config.ojuny.repoPath
        else
          "${primaryHome}/${config.ojuny.repoPath}";
      system = pkgs.stdenv.hostPlatform.system;
      binaryMode =
        name:
        if config.ojuny.binaries.${name} == "auto" then
          config.ojuny.binaries.mode
        else
          config.ojuny.binaries.${name};
      pick = name: source: binary: if binaryMode name == "binary" then binary else source;
    in
    {
      imports = [ self.modules.nixos.patches ];

      options.ojuny.patches = lib.mkEnableOption "automatic import of patch- modules placed in the repository";

      options.ojuny.time.auto = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set the time zone automatically from location.";
      };

      options.ojuny.repoPath = lib.mkOption {
        type = lib.types.str;
        default = "repos/nix-flake";
        description = "Path to the system flake, relative to the primary user's home or absolute.";
      };

      options.ojuny.i18n.extraLocaleSettings = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options.locale = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Locale value for this category.";
            };
          }
        );
        default = { };
        description = "Locale category overrides written to i18n.extraLocaleSettings.";
      };

      options.ojuny.binaries.mode = lib.mkOption {
        type = lib.types.enum [
          "source"
          "binary"
        ];
        default = "source";
        description = "Default package source for release tools. Source builds from the flake; binary downloads the release bundle.";
      };

      options.ojuny.binaries.cli = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "binary"
        ];
        default = "auto";
        description = "Package source for ojuny-cli and ojuny-patches-cli.";
      };

      options.ojuny.binaries.cleaner = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "binary"
        ];
        default = "auto";
        description = "Package source for nix-cleaner.";
      };

      options.ojuny.binaries.cacheDiscovery = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "binary"
        ];
        default = "auto";
        description = "Package source for nix-cache-discovery.";
      };

      options.ojuny.binaries.regedit = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "binary"
        ];
        default = "auto";
        description = "Package source for nix-regedit.";
      };

      options.ojuny.binaries.settingsGui = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "binary"
        ];
        default = "auto";
        description = "Package source for nix-settings-gui.";
      };

      options.ojuny.binaries.shellGui = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "binary"
        ];
        default = "auto";
        description = "Package source for nix-shell-gui.";
      };

      options.ojuny.binaries.simpleUpdateGui = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "binary"
        ];
        default = "auto";
        description = "Package source for simple-nix-update-gui and its daemon.";
      };

      options.ojuny.manual.source = lib.mkOption {
        type = lib.types.enum [
          "source"
          "binary"
        ];
        default = "source";
        description = "Package source for the offline manual. Defaults to source because the manual tracks the rolling repository.";
      };

      config = {

        # @option widget = "switch"; label = "Enable patches"; group = "Patches"; description = "Automatically import patch- modules placed in the repository.";
        ojuny.patches = true;

        programs.nix-cleaner.package = pick "cleaner"
          inputs.nix-cleaner.packages.${system}.default
          inputs.nix-cleaner-binary.packages.${system}.default;

        services.nix-cache-discovery.package = pick "cacheDiscovery"
          inputs.nix-cache-discovery.packages.${system}.default
          inputs.nix-cache-discovery-binary.packages.${system}.default;

        services.nix-regedit.package = pick "regedit"
          inputs.nix-regedit.packages.${system}.default
          inputs.nix-regedit-binary.packages.${system}.default;

        services.nix-settings-gui.package = pick "settingsGui"
          inputs.nix-settings-gui.packages.${system}.default
          inputs.nix-settings-gui-binary.packages.${system}.default;

        services.nix-shell-gui.package = pick "shellGui"
          inputs.nix-shell-gui.packages.${system}.default
          inputs.nix-shell-gui-binary.packages.${system}.default;

        services.simple-nix-update-gui.package = pick "simpleUpdateGui"
          inputs.simple-nix-update-gui.packages.${system}.default
          inputs.simple-nix-update-gui-binary.packages.${system}.simple-nix-update-gui;

        services.simple-nix-update-gui.daemonPackage = pick "simpleUpdateGui"
          inputs.simple-nix-update-gui.packages.${system}.daemon
          inputs.simple-nix-update-gui-binary.packages.${system}.simple-nix-update-gui-daemon;

        environment.systemPackages = [
          (pick "cli"
            inputs.ojuny-cli.packages.${system}.ojuny-cli
            inputs.ojuny-cli-binary.packages.${system}.ojuny-cli)
          (pick "cli"
            inputs.ojuny-cli.packages.${system}.ojuny-patches-cli
            inputs.ojuny-cli-binary.packages.${system}.ojuny-patches)
          (if config.ojuny.manual.source == "binary" then
            inputs.ojuny-manual-binary.packages.${system}.ojuny-manual
          else
            inputs.ojuny-manual.packages.${system}.default)
        ];

        # @option widget = "text"; label = "Repository path"; group = "Paths"; groupOrder = 50; order = 10; description = "Absolute path, or a path relative to the primary user's home.";
        ojuny.repoPath = "repos/nix-flake";

        # @option widget = "dropdown"; label = "Package source"; group = "Binaries"; groupOrder = 60; order = 10; choices = [ "source" "binary" ]; description = "Build release tools from the flake, or install the pinned release bundles. Source follows the flake lock.";
        ojuny.binaries.mode = "source";

        # @option widget = "dropdown"; label = "Command line"; group = "Binaries"; groupOrder = 60; order = 20; advanced = true; choices = [ "auto" "source" "binary" ]; description = "Override the package source for ojuny-cli and ojuny-patches-cli.";
        ojuny.binaries.cli = "auto";

        # @option widget = "dropdown"; label = "Nix cleaner"; group = "Binaries"; groupOrder = 60; order = 30; advanced = true; choices = [ "auto" "source" "binary" ]; description = "Override the package source for nix-cleaner.";
        ojuny.binaries.cleaner = "auto";

        # @option widget = "dropdown"; label = "Cache discovery"; group = "Binaries"; groupOrder = 60; order = 40; advanced = true; choices = [ "auto" "source" "binary" ]; description = "Override the package source for nix-cache-discovery.";
        ojuny.binaries.cacheDiscovery = "auto";

        # @option widget = "dropdown"; label = "Registry editor"; group = "Binaries"; groupOrder = 60; order = 50; advanced = true; choices = [ "auto" "source" "binary" ]; description = "Override the package source for nix-regedit.";
        ojuny.binaries.regedit = "auto";

        # @option widget = "dropdown"; label = "Settings GUI"; group = "Binaries"; groupOrder = 60; order = 60; advanced = true; choices = [ "auto" "source" "binary" ]; description = "Override the package source for nix-settings-gui.";
        ojuny.binaries.settingsGui = "auto";

        # @option widget = "dropdown"; label = "Shell GUI"; group = "Binaries"; groupOrder = 60; order = 70; advanced = true; choices = [ "auto" "source" "binary" ]; description = "Override the package source for nix-shell-gui.";
        ojuny.binaries.shellGui = "auto";

        # @option widget = "dropdown"; label = "Update GUI"; group = "Binaries"; groupOrder = 60; order = 80; advanced = true; choices = [ "auto" "source" "binary" ]; description = "Override the package source for simple-nix-update-gui and its daemon.";
        ojuny.binaries.simpleUpdateGui = "auto";

        # @option widget = "dropdown"; label = "Manual"; group = "Binaries"; groupOrder = 60; order = 90; choices = [ "source" "binary" ]; description = "Source builds the manual from the current repository. Binary installs the pinned offline release. Defaults to source.";
        ojuny.manual.source = "source";

        environment.variables = {
          OJUNY_REPO_PATH = repoPathAbsolute;
          OJUNY_FLAKE = repoPathAbsolute;
        };

        # @option widget = "text"; label = "Hostname"; group = "Identity"; applyCommand = "hostnamectl set-hostname %%val%%";
        networking.hostName = "ojuny";

        # @option widget = "switch"; label = "Automatic time zone"; group = "Time and locale"; groupOrder = 20; order = 5; description = "Use automatic-timezoned and geoclue2 to set the time zone from location.";
        ojuny.time.auto = false;

        # @option widget = "dropdown"; label = "Time zone"; group = "Time and locale"; description = "A name from the tz database."; choices = [ "Europe/Amsterdam" "Europe/London" "Europe/Berlin" "UTC" "America/New_York" "America/Los_Angeles" "Asia/Tokyo" "Asia/Shanghai" "Australia/Sydney" ]; applyCommand = "timedatectl set-timezone %%val%%"; visibleWhen.path = "ojuny.time.auto"; visibleWhen.equals = false;
        time.timeZone = "Europe/Amsterdam";

        services.automatic-timezoned.enable = config.ojuny.time.auto;
        services.geoclue2.enable = config.ojuny.time.auto;

        # @option widget = "dropdown"; label = "Default locale"; group = "Time and locale"; choices = [ "en_US.UTF-8" "en_GB.UTF-8" "de_DE.UTF-8" "nl_NL.UTF-8" "fr_FR.UTF-8" "es_ES.UTF-8" ]; applyCommand = "localectl set-locale LANG=%%val%%";
        i18n.defaultLocale = "en_US.UTF-8";

        # @option widget = "table-attrset"; label = "Extra locale settings"; group = "Time and locale"; advanced = true; columns = [ "locale" ]; columnTypes = [ "str" ]; keyEditable = true; description = "Per-category locale overrides, for example LC_TIME = nl_NL.UTF-8.";
        ojuny.i18n.extraLocaleSettings = { };

        # Derived from the table above; no @option.
        i18n.extraLocaleSettings = lib.mapAttrs (
          _: entry: entry.locale
        ) config.ojuny.i18n.extraLocaleSettings;

        # @option widget = "dropdown"; label = "Console keymap"; group = "Keyboard"; description = "Used on the TTY; the Wayland layout is on the Display page."; choices = [ "us" "uk" "de" "fr" "latam" "es" "nl" "dvorak" ]; applyCommand = "localectl set-keymap %%val%%";
        console.keyMap = "us";

        system.nixos.distroName = "Ojuny";
        system.nixos.distroId = "ojuny";

        # DO NOT CHANGE, this value is for the *initial* state and should not be changed.
        system.stateVersion = "25.05";

      };

    };

}

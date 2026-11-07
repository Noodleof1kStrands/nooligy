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
      toolMode =
        name:
        if config.ojuny.binaries.${name} == "auto" then
          config.ojuny.binaries.mode
        else
          config.ojuny.binaries.${name};
      toolTag =
        name:
        if config.ojuny.binaries.${name + "Tag"} != "" then
          config.ojuny.binaries.${name + "Tag"}
        else if config.ojuny.binaries.tag != "" then
          config.ojuny.binaries.tag
        else
          throw "ojuny.binaries.${name}Tag must name a release recorded in binary-url.json when ${name} uses tag mode";
      binaryPackage =
        name: repo: package:
        if toolMode name == "tag" then
          inputs.${repo}.lib.mkBinary {
            inherit system package;
            tag = toolTag name;
          }
        else
          inputs.${repo}.lib.mkBinary { inherit system package; };
      pick =
        name: source: repo: package:
        if toolMode name == "source" then source else binaryPackage name repo package;
      manualPackage =
        if config.ojuny.manual.source == "source" then
          inputs.ojuny-manual.packages.${system}.default
        else if config.ojuny.manual.source == "tag" then
          inputs.ojuny-manual.lib.mkBinary {
            inherit system;
            tag =
              if config.ojuny.manual.tag != "" then
                config.ojuny.manual.tag
              else
                throw "ojuny.manual.tag must name a release recorded in binary-url.json when ojuny.manual.source is tag";
          }
        else
          inputs.ojuny-manual.lib.mkBinary { inherit system; };
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
          "latest"
          "tag"
        ];
        default = "source";
        description = "Default package source for release tools. Source builds from the flake; latest downloads the newest bundle recorded in binary-url.json; tag downloads a named release from the same file.";
      };

      options.ojuny.binaries.tag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Fallback release tag for tag mode when a tool does not set its own.";
      };

      options.ojuny.binaries.cli = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "latest"
          "tag"
        ];
        default = "auto";
        description = "Package source for ojuny-cli and ojuny-patches-cli.";
      };

      options.ojuny.binaries.cliTag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Release tag for ojuny-cli and ojuny-patches-cli when its package source is tag.";
      };

      options.ojuny.binaries.cleaner = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "latest"
          "tag"
        ];
        default = "auto";
        description = "Package source for nix-cleaner.";
      };

      options.ojuny.binaries.cleanerTag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Release tag for nix-cleaner when its package source is tag.";
      };

      options.ojuny.binaries.cacheDiscovery = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "latest"
          "tag"
        ];
        default = "auto";
        description = "Package source for nix-cache-discovery.";
      };

      options.ojuny.binaries.cacheDiscoveryTag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Release tag for nix-cache-discovery when its package source is tag.";
      };

      options.ojuny.binaries.regedit = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "latest"
          "tag"
        ];
        default = "auto";
        description = "Package source for nix-regedit.";
      };

      options.ojuny.binaries.regeditTag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Release tag for nix-regedit when its package source is tag.";
      };

      options.ojuny.binaries.settingsGui = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "latest"
          "tag"
        ];
        default = "auto";
        description = "Package source for nix-settings-gui.";
      };

      options.ojuny.binaries.settingsGuiTag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Release tag for nix-settings-gui when its package source is tag.";
      };

      options.ojuny.binaries.shellGui = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "latest"
          "tag"
        ];
        default = "auto";
        description = "Package source for nix-shell-gui.";
      };

      options.ojuny.binaries.shellGuiTag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Release tag for nix-shell-gui when its package source is tag.";
      };

      options.ojuny.binaries.simpleUpdateGui = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "source"
          "latest"
          "tag"
        ];
        default = "auto";
        description = "Package source for simple-nix-update-gui and its daemon.";
      };

      options.ojuny.binaries.simpleUpdateGuiTag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Release tag for simple-nix-update-gui and its daemon when its package source is tag.";
      };

      options.ojuny.manual.source = lib.mkOption {
        type = lib.types.enum [
          "source"
          "latest"
          "tag"
        ];
        default = "source";
        description = "Package source for the offline manual. Defaults to source because the manual tracks the rolling repository.";
      };

      options.ojuny.manual.tag = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Release tag for the offline manual when its package source is tag.";
      };

      config = {

        # @option widget = "switch"; label = "Enable patches"; group = "Patches"; description = "Automatically import patch- modules placed in the repository.";
        ojuny.patches = true;

        programs.nix-cleaner.package =
          pick "cleaner" inputs.nix-cleaner.packages.${system}.default "nix-cleaner"
            "nix-cleaner";

        services.nix-cache-discovery.package =
          pick "cacheDiscovery" inputs.nix-cache-discovery.packages.${system}.default "nix-cache-discovery"
            "nix-cache-discovery";

        services.nix-regedit.package =
          pick "regedit" inputs.nix-regedit.packages.${system}.default "nix-regedit"
            "nix-regedit";

        services.nix-settings-gui.package =
          pick "settingsGui" inputs.nix-settings-gui.packages.${system}.default "nix-settings-gui"
            "nix-settings-gui";

        services.nix-shell-gui.package =
          pick "shellGui" inputs.nix-shell-gui.packages.${system}.default "nix-shell-gui"
            "nix-shell-gui";

        services.simple-nix-update-gui.package =
          pick "simpleUpdateGui" inputs.simple-nix-update-gui.packages.${system}.default
            "simple-nix-update-gui"
            "simple-nix-update-gui";

        services.simple-nix-update-gui.daemonPackage =
          pick "simpleUpdateGui" inputs.simple-nix-update-gui.packages.${system}.daemon
            "simple-nix-update-gui"
            "simple-nix-update-gui-daemon";

        environment.systemPackages = [
          (pick "cli" inputs.ojuny-cli.packages.${system}.ojuny-cli "ojuny-cli" "ojuny-cli")
          (pick "cli" inputs.ojuny-cli.packages.${system}.ojuny-patches-cli "ojuny-cli" "ojuny-patches")
          manualPackage
        ];

        # @option widget = "text"; label = "Repository path"; group = "Paths"; groupOrder = 50; order = 10; description = "Absolute path, or a path relative to the primary user's home.";
        ojuny.repoPath = "repos/nix-flake";

        # @option widget = "dropdown"; label = "Package source"; group = "Binaries"; groupOrder = 60; order = 10; choices = [ "source" "latest" "tag" ]; description = "Build release tools from the flake, install the newest release recorded in binary-url.json, or install a named release from that file.";
        ojuny.binaries.mode = "source";

        # @option widget = "text"; label = "Fallback release tag"; group = "Binaries"; groupOrder = 60; order = 15; advanced = true; description = "Release tag used in tag mode when a tool does not set its own.";
        ojuny.binaries.tag = "";

        # @option widget = "dropdown"; label = "Command line"; group = "Binaries"; groupOrder = 60; order = 20; advanced = true; choices = [ "auto" "source" "latest" "tag" ]; description = "Override the package source for ojuny-cli and ojuny-patches-cli.";
        ojuny.binaries.cli = "auto";

        # @option widget = "text"; label = "Command line release tag"; group = "Binaries"; groupOrder = 60; order = 21; advanced = true; description = "Release tag for ojuny-cli and ojuny-patches-cli when their package source is tag.";
        ojuny.binaries.cliTag = "";

        # @option widget = "dropdown"; label = "Nix cleaner"; group = "Binaries"; groupOrder = 60; order = 30; advanced = true; choices = [ "auto" "source" "latest" "tag" ]; description = "Override the package source for nix-cleaner.";
        ojuny.binaries.cleaner = "auto";

        # @option widget = "text"; label = "Nix cleaner release tag"; group = "Binaries"; groupOrder = 60; order = 31; advanced = true; description = "Release tag for nix-cleaner when its package source is tag.";
        ojuny.binaries.cleanerTag = "";

        # @option widget = "dropdown"; label = "Cache discovery"; group = "Binaries"; groupOrder = 60; order = 40; advanced = true; choices = [ "auto" "source" "latest" "tag" ]; description = "Override the package source for nix-cache-discovery.";
        ojuny.binaries.cacheDiscovery = "auto";

        # @option widget = "text"; label = "Cache discovery release tag"; group = "Binaries"; groupOrder = 60; order = 41; advanced = true; description = "Release tag for nix-cache-discovery when its package source is tag.";
        ojuny.binaries.cacheDiscoveryTag = "";

        # @option widget = "dropdown"; label = "Registry editor"; group = "Binaries"; groupOrder = 60; order = 50; advanced = true; choices = [ "auto" "source" "latest" "tag" ]; description = "Override the package source for nix-regedit.";
        ojuny.binaries.regedit = "auto";

        # @option widget = "text"; label = "Registry editor release tag"; group = "Binaries"; groupOrder = 60; order = 51; advanced = true; description = "Release tag for nix-regedit when its package source is tag.";
        ojuny.binaries.regeditTag = "";

        # @option widget = "dropdown"; label = "Settings GUI"; group = "Binaries"; groupOrder = 60; order = 60; advanced = true; choices = [ "auto" "source" "latest" "tag" ]; description = "Override the package source for nix-settings-gui.";
        ojuny.binaries.settingsGui = "auto";

        # @option widget = "text"; label = "Settings GUI release tag"; group = "Binaries"; groupOrder = 60; order = 61; advanced = true; description = "Release tag for nix-settings-gui when its package source is tag.";
        ojuny.binaries.settingsGuiTag = "";

        # @option widget = "dropdown"; label = "Shell GUI"; group = "Binaries"; groupOrder = 60; order = 70; advanced = true; choices = [ "auto" "source" "latest" "tag" ]; description = "Override the package source for nix-shell-gui.";
        ojuny.binaries.shellGui = "auto";

        # @option widget = "text"; label = "Shell GUI release tag"; group = "Binaries"; groupOrder = 60; order = 71; advanced = true; description = "Release tag for nix-shell-gui when its package source is tag.";
        ojuny.binaries.shellGuiTag = "";

        # @option widget = "dropdown"; label = "Update GUI"; group = "Binaries"; groupOrder = 60; order = 80; advanced = true; choices = [ "auto" "source" "latest" "tag" ]; description = "Override the package source for simple-nix-update-gui and its daemon.";
        ojuny.binaries.simpleUpdateGui = "auto";

        # @option widget = "text"; label = "Update GUI release tag"; group = "Binaries"; groupOrder = 60; order = 81; advanced = true; description = "Release tag for simple-nix-update-gui and its daemon when their package source is tag.";
        ojuny.binaries.simpleUpdateGuiTag = "";

        # @option widget = "dropdown"; label = "Manual"; group = "Binaries"; groupOrder = 60; order = 90; choices = [ "source" "latest" "tag" ]; description = "Source builds the manual from the current repository. Latest installs the newest release recorded in binary-url.json. Tag installs a named release from that file. Defaults to source.";
        ojuny.manual.source = "source";

        # @option widget = "text"; label = "Manual release tag"; group = "Binaries"; groupOrder = 60; order = 91; advanced = true; description = "Release tag for the offline manual when its package source is tag.";
        ojuny.manual.tag = "";

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

        # @option widget = "dropdown"; label = "Default locale"; group = "Time and locale"; choices = [ "en_US.UTF-8" "en_GB.UTF-8" "en_AU.UTF-8" "en_CA.UTF-8" "de_DE.UTF-8" "nl_NL.UTF-8" "fr_FR.UTF-8" "es_ES.UTF-8" "pt_BR.UTF-8" "pt_PT.UTF-8" "it_IT.UTF-8" "pl_PL.UTF-8" "ru_RU.UTF-8" "uk_UA.UTF-8" "tr_TR.UTF-8" "ar_SA.UTF-8" "he_IL.UTF-8" "hi_IN.UTF-8" "ja_JP.UTF-8" "ko_KR.UTF-8" "zh_CN.UTF-8" "zh_TW.UTF-8" "sv_SE.UTF-8" "da_DK.UTF-8" "fi_FI.UTF-8" "nb_NO.UTF-8" ]; applyCommand = "localectl set-locale LANG=%%val%%"; description = "System language and formatting locale. Dux Shell follows it by default; its own Locale settings can override it at runtime.";
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
        system.stateVersion = "25.11";

        # Point at the source that built this system. The marker does not store
        # the state versions; setup evaluates the source to read them.
        environment.etc."ojuny/flake-source".source = self.outPath;

      };

    };

}

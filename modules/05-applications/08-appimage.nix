/*
  @menu
  displayname = "App format compatibility";
  icon = "application-x-executable-symbolic";
  order = 80;
  description = "AppImage support and an optional experimental Raven runtime for Windows files";
  category = "05-Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-appimage =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.ojuny.appimage;

      commonPackages = with pkgs; [
        icu
        libxcrypt-legacy
        libnotify
        libva
        libva-utils
        libayatana-appindicator
        libappindicator-gtk3
        libxshmfence
      ];

      stylixPackages = lib.optionals config.stylix.enable (
        config.stylix.fonts.packages
        ++ lib.optional (config.stylix.icons.package != null) config.stylix.icons.package
        ++ lib.optional (config.stylix.cursor != null) config.stylix.cursor.package
        ++ [ pkgs.adw-gtk3 ]
      );

      runtimePackages = lib.unique (
        commonPackages ++ config.fonts.packages ++ stylixPackages ++ cfg.extraPackages
      );

      appimageRun = pkgs.appimage-run.override {
        extraPkgs = _: runtimePackages;
      };

      cursorTheme =
        if config.stylix.cursor != null then config.stylix.cursor.name else "default";

      cursorSize =
        if config.stylix.cursor != null then toString config.stylix.cursor.size else "24";

      appimageRunWrapped = pkgs.writeShellApplication {
        name = "appimage-run";
        text = ''
          export XDG_DATA_DIRS="/run/current-system/sw/share:''${XDG_DATA_HOME:-$HOME/.local/share}:$HOME/.nix-profile/share:''${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
          export XCURSOR_THEME="${cursorTheme}"
          export XCURSOR_SIZE="${cursorSize}"
          exec ${appimageRun}/bin/appimage-run "$@"
        '';
      };

      appimageDesktop = pkgs.makeDesktopItem {
        name = "ojuny-appimage";
        exec = "${appimageRunWrapped}/bin/appimage-run %f";
        desktopName = "AppImage";
        genericName = "AppImage runner";
        noDisplay = true;
        icon = "application-x-executable";
        mimeTypes = [
          "application/vnd.appimage"
          "application/x-iso9660-appimage"
        ];
        categories = [ "Utility" ];
      };
    in
    {
      options.ojuny.appimage = {
        enable = lib.mkEnableOption "AppImage support";

        binfmt = lib.mkEnableOption "binfmt registration for AppImage files";

        extraPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "Packages added to the AppImage runtime environment. They are not installed system-wide; they are available only to AppImage applications.";
        };
      };

      config = {
        # @option widget = "switch"; label = "AppImage support"; group = "AppImage"; description = "Run AppImage files by double-clicking and from the terminal.";
        ojuny.appimage.enable = true;

        # @option widget = "switch"; label = "Register with binfmt"; group = "AppImage"; advanced = true; description = "Let the kernel run executable AppImage files through appimage-run.";
        ojuny.appimage.binfmt = true;

        # @option widget = "packages"; label = "AppImage environment includes"; group = "AppImage"; description = "Packages added to the AppImage runtime environment. They are not installed system-wide; they are available only to AppImage applications.";
        ojuny.appimage.extraPackages = [ ];

        programs.appimage.enable = cfg.enable;
        programs.appimage.binfmt = cfg.binfmt;
        programs.appimage.package = appimageRunWrapped;

        environment.systemPackages = lib.mkIf cfg.enable [ appimageDesktop ];

        xdg.mime.defaultApplications = lib.mkIf cfg.enable {
          "application/vnd.appimage" = "ojuny-appimage.desktop";
          "application/x-iso9660-appimage" = "ojuny-appimage.desktop";
        };
      };
    };

  flake.modules.nixos.applications-appimage-raven =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.ojuny.raven;

      ravenRun = pkgs.writeShellApplication {
        name = "ojuny-raven";
        runtimeInputs = [ pkgs.coreutils pkgs.gnused ];
        text = ''
          if [ "$#" -eq 0 ]; then
            echo "usage: ojuny-raven FILE.exe" >&2
            exit 2
          fi
          host_file="$(realpath -- "$1")"
          shift
          win_dir="Z:$(dirname -- "$host_file" | sed 's|/|\\|g')"
          exec ${config.programs.raven.package}/bin/raven --run-process --execution=native --timeout-ms=86400000 --desktop=wayland --directory="$win_dir" "$host_file" "$@"
        '';
      };

      ravenDesktop = pkgs.makeDesktopItem {
        name = "ojuny-raven";
        exec = "${ravenRun}/bin/ojuny-raven %f";
        desktopName = "Raven (experimental)";
        genericName = "Windows application runtime";
        comment = "Optional experimental runtime for Windows .exe files. Not guaranteed to run a given program.";
        noDisplay = true;
        icon = "application-x-executable";
        mimeTypes = [ "application/x-ms-dos-executable" ];
        categories = [ "Utility" ];
      };

      ravenMsiRun = pkgs.writeShellApplication {
        name = "ojuny-raven-msi";
        runtimeInputs = [ pkgs.coreutils pkgs.gnused ];
        text = ''
          if [ "$#" -eq 0 ]; then
            echo "usage: ojuny-raven-msi FILE.msi" >&2
            exit 2
          fi
          host_file="$(realpath -- "$1")"
          shift
          win_file="Z:$(printf '%s' "$host_file" | sed 's|/|\\|g')"
          win_dir="Z:$(dirname -- "$host_file" | sed 's|/|\\|g')"
          exec ${config.programs.raven.package}/bin/raven --run-process --execution=native --timeout-ms=86400000 --desktop=wayland --directory="$win_dir" ${config.programs.raven.package.unwrapped}/libexec/raven/msiexec.exe -- /i "$win_file"
        '';
      };

      ravenMsiDesktop = pkgs.makeDesktopItem {
        name = "ojuny-raven-msi";
        exec = "${ravenMsiRun}/bin/ojuny-raven-msi %f";
        desktopName = "Raven MSI installer (experimental)";
        genericName = "Windows Installer package";
        comment = "Optional experimental Raven handler for .msi packages. Not guaranteed to run a given installer.";
        noDisplay = true;
        icon = "application-x-executable";
        mimeTypes = [ "application/x-msi" ];
        categories = [ "Utility" ];
      };

      ravenBatRun = pkgs.writeShellApplication {
        name = "ojuny-raven-bat";
        runtimeInputs = [ pkgs.coreutils pkgs.gnused ];
        text = ''
          if [ "$#" -eq 0 ]; then
            echo "usage: ojuny-raven-bat FILE.bat" >&2
            exit 2
          fi
          host_file="$(realpath -- "$1")"
          shift
          win_file="Z:$(printf '%s' "$host_file" | sed 's|/|\\|g')"
          win_dir="Z:$(dirname -- "$host_file" | sed 's|/|\\|g')"
          exec ${config.programs.raven.package}/bin/raven --run-process --execution=native --timeout-ms=86400000 --desktop=wayland --directory="$win_dir" ${config.programs.raven.package.unwrapped}/libexec/raven/cmd.exe -- /c "$win_file"
        '';
      };

      ravenBatDesktop = pkgs.makeDesktopItem {
        name = "ojuny-raven-bat";
        exec = "${ravenBatRun}/bin/ojuny-raven-bat %f";
        desktopName = "Raven batch file (experimental)";
        genericName = "Windows batch file";
        comment = "Optional experimental Raven handler for .bat files. Interactive scripts need a terminal and behavior is not guaranteed.";
        noDisplay = true;
        terminal = true;
        icon = "application-x-executable";
        mimeTypes = [ "application/x-bat" ];
        categories = [ "Utility" ];
      };
    in
    {
      imports = [ inputs.raven.nixosModules.default ];

      options.ojuny.raven = {
        enable = lib.mkEnableOption "the optional experimental Raven Windows runtime";
      };

      config = {
        # @option widget = "switch"; label = "Raven for Windows files (experimental)"; group = "Windows applications"; groupOrder = 20; order = 10; description = "Optional and experimental. Opens .exe, .msi and .bat files with Raven instead of Wine. Raven is not guaranteed to run a given program, and some installers and games will fail. .bat files are best-effort and interactive scripts need a terminal. This does not affect Steam or Proton.";
        ojuny.raven.enable = false;

        programs.raven.enable = cfg.enable;

        environment.systemPackages = lib.mkIf cfg.enable [
          ravenRun
          ravenDesktop
          ravenMsiRun
          ravenMsiDesktop
          ravenBatRun
          ravenBatDesktop
        ];

        xdg.mime.defaultApplications = lib.mkIf cfg.enable {
          "application/x-ms-dos-executable" = lib.mkDefault "ojuny-raven.desktop";
          "application/x-msi" = lib.mkDefault "ojuny-raven-msi.desktop";
          "application/x-bat" = lib.mkDefault "ojuny-raven-bat.desktop";
        };
      };
    };

}

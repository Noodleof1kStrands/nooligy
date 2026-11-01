/*
  @menu
  displayname = "Installed applications";
  icon = "system-software-install-symbolic";
  order = 10;
  description = "Applications installed system-wide";
  category = "05-Applications";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.applications-applist =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.ojuny.apps.mimeDefaults = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options.desktop = lib.mkOption {
              type = lib.types.str;
              description = "Desktop entry that opens this MIME type.";
            };
          }
        );
        default = { };
        description = "Default desktop entries keyed by MIME type, applied to xdg.mime.defaultApplications.";
      };

      config = {
        # @option widget = "packages"; label = "Base packages"; group = "Installed applications"; description = "Small command line and utility tools available to every user.";
        environment.systemPackages = with pkgs; [
          wget
          curl
          micro
          brightnessctl
          playerctl
          fzf
          bat
          eza
          jq
          netcat-openbsd
          dnsmasq
          libnotify
          wtype
          ydotool
        ];
        services.upower.enable = true;

        xdg.mime.enable = true;

        # @option widget = "dropdown"; label = "File manager"; group = "Default applications"; choices = [ "dux-files" "nautilus" "custom" ]; description = "File manager used for directories and remote schemes."; applyCommand = "case %%val%% in dux-files) xdg-mime default dev.duxlabs.files.desktop inode/directory;; esac";
        desktop.ojuny.fileManager.package = "dux-files";

        # @option widget = "table-attrset"; label = "Other MIME defaults"; group = "Default applications"; columns = [ "desktop" ]; columnTypes = [ "str" ]; keyEditable = true; description = "Desktop entries for archives and text types. The file manager and remote schemes are owned by the file manager option above. Browser, office, image and Discord defaults live on their own pages.";
        ojuny.apps.mimeDefaults = { };

        # Derived from the table above; no @option.
        xdg.mime.defaultApplications = lib.mapAttrs (
          _: entry: entry.desktop
        ) config.ojuny.apps.mimeDefaults;
      };

      # Larger optional applications are installed from their own pages: the
      # Office, Multimedia and Vesktop switches live on those pages and add
      # their packages there.

    };

}

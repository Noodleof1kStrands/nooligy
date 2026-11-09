{ self, ... }:

{
  flake.modules.nixos.applications-mount-image =
    { pkgs, ... }:
    let
      diskImageMimeTypes = [
        "application/x-cd-image"
        "application/x-iso9660-image"
        "application/x-raw-disk-image"
        "application/x-raw-disk-image-xz-compressed"
        "application/vnd.efi.iso"
        "application/x-apple-diskimage"
      ];

      mountImage = pkgs.writeShellApplication {
        name = "ojuny-mount-image";
        runtimeInputs = with pkgs; [
          coreutils
          gnused
          libnotify
          udisks2
          util-linux
          xdg-utils
        ];
        text = builtins.readFile ../../scripts/ojuny-mount-image.sh;
      };

      mountImageDesktop = pkgs.makeDesktopItem {
        name = "ojuny-mount-image";
        desktopName = "Mount Disk Image";
        comment = "Mount a disk image and open it";
        exec = "ojuny-mount-image %f";
        icon = "drive-harddisk";
        categories = [ "Utility" ];
        mimeTypes = diskImageMimeTypes;
        noDisplay = true;
      };

      diskImageDefaults = pkgs.lib.genAttrs diskImageMimeTypes (
        _: pkgs.lib.mkDefault "ojuny-mount-image.desktop"
      );
    in
    {
      environment.systemPackages = [
        mountImage
        mountImageDesktop
      ];

      xdg.mime.defaultApplications = diskImageDefaults;
    };
}

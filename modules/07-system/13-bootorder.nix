{ self, inputs, ... }: {

  flake.modules.nixos.system-bootorder =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      bootMountPoint = config.boot.loader.efi.efiSysMountPoint;
      recoveryEnabled = config.ojuny.recovery.enable;
      recoveryFile = "${bootMountPoint}/EFI/ojuny/recovery/ojuny-recovery.efi";

      bootorder = self.packages.${pkgs.system}.ojuny-bootorder;
    in
    {
      systemd.services.ojuny-bootorder = {
        description = "Keep the Ojuny entries first among the internal boot entries";
        wantedBy = [ "multi-user.target" ];
        after =
          [ "local-fs.target" ]
          ++ lib.optional recoveryEnabled "ojuny-recovery.service"
          ++ lib.optional config.ojuny.multiboot.enable "ojuny-multiboot.service";
        before = [ "shutdown.target" ];
        unitConfig.ConditionPathExists = "/sys/firmware/efi";
        environment = {
          OJUNY_BOOT_MOUNT = bootMountPoint;
          OJUNY_RECOVERY_FILE = recoveryFile;
          OJUNY_RECOVERY_ENABLED = lib.boolToString recoveryEnabled;
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${bootorder}/bin/ojuny-bootorder";
        };
      };
    };

}

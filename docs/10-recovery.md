# 10 - Recovery

The Recovery page holds one switch:

```nix
ojuny.recovery.enable = true;
```

The switch is labelled "Enable recovery UKI". It is on by default. Turning it
off removes the recovery UKI, its service and its firmware entry. It does not
change the primary systemd-boot or rEFInd boot path.

## What it installs

The backend builds a Unified Kernel Image from the current generation and writes
it to the ojuny ESP:

- `EFI/ojuny/recovery/ojuny-recovery.efi`

The service runs once at boot. It reads `/run/current-system/boot.json`, builds
the UKI with the current kernel and initrd, signs it with `sbctl` when the
Lanzaboote keys exist, and writes `/var/lib/ojuny/recovery.json`.

The UKI is a single signed EFI file. It boots the installed system without
systemd-boot, rEFInd or the loader entries.

## Firmware entry

The boot order service creates and maintains:

- `Linux Boot Manager` on the ojuny ESP
- `Ojuny Recovery` on the ojuny ESP
- `Windows Boot Manager` on the Windows ESP

It puts the ojuny systemd-boot entry first, the recovery entry second, and the
Windows entry next. It preserves the other entries.

If Windows resets the boot order, boot ojuny once from the firmware menu. The
service restores the order.

## No-USB recovery

The recovery UKI is a backup boot path for a broken systemd-boot or rEFInd:

1. Reboot and open the firmware boot menu.
2. Select `Ojuny Recovery`.
3. The UKI boots NixOS directly.
4. Run `nixos-rebuild boot` to repair the primary bootloader.

This does not cover a corrupted ojuny ESP. The UKI lives on the same ESP. If the
ESP is unreadable, use the firmware boot-from-file option or a live USB.

## Separate ojuny ESP

The recovery path is designed for the separate-ESP layout:

- Windows keeps its 200 MiB ESP, 16 MiB MSR, Windows partition and 750 MiB
  recovery partition.
- A new 1 GiB ojuny ESP holds systemd-boot, rEFInd, the kernels, the initrds,
  the loader entries and the recovery UKI.
- The Windows ESP is not mounted and is not modified by ojuny.
- Windows updates can rebuild the Windows ESP without removing the ojuny
  bootloader or the recovery UKI.
- rEFInd is the `Other systems` route for the Windows ESP.
- BitLocker Windows is started through the firmware `BootNext` entry.

The installer creates the 1 GiB ojuny ESP in the free space automatically. It
rejects using the Windows ESP as the ojuny boot partition.

## Commands

```console
$ ojuny recovery status
$ sudo ojuny recovery rebuild
$ ojuny bootorder status
$ sudo ojuny bootorder fix
$ ojuny multiboot status
```

## Limits

- The recovery UKI is x86_64 only, matching the template.
- Secure Boot requires the UKI to be signed with a key enrolled in the firmware.
- The UKI does not protect against a corrupted ojuny ESP.
- The firmware must be able to boot the ojuny ESP through its NVRAM entry or its
  boot-from-file menu.

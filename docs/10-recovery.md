# 10 - Recovery

The Secure Boot page holds the recovery switch, under Boot entries:

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

The boot order service maintains two entries on the ojuny ESP:

- `Linux Boot Manager`
- `Ojuny Recovery`

It asserts only that these two are the top two internal entries, in that order.
External entries keep their exact positions. Other internal systems keep their
relative order below the two Ojuny entries. The service rewrites only the slots
already occupied by internal OS entries and does nothing when the order is
already correct, so a plugged-in USB drive is not forced above or below ojuny.

If Windows resets the boot order, boot ojuny once from the firmware menu. The
service restores the order.

The installer applies the rule once, after `nixos-install`. It saves the
firmware order before the install, restores it afterwards, and inserts
`Linux Boot Manager` above the first internal entry. This undoes the one-time
move to the top that `bootctl install` performs, so external entries keep their
positions on devices whose firmware stores them in `BootOrder`. The recovery
entry is added by the service on the first boot.

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
- A new 4 GiB ojuny ESP holds systemd-boot, rEFInd, the kernels, the initrds,
  the loader entries and the recovery UKI.
- The boot menu keeps the 50 newest generations
  (`boot.loader.systemd-boot.configurationLimit`). Kernel and initrd files are
  deduplicated and unused files are removed when old entries are pruned.
- The Windows ESP is not mounted and is not modified by ojuny.
- Windows updates can rebuild the Windows ESP without removing the ojuny
  bootloader or the recovery UKI.
- rEFInd is the `Other systems` route for the Windows ESP.
- BitLocker Windows is started through the firmware `BootNext` entry.

The installer creates the 4 GiB ojuny ESP automatically, whether the replaced
partition is free space or an existing partition. It rejects using the Windows
ESP as the ojuny boot partition.

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

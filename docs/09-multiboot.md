# 09 - Multiboot

Multiboot is an optional rEFInd helper. It is off by default. When it is on,
systemd-boot gets one extra entry named "Other systems". The entry starts
rEFInd, which scans the internal drives and shows the other operating systems
it finds.

The helper is not installed when the option is off. The installer enables the
option when it finds another internal system that systemd-boot cannot see on its
own.

## When it is needed

systemd-boot reads boot entries from its own ESP and its XBOOTLDR partition.
It does not read another ESP. Windows on the same ESP is detected natively. Any
other operating system on another ESP or another internal disk needs the
helper. In the separate ojuny ESP layout in `10-recovery.md`, Windows is on the
Windows ESP and the helper is required.

The setting is on the Multiboot page:

```nix
ojuny.multiboot.enable = true;
```

Turning it off again removes the rEFInd directory and the "Other systems"
entry at the next boot.

## What it installs

The backend writes these files to the active boot partition, which is the
XBOOTLDR partition when one is configured and the ESP otherwise:

- `EFI/ojuny/multiboot/refind_x64.efi`
- `EFI/ojuny/multiboot/refind.conf`
- `EFI/ojuny/multiboot/ojuny-generated.conf`
- `EFI/ojuny/multiboot/icons`, `fonts` and `images`
- `loader/entries/ojuny-other-systems.conf`

The entry is:

```text
title Other systems
efi /EFI/ojuny/multiboot/refind_x64.efi
sort-key o_other_systems
```

`refind.conf` is created only when it does not exist, so its timeout and theme
can be edited. The service rewrites `ojuny-generated.conf` on every scan. That
file hides the ojuny ESP to prevent a loop back into systemd-boot, hides the
ojuny firmware entry, and chooses the Windows entry that is safe for BitLocker.

## Secure Boot

Under Secure Boot the helper must be signed. The service signs it with `sbctl`
when `/var/lib/sbctl/keys` exists. If Secure Boot is on and the helper is not
signed, the firmware refuses to start it. `ojuny multiboot status` reports the
helper state as `signed`, `unsigned` or `not-required`.

The helper can start Windows because Windows Boot Manager is Microsoft signed
and the enrollment includes the Microsoft keys. Another Linux distribution can
only start if its own boot loader is signed by a key the firmware trusts. That
is the normal Secure Boot key problem, not something the helper can bypass.

Lanzaboote measures its own systemd-boot path. Adding rEFInd to that path
changes the PCR 4 measurements. Systems with Lanzaboote measured boot enabled
must re-enroll their policy after enabling the helper.

## Windows and BitLocker

Selecting Windows from the helper uses the Windows Boot Manager firmware entry.
rEFInd sets `BootNext` and reboots, so the firmware starts Windows directly and
the BitLocker PCR values stay on the expected path. This costs one visible
reboot. The direct chainload of `bootmgfw.efi` is hidden when BitLocker is
detected.

The service creates the Windows Boot Manager NVRAM entry if it is missing and
keeps the existing boot order, so ojuny stays first.

## Installing alongside Windows

Windows NTFS is never resized by ojuny. Shrink the Windows partition in Windows
Disk Management before starting the installer, and export the BitLocker
recovery key first when BitLocker is enabled. A forced Linux-side NTFS shrink
can leave Windows unbootable.

The attended installer can shrink XFS, EXT4, BTRFS, f2fs and vfat partitions
and install into the freed space. It does not resize NTFS. The whole-disk and
unattended paths wipe the disk and are not dual-boot paths.

Install Windows first. Windows recreates the ESP when it installs and removes a
Linux bootloader installed before it. Do not resize the 200 MiB Windows ESP.
The installer creates a 4 GiB ojuny ESP in the replaced partition and leaves the
Windows ESP unassigned. systemd-boot, rEFInd, the kernels, the initrds and the
recovery UKI live on the ojuny ESP.

## Adding a drive

Detection runs once at boot. After adding an internal drive:

1. Boot ojuny once so the service scans the new drive.
2. Reboot and select "Other systems".

The status command shows the last scan:

```console
$ ojuny multiboot status
```

A rescan needs root:

```console
$ sudo ojuny multiboot rescan
```

## Limits

- UEFI only. rEFInd does not run on BIOS installs. BIOS uses GRUB with
  os-prober.
- Two menus. systemd-boot shows "Other systems" and rEFInd shows the targets.
- The helper only sees EFI loaders. A Linux installation whose boot loader is
  not on an ESP is not listed unless rEFInd has a filesystem driver for it.
- External and optical drives are not scanned.

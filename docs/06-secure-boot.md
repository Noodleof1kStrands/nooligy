# 06 - Secure Boot

Secure Boot is an optional, post-install step for UEFI installs that already use
systemd-boot. It is a manual, best-effort flow. It is not enabled by the
installer, it is not a security guarantee, and it is not a supported claim that
the system stays secure after modification.

The supported boundary is narrow:

- UEFI firmware only. A BIOS install with GRUB cannot use this flow.
- systemd-boot only. Lanzaboote replaces the systemd-boot module, so the boot
  loader must already be systemd-boot.
- The firmware must be able to enter Setup Mode. Some firmware cannot.
- Windows and BitLocker users must read the recovery-key section below before
  enrolling anything.

## 1. Before you start

Check the current boot:

```console
$ bootctl status
System:
     Firmware: UEFI 2.70 (Lenovo 0.4720)
  Secure Boot: disabled (disabled)
 TPM2 Support: yes
 Boot into FW: supported

Current Boot Loader:
      Product: systemd-boot 251.7
```

The firmware must report `UEFI` and the current boot loader must be
systemd-boot. If the machine booted in BIOS mode or uses GRUB, stop here. This
flow is unsupported on that hardware, and the template asserts against enabling
Secure Boot while GRUB is the loader.

Only continue if you are comfortable with recovery tools or have a backup. A
bad key or firmware setup can leave the machine unbootable. The template does
not provide a recovery guarantee for this flow.

If Windows is installed or BitLocker is active, export and confirm the BitLocker
recovery key first. Enrolling keys changes the PCR measurements, so Windows may
demand the recovery key on the next boot. Keep the key available outside the
machine being changed.

## 2. Create the keys

```console
$ sudo sbctl create-keys
Created Owner UUID 8ec4b2c3-dc7f-4362-b9a3-0cc17e5a34cd
Creating secure boot keys...✓
Secure boot keys created!
```

The keys are written to `/var/lib/sbctl`. The secret key is readable by root
only. The template points `boot.lanzaboote.pkiBundle` at that directory. Do not
delete or replace the bundle after enrollment unless you intend to enroll again.

## 3. Enable Lanzaboote and rebuild

In the settings GUI, open Secure Boot and enable the switch. The setup flow
stages key creation, writes the Lanzaboote configuration, and runs the rebuild
command from `~/.config/nix-settings-gui/config.json`. The installers and
`setup.sh` write `nixos-rebuild boot`, so the rebuild does not switch the running
system and a reboot is part of the flow.

The same change can be made by hand. The module already holds the annotated
toggle, the PKI bundle path, and `sbctl`:

```nix
boot.lanzaboote.enable = true;
boot.lanzaboote.pkiBundle = "/var/lib/sbctl";
environment.systemPackages = [ pkgs.sbctl ];
```

Lanzaboote also needs systemd-boot disabled as a module. The Secure Boot module
does that on UEFI when the toggle is on. Do not enable Secure Boot on a GRUB
install; the assertion stops evaluation.

After the rebuild, check the signatures:

```console
$ sudo sbctl verify
Verifying file database and EFI images in /boot...
✓ /boot/EFI/BOOT/BOOTX64.EFI is signed
✓ /boot/EFI/Linux/nixos-generation-355.efi is signed
✓ /boot/EFI/systemd/systemd-bootx64.efi is signed
```

Unsigned kernel files under `/boot/EFI/nixos/` are expected. Reboot before
continuing if the rebuild used `nixos-rebuild boot`.

## 4. Put the firmware in Setup Mode

The firmware only accepts enrolled keys in Setup Mode. Enter the firmware
settings from the boot menu or with `systemctl reboot --firmware-setup`.

ThinkPad:

1. Open the Security tab and the Secure Boot entry.
2. Enable Secure Boot.
3. Select "Reset to Setup Mode".
4. Save and exit.

Framework:

1. Open "Administer Secure Boot".
2. For "PK Options", "KEK Options" and "DB Options", select "Delete", then
   select each item and confirm "Delete this signature".
3. Save and exit.

Do not select "Erase all Secure Boot Settings" on Framework. The firmware is
bugged on most models and the manual deletion is the supported path.

Other boards usually have no explicit Setup Mode entry. Erase the existing
Platform Key instead. Microsoft Surface devices should keep Secure Boot disabled
in firmware; disabling it places the firmware in Setup Mode, and Lanzaboote
enables Secure Boot after enrollment.

## 5. Enroll the keys

Boot back into NixOS and enroll the keys. Include the Microsoft certificates so
option ROMs and Windows signatures keep working:

```console
$ sudo sbctl enroll-keys --microsoft
Enrolling keys to EFI variables...
With vendor keys from microsoft...✓
Enrolled keys to the EFI variables!
```

On Framework laptops, add `--firmware-builtin` so the keys pre-provisioned by
the firmware stay enrolled. Vendor firmware updates need them:

```console
$ sudo sbctl enroll-keys --microsoft --firmware-builtin
```

On Framework, also open "Administer Secure Boot" again and enable "Enforce
Secure Boot". Save and exit, then reboot.

## 6. Check the result

```console
$ bootctl status
System:
     Firmware: UEFI 2.70 (Lenovo 0.4720)
  Secure Boot: enabled (user)
```

`enabled (user)` means the firmware is enforcing the keys you enrolled.

## 7. The dbx caution

Do not select "Clear All Secure Boot Keys" during firmware setup. It drops the
Forbidden Signature Database (`dbx`) and weakens the boot chain.

After enrolling with `--microsoft`, check that `dbx` is not empty:

```console
$ ls -l /sys/firmware/efi/efivars/dbx-*
```

If the file is missing or empty, select "Restore Secure Boot to Factory Settings"
in the firmware, then repeat the Setup Mode steps and enroll again. On Framework
this is done from the "Administer Secure Boot" menu.

## 8. The settings GUI flow

The Secure Boot card attaches to `boot.lanzaboote.enable`. It reads firmware and
key state from `bootctl`, `sbctl status` and `sbctl verify`, and refuses to run
unless the machine booted in UEFI mode.

The setup dialog is stage-driven, not a fixed script. It derives the next step
from live state: keys, configuration, rebuild, firmware setup, enrollment,
verification, and done. A reboot or a firmware change resumes at the right step
instead of restarting. Existing keys in `/var/lib/sbctl` are kept unless you
explicitly remove them.

Privileged commands run through the configured terminal command, so the GUI
never sees the sudo password.

## 9. Boundary

The installer produces an unsigned system. On UEFI it installs systemd-boot; on
BIOS it installs GRUB. Secure Boot is enabled after the first boot, if at all.
There is no installer key enrollment, no installer option, no signing
infrastructure and no key server.

This flow is optional and unsupported beyond what is written here. It does not
make Ojuny a security-focused distribution, and it does not guarantee that a
modified system stays secure.

## 10. Multiboot and the rEFInd helper

The optional multiboot helper in `docs/09-multiboot.md` is chainloaded by
systemd-boot; it does not replace systemd-boot or Lanzaboote. Under Secure Boot
the helper must be signed with the same `sbctl` keys. If Lanzaboote measured
boot is enabled, adding the helper changes the PCR 4 measurements and the
pcrlock policy must be re-enrolled. The helper can start Windows because
Windows Boot Manager is Microsoft signed. Another Linux distribution can only
start when its boot loader is signed by a key the firmware trusts.

The optional recovery UKI in `docs/10-recovery.md` is also signed with the same
`sbctl` keys. It is a direct firmware boot path that does not depend on
systemd-boot or rEFInd.

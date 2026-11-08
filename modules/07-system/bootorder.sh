boot_mount="${OJUNY_BOOT_MOUNT:?}"
recovery_file="${OJUNY_RECOVERY_FILE:-}"
recovery_enabled="${OJUNY_RECOVERY_ENABLED:-false}"

source="$(findmnt -no SOURCE "$boot_mount" 2>/dev/null || true)"
if [ -z "$source" ]; then
    exit 0
fi

disk="$(lsblk -no PKNAME "$source" 2>/dev/null | head -n1 || true)"
partnum="$(lsblk -no PARTN "$source" 2>/dev/null | head -n1 || true)"
partuuid="$(blkid -s PARTUUID -o value "$source" 2>/dev/null || true)"
if [ -z "$disk" ] || [ -z "$partnum" ] || [ -z "$partuuid" ]; then
    exit 0
fi

efi="$(efibootmgr -v 2>/dev/null || true)"

find_by_path() {
    local pattern="$1"
    printf '%s\n' "$efi" | awk -v uuid="$partuuid" -v pattern="$pattern" '
        /^Boot[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]/ {
            if (index($0, uuid) > 0 && index($0, pattern) > 0) {
                print substr($1, 5, 4)
                exit
            }
        }
    '
}

ojuny_num="$(find_by_path 'systemd-bootx64.efi')"
if [ -z "$ojuny_num" ]; then
    ojuny_num="$(find_by_path 'BOOTX64.EFI')"
fi
if [ -z "$ojuny_num" ]; then
    efibootmgr -c -d "/dev/$disk" -p "$partnum" -L 'Linux Boot Manager' -l '\EFI\systemd\systemd-bootx64.efi' >/dev/null 2>&1 || true
    efi="$(efibootmgr -v 2>/dev/null || true)"
    ojuny_num="$(find_by_path 'systemd-bootx64.efi')"
fi

recovery_num="$(printf '%s\n' "$efi" | awk '/^Boot[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]/ && /Ojuny Recovery/ { print substr($1, 5, 4); exit }')"
if [ "$recovery_enabled" = "true" ] && [ -n "$recovery_file" ] && [ -f "$recovery_file" ] && [ -z "$recovery_num" ]; then
    efibootmgr -c -d "/dev/$disk" -p "$partnum" -L 'Ojuny Recovery' -l '\EFI\ojuny\recovery\ojuny-recovery.efi' >/dev/null 2>&1 || true
    efi="$(efibootmgr -v 2>/dev/null || true)"
    recovery_num="$(printf '%s\n' "$efi" | awk '/^Boot[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]/ && /Ojuny Recovery/ { print substr($1, 5, 4); exit }')"
fi

windows_num="$(printf '%s\n' "$efi" | awk '/^Boot[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]/ && /bootmgfw.efi/ { print substr($1, 5, 4); exit }')"

order="$(efibootmgr 2>/dev/null | sed -n 's/^BootOrder: //p' | head -n1 || true)"
rest="$(printf '%s' "$order" | tr ',' '\n' | awk -v a="$ojuny_num" -v b="$recovery_num" -v c="$windows_num" '$0 != "" && $0 != a && $0 != b && $0 != c' | paste -sd, -)"

prefix=""
for number in "$ojuny_num" "$recovery_num" "$windows_num"; do
    [ -n "$number" ] || continue
    prefix="${prefix:+$prefix,}$number"
done

new_order="$prefix${rest:+,$rest}"
if [ -n "$new_order" ]; then
    efibootmgr -o "$new_order" >/dev/null 2>&1 || true
fi

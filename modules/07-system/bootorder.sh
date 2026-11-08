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

[ -n "$ojuny_num" ] || exit 0

order="$(efibootmgr 2>/dev/null | sed -n 's/^BootOrder: //p' | head -n1 || true)"
[ -n "$order" ] || exit 0

entry_line() {
    printf '%s\n' "$efi" | awk -v number="$1" '
        /^Boot[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]/ {
            if (substr($1, 5, 4) == number) {
                print
                exit
            }
        }
    '
}

is_ojuny_entry() {
    [ "$1" = "$ojuny_num" ] && return 0
    [ "$recovery_enabled" = "true" ] && [ "$1" = "$recovery_num" ] && return 0
    return 1
}

is_internal_os() {
    local line
    line="$(entry_line "$1")" || return 1
    [ -n "$line" ] || return 1
    line="${line,,}"
    case "$line" in
    *usb\(*) return 1 ;;
    esac
    case "$line" in
    *bootmgfw.efi* | *grubx64.efi* | *shimx64.efi* | *systemd-bootx64.efi* | *vmlinuz* | *efi/linux/* | *bootx64.efi*)
        return 0
        ;;
    esac
    return 1
}

IFS=',' read -r -a current_order <<<"$order"

desired=("$ojuny_num")
if [ "$recovery_enabled" = "true" ] && [ -n "$recovery_num" ]; then
    desired+=("$recovery_num")
fi
internal_total=0
for number in "${current_order[@]}"; do
    if is_ojuny_entry "$number"; then
        internal_total=$((internal_total + 1))
    elif is_internal_os "$number"; then
        desired+=("$number")
        internal_total=$((internal_total + 1))
    fi
done

[ "${#desired[@]}" -eq "$internal_total" ] || exit 0

new_order=()
slot=0
for number in "${current_order[@]}"; do
    if is_ojuny_entry "$number" || is_internal_os "$number"; then
        new_order+=("${desired[$slot]}")
        slot=$((slot + 1))
    else
        new_order+=("$number")
    fi
done

new="$(IFS=,; printf '%s' "${new_order[*]}")"
if [ "$new" != "$order" ]; then
    efibootmgr -o "$new" >/dev/null 2>&1 || true
fi

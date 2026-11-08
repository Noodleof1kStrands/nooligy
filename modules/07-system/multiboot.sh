boot_mount="${OJUNY_BOOT_MOUNT:?}"
esp_mount="${OJUNY_ESP_MOUNT:?}"
helper_dir="${OJUNY_HELPER_DIR:?}"
entry_file="${OJUNY_ENTRY_FILE:?}"
refind_assets="${OJUNY_REFIND_ASSETS:?}"
can_touch_efi="${OJUNY_CAN_TOUCH_EFI:-false}"
pki_bundle="${OJUNY_PKI_BUNDLE:-}"
state_dir="/var/lib/ojuny"
manifest="$state_dir/multiboot.json"
refind_bin="$helper_dir/refind_x64.efi"
refind_conf="$helper_dir/refind.conf"
generated_conf="$helper_dir/ojuny-generated.conf"

targets_file=""
mounts=()

cleanup_mounts() {
    local mount
    if [ "${#mounts[@]}" -eq 0 ]; then
        return 0
    fi
    for mount in "${mounts[@]}"; do
        umount "$mount" 2>/dev/null || true
        rmdir "$mount" 2>/dev/null || true
    done
}

trap cleanup_mounts EXIT

same_device() {
    local device="$1"
    local mount="$2"
    local source

    source="$(findmnt -no SOURCE "$mount" 2>/dev/null || true)"
    [ -n "$source" ] || return 1
    [ "$(readlink -f "$device")" = "$(readlink -f "$source")" ]
}

esp_partuuid() {
    local source

    source="$(findmnt -no SOURCE "$esp_mount" 2>/dev/null || true)"
    [ -n "$source" ] || return 0
    blkid -s PARTUUID -o value "$source" 2>/dev/null || true
}

boot_partuuid() {
    local source

    source="$(findmnt -no SOURCE "$boot_mount" 2>/dev/null || true)"
    [ -n "$source" ] || return 0
    blkid -s PARTUUID -o value "$source" 2>/dev/null || true
}

secure_boot_enabled() {
    local file

    file="$(find /sys/firmware/efi/efivars -maxdepth 1 -name 'SecureBoot-*' -print -quit 2>/dev/null || true)"
    [ -n "$file" ] || return 1
    [ "$(od -An -t u1 -j 4 -N 1 "$file" | tr -d ' ')" = "1" ]
}

copy_helper() {
    local marker="$helper_dir/.ojuny-refind-version"

    install -d "$helper_dir" "$(dirname "$entry_file")" "$state_dir"
    if [ -f "$marker" ] && [ "$(cat "$marker")" = "$refind_assets" ] && [ -f "$refind_bin" ]; then
        return 0
    fi
    cp -r "$refind_assets/." "$helper_dir/"
    printf '%s\n' "$refind_assets" >"$marker"
}

write_entry() {
    local content

    content="$(printf '%s\n' 'title Other systems' 'efi /EFI/ojuny/multiboot/refind_x64.efi' 'sort-key o_other_systems')"
    if [ ! -f "$entry_file" ] || [ "$(cat "$entry_file")" != "$content" ]; then
        printf '%s\n' "$content" >"$entry_file"
    fi
}

write_base_config() {
    local content

    content="$(printf '%s\n' 'timeout 10' 'use_nvram false' 'scanfor internal,manual,firmware' 'include ojuny-generated.conf')"
    if [ ! -f "$refind_conf" ]; then
        printf '%s\n' "$content" >"$refind_conf"
    fi
}

write_generated_config() {
    local volumes="$1"
    local firmware_filters="$2"
    local bitlocker="$3"

    {
        if [ -n "$volumes" ]; then
            printf 'dont_scan_volumes %s\n' "$volumes"
        fi
        if [ -n "$firmware_filters" ]; then
            printf 'dont_scan_firmware %s\n' "$firmware_filters"
        fi
        if [ "$bitlocker" = "true" ]; then
            printf 'dont_scan_files EFI/Microsoft/Boot/bootmgfw.efi\n'
        fi
    } >"$generated_conf.tmp"

    if [ ! -f "$generated_conf" ] || ! cmp -s "$generated_conf.tmp" "$generated_conf"; then
        mv "$generated_conf.tmp" "$generated_conf"
    else
        rm -f "$generated_conf.tmp"
    fi
}

sign_helper() {
    [ -f "$refind_bin" ] || return 0
    [ -n "$pki_bundle" ] || return 0
    [ -d "$pki_bundle/keys" ] || return 0
    if sbctl verify "$refind_bin" >/dev/null 2>&1; then
        return 0
    fi
    sbctl sign -s "$refind_bin" >/dev/null 2>&1 || true
}

helper_state() {
    if ! secure_boot_enabled; then
        printf 'not-required\n'
        return 0
    fi
    if sbctl verify "$refind_bin" >/dev/null 2>&1; then
        printf 'signed\n'
    else
        printf 'unsigned\n'
    fi
}

ojuny_firmware_labels() {
    local uuid="$1"

    [ -n "$uuid" ] || return 0
    efibootmgr -v 2>/dev/null | awk -v uuid="$uuid" '
        /^Boot[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]/ {
            line = $0
            label = line
            sub(/^Boot[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]\*?[[:space:]]*/, "", label)
            sub(/[[:space:]]+HD\(.*$/, "", label)
            if (index(line, uuid) > 0 && label != "") print label
        }
    '
}

ensure_windows_entry() {
    local partition="$1"
    local disk partnum before after newnum

    [ "$can_touch_efi" = "true" ] || return 0
    if efibootmgr -v 2>/dev/null | grep -qi 'bootmgfw.efi'; then
        return 0
    fi

    disk="$(lsblk -no PKNAME "$partition" 2>/dev/null | head -n1 || true)"
    partnum="$(lsblk -no PARTN "$partition" 2>/dev/null | head -n1 || true)"
    [ -n "$disk" ] && [ -n "$partnum" ] || return 0

    before="$(efibootmgr 2>/dev/null | sed -n 's/^BootOrder: //p' | head -n1 || true)"
    after="$(efibootmgr -c -d "/dev/$disk" -p "$partnum" -L 'Windows Boot Manager' -l '\EFI\Microsoft\Boot\bootmgfw.efi' 2>/dev/null || true)"
    newnum="$(printf '%s\n' "$after" | sed -n 's/^Boot\([0-9A-Fa-f]\{4\}\)\*.*Windows Boot Manager.*/\1/p' | head -n1 || true)"
    if [ -n "$before" ] && [ -n "$newnum" ]; then
        efibootmgr -o "$before,$newnum" >/dev/null 2>&1 || true
    fi
}

disk_has_bitlocker() {
    local disk="$1"
    local partition fs

    while IFS= read -r partition; do
        fs="$(blkid -s TYPE -o value "$partition" 2>/dev/null || true)"
        case "$fs" in
        BitLocker*) return 0 ;;
        esac
    done < <(lsblk -no PATH "$disk" 2>/dev/null | tail -n +2)
    return 1
}

add_target() {
    local kind="$1"
    local disk="$2"
    local partition="$3"
    local label="$4"
    local path="$5"
    local partuuid

    partuuid="$(blkid -s PARTUUID -o value "$partition" 2>/dev/null || true)"
    jq -cn \
        --arg kind "$kind" \
        --arg disk "$disk" \
        --arg partition "$partition" \
        --arg partuuid "$partuuid" \
        --arg label "$label" \
        --arg path "$path" \
        '{kind:$kind,disk:$disk,partition:$partition,partuuid:$partuuid,label:$label,path:$path}' \
        >>"$targets_file"
}

scan_esp() {
    local disk="$1"
    local partition="$2"
    local mountpoint="$3"
    local scan_mount="$mountpoint"
    local loader
    local uki
    local entry

    if [ -z "$scan_mount" ]; then
        scan_mount="$(mktemp -d)"
        if ! mount -o ro,nosuid,nodev,noexec "$partition" "$scan_mount"; then
            rmdir "$scan_mount" 2>/dev/null || true
            return 0
        fi
        mounts+=("$scan_mount")
    fi

    if [ -f "$scan_mount/EFI/Microsoft/Boot/bootmgfw.efi" ]; then
        ensure_windows_entry "$partition"
        add_target "windows" "$disk" "$partition" "Windows Boot Manager" "/EFI/Microsoft/Boot/bootmgfw.efi"
    fi

    for loader in "$scan_mount"/EFI/*/grubx64.efi "$scan_mount"/EFI/*/shimx64.efi "$scan_mount"/EFI/systemd/systemd-bootx64.efi; do
        [ -f "$loader" ] || continue
        add_target "linux" "$disk" "$partition" "$(basename "$(dirname "$loader")")" "${loader#"$scan_mount"}"
    done

    for uki in "$scan_mount"/EFI/Linux/*.efi; do
        [ -f "$uki" ] || continue
        add_target "linux" "$disk" "$partition" "$(basename "$uki")" "${uki#"$scan_mount"}"
    done

    for entry in "$scan_mount"/loader/entries/*.conf; do
        [ -f "$entry" ] || continue
        add_target "entry" "$disk" "$partition" "$(basename "$entry")" "${entry#"$scan_mount"}"
    done
}

list_esps() {
    lsblk -J -o PATH,TYPE,RM,TRAN,PARTTYPE,MOUNTPOINT 2>/dev/null |
        jq -r '
            .blockdevices[]
            | select(.type == "disk")
            | select((.rm // false) == false)
            | select((.tran // "") != "usb")
            | .path as $disk
            | .children[]?
            | select((.parttype // "") == "c12a7328-f81f-11d2-ba4b-00a0c93ec93b")
            | [$disk, .path, (.mountpoint // "")] | @tsv
        '
}

copy_helper
write_entry
sign_helper
write_base_config

secure_boot="false"
if secure_boot_enabled; then
    secure_boot="true"
fi
state="$(helper_state)"

ojuny_esp_source="$(findmnt -no SOURCE "$esp_mount" 2>/dev/null || true)"
ojuny_esp_disk=""
if [ -n "$ojuny_esp_source" ]; then
    ojuny_esp_disk="$(lsblk -no PKNAME "$ojuny_esp_source" 2>/dev/null | head -n1 || true)"
fi
ojuny_partuuid="$(esp_partuuid)"
ojuny_boot_partuuid="$(boot_partuuid)"
hide_volumes="$ojuny_partuuid"
if [ -n "$ojuny_boot_partuuid" ] && [ "$ojuny_boot_partuuid" != "$ojuny_partuuid" ]; then
    hide_volumes="${hide_volumes:+$hide_volumes,}$ojuny_boot_partuuid"
fi

targets_file="$(mktemp)"
bitlocker="false"

if [ -n "$ojuny_esp_source" ] && [ -n "$ojuny_esp_disk" ] && [ -f "$esp_mount/EFI/Microsoft/Boot/bootmgfw.efi" ]; then
    ensure_windows_entry "$ojuny_esp_source"
    add_target "windows" "/dev/$ojuny_esp_disk" "$ojuny_esp_source" "Windows Boot Manager" "/EFI/Microsoft/Boot/bootmgfw.efi"
fi
if [ -n "$ojuny_esp_disk" ] && disk_has_bitlocker "/dev/$ojuny_esp_disk"; then
    bitlocker="true"
fi

while IFS=$'\t' read -r disk partition mountpoint; do
    [ -n "$partition" ] || continue
    if same_device "$partition" "$esp_mount" || same_device "$partition" "$boot_mount"; then
        continue
    fi
    if disk_has_bitlocker "$disk"; then
        bitlocker="true"
    fi
    scan_esp "$disk" "$partition" "$mountpoint"
done < <(list_esps)

sort -u "$targets_file" -o "$targets_file"

ojuny_labels="$(ojuny_firmware_labels "$ojuny_partuuid" | paste -sd, -)"
firmware_filters="$ojuny_labels"
if [ "$bitlocker" != "true" ]; then
    firmware_filters="${firmware_filters:+$firmware_filters,}Windows Boot Manager"
fi

write_generated_config "$hide_volumes" "$firmware_filters" "$bitlocker"

jq -s \
    --arg generated_at "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg boot_mount "$boot_mount" \
    --arg esp_mount "$esp_mount" \
    --arg esp_partuuid "$ojuny_partuuid" \
    --arg boot_partuuid "$ojuny_boot_partuuid" \
    --arg helper "$refind_bin" \
    --arg helper_state "$state" \
    --argjson secure_boot "$secure_boot" \
    --argjson bitlocker "$bitlocker" \
    '{schema:1,generated_at:$generated_at,boot_mount:$boot_mount,esp_mount:$esp_mount,esp_partuuid:$esp_partuuid,boot_partuuid:$boot_partuuid,helper:$helper,helper_state:$helper_state,secure_boot:$secure_boot,bitlocker:$bitlocker,systems:.}' \
    "$targets_file" >"$manifest.tmp"
mv "$manifest.tmp" "$manifest"
rm -f "$targets_file"

sync

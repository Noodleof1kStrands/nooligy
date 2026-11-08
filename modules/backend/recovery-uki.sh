recovery_dir="${OJUNY_RECOVERY_DIR:?}"
recovery_file="${OJUNY_RECOVERY_FILE:?}"
manifest="${OJUNY_MANIFEST:?}"
pki_bundle="${OJUNY_PKI_BUNDLE:-}"
stub="${OJUNY_STUB:?}"

install -d "$recovery_dir" "$(dirname "$manifest")"

toplevel="$(readlink -f /run/current-system)"
boot_json="/run/current-system/boot.json"
if [ ! -f "$boot_json" ]; then
    boot_json="/nix/var/nix/profiles/system/boot.json"
fi
if [ ! -f "$boot_json" ]; then
    echo "ojuny-recovery: no bootspec document found" >&2
    exit 1
fi

marker="$recovery_dir/.ojuny-recovery-version"
if [ ! -f "$marker" ] || [ "$(cat "$marker")" != "$toplevel" ] || [ ! -f "$recovery_file" ]; then
    kernel="$(jq -r '.org.nixos.bootspec.v1.kernel // empty' "$boot_json")"
    initrd="$(jq -r '.org.nixos.bootspec.v1.initrd // empty' "$boot_json")"
    init="$(jq -r '.org.nixos.bootspec.v1.init // empty' "$boot_json")"
    params="$(jq -r '(.org.nixos.bootspec.v1.kernelParams // []) | join(" ")' "$boot_json")"
    if [ -z "$kernel" ] || [ -z "$init" ]; then
        echo "ojuny-recovery: bootspec document is missing kernel or init" >&2
        exit 1
    fi
    cmdline="init=$init${params:+ $params}"

    cmdline_file="$(mktemp)"
    trap 'rm -f "$cmdline_file"' EXIT
    printf '%s' "$cmdline" >"$cmdline_file"

    objcopy_args=(
        --add-section ".osrel=/etc/os-release" --change-section-vma .osrel=0x20000
        --add-section ".cmdline=$cmdline_file" --change-section-vma .cmdline=0x30000
        --add-section ".linux=$kernel" --change-section-vma .linux=0x40000
    )
    if [ -n "$initrd" ]; then
        objcopy_args+=(--add-section ".initrd=$initrd" --change-section-vma .initrd=0x3000000)
    fi

    objcopy "${objcopy_args[@]}" "$stub" "$recovery_file.tmp"
    install -m 0644 "$recovery_file.tmp" "$recovery_file"
    rm -f "$recovery_file.tmp"
    printf '%s\n' "$toplevel" >"$marker"
fi

signed="not-required"
if [ -d "$pki_bundle/keys" ]; then
    if sbctl verify "$recovery_file" >/dev/null 2>&1; then
        signed="signed"
    elif sbctl sign -s "$recovery_file" >/dev/null 2>&1; then
        signed="signed"
    else
        signed="unsigned"
    fi
fi

jq -n \
    --arg generated_at "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg toplevel "$toplevel" \
    --arg uki "$recovery_file" \
    --arg signed "$signed" \
    '{schema:1,generated_at:$generated_at,enabled:true,toplevel:$toplevel,uki:$uki,signed:$signed}' \
    >"$manifest.tmp"
mv "$manifest.tmp" "$manifest"

sync

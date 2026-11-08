recovery_dir="${OJUNY_RECOVERY_DIR:?}"
manifest="${OJUNY_MANIFEST:?}"

if [ -d "$recovery_dir" ]; then
    rm -rf "$recovery_dir"
fi
if [ -f "$manifest" ]; then
    rm -f "$manifest"
fi

entry="$(efibootmgr -v 2>/dev/null | awk '/^Boot[0-9A-Fa-f]{4}/ && /Ojuny Recovery/ { print substr($1, 5, 4); exit }')"
if [ -n "$entry" ]; then
    efibootmgr -b "$entry" -B >/dev/null 2>&1 || true
fi

sync

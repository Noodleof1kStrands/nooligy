#!/usr/bin/env python3
import argparse
import importlib.util
import json
import os
import re
import sys
from pathlib import Path

sys.dont_write_bytecode = True

DEFAULT_ROOT = Path(__file__).resolve().parents[1]

ALLOWED_STATES = {"tested", "untested", "unsupported"}
ROW_RE = re.compile(
    r'\{\s*vendor\s*=\s*"([^"]*)"\s*;\s*pattern\s*=\s*"([^"]*)"\s*;'
    r'\s*profile\s*=\s*"([^"]*)"\s*;\s*state\s*=\s*"([^"]*)"\s*;\s*\}',
    re.S,
)
ALIAS_RE = re.compile(
    r'\{\s*vendor\s*=\s*"([^"]*)"\s*;\s*pattern\s*=\s*"([^"]*)"\s*;\s*\}',
    re.S,
)
DOCS_ROW_RE = re.compile(
    r"\|\s*([^|]+?)\s*\|\s*`([^`]+)`\s*\|\s*`([^`]+)`\s*\|\s*([^|]+?)\s*\|"
)
GPU_RE = re.compile(
    r'"([^"]+)"\s*=\s*\{\s*owns\s*=\s*(true|false)\s*;\s*'
    r'variants\s*=\s*\[(.*?)\]\s*;\s*\}\s*;',
    re.S,
)
VARIANT_RE = re.compile(
    r'\{\s*layout\s*=\s*"([^"]+)"\s*(?:;\s*profile\s*=\s*"([^"]+)")?\s*;\s*\}'
)

ASSERTION_ONLY = {
    "asus-zephyrus-ga402x",
    "framework",
    "lenovo-thinkpad-x13",
    "lenovo-yoga-7-14ARH7",
    "microsoft-surface-common",
}

GPU_FIXTURES = {
    "intel": (
        [{"vendor": {"name": "Intel Corporation", "hex": "8086"}, "sysfs_bus_id": "0000:00:02.0"}],
        "intel",
    ),
    "amd": (
        [{"vendor": {"name": "Advanced Micro Devices, Inc. [AMD/ATI]", "hex": "1002"}, "sysfs_bus_id": "0000:05:00.0"}],
        "amd",
    ),
    "nvidia": (
        [{"vendor": {"name": "NVIDIA Corporation", "hex": "10de"}, "sysfs_bus_id": "0000:01:00.0"}],
        "nvidia",
    ),
    "hybrid-intel-nvidia": (
        [
            {"vendor": {"name": "Intel Corporation", "hex": "8086"}, "sysfs_bus_id": "0000:00:02.0"},
            {"vendor": {"name": "NVIDIA Corporation", "hex": "10de"}, "sysfs_bus_id": "0000:01:00.0"},
        ],
        "hybrid-intel-nvidia",
    ),
    "hybrid-amd-nvidia": (
        [
            {"vendor": {"name": "Advanced Micro Devices, Inc. [AMD/ATI]", "hex": "1002"}, "sysfs_bus_id": "0000:05:00.0"},
            {"vendor": {"name": "NVIDIA Corporation", "hex": "10de"}, "sysfs_bus_id": "0000:01:00.0"},
        ],
        "hybrid-amd-nvidia",
    ),
    "hybrid-intel-amd": (
        [
            {"vendor": {"name": "Intel Corporation", "hex": "8086"}, "sysfs_bus_id": "0000:00:02.0"},
            {"vendor": {"name": "Advanced Micro Devices, Inc. [AMD/ATI]", "hex": "1002"}, "sysfs_bus_id": "0000:05:00.0"},
        ],
        "hybrid-intel-amd",
    ),
}

errors = []


def check(condition, message):
    if not condition:
        errors.append(message)


def load_module(script_path):
    spec = importlib.util.spec_from_file_location("regenerate_hardware", script_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def read_block(text, name):
    match = re.search(r"\b%s\s*=\s*\[(.*?)\]\s*;" % re.escape(name), text, re.S)
    if not match:
        raise SystemExit("check-hardware-profile: missing %s block" % name)
    return match.group(1)


def parse_table(text):
    rows = []
    for vendor, pattern, profile, state in ROW_RE.findall(read_block(text, "hardwareProfiles")):
        rows.append((vendor, pattern, profile, state))
    return rows


def parse_aliases(text):
    return ALIAS_RE.findall(read_block(text, "vendorAliases"))


def parse_choices(text):
    match = re.search(r"choices = \[(.*?)\];", text, re.S)
    if not match:
        raise SystemExit("check-hardware-profile: missing choices list in 09-facter.nix")
    return re.findall(r'"([^"]*)"', match.group(1))


def parse_gpu_profiles(text):
    profiles = {}
    for slug, owns, variants_text in GPU_RE.findall(text):
        variants = [
            {"layout": layout, **({"profile": profile} if profile else {})}
            for layout, profile in VARIANT_RE.findall(variants_text)
        ]
        profiles[slug] = {"owns": owns == "true", "variants": variants}
    return profiles


def supported_profiles(rows, gpu_profiles):
    profiles = {row[2] for row in rows if row[3] != "unsupported"}
    for meta in gpu_profiles.values():
        for variant in meta["variants"]:
            if variant.get("profile"):
                profiles.add(variant["profile"])
    return sorted(profiles)


def upstream_slugs():
    configured = os.environ.get("NIXOS_HARDWARE_PATH")
    candidates = ([Path(configured)] if configured else []) + [
        Path.home() / "repos/nixos-hardware",
    ]
    for candidate in candidates:
        flake = candidate / "flake.nix"
        if flake.is_file():
            text = flake.read_text()
            return set(
                re.findall(r'^\s{10}([A-Za-z0-9][A-Za-z0-9-]*)\s*=\s*(?:import|deprecated)', text, re.M)
            )
    return None


def gpu_report(cards):
    report = {"smbios": {"system": {"manufacturer": "Test", "product": "Test"}}}
    if cards is not None:
        report["hardware"] = {"graphics_card": cards}
    return report


def parse_docs(text):
    rows = []
    for line in text.splitlines():
        match = DOCS_ROW_RE.fullmatch(line.strip())
        if match:
            rows.append(tuple(part.strip() for part in match.groups()))
    return rows


def main():
    parser = argparse.ArgumentParser(
        description="Check the ojuny hardware profile mapping and coverage table."
    )
    parser.add_argument("--root", default=str(DEFAULT_ROOT), help="Repository path.")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    module_path = root / "modules/07-system/10-hardware-profile.nix"
    page_path = root / "modules/07-system/09-facter.nix"
    script_path = root / "scripts/regenerate-hardware.py"
    fixture_path = root / "tests/fixtures/facter-surface-go.json"
    docs_path = root / "docs/hardware-coverage.md"

    module = load_module(script_path)
    table_text = module_path.read_text()
    page_text = page_path.read_text()

    nix_rows = parse_table(table_text)
    nix_gpu = parse_gpu_profiles(table_text)
    nix_aliases = parse_aliases(table_text)
    choices = parse_choices(page_text)
    docs_rows = parse_docs(docs_path.read_text())

    check(
        nix_rows == module.HARDWARE_PROFILES,
        "10-hardware-profile.nix and scripts/regenerate-hardware.py tables differ",
    )
    check(
        nix_gpu == module.GPU_PROFILES,
        "10-hardware-profile.nix and scripts/regenerate-hardware.py GPU tables differ",
    )
    check(
        nix_aliases == module.VENDOR_ALIASES,
        "10-hardware-profile.nix and scripts/regenerate-hardware.py vendor aliases differ",
    )

    states = {row[3] for row in nix_rows}
    check(states <= ALLOWED_STATES, "unexpected coverage state: %s" % sorted(states - ALLOWED_STATES))

    table_profiles = {row[2] for row in nix_rows}
    selected = table_profiles | {
        variant.get("profile")
        for meta in nix_gpu.values()
        for variant in meta["variants"]
        if variant.get("profile")
    }
    assertion_only = sorted(selected & ASSERTION_ONLY)
    check(not assertion_only, "assertion-only slug selected: %s" % assertion_only)
    missing = sorted(set(nix_gpu) - table_profiles)
    check(not missing, "gpuProfiles key is not in the profile table: %s" % missing)

    quirk_dir = root / "modules/07-system/quirks"
    for profile in sorted(p for p in table_profiles if p.startswith("ojuny-")):
        quirk_path = quirk_dir / ("%s.nix" % profile[len("ojuny-"):])
        check(
            quirk_path.exists(),
            "missing Ojuny quirk module for %s: %s" % (profile, quirk_path),
        )
        if quirk_path.exists():
            check(
                ("flake.modules.nixos.%s" % profile) in quirk_path.read_text(),
                "Ojuny quirk module %s does not define flake.modules.nixos.%s"
                % (quirk_path, profile),
            )

    upstream = upstream_slugs()
    if upstream is not None:
        missing_upstream = sorted(
            profile
            for profile in selected
            if not profile.startswith("ojuny-") and profile not in upstream
        )
        check(
            not missing_upstream,
            "profile slug is not in the nixos-hardware checkout: %s" % missing_upstream,
        )

    supported = supported_profiles(nix_rows, nix_gpu)
    check(choices[:1] == ["auto"], "dropdown must start with auto")
    check(choices[1:] == supported, "dropdown choices do not match the supported profiles")
    check(choices[1:] == sorted(choices[1:]), "dropdown profile choices are not sorted")

    check(
        [tuple(row) for row in docs_rows] == nix_rows,
        "docs/hardware-coverage.md rows do not match the coverage table",
    )

    fixture = json.loads(fixture_path.read_text())
    surface = module.detect_profile(fixture)
    check(surface["vendor"] == "microsoft", "Surface Go vendor was not detected as microsoft")
    check(
        surface["profile"] == "microsoft-surface-go",
        "Surface Go did not select microsoft-surface-go",
    )
    check(surface["state"] == "untested", "Surface Go state is not untested")

    for name, (cards, expected) in GPU_FIXTURES.items():
        detection = module.detect_profile(gpu_report(cards))
        check(
            detection["gpu"]["layout"] == expected,
            "GPU fixture %s detected as %s, expected %s"
            % (name, detection["gpu"]["layout"], expected),
        )

    no_gpu = module.detect_profile(gpu_report(None))
    check(
        no_gpu["gpu"]["layout"] == "unknown",
        "missing graphics_card must produce an unknown layout",
    )
    empty_gpu = module.detect_profile(gpu_report([]))
    check(
        empty_gpu["gpu"]["layout"] == "unknown",
        "empty graphics_card must produce an unknown layout",
    )

    dell_hybrid = {
        "smbios": {"system": {"manufacturer": "Dell Inc.", "product": "XPS 15 9520"}},
        "hardware": {
            "graphics_card": [
                {"vendor": {"name": "Intel Corporation", "hex": "8086"}, "sysfs_bus_id": "0000:00:02.0"},
                {"vendor": {"name": "NVIDIA Corporation", "hex": "10de"}, "sysfs_bus_id": "0000:01:00.0"},
            ]
        },
    }
    dell = module.detect_profile(dell_hybrid)
    check(
        dell["profile"] == "dell-xps-15-9520-nvidia",
        "Dell XPS 15 9520 hybrid did not select the NVIDIA variant",
    )
    check(dell["gpu"]["managed"], "Dell XPS 15 9520 hybrid must be marked managed")
    check(
        dell["gpu"]["busIds"]["nvidia"] == "PCI:1:0:0",
        "Dell XPS 15 9520 NVIDIA bus ID was not derived from sysfs",
    )

    dell_intel = {
        "smbios": {"system": {"manufacturer": "Dell Inc.", "product": "XPS 15 9520"}},
        "hardware": {
            "graphics_card": [
                {"vendor": {"name": "Intel Corporation", "hex": "8086"}, "sysfs_bus_id": "0000:00:02.0"},
            ]
        },
    }
    check(
        module.detect_profile(dell_intel)["profile"] == "dell-xps-15-9520",
        "Dell XPS 15 9520 Intel-only did not select the base profile",
    )

    framework_12 = {
        "smbios": {"system": {"manufacturer": "Framework", "product": "Laptop 12 (13th Gen Intel Core)"}},
        "hardware": {
            "graphics_card": [
                {"vendor": {"name": "Intel Corporation", "hex": "8086"}, "sysfs_bus_id": "0000:00:02.0"},
            ]
        },
    }
    check(
        module.detect_profile(framework_12)["profile"] == "framework-12-13th-gen-intel",
        "Framework 12 did not select its profile",
    )

    lenovo_version = {
        "smbios": {
            "system": {
                "manufacturer": "LENOVO",
                "product": "20QDCTO1WW",
                "version": "ThinkPad X1 Carbon 7th",
            }
        }
    }
    check(
        module.detect_profile(lenovo_version)["vendor"] == "lenovo",
        "Lenovo manufacturer was not normalized",
    )

    lenovo_t14 = {
        "smbios": {
            "system": {
                "manufacturer": "LENOVO",
                "product": "20S0CTO1WW",
                "version": "ThinkPad T14 Gen 1",
            }
        }
    }
    check(
        module.detect_profile(lenovo_t14)["profile"] == "lenovo-thinkpad-t14-intel-gen1",
        "Lenovo product version did not select the T14 profile",
    )

    lenovo_yoga = {
        "smbios": {
            "system": {
                "manufacturer": "LENOVO",
                "product": "82N7CTO1WW",
                "version": "Yoga 7 14ARH7",
            }
        },
        "hardware": {
            "graphics_card": [
                {"vendor": {"name": "Advanced Micro Devices, Inc. [AMD/ATI]", "hex": "1002"}, "sysfs_bus_id": "0000:05:00.0"},
            ]
        },
    }
    check(
        module.detect_profile(lenovo_yoga)["profile"] == "lenovo-yoga-7-14ARH7-amdgpu",
        "Lenovo Yoga 7 did not select the AMDGPU profile",
    )

    unknown = module.detect_profile(
        {"smbios": {"system": {"manufacturer": "Acme", "product": "Unknown 1"}}}
    )
    check(unknown["profile"] == "unmatched", "unknown product did not return unmatched")
    check(unknown["state"] == "unmatched", "unknown product state is not unmatched")

    check(
        module.selected_profile(fixture, "auto") == "microsoft-surface-go",
        "auto selection did not pick the Surface Go profile",
    )

    unsupported = {
        "smbios": {"system": {"manufacturer": "Samsung", "product": "NP900X3C"}}
    }
    check(
        module.selected_profile(unsupported, "auto") is None,
        "auto selection must not pick an unsupported profile",
    )
    check(
        module.selected_profile(unsupported, "samsung-np900x3c") == "samsung-np900x3c",
        "explicit selection must honour an unsupported profile",
    )

    if errors:
        for error in errors:
            print("check-hardware-profile: %s" % error, file=sys.stderr)
        return 1

    print(
        "check-hardware-profile: ok (%d rows, %d supported, Surface Go -> %s)"
        % (len(nix_rows), len(supported), surface["profile"])
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())

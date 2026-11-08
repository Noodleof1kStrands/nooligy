#!/usr/bin/env python3
import argparse
import json
import os
import re
import subprocess
import sys


# The coverage table lives in modules/backend/10-hardware-profile.nix.
# tests/check-hardware-profile.py asserts that this table still matches it.
HARDWARE_PROFILES = [
    ("apple", ".*macbookpro.*", "apple-macbook-pro", "untested"),
    ("apple", ".*macbookair7,.*", "apple-macbook-air-3", "untested"),
    ("apple", ".*macbookair8,.*", "apple-macbook-air-4", "untested"),
    ("apple", ".*macbookair9,.*", "apple-macbook-air-5", "untested"),
    ("apple", ".*macmini.*", "apple-macmini-4-1", "untested"),
    ("asus", ".*g533q.*", "asus-rog-strix-g533q", "untested"),
    ("asus", ".*g533zw.*", "asus-rog-strix-g533zw", "untested"),
    ("asus", ".*ga401iv.*", "asus-zephyrus-ga401iv", "untested"),
    ("asus", ".*ga401.*", "asus-zephyrus-ga401", "untested"),
    ("asus", ".*ga402x.*", "asus-zephyrus-ga402x-amdgpu", "untested"),
    ("asus", ".*ga402.*", "asus-zephyrus-ga402", "untested"),
    ("asus", ".*hn7306eac.*", "asus-proart-px13-hn7306eac", "untested"),
    ("asus", ".*px13.*", "asus-proart-px13", "untested"),
    ("asus", ".*g513.*", "asus-rog-strix-g513im", "untested"),
    ("asus", ".*g713.*", "asus-rog-strix-g713ie", "untested"),
    ("asus", ".*g733.*", "asus-rog-strix-g733qs", "untested"),
    ("asus", ".*ga503.*", "asus-zephyrus-ga503", "untested"),
    ("asus", ".*gu603.*", "asus-zephyrus-gu603h", "untested"),
    ("asus", ".*ux371.*", "asus-zenbook-ux371", "untested"),
    ("asus", ".*ux535.*", "asus-zenbook-ux535", "untested"),
    ("asus", ".*fx506.*", "asus-fx506hm", "untested"),
    ("asus", ".*fa506.*", "asus-fa506nc", "untested"),
    ("asus", ".*fa507.*", "asus-fa507nv", "untested"),
    ("asus", ".*rog strix x570.*", "asus-rog-strix-x570e", "untested"),
    ("asus", ".*rog ally rc71l.*", "asus-ally-rc71l", "untested"),
    ("asus", ".*gv302x.*", "asus-flow-gv302x-amdgpu", "untested"),
    ("asus", ".*gz301vu.*", "asus-flow-gz301vu", "untested"),
    ("asus", ".*gl552vw.*", "asus-rog-gl552vw", "untested"),
    ("asus", ".*ga502.*", "asus-zephyrus-ga502", "untested"),
    ("asus", ".*gu605cw.*", "asus-zephyrus-gu605cw", "untested"),
    ("asus", ".*gu605my.*", "asus-zephyrus-gu605my", "untested"),
    ("asus", ".*pro ws x570.*", "asus-pro-ws-x570-ace", "untested"),
    ("asus", ".*b9406.*", "ojuny-asus-expertbook-b9406", "untested"),
    ("asus", ".*ux5406aa.*", "ojuny-asus-zenbook-ux5406aa", "untested"),
    ("asus", ".*gz302.*", "ojuny-asus-rog-z13-gz302", "untested"),
    ("chuwi", ".*minibook x.*", "chuwi-minibook-x", "untested"),
    ("dell", ".*xps 13 9370.*", "dell-xps-13-9370", "untested"),
    ("dell", ".*xps 13 9380.*", "dell-xps-13-9380", "untested"),
    ("dell", ".*xps 13 9300.*", "dell-xps-13-9300", "untested"),
    ("dell", ".*xps 13 9310.*", "dell-xps-13-9310", "untested"),
    ("dell", ".*xps 13 9315.*", "dell-xps-13-9315", "untested"),
    ("dell", ".*xps 13 9343.*", "dell-xps-13-9343", "untested"),
    ("dell", ".*xps 15 9500.*", "dell-xps-15-9500", "untested"),
    ("dell", ".*xps 15 9510.*", "dell-xps-15-9510", "untested"),
    ("dell", ".*xps 15 9520.*", "dell-xps-15-9520", "untested"),
    ("dell", ".*xps 15 9530.*", "dell-xps-15-9530", "untested"),
    ("dell", ".*xps 15 9550.*", "dell-xps-15-9550", "untested"),
    ("dell", ".*latitude 7420.*", "dell-latitude-7420", "untested"),
    ("dell", ".*latitude 7430.*", "dell-latitude-7430", "untested"),
    ("dell", ".*latitude 7490.*", "dell-latitude-7490", "untested"),
    ("dell", ".*precision 5560.*", "dell-precision-5560", "untested"),
    ("dell", ".*precision 5570.*", "dell-precision-5570", "untested"),
    ("dell", ".*xps 13 7390.*", "dell-xps-13-7390", "untested"),
    ("dell", ".*xps 13 9333.*", "dell-xps-13-9333", "untested"),
    ("dell", ".*xps 13 9350.*", "dell-xps-13-9350", "untested"),
    ("dell", ".*xps 13 9360.*", "dell-xps-13-9360", "untested"),
    ("dell", ".*xps 15 7590.*", "dell-xps-15-7590", "untested"),
    ("dell", ".*xps 15 9560.*", "dell-xps-15-9560-nvidia", "untested"),
    ("dell", ".*xps 15 9570.*", "dell-xps-15-9570-nvidia", "untested"),
    ("dell", ".*xps 17 9700.*", "dell-xps-17-9700-intel", "untested"),
    ("dell", ".*xps 17 9710.*", "dell-xps-17-9710-intel", "untested"),
    ("framework", ".*laptop 13.*7040.*", "framework-13-7040-amd", "untested"),
    ("framework", ".*laptop 13.*12th.*", "framework-12th-gen-intel", "untested"),
    ("framework", ".*laptop 13.*11th.*", "framework-11th-gen-intel", "untested"),
    ("framework", ".*laptop 13.*13th.*", "framework-13th-gen-intel", "untested"),
    ("framework", ".*laptop 13.*core ultra.*1.*", "framework-intel-core-ultra-series1", "untested"),
    ("framework", ".*laptop 13.*ai 300.*", "framework-amd-ai-300-series", "untested"),
    ("framework", ".*laptop 16.*7040.*", "framework-16-7040-amd", "untested"),
    ("framework", ".*laptop 16.*ai 300.*", "framework-16-amd-ai-300-series", "untested"),
    ("framework", ".*laptop 12.*13th.*", "framework-12-13th-gen-intel", "untested"),
    ("framework", ".*laptop 13.*core ultra.*3.*", "framework-intel-core-ultra-series3", "untested"),
    ("framework", ".*framework desktop.*", "framework-desktop-amd-ai-max-300-series", "untested"),
    ("gigabyte", ".*b550.*", "gigabyte-b550", "untested"),
    ("gigabyte", ".*b650.*", "gigabyte-b650", "untested"),
    ("google", ".*pixelbook.*", "google-pixelbook", "untested"),
    ("google", ".*brya.*", "google-brya", "untested"),
    ("google", ".*rex.*", "google-rex", "untested"),
    ("gpd", ".*pocket 3.*", "gpd-pocket-3", "untested"),
    ("gpd", ".*pocket 4.*", "gpd-pocket-4", "untested"),
    ("gpd", ".*win 2.*", "gpd-win-2", "untested"),
    ("gpd", ".*win max 2.*", "gpd-win-max-2-2023", "untested"),
    ("gpd", ".*win mini.*", "gpd-win-mini-2024", "untested"),
    ("hp", ".*elitebook 830 g6.*", "hp-elitebook-830g6", "untested"),
    ("hp", ".*elitebook 845 g7.*", "hp-elitebook-845g7", "untested"),
    ("hp", ".*elitebook 845 g8.*", "hp-elitebook-845g8", "untested"),
    ("hp", ".*elitebook 845 g9.*", "hp-elitebook-845g9", "untested"),
    ("hp", ".*probook 440 g5.*", "hp-probook-440G5", "untested"),
    ("hp", ".*probook 460 g11.*", "hp-probook-460G11", "untested"),
    ("hp", ".*laptop 14s.*", "hp-laptop-14s-dq2024nf", "untested"),
    ("hp", ".*laptop 15s.*", "hp-laptop-15s-fq1xxx", "untested"),
    ("hp", ".*omen 14.*", "omen-14-fb0798ng", "untested"),
    ("hp", ".*omen 16.*", "omen-16-n0005ne", "untested"),
    ("huawei", ".*machc.*", "huawei-machc-wa", "untested"),
    ("intel", ".*nuc.*", "intel-nuc-12wshi7", "untested"),
    ("lenovo", ".*x1 carbon.*7th.*", "lenovo-thinkpad-x1-7th-gen", "untested"),
    ("lenovo", ".*x1 carbon.*9th.*", "lenovo-thinkpad-x1-9th-gen", "untested"),
    ("lenovo", ".*x1 carbon.*10th.*", "lenovo-thinkpad-x1-10th-gen", "untested"),
    ("lenovo", ".*x1 carbon.*11th.*", "lenovo-thinkpad-x1-11th-gen", "untested"),
    ("lenovo", ".*20qd.*", "lenovo-thinkpad-x1-7th-gen", "untested"),
    ("lenovo", ".*20xw.*", "lenovo-thinkpad-x1-9th-gen", "untested"),
    ("lenovo", ".*21cb.*", "lenovo-thinkpad-x1-10th-gen", "untested"),
    ("lenovo", ".*21hm.*", "lenovo-thinkpad-x1-11th-gen", "untested"),
    ("lenovo", ".*thinkpad x1 carbon.*", "lenovo-thinkpad-x1", "untested"),
    ("lenovo", ".*thinkpad t14.*gen 1.*", "lenovo-thinkpad-t14-intel-gen1", "untested"),
    ("lenovo", ".*thinkpad t14s.*", "lenovo-thinkpad-t14s", "untested"),
    ("lenovo", ".*thinkpad x13.*", "lenovo-thinkpad-x13-intel", "untested"),
    ("lenovo", ".*yoga 7 14arh7.*", "lenovo-yoga-7-14ARH7-amdgpu", "untested"),
    ("lenovo", ".*yoga 6 13alc6.*", "lenovo-yoga-6-13ALC6", "untested"),
    ("lenovo", ".*ideapad 15ach6.*", "lenovo-ideapad-15ach6", "untested"),
    ("lenovo", ".*legion 5.*", "lenovo-legion-15ach6h", "untested"),
    ("lenovo", ".*yoga pro 7 14iah10.*", "ojuny-lenovo-yoga-pro-7-14iah10", "untested"),
    ("microsoft", ".*surface go.*", "microsoft-surface-go", "untested"),
    ("microsoft", ".*surface pro 3.*", "microsoft-surface-pro-3", "untested"),
    ("microsoft", ".*surface pro 9.*", "microsoft-surface-pro-9", "untested"),
    ("microsoft", ".*surface pro.*", "microsoft-surface-pro-intel", "untested"),
    ("microsoft", ".*surface laptop.*amd.*", "microsoft-surface-laptop-amd", "untested"),
    ("msi", ".*gf63.*", "msi-gf63", "untested"),
    ("msi", ".*gs60.*", "msi-gs60", "untested"),
    ("msi", ".*gl62.*", "msi-gl62", "untested"),
    ("msi", ".*gl65.*", "msi-gl65-10SDR-492", "untested"),
    ("msi", ".*prestige 15.*", "msi-prestige-15-a10sc", "untested"),
    ("msi", ".*b550.*", "msi-b550-tomahawk", "untested"),
    ("panasonic", ".*cf-lx3.*", "letsnote-cf-lx3", "untested"),
    ("panasonic", ".*cf-lx4.*", "letsnote-cf-lx4", "untested"),
    ("purism", ".*librem 13.*", "purism-librem-13v3", "untested"),
    ("purism", ".*librem 15.*", "purism-librem-15v3", "untested"),
    ("razer", ".*blade 14.*", "razer-blade-14-RZ09-0530", "untested"),
    ("samsung", ".*np900x3c.*", "samsung-np900x3c", "unsupported"),
    ("slimbook", ".*hero.*", "slimbook-hero-rpl-rtx", "untested"),
    ("starlabs", ".*starlite.*", "starlabs-starlite-i5", "untested"),
    ("system76", ".*gaze.*", "system76-gaze18", "untested"),
    ("system76", ".*galago.*", "system76-galp5-1650", "untested"),
    ("system76", ".*darter.*", "system76-darp6", "untested"),
    ("system76", ".*thelio.*", "system76-thelio-mega", "untested"),
    ("system76", ".*", "system76", "untested"),
    ("toshiba", ".*satellite.*", "toshiba-swanky", "unsupported"),
    ("tuxedo", ".*aura 15.*", "tuxedo-aura-15-gen1", "untested"),
    ("tuxedo", ".*infinitybook.*14.*gen 9.*intel.*", "tuxedo-infinitybook-pro14-gen9-intel", "untested"),
    ("tuxedo", ".*infinitybook.*14.*gen 9.*amd.*", "tuxedo-infinitybook-pro14-gen9-amd", "untested"),
    ("tuxedo", ".*infinitybook.*14.*gen 10.*amd.*", "tuxedo-infinitybook-pro14-gen10-amd", "untested"),
    ("tuxedo", ".*infinitybook.*15.*gen 10.*amd.*", "tuxedo-infinitybook-pro15-gen10-amd", "untested"),
    ("tuxedo", ".*pulse 14.*", "tuxedo-pulse-14-gen3", "untested"),
    ("tuxedo", ".*pulse 15.*", "tuxedo-pulse-15-gen2", "untested"),
    ("xiaomi", ".*redmibook 15.*", "xiaomi-redmibook-15-pro-2021", "untested"),
    ("xiaomi", ".*redmibook 16.*", "xiaomi-redmibook-16-pro-2024", "untested"),
]

GPU_PROFILES = {
    "asus-ally-rc71l": {"owns": True, "variants": [{"layout": "amd"}]},
    "asus-flow-gv302x-amdgpu": {"owns": True, "variants": [{"layout": "amd"}, {"layout": "hybrid-amd-nvidia", "profile": "asus-flow-gv302x-nvidia"}]},
    "asus-flow-gz301vu": {"owns": True, "variants": [{"layout": "hybrid-intel-nvidia"}]},
    "asus-proart-px13": {"owns": True, "variants": [{"layout": "amd"}]},
    "asus-proart-px13-hn7306eac": {"owns": True, "variants": [{"layout": "amd"}]},
    "asus-rog-gl552vw": {"owns": True, "variants": [{"layout": "hybrid-intel-nvidia"}]},
    "asus-rog-strix-g513im": {"owns": True, "variants": [{"layout": "hybrid-amd-nvidia"}]},
    "asus-rog-strix-g533q": {"owns": True, "variants": [{"layout": "hybrid-amd-nvidia"}]},
    "asus-rog-strix-g533zw": {"owns": True, "variants": [{"layout": "hybrid-intel-nvidia"}]},
    "asus-rog-strix-g713ie": {"owns": True, "variants": [{"layout": "hybrid-amd-nvidia"}]},
    "asus-rog-strix-g733qs": {"owns": True, "variants": [{"layout": "hybrid-amd-nvidia"}]},
    "asus-zephyrus-ga401": {"owns": True, "variants": [{"layout": "hybrid-amd-nvidia"}]},
    "asus-zephyrus-ga401iv": {"owns": True, "variants": [{"layout": "hybrid-amd-nvidia"}]},
    "asus-zephyrus-ga402": {"owns": True, "variants": [{"layout": "amd"}]},
    "asus-zephyrus-ga402x-amdgpu": {"owns": True, "variants": [{"layout": "amd"}, {"layout": "hybrid-amd-nvidia", "profile": "asus-zephyrus-ga402x-nvidia"}]},
    "asus-zephyrus-ga502": {"owns": True, "variants": [{"layout": "hybrid-amd-nvidia"}]},
    "asus-zephyrus-ga503": {"owns": True, "variants": [{"layout": "hybrid-amd-nvidia"}]},
    "asus-zephyrus-gu603h": {"owns": True, "variants": [{"layout": "hybrid-intel-nvidia"}]},
    "asus-zephyrus-gu605cw": {"owns": True, "variants": [{"layout": "hybrid-intel-nvidia"}]},
    "asus-zephyrus-gu605my": {"owns": True, "variants": [{"layout": "hybrid-intel-nvidia"}]},
    "dell-xps-15-7590": {"owns": True, "variants": [{"layout": "intel"}, {"layout": "hybrid-intel-nvidia", "profile": "dell-xps-15-7590-nvidia"}]},
    "dell-xps-15-9500": {"owns": True, "variants": [{"layout": "intel"}, {"layout": "hybrid-intel-nvidia", "profile": "dell-xps-15-9500-nvidia"}]},
    "dell-xps-15-9510": {"owns": True, "variants": [{"layout": "intel"}, {"layout": "hybrid-intel-nvidia", "profile": "dell-xps-15-9510-nvidia"}]},
    "dell-xps-15-9520": {"owns": True, "variants": [{"layout": "intel"}, {"layout": "hybrid-intel-nvidia", "profile": "dell-xps-15-9520-nvidia"}]},
    "dell-xps-15-9530": {"owns": True, "variants": [{"layout": "intel"}, {"layout": "hybrid-intel-nvidia", "profile": "dell-xps-15-9530-nvidia"}]},
    "dell-xps-15-9550": {"owns": True, "variants": [{"layout": "intel"}, {"layout": "hybrid-intel-nvidia", "profile": "dell-xps-15-9550-nvidia"}]},
    "dell-xps-15-9560-nvidia": {"owns": True, "variants": [{"layout": "hybrid-intel-nvidia"}, {"layout": "intel", "profile": "dell-xps-15-9560-intel"}]},
    "dell-xps-15-9570-nvidia": {"owns": True, "variants": [{"layout": "hybrid-intel-nvidia"}, {"layout": "intel", "profile": "dell-xps-15-9570-intel"}]},
    "dell-xps-17-9700-intel": {"owns": True, "variants": [{"layout": "intel"}, {"layout": "hybrid-intel-nvidia", "profile": "dell-xps-17-9700-nvidia"}]},
    "dell-xps-17-9710-intel": {"owns": True, "variants": [{"layout": "intel"}]},
    "framework-13-7040-amd": {"owns": True, "variants": [{"layout": "amd"}]},
    "framework-16-7040-amd": {"owns": True, "variants": [{"layout": "amd"}]},
    "framework-16-amd-ai-300-series": {"owns": True, "variants": [{"layout": "amd"}, {"layout": "hybrid-amd-nvidia", "profile": "framework-16-amd-ai-300-series-nvidia"}]},
    "framework-desktop-amd-ai-max-300-series": {"owns": True, "variants": [{"layout": "amd"}]},
    "framework-amd-ai-300-series": {"owns": True, "variants": [{"layout": "amd"}]},
    "hp-elitebook-845g7": {"owns": True, "variants": [{"layout": "amd"}]},
    "hp-elitebook-845g8": {"owns": True, "variants": [{"layout": "amd"}]},
    "hp-elitebook-845g9": {"owns": True, "variants": [{"layout": "amd"}]},
    "lenovo-ideapad-15ach6": {"owns": True, "variants": [{"layout": "amd"}]},
    "lenovo-legion-15ach6h": {"owns": True, "variants": [{"layout": "hybrid-amd-nvidia"}]},
    "lenovo-yoga-6-13ALC6": {"owns": True, "variants": [{"layout": "amd"}]},
    "lenovo-yoga-7-14ARH7-amdgpu": {"owns": True, "variants": [{"layout": "amd"}, {"layout": "hybrid-amd-nvidia", "profile": "lenovo-yoga-7-14ARH7-nvidia"}]},
}

VENDOR_ALIASES = [
    ("apple", ".*apple.*"),
    ("asus", ".*asus.*"),
    ("asus", ".*asustek.*"),
    ("chuwi", ".*chuwi.*"),
    ("dell", ".*dell.*"),
    ("framework", ".*framework.*"),
    ("gigabyte", ".*gigabyte.*"),
    ("google", ".*google.*"),
    ("gpd", ".*gpd.*"),
    ("hp", ".*hewlett.*packard.*"),
    ("hp", ".*hp.*"),
    ("hp", ".*omen.*"),
    ("huawei", ".*huawei.*"),
    ("intel", ".*intel.*"),
    ("lenovo", ".*lenovo.*"),
    ("microsoft", ".*microsoft.*"),
    ("msi", ".*micro.star.*"),
    ("msi", ".*msi.*"),
    ("panasonic", ".*panasonic.*"),
    ("purism", ".*purism.*"),
    ("razer", ".*razer.*"),
    ("samsung", ".*samsung.*"),
    ("slimbook", ".*slimbook.*"),
    ("starlabs", ".*star.?labs.*"),
    ("system76", ".*system76.*"),
    ("toshiba", ".*toshiba.*"),
    ("toshiba", ".*dynabook.*"),
    ("tuxedo", ".*tuxedo.*"),
    ("xiaomi", ".*xiaomi.*"),
]


def nix_string(value):
    text = str(value).replace("${", "''${")
    return json.dumps(text, ensure_ascii=False)


def run(command):
    result = subprocess.run(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(
            "command failed ({}): {}\n{}".format(
                result.returncode, " ".join(command), result.stdout
            )
        )
    return result.stdout


def fix_btrfs_subvolumes(hardware):
    if 'fsType = "btrfs"' not in hardware:
        return hardware

    for mount_point, subvolume in {"/home": "home", "/nix": "nix"}.items():
        pattern = r'(fileSystems\."{}"[^;]*"subvol=)[^"]*"'.format(
            re.escape(mount_point)
        )
        hardware = re.sub(
            pattern,
            '\\g<1>{}\"'.format(subvolume),
            hardware,
            flags=re.DOTALL,
        )
    return hardware


def root_is_btrfs(hardware):
    return re.search(
        r'fileSystems\."/"\s*=\s*\{[^}]*fsType\s*=\s*"btrfs"',
        hardware,
        re.DOTALL,
    ) is not None


def luks_device_lines(hardware=""):
    """One boot.initrd.luks.devices line per open LUKS device.

    The mapper name comes from the crypt node; the UUID is the encrypted
    parent partition's UUID, not the filesystem UUID inside the mapper.
    """
    try:
        report = json.loads(run(["lsblk", "-J", "-o", "NAME,TYPE,UUID"]))
    except Exception:
        return []
    lines = []

    def walk(node, parent_uuid=None):
        if node.get("type") == "crypt":
            name = node.get("name")
            uuid = parent_uuid or node.get("uuid")
            if name and uuid and 'boot.initrd.luks.devices."{}"'.format(name) not in hardware:
                line = 'boot.initrd.luks.devices."{}".device = "/dev/disk/by-uuid/{}";'.format(
                    name, uuid
                )
                if line not in lines:
                    lines.append(line)
        for child in node.get("children") or []:
            walk(child, node.get("uuid") or parent_uuid)

    for node in report.get("blockdevices", []):
        walk(node)
    return lines


def bootloader_module(firmware, device, extra_lines, btrfs_root):
    lines = []
    if firmware == "efi":
        lines += [
            "boot.loader.systemd-boot.enable = true;",
            "boot.loader.efi.canTouchEfiVariables = true;",
        ]
    elif firmware == "bios" and device:
        lines += [
            "boot.loader.grub.enable = true;",
            "boot.loader.grub.device = {};".format(nix_string(device)),
            "boot.loader.grub.useOSProber = true;",
        ]
        if btrfs_root:
            lines.append('boot.loader.grub.fsIdentifier = "provided";')
    else:
        lines.append("boot.loader.grub.enable = false;")

    lines += extra_lines
    return "\n".join("    " + line if line else line for line in lines)


def hardware_module(hardware, firmware, device, extra_lines):
    indented = "\n".join(
        "    " + line if line else line for line in hardware.splitlines()
    )
    return """# Generated by scripts/regenerate-hardware.py. Do not edit by hand.
{{ self, inputs, ... }}: {{

  flake.modules.nixos.system-hardware =
{hardware}
  ;

  flake.modules.nixos.system-bootloader = {{ pkgs, ... }}: {{
{bootloader}
  }};

}}
""".format(
        hardware=indented,
        bootloader=bootloader_module(
            firmware, device, extra_lines, root_is_btrfs(hardware)
        ),
    )


def profile_module(profile):
    if profile:
        if profile.startswith("ojuny-"):
            target = "self.modules.nixos.{}".format(profile)
        else:
            target = "inputs.nixos-hardware.nixosModules.{}".format(profile)
        imports = (
            "    imports = [\n"
            "      {}\n"
            "    ];\n"
        ).format(target)
    else:
        imports = "    imports = [ ];\n"

    return """# Generated by scripts/regenerate-hardware.py. Do not edit by hand.
{{ self, inputs, ... }}: {{

  flake.modules.nixos.system-hardware-quirks = {{ ... }}: {{
{imports}  }};

}}
""".format(imports=imports)


def detect_boot_device(repo):
    try:
        source = run(["findmnt", "-no", "SOURCE", "/"]).strip()
        if source:
            parent = run(["lsblk", "-no", "PKNAME", source]).strip()
            if parent:
                return "/dev/{}".format(parent)
            return source
    except Exception:
        pass

    hardware_path = os.path.join(repo, "modules/07-system/00-hardware.nix")
    if os.path.exists(hardware_path):
        with open(hardware_path) as handle:
            match = re.search(
                r'boot\.loader\.grub\.device\s*=\s*"([^"]+)"', handle.read()
            )
            if match:
                return match.group(1)

    return None


def detect_vendor(manufacturer):
    lowered = manufacturer.lower()
    for vendor, pattern in VENDOR_ALIASES:
        if re.fullmatch(pattern, lowered):
            return vendor
    return "unknown"


def to_bus_id(sysfs):
    if not sysfs:
        return None
    try:
        _domain, bus, devfn = sysfs.split(":")
        device, function = devfn.split(".")
        return "PCI:%d:%d:%d" % (int(bus, 16), int(device, 16), int(function, 16))
    except ValueError:
        return None


def card_vendor(card):
    vendor = card.get("vendor") or {}
    return str(vendor.get("name", "")).lower(), str(vendor.get("hex", "")).lower()


def is_intel(card):
    name, hex_id = card_vendor(card)
    return "intel" in name or hex_id == "8086"


def is_amd(card):
    name, hex_id = card_vendor(card)
    return hex_id in ("1002", "1022") or "advanced micro devices" in name or "ati " in name or name == "ati"


def is_nvidia(card):
    name, hex_id = card_vendor(card)
    return "nvidia" in name or hex_id == "10de"


def detect_gpu(report):
    hardware = report.get("hardware", {})
    present = "graphics_card" in hardware
    cards = hardware.get("graphics_card") or []
    intel = [card for card in cards if is_intel(card)]
    amd = [card for card in cards if is_amd(card)]
    nvidia = [card for card in cards if is_nvidia(card)]
    has_intel = bool(intel)
    has_amd = bool(amd)
    has_nvidia = bool(nvidia)

    if not has_intel and not has_amd and not has_nvidia:
        layout = "unknown"
    elif has_intel and has_nvidia and not has_amd:
        layout = "hybrid-intel-nvidia"
    elif has_amd and has_nvidia and not has_intel:
        layout = "hybrid-amd-nvidia"
    elif has_intel and has_amd and not has_nvidia:
        layout = "hybrid-intel-amd"
    elif has_intel and not has_amd and not has_nvidia:
        layout = "intel"
    elif has_amd and not has_intel and not has_nvidia:
        layout = "amd"
    elif has_nvidia and not has_intel and not has_amd:
        layout = "nvidia"
    else:
        layout = "unknown"

    def bus_or_default(items, default):
        for card in items:
            bus = to_bus_id(card.get("sysfs_bus_id"))
            if bus:
                return bus
        return default

    discrete = "PCI:5:0:0"
    if len(amd) > 1:
        discrete = to_bus_id(amd[1].get("sysfs_bus_id")) or discrete
    elif len(intel) > 1:
        discrete = to_bus_id(intel[1].get("sysfs_bus_id")) or discrete
    elif len(nvidia) > 1:
        discrete = to_bus_id(nvidia[1].get("sysfs_bus_id")) or discrete

    return {
        "layout": layout,
        "source": "facter" if present else "unknown",
        "busIds": {
            "intel": bus_or_default(intel, "PCI:0:2:0"),
            "amd": bus_or_default(amd, "PCI:5:0:0"),
            "nvidia": bus_or_default(nvidia, "PCI:1:0:0"),
            "discrete": discrete,
        },
    }


def resolve_gpu_profile(base_profile, gpu):
    meta = GPU_PROFILES.get(base_profile)
    if not meta:
        return {
            "profile": base_profile,
            "managed": False,
            "layout": gpu["layout"],
            "busIds": gpu["busIds"],
            "source": gpu["source"],
        }

    variants = meta["variants"]
    chosen = None
    for variant in variants:
        if variant["layout"] == gpu["layout"]:
            chosen = variant
            break
    if chosen is None and variants:
        chosen = variants[0]

    return {
        "profile": chosen.get("profile", base_profile) if chosen else base_profile,
        "managed": bool(meta.get("owns", False)),
        "layout": chosen["layout"] if chosen else gpu["layout"],
        "busIds": gpu["busIds"],
        "source": gpu["source"],
    }


def detect_profile(report):
    system = report.get("smbios", {}).get("system", {})
    manufacturer = system.get("manufacturer", "")
    product = system.get("product", "")
    version = system.get("version", "")
    vendor = detect_vendor(manufacturer)
    model = " ".join(part for part in (manufacturer, product) if part) or "unknown"
    lowered_product = product.lower()
    lowered_version = version.lower()

    match = None
    if vendor != "unknown":
        for row in HARDWARE_PROFILES:
            if row[0] != vendor:
                continue
            if re.fullmatch(row[1], lowered_product) or re.fullmatch(row[1], lowered_version):
                match = row
                break

    if match is None:
        base = {
            "vendor": vendor,
            "model": model,
            "baseProfile": "unmatched",
            "profile": "unmatched",
            "state": "unmatched",
        }
    else:
        base = {
            "vendor": vendor,
            "model": model,
            "baseProfile": match[2],
            "profile": match[2],
            "state": match[3],
        }

    gpu = detect_gpu(report)
    resolved = resolve_gpu_profile(base["baseProfile"], gpu)
    base["profile"] = resolved["profile"]
    base["gpu"] = {
        "layout": resolved["layout"],
        "managed": resolved["managed"],
        "busIds": resolved["busIds"],
        "source": resolved["source"],
    }
    return base


def known_profiles():
    profiles = {row[2] for row in HARDWARE_PROFILES}
    for meta in GPU_PROFILES.values():
        for variant in meta["variants"]:
            if variant.get("profile"):
                profiles.add(variant["profile"])
    return profiles


def supported_profiles():
    profiles = {row[2] for row in HARDWARE_PROFILES if row[3] != "unsupported"}
    for name in list(profiles):
        for meta in GPU_PROFILES.values():
            for variant in meta["variants"]:
                if variant.get("profile"):
                    profiles.add(variant["profile"])
    return sorted(profiles)


def selected_profile(report, explicit=None):
    if explicit and explicit != "auto":
        return explicit
    detection = detect_profile(report)
    if detection["state"] in ("tested", "untested"):
        return detection["profile"]
    return None


def read_facter(root):
    path = os.path.join(root, "modules/07-system/facter.json")
    if not os.path.exists(path):
        return {}
    with open(path) as handle:
        return json.load(handle)


def explicit_profile_from_page(root):
    path = os.path.join(root, "modules/07-system/09-facter.nix")
    if not os.path.exists(path):
        return None
    with open(path) as handle:
        source = handle.read()
    match = re.search(r'ojuny\.hardware\.profile\s*=\s*"([^"]+)"', source)
    if match and match.group(1) != "auto":
        return match.group(1)
    return None


def resolve_profile(root, explicit):
    if explicit and explicit != "auto":
        choice = explicit
    else:
        choice = explicit_profile_from_page(root)
    profile = selected_profile(read_facter(root), choice)
    if profile and profile not in known_profiles():
        raise RuntimeError("unknown nixos-hardware profile: {}".format(profile))
    return profile


def write_profile_module(root, profile):
    path = os.path.join(root, "modules/07-system/00-hardware-quirks.nix")
    with open(path, "w") as handle:
        handle.write(profile_module(profile))
    return path


def main():
    parser = argparse.ArgumentParser(
        description="Regenerate the hardware module of an ojuny-template repository."
    )
    parser.add_argument("--root", default=".", help="Repository path (default: current directory).")
    parser.add_argument("--target-root", default="/", help="Mounted target root.")
    parser.add_argument("--firmware", choices=["efi", "bios", "none"], default=None)
    parser.add_argument("--boot-device", default=None)
    parser.add_argument("--extra-boot-config", default=None)
    parser.add_argument("--profile", default=None, help="Force a nixos-hardware profile slug.")
    parser.add_argument(
        "--profile-only",
        action="store_true",
        help="Only rewrite modules/07-system/00-hardware-quirks.nix.",
    )
    args = parser.parse_args()

    root = os.path.abspath(args.root)
    if not os.path.isdir(root):
        print("regenerate-hardware: repository not found: {}".format(root), file=sys.stderr)
        return 1

    if args.profile_only:
        try:
            profile = resolve_profile(root, args.profile)
        except Exception as error:
            print("regenerate-hardware: {}".format(error), file=sys.stderr)
            return 1
        output_path = write_profile_module(root, profile)
        print(
            "regenerate-hardware: wrote {} (profile: {})".format(
                output_path, profile or "unmatched"
            )
        )
        return 0

    if os.geteuid() != 0:
        print("regenerate-hardware: must run as root", file=sys.stderr)
        return 1

    target_root = os.path.abspath(args.target_root)
    try:
        if target_root == "/":
            run(["nixos-generate-config"])
            hardware_path = "/etc/nixos/hardware-configuration.nix"
        else:
            run(["nixos-generate-config", "--root", target_root])
            hardware_path = os.path.join(
                target_root, "etc/nixos/hardware-configuration.nix"
            )

        with open(hardware_path) as handle:
            hardware = fix_btrfs_subvolumes(handle.read())
    except Exception as error:
        print("regenerate-hardware: {}".format(error), file=sys.stderr)
        return 1

    firmware = args.firmware
    if firmware is None:
        firmware = "efi" if os.path.isdir("/sys/firmware/efi") else "bios"

    device = args.boot_device
    if firmware == "bios" and not device:
        device = detect_boot_device(root)
        if not device:
            print(
                "regenerate-hardware: could not determine the GRUB disk; pass --boot-device",
                file=sys.stderr,
            )
            return 1

    extra_lines = []
    if args.extra_boot_config:
        with open(args.extra_boot_config) as handle:
            extra_lines = [line.rstrip() for line in handle if line.strip()]
    extra_lines += luks_device_lines(hardware)

    facter_path = os.path.join(root, "modules/07-system/facter.json")
    try:
        report = json.loads(run(["nixos-facter"]))
    except Exception as error:
        print("regenerate-hardware: {}".format(error), file=sys.stderr)
        return 1

    with open(facter_path, "w") as handle:
        json.dump(report, handle, indent=2)
        handle.write("\n")

    output_path = os.path.join(root, "modules/07-system/00-hardware.nix")
    with open(output_path, "w") as handle:
        handle.write(hardware_module(hardware, firmware, device, extra_lines))

    try:
        profile = resolve_profile(root, args.profile)
    except Exception as error:
        print("regenerate-hardware: {}".format(error), file=sys.stderr)
        return 1

    quirks_path = write_profile_module(root, profile)

    print("regenerate-hardware: wrote {}".format(output_path))
    print(
        "regenerate-hardware: wrote {} (profile: {})".format(
            quirks_path, profile or "unmatched"
        )
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())

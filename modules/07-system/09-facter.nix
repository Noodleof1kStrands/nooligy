/*
  @menu
  displayname = "Hardware profile";
  icon = "computer-symbolic";
  order = 46;
  description = "Detected hardware and nixos-hardware profile. Coverage: docs/hardware-coverage.md. Apply a change with: nix run .#regenerate-hardware -- --profile-only";
  category = "07-System";
  hidden = false;
*/

{ self, ... }: {

  flake.modules.nixos.system-facter =
    { config, lib, ... }:
    {
      options.ojuny.hardware.profile = lib.mkOption {
        type = lib.types.str;
        default = "auto";
        description = "nixos-hardware profile written to 00-hardware-quirks.nix, or auto to select from facter.json.";
      };

      config = {
        /* @option widget = "dropdown"; label = "Hardware profile";
           description = "auto reads the generated facter.json. Apply with: nix run .#regenerate-hardware -- --profile-only";
           choices = [
            "auto" "apple-macbook-air-3" "apple-macbook-air-4" "apple-macbook-air-5"
            "apple-macbook-pro" "apple-macmini-4-1" "asus-fa506nc" "asus-fa507nv"
            "asus-fx506hm" "asus-proart-px13" "asus-rog-strix-g513im" "asus-rog-strix-g533zw"
            "asus-rog-strix-g713ie" "asus-rog-strix-g733qs" "asus-rog-strix-x570e" "asus-zenbook-ux371"
            "asus-zenbook-ux535" "asus-zephyrus-ga401iv" "asus-zephyrus-ga402" "asus-zephyrus-ga503"
            "asus-zephyrus-gu603h" "chuwi-minibook-x" "dell-latitude-7420" "dell-latitude-7430"
            "dell-latitude-7490" "dell-precision-5560" "dell-precision-5570" "dell-xps-13-9300"
            "dell-xps-13-9310" "dell-xps-13-9315" "dell-xps-13-9370" "dell-xps-13-9380"
            "dell-xps-15-9500" "dell-xps-15-9510" "dell-xps-15-9520" "dell-xps-15-9530"
            "framework" "framework-11th-gen-intel" "framework-12th-gen-intel" "framework-13-7040-amd"
            "framework-13th-gen-intel" "framework-16-7040-amd" "framework-16-amd-ai-300-series" "framework-amd-ai-300-series"
            "framework-intel-core-ultra-series1" "gigabyte-b550" "gigabyte-b650" "google-brya"
            "google-pixelbook" "google-rex" "gpd-pocket-3" "gpd-pocket-4"
            "gpd-win-2" "gpd-win-max-2-2023" "gpd-win-mini-2024" "hp-elitebook-830g6"
            "hp-elitebook-845g7" "hp-elitebook-845g8" "hp-elitebook-845g9" "hp-laptop-14s-dq2024nf"
            "hp-laptop-15s-fq1xxx" "hp-probook-440G5" "hp-probook-460G11" "huawei-machc-wa"
            "intel-nuc-12wshi7" "lenovo-ideapad-15ach6" "lenovo-legion-15ach6h" "lenovo-thinkpad-t14-intel-gen1"
            "lenovo-thinkpad-t14s" "lenovo-thinkpad-x1" "lenovo-thinkpad-x1-10th-gen" "lenovo-thinkpad-x1-11th-gen"
            "lenovo-thinkpad-x1-7th-gen" "lenovo-thinkpad-x1-9th-gen" "lenovo-thinkpad-x13-intel" "lenovo-yoga-6-13ALC6"
            "lenovo-yoga-7-14ARH7" "letsnote-cf-lx3" "letsnote-cf-lx4" "microsoft-surface-go"
            "microsoft-surface-laptop-amd" "microsoft-surface-pro-3" "microsoft-surface-pro-9" "microsoft-surface-pro-intel"
            "msi-b550-tomahawk" "msi-gf63" "msi-gl62" "msi-gl65-10SDR-492"
            "msi-gs60" "msi-prestige-15-a10sc" "omen-14-fb0798ng" "omen-16-n0005ne"
            "purism-librem-13v3" "purism-librem-15v3" "razer-blade-14-RZ09-0530" "slimbook-hero-rpl-rtx"
            "starlabs-starlite-i5" "system76" "system76-darp6" "system76-galp5-1650"
            "system76-gaze18" "system76-thelio-mega" "tuxedo-aura-15-gen1" "tuxedo-infinitybook-pro14-gen10-amd"
            "tuxedo-infinitybook-pro14-gen9-amd" "tuxedo-infinitybook-pro14-gen9-intel" "tuxedo-infinitybook-pro15-gen10-amd" "tuxedo-pulse-14-gen3"
            "tuxedo-pulse-15-gen2" "xiaomi-redmibook-15-pro-2021" "xiaomi-redmibook-16-pro-2024"
           ]; */
        ojuny.hardware.profile = "auto";

        /* @option widget = "text"; label = "Detected model"; readonly = true; */
        ojuny.hardware.detectedModel = self.lib.hardware-detection.model;

        /* @option widget = "text"; label = "Detected profile"; readonly = true; */
        ojuny.hardware.detectedProfile = self.lib.hardware-detection.profile;

        /* @option widget = "text"; label = "Detection state"; readonly = true; */
        ojuny.hardware.detectedState = self.lib.hardware-detection.state;

        hardware.facter.reportPath = lib.mkIf (builtins.pathExists ./facter.json) ./facter.json;
      };
    };
}

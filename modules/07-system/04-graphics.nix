/*
  @menu
  displayname = "Graphics";
  icon = "hardware-driver-symbolic";
  order = 40;
  description = "Graphics drivers, hybrids, compute accelerators and hardware acceleration";
  category = "07-System";
*/

{ self, inputs, ... }: {

  flake.modules.nixos.system-graphics =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      gpuTarget = config.ojuny.gpu;
      managed = config.ojuny.hardware.gpu.managed;
      resolvedGpu =
        if gpuTarget == "auto" then config.ojuny.hardware.gpu.detected else gpuTarget;
      gpu = if resolvedGpu == "auto" || resolvedGpu == "unknown" then "none" else resolvedGpu;
      effectiveBusIds =
        if gpuTarget == "auto" then config.ojuny.hardware.gpu.busIds else config.ojuny.gpuBusIds;
      nvidiaSelected = lib.elem gpu [
        "nvidia"
        "hybrid-intel-nvidia"
        "hybrid-amd-nvidia"
      ];
      nvidiaHybrid = lib.elem gpu [
        "hybrid-intel-nvidia"
        "hybrid-amd-nvidia"
      ];
      intelSelected = lib.elem gpu [
        "intel"
        "hybrid-intel-nvidia"
        "hybrid-intel-amd"
      ];
      amdSelected = lib.elem gpu [
        "amd"
        "hybrid-amd-nvidia"
        "hybrid-intel-amd"
      ];
      nouveau = config.ojuny.gpuNvidia.branch == "nouveau";
      nvidiaProprietary = nvidiaSelected && !nouveau;
      amdDriver = if config.ojuny.gpuAmd.legacy then "radeon" else "amdgpu";

      nvidiaPackage =
        if config.ojuny.gpuNvidia.branch == "latest" then
          config.boot.kernelPackages.nvidiaPackages.latest
        else if config.ojuny.gpuNvidia.branch == "legacy_580" then
          config.boot.kernelPackages.nvidiaPackages.legacy_580
        else
          config.boot.kernelPackages.nvidiaPackages.production;

      pciAddress =
        busId:
        if lib.hasPrefix "PCI:" busId then
          let
            parts = lib.splitString ":" busId;
            pad = value: lib.fixedWidthString 2 "0" value;
          in
          "0000:${pad (lib.elemAt parts 1)}:${pad (lib.elemAt parts 2)}.${lib.elemAt parts 3}"
        else
          busId;

      pciDriPrime = busId: "pci-" + lib.replaceStrings [ ":" "." ] [ "_" "_" ] (pciAddress busId);

      offloadEnabled =
        !managed
        && (
          (config.ojuny.gpuOffload.enable && lib.hasPrefix "hybrid-" gpu)
          || (config.ojuny.gpuMesaOffload.enable && lib.elem gpu [ "intel" "amd" ])
        );
      offloadNvidia = nvidiaProprietary && config.ojuny.gpuOffload.enable;
      offloadBus =
        if gpu == "hybrid-intel-amd" then
          effectiveBusIds.amd
        else if nvidiaHybrid then
          effectiveBusIds.nvidia
        else
          effectiveBusIds.discrete;

      offloadPackage = pkgs.writeShellApplication {
        name = "ojuny-offload";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          if [ "$#" -eq 0 ]; then
            echo "usage: ojuny-offload command [args...]" >&2
            exit 2
          fi
          ${lib.optionalString offloadNvidia ''
            export __NV_PRIME_RENDER_OFFLOAD=1
            export __GLX_VENDOR_LIBRARY_NAME=nvidia
            export __VK_LAYER_NV_optimus=NVIDIA_only
            export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
          ''}
          ${lib.optionalString (!offloadNvidia) ''
            pci="${pciAddress offloadBus}"
            vid=$(cat "/sys/bus/pci/devices/$pci/vendor")
            did=$(cat "/sys/bus/pci/devices/$pci/device")
            export DRI_PRIME="${pciDriPrime offloadBus}"
            export MESA_VK_DEVICE_SELECT="''${vid#0x}:''${did#0x}!"
          ''}
          exec "$@"
        '';
      };

      drivers =
        if gpu == "intel" then
          [ "modesetting" ]
        else if gpu == "amd" then
          [ amdDriver ]
        else if gpu == "nvidia" then
          (if nouveau then [ "modesetting" ] else [ "nvidia" ])
        else if gpu == "hybrid-intel-nvidia" then
          (if nouveau then [ "modesetting" ] else [ "modesetting" "nvidia" ])
        else if gpu == "hybrid-amd-nvidia" then
          (if nouveau then [ amdDriver ] else [ amdDriver "nvidia" ])
        else if gpu == "hybrid-intel-amd" then
          [ "modesetting" amdDriver ]
        else
          [ "modesetting" ];
    in
    {
      options.ojuny.gpu = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "intel"
          "amd"
          "nvidia"
          "hybrid-intel-nvidia"
          "hybrid-amd-nvidia"
          "hybrid-intel-amd"
          "none"
        ];
        default = "auto";
        description = "Graphics vendor and hybrid layout, or auto to read the facter report. Drives the kernel video drivers, vendor packages and VA-API backend.";
      };

      options.ojuny.gpuManualEditable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the manual GPU controls are editable. False when the target is auto or a hardware profile owns the GPU settings.";
      };

      options.ojuny.gpu32Bit = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Install 32-bit graphics libraries. The hardware profile owns this setting when it sets it.";
      };

      options.ojuny.gpuBusIds = {
        intel = lib.mkOption {
          type = lib.types.str;
          default = "PCI:0:2:0";
        };
        amd = lib.mkOption {
          type = lib.types.str;
          default = "PCI:5:0:0";
        };
        nvidia = lib.mkOption {
          type = lib.types.str;
          default = "PCI:1:0:0";
        };
        discrete = lib.mkOption {
          type = lib.types.str;
          default = "PCI:5:0:0";
          description = "Discrete GPU bus ID used by the Mesa offload wrapper for Intel+Intel and AMD+AMD.";
        };
      };

      options.ojuny.gpuNvidia.branch = lib.mkOption {
        type = lib.types.enum [
          "production"
          "latest"
          "legacy_580"
          "nouveau"
        ];
        default = "production";
        description = "NVIDIA driver branch. Production is 595 and latest is 615. Legacy 580 covers Maxwell, Pascal and Volta. Nouveau uses the open-source Mesa stack.";
      };

      options.ojuny.gpuNvidia.open = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use the open NVIDIA kernel modules. Ignored for legacy 580 and Nouveau.";
      };

      options.ojuny.gpuIntel.legacy = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use the legacy i965 VA-API stack for Haswell and older Intel graphics.";
      };

      options.ojuny.gpuAmd.legacy = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use the legacy radeon driver and r600 VA-API for pre-GCN AMD graphics.";
      };

      options.ojuny.gpuAmd.siCik = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable amdgpu support for GCN 1.0 and 2.0 cards through the SI and CIK kernel parameters.";
      };

      options.ojuny.gpuOffload.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install the general ojuny-offload command for hybrid graphics.";
      };

      options.ojuny.gpuMesaOffload.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Install the general ojuny-offload command for Intel+Intel or AMD+AMD systems.";
      };

      options.ojuny.gpuCompute = lib.mkOption {
        type = lib.types.enum [
          "none"
          "amd-instinct"
          "nvidia-datacenter"
          "intel-datacenter"
        ];
        default = "none";
        description = "Optional compute accelerator. Installs ROCm, CUDA or oneAPI without changing the display GPU.";
      };

      config = {

        # @option widget = "dropdown"; label = "GPU vendor"; group = "Graphics"; groupOrder = 10; order = 10; description = "auto reads the GPU layout and bus IDs from the facter report. The other choices are manual overrides. Use none for a VM or a machine without a usable GPU: it enables software rendering, allows the wlroots software renderer and switches Qt to the basic render loop."; choices = [ "auto" "intel" "amd" "nvidia" "hybrid-intel-nvidia" "hybrid-amd-nvidia" "hybrid-intel-amd" "none" ]; visibleWhen.path = "ojuny.hardware.gpu.managed"; visibleWhen.equals = false;
        ojuny.gpu = "auto";

        # @option widget = "text"; label = "Effective GPU"; readonly = true; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = "auto"; description = "Layout resolved from hardware.graphics_card in the facter report.";
        ojuny.hardware.gpu.detected = lib.mkDefault "unknown";

        # @option widget = "switch"; label = "GPU managed by hardware profile"; readonly = true; visibleWhen.path = "ojuny.hardware.gpu.managed"; visibleWhen.equals = true; description = "The selected nixos-hardware profile owns the GPU driver, PRIME and bus ID settings. The manual GPU controls do not take effect.";
        ojuny.hardware.gpu.managed = lib.mkDefault false;

        # @option widget = "text"; label = "GPU source"; readonly = true; visibleWhen.path = "ojuny.hardware.gpu.managed"; visibleWhen.equals = true;
        ojuny.hardware.gpu.source = lib.mkDefault "unknown";

        ojuny.hardware.gpu.busIds = lib.mkDefault {
          intel = "PCI:0:2:0";
          amd = "PCI:5:0:0";
          nvidia = "PCI:1:0:0";
          discrete = "PCI:5:0:0";
        };

        ojuny.gpuManualEditable = !managed && gpuTarget != "auto";

        # @option widget = "text"; label = "Intel bus ID"; group = "Hybrid"; order = 10; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "hybrid-intel-nvidia" "hybrid-intel-amd" ];
        ojuny.gpuBusIds.intel = "PCI:0:2:0";

        # @option widget = "text"; label = "AMD bus ID"; group = "Hybrid"; order = 20; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "hybrid-amd-nvidia" "hybrid-intel-amd" ];
        ojuny.gpuBusIds.amd = "PCI:5:0:0";

        # @option widget = "text"; label = "NVIDIA bus ID"; group = "Hybrid"; order = 30; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "hybrid-intel-nvidia" "hybrid-amd-nvidia" ];
        ojuny.gpuBusIds.nvidia = "PCI:1:0:0";

        # @option widget = "text"; label = "Discrete GPU bus ID"; group = "Hybrid"; order = 40; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "intel" "amd" ]; description = "Used by the Mesa offload wrapper for Intel+Intel and AMD+AMD.";
        ojuny.gpuBusIds.discrete = "PCI:5:0:0";

        # @option widget = "dropdown"; label = "NVIDIA driver branch"; group = "NVIDIA"; groupOrder = 40; order = 10; choices = [ "production" "latest" "legacy_580" "nouveau" ]; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "nvidia" "hybrid-intel-nvidia" "hybrid-amd-nvidia" ]; description = "Production is the stable 595 branch. Latest is 615 and may break. Legacy 580 covers Maxwell, Pascal and Volta. Nouveau uses Mesa and NVK.";
        ojuny.gpuNvidia.branch = "production";

        # @option widget = "switch"; label = "NVIDIA open kernel modules"; group = "NVIDIA"; groupOrder = 40; order = 20; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "nvidia" "hybrid-intel-nvidia" "hybrid-amd-nvidia" ]; description = "Use the open kernel modules for Turing and newer. Ignored for legacy 580 and Nouveau.";
        ojuny.gpuNvidia.open = false;

        # @option widget = "switch"; label = "Legacy Intel configuration"; group = "Intel"; groupOrder = 20; order = 10; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "intel" "hybrid-intel-nvidia" "hybrid-intel-amd" ]; description = "Use the i965 VA-API stack for Haswell and older Intel graphics instead of iHD.";
        ojuny.gpuIntel.legacy = false;

        # @option widget = "switch"; label = "Legacy AMD configuration"; group = "AMD"; groupOrder = 30; order = 10; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "amd" "hybrid-amd-nvidia" "hybrid-intel-amd" ]; description = "Use the radeon driver and r600 VA-API for pre-GCN AMD graphics.";
        ojuny.gpuAmd.legacy = false;

        # @option widget = "switch"; label = "GCN 1.0 and 2.0 support"; group = "AMD"; groupOrder = 30; order = 20; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "amd" "hybrid-amd-nvidia" "hybrid-intel-amd" ]; description = "Use amdgpu on SI and CIK cards and disable the matching radeon support. Ignored when the legacy configuration is on.";
        ojuny.gpuAmd.siCik = false;

        # @option widget = "switch"; label = "Offload command"; group = "Hybrid"; order = 50; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "hybrid-intel-nvidia" "hybrid-amd-nvidia" "hybrid-intel-amd" ]; description = "Install ojuny-offload. NVIDIA hybrids use the PRIME render-offload variables; Intel+AMD uses DRI_PRIME and MESA_VK_DEVICE_SELECT.";
        ojuny.gpuOffload.enable = true;

        # @option widget = "switch"; label = "Mesa offload command"; group = "Hybrid"; order = 60; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "intel" "amd" ]; description = "Install ojuny-offload for Intel+Intel or AMD+AMD. Uses DRI_PRIME and MESA_VK_DEVICE_SELECT.";
        ojuny.gpuMesaOffload.enable = false;

        # @option widget = "dropdown"; label = "Compute accelerator"; group = "Compute"; groupOrder = 50; order = 10; choices = [ "none" "amd-instinct" "nvidia-datacenter" "intel-datacenter" ]; description = "Install ROCm, CUDA or oneAPI for a compute GPU without changing the display GPU. Datacenter GPUs are not display targets.";
        ojuny.gpuCompute = "none";

        # @option widget = "switch"; label = "Graphics acceleration"; group = "Graphics"; groupOrder = 10; order = 20;
        hardware.graphics.enable = true;

        # @option widget = "switch"; label = "32-bit graphics"; group = "Graphics"; groupOrder = 10; order = 30; description = "Install 32-bit graphics libraries for 32-bit games and Wine. A hardware profile that owns the GPU settings supplies its own value.";
        ojuny.gpu32Bit = false;

        hardware.graphics.enable32Bit = lib.mkIf (!managed) (lib.mkDefault config.ojuny.gpu32Bit);

        # @option widget = "switch"; label = "Redistributable firmware"; group = "Graphics"; groupOrder = 10; order = 40; description = "Firmware blobs for Wi-Fi, GPUs and other devices.";
        hardware.enableRedistributableFirmware = true;

        hardware.cpu.intel.updateMicrocode = true;
        hardware.cpu.amd.updateMicrocode = true;

        # Intel media packages are derived from the Intel legacy switch.
        hardware.graphics.extraPackages = lib.mkIf (!managed && intelSelected) (
          if config.ojuny.gpuIntel.legacy then
            [ pkgs.intel-vaapi-driver ]
          else
            [
              pkgs.intel-media-driver
              pkgs.vpl-gpu-rt
              pkgs.intel-compute-runtime
            ]
        );

        # Intel GuC is derived from the selected Intel path and the legacy switch.
        boot.kernelParams = lib.mkIf (!managed && intelSelected && !config.ojuny.gpuIntel.legacy) [ "i915.enable_guc=3" ];

        boot.extraModprobeConfig = lib.mkIf (!managed && amdSelected && config.ojuny.gpuAmd.siCik && !config.ojuny.gpuAmd.legacy) ''
          options amdgpu si_support=1 cik_support=1
          options radeon si_support=0 cik_support=0
        '';

        # AMD
        # @option widget = "switch"; label = "AMDGPU in initrd"; group = "AMD"; groupOrder = 30; order = 30; visibleWhen.path = "ojuny.gpu"; visibleWhen.equals = [ "amd" "hybrid-amd-nvidia" "hybrid-intel-amd" ];
        hardware.amdgpu.initrd.enable = lib.mkIf (!managed && amdSelected && !config.ojuny.gpuAmd.legacy) true;

        # NVIDIA
        hardware.nvidia.package = lib.mkIf (!managed && (nvidiaProprietary || (config.ojuny.gpuCompute == "nvidia-datacenter" && !nvidiaSelected))) (
          if nvidiaProprietary then nvidiaPackage else config.boot.kernelPackages.nvidiaPackages.dc
        );
        hardware.nvidia.open = lib.mkIf (!managed && nvidiaProprietary) (
          config.ojuny.gpuNvidia.open && config.ojuny.gpuNvidia.branch != "legacy_580"
        );
        hardware.nvidia.modesetting.enable = lib.mkIf (!managed && nvidiaProprietary) true;

        hardware.nvidia.prime.offload.enable = lib.mkIf (!managed && nvidiaHybrid && nvidiaProprietary) config.ojuny.gpuOffload.enable;
        hardware.nvidia.prime.nvidiaBusId = lib.mkIf (!managed && nvidiaHybrid && nvidiaProprietary) effectiveBusIds.nvidia;
        hardware.nvidia.prime.intelBusId = lib.mkIf (!managed && nvidiaHybrid && nvidiaProprietary && gpu == "hybrid-intel-nvidia") effectiveBusIds.intel;
        hardware.nvidia.prime.amdgpuBusId = lib.mkIf (!managed && nvidiaHybrid && nvidiaProprietary && gpu == "hybrid-amd-nvidia") effectiveBusIds.amd;

        services.xserver.videoDrivers = lib.mkIf (!managed) drivers;

        environment.sessionVariables = lib.mkMerge [
          (lib.mkIf (gpu == "none") {
            WLR_RENDERER_ALLOW_SOFTWARE = "1";
            QSG_RENDER_LOOP = "basic";
          })
          (lib.mkIf (gpu != "none") {
            QSG_RENDER_LOOP = "threaded";
          })
          (lib.mkIf intelSelected {
            LIBVA_DRIVER_NAME = if config.ojuny.gpuIntel.legacy then "i965" else "iHD";
          })
          (lib.mkIf (!intelSelected && amdSelected) {
            LIBVA_DRIVER_NAME = if config.ojuny.gpuAmd.legacy then "r600" else "radeonsi";
          })
        ];

        environment.systemPackages =
          lib.optionals offloadEnabled [ offloadPackage ]
          ++ lib.optionals (config.ojuny.gpuCompute == "amd-instinct") [
            pkgs.rocmPackages.clr
            pkgs.rocmPackages.rocblas
            pkgs.rocmPackages.hipblas
            pkgs.rocmPackages.rocminfo
            pkgs.rocmPackages.rocm-smi
          ]
          ++ lib.optionals (config.ojuny.gpuCompute == "nvidia-datacenter") [
            pkgs.cudaPackages.cudatoolkit
            pkgs.cudaPackages.cudnn
          ]
          ++ lib.optionals (config.ojuny.gpuCompute == "intel-datacenter") [
            pkgs.intel-compute-runtime
            pkgs.level-zero
            pkgs.intel-oneapi-toolkit
            pkgs.clinfo
          ];

        users.groups.render = lib.mkIf (config.ojuny.gpuCompute == "amd-instinct") { };
        users.groups.video = lib.mkIf (config.ojuny.gpuCompute == "amd-instinct") { };

        assertions = lib.optional (config.ojuny.gpuCompute == "nvidia-datacenter" && nvidiaSelected) {
          assertion = false;
          message = "ojuny.gpuCompute = nvidia-datacenter cannot share the display with an NVIDIA display GPU. Select an Intel or AMD display GPU.";
        };

      };

    };

}

# Supported hardware matrix

This is the Ojuny hardware support contract for the Graphics page. It lists
the configurations the settings GUI can set up and the combinations that are
outside the supported desktop paths. It is not a test report and does not list
tested or untested states.

## Automatic selection

The Graphics page defaults to `auto`, which reads `hardware.graphics_card`
from the nixos-facter report. The key is optional, so a machine without a
classifiable PCI display controller resolves to `unknown` and then to `none`.
A selected nixos-hardware profile that ships GPU settings owns the drivers,
PRIME bus IDs and VA-API packages; the profile page marks them managed and the
concrete targets below are ignored. The concrete target names remain manual
overrides when no profile owns the GPU.

## CPU support

Intel and AMD microcode updates are both enabled. CPU support follows the
kernel and the selected graphics path; the generation ranges below are the
Ojuny support contract, not a test report.

| Vendor | Line | Supported generations | iGPU | Notes |
|---|---|---|---|---|
| Intel | Core | Broadwell (5th gen) through Core Ultra Series 2 | Intel HD, UHD, Iris, Iris Xe or Arc | Haswell and older need **Legacy Intel configuration**. Pre-Haswell is display only. Newer Core Ultra generations follow kernel support. |
| Intel | Pentium, Celeron, Atom | Broadwell and newer | Intel HD or UHD | Older generations are display only. |
| Intel | Xeon E3, E5, E7 | Haswell (E3 v3 and E5 v3) and newer, including Broadwell-EP and Skylake | Some E3 v3/v4/v5 parts have Intel HD or P graphics; E5 and E7 do not | Use the iGPU path only when the part has one. |
| Intel | Xeon W | W-1200 and W-1300 (Comet and Rocket Lake); W-2400 and W-3400 (Sapphire Rapids) | Intel UHD on W-1200 and W-1300; no iGPU on W-2400 and W-3400 | Workstation line. |
| Intel | Xeon Scalable | Skylake-SP through Granite Rapids and Sierra Forest | None | Requires a supported discrete display GPU. |
| AMD | Ryzen | Zen (1000) through Zen5 (9000 and Ryzen AI 300) | Vega on 2000G and 3000G, RDNA2 on 6000, RDNA3 on 7000 and 8000 | Full support through the AMD or Intel+AMD paths. |
| AMD | Athlon | Zen-based 200GE and 3000G | Vega | Full support. |
| AMD | Threadripper | Zen (1000) through Zen4 and Zen5 (7000 and 9000) | None | Requires a supported discrete display GPU. |
| AMD | EPYC | Naples (7001) through Turin (9005) | None | Requires a supported discrete display GPU. |
| AMD | FX and Phenom | Legacy generations | None | CPU only with a supported discrete GPU. No integrated graphics path. |

## Display targets

| Target | Hardware | GUI selection | Notes |
|---|---|---|---|
| Intel integrated | Broadwell and newer | `intel` | iHD VA-API and the Xe/Arc media packages. |
| Intel integrated, legacy | Haswell and older | `intel` with **Legacy Intel configuration** | i965 VA-API. Display works through modesetting. |
| Intel discrete | Arc Alchemist and Battlemage, Arc Pro | `intel` | Modesetting plus the Intel media stack. |
| AMD integrated | GCN 3.0 and newer, Ryzen Vega and RDNA | `amd` | amdgpu and radeonsi. |
| AMD integrated, GCN 1.0 and 2.0 | SI and CIK APUs | `amd` with **GCN 1.0 and 2.0 support** | amdgpu with the SI/CIK module parameters. |
| AMD integrated, pre-GCN | TeraScale APUs | `amd` with **Legacy AMD configuration** | radeon and r600 VA-API. |
| AMD discrete | Radeon RX 400 and newer, Radeon Pro | `amd` | amdgpu and radeonsi. ROCm is not installed by the display target. |
| NVIDIA consumer and professional | GeForce, Quadro and RTX Pro | `nvidia` | Branch selected separately. |
| NVIDIA production | Turing and newer | `nvidia`, branch `production` | 595 driver. |
| NVIDIA latest | Turing and newer | `nvidia`, branch `latest` | 615 driver. May break on new hardware. |
| NVIDIA legacy 580 | Maxwell, Pascal and Volta, including the GTX 750 Ti | `nvidia`, branch `legacy_580` | Native Wayland. Recommended for these cards. |
| NVIDIA Nouveau | Kepler and newer | `nvidia`, branch `nouveau` | Mesa and NVK. See the limits below. |
| Software rendering | No usable GPU, VM | `none` | Desktop only. Not a gaming path. |

## Hybrid targets

| Target | Display GPU | Render GPU | GUI selection | Notes |
|---|---|---|---|---|
| Intel plus NVIDIA | Intel | NVIDIA | `hybrid-intel-nvidia` | PRIME render offload for proprietary branches. Mesa offload for Nouveau. |
| AMD plus NVIDIA | AMD | NVIDIA | `hybrid-amd-nvidia` | PRIME render offload for proprietary branches. Mesa offload for Nouveau. |
| Intel plus AMD | Intel | AMD | `hybrid-intel-amd` | Mesa offload with `DRI_PRIME` and `MESA_VK_DEVICE_SELECT`. |
| AMD plus AMD | AMD integrated | AMD discrete | `amd` with **Mesa offload command** | Mesa offload. No separate hybrid target. |
| Intel plus Intel | Intel integrated | Intel discrete | `intel` with **Mesa offload command** | Mesa offload. No separate hybrid target. |

The `ojuny-offload` command is the general offload wrapper. It is available
only for hybrid selections and for the Intel and AMD Mesa offload switches.

## Non-consumer hardware

| Brand | Line | Support |
|---|---|---|
| Intel | Xeon E3, E5, W and Scalable | CPU support through the kernel, with a supported Intel iGPU or a supported display GPU. |
| Intel | Arc Pro | Display support through the `intel` target. |
| Intel | Data Center GPU Flex and Max | Compute-only through the compute accelerator selector. Not a display target. |
| AMD | Ryzen, Athlon, Threadripper and EPYC | CPU support through the kernel, with a supported AMD or other display GPU. |
| AMD | Radeon Pro | Display and media support through the `amd` target. |
| AMD | Instinct | Compute-only through the ROCm compute accelerator. Not a display target. |
| NVIDIA | GeForce, Quadro and RTX Pro | Display support through the selected NVIDIA branch. |
| NVIDIA | Tesla and data center | Compute-only through the data center compute accelerator. Not a display target. |

## Compute accelerators

| Selector | Stack | Notes |
|---|---|---|
| AMD Instinct | ROCm, rocBLAS, hipBLAS, rocminfo and rocm-smi | Requires a display GPU for the desktop. The render and video groups are created; add the user to them on the Users page. |
| NVIDIA data center | `nvidia_dc` and CUDA | Requires a display GPU that is not using an NVIDIA display driver. |
| Intel data center | Intel compute-runtime, Level Zero, oneAPI Toolkit and clinfo | Compute only. |

The compute accelerator selector never changes the display GPU driver.

## Explicit limits

- NVIDIA 470 and 390 lack GBM and cannot run Mango. Use Nouveau or a separate X11 session for those cards.
- Nouveau covers Kepler and newer. Maxwell, Pascal and Volta have limited reclocking; Maxwell 1, including the 750 Ti, is the best case. Kepler uses Vulkan 1.2.
- Fermi and older have Nouveau OpenGL only and no usable Vulkan for modern Proton.
- Datacenter GPUs are compute targets and are not display targets.
- Software rendering needs a KMS-capable display driver and is not a gaming path.
- A software-rendered Mango compositor cannot composite a GPU-accelerated Xwayland game window.

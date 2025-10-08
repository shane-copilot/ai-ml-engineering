# System Specifications - Comprehensive Report
**Generated:** 2025-10-02  
**System:** Arch Linux  
**Purpose:** Rust/Vulkan High-Performance Inference Engine Development

---

## CPU Specifications

### Processor Information
- **Model:** 13th Gen Intel(R) Core(TM) i9-13900H
- **Architecture:** x86_64 (Raptor Lake-P)
- **CPU Family:** 6
- **Model Number:** 186
- **Stepping:** 2
- **Microcode:** 0x4129

### Core Configuration
- **Physical Cores:** 14
- **Logical Processors (Threads):** 20
- **Threads per Core:** 2 (Hyper-Threading enabled)
- **Sockets:** 1
- **NUMA Nodes:** 1

### Frequency & Performance
- **Base Frequency:** 400 MHz (minimum)
- **Max Turbo Frequency:** 5400 MHz (5.4 GHz)
- **Current Scaling:** Dynamic (51% at measurement time)
- **BogoMIPS:** 5990.40
- **External Clock:** 100 MHz
- **Voltage:** 0.7V

### Cache Hierarchy

#### Performance Cores (P-Cores) - 6 Cores
- **L1 Data Cache:** 48 KB per core (12-way set-associative)
- **L1 Instruction Cache:** 32 KB per core (8-way set-associative)
- **L2 Cache:** 1280 KB (1.25 MB) per core
- **Total P-Core L1d:** 288 KB
- **Total P-Core L1i:** 192 KB
- **Total P-Core L2:** 7.5 MB (6 × 1.25 MB)

#### Efficiency Cores (E-Cores) - 8 Cores
- **L1 Data Cache:** 32 KB per core (8-way set-associative)
- **L1 Instruction Cache:** 64 KB per core (8-way set-associative)
- **L2 Cache:** 2048 KB (2 MB) shared per cluster (4 cores per cluster)
- **Total E-Core L1d:** 256 KB
- **Total E-Core L1i:** 512 KB
- **Total E-Core L2:** 4 MB (2 × 2 MB)

#### Shared Cache
- **L3 Cache:** 24 MB (24576 KB)
  - Shared across all cores
  - 12-way set-associative
  - Multi-bit ECC error correction

#### Cache Summary
- **Total L1d:** 544 KB (14 instances)
- **Total L1i:** 704 KB (14 instances)
- **Total L2:** 11.5 MB (8 instances)
- **Total L3:** 24 MB (1 instance)

### Memory Addressing
- **Physical Address Bits:** 46 bits
- **Virtual Address Bits:** 48 bits
- **Page Size:** 4096 bytes (4 KB)
- **Cache Line Size:** 64 bytes
- **Cache Alignment:** 64 bytes

### Instruction Set Extensions
**SIMD & Vector:**
- SSE, SSE2, SSE3, SSSE3, SSE4.1, SSE4.2
- AVX, AVX2, AVX-VNNI
- FMA (Fused Multiply-Add)
- F16C (Half-precision float conversion)

**Security & Encryption:**
- AES-NI (AES acceleration)
- SHA-NI (SHA acceleration)
- RDRAND (Hardware RNG)
- RDSEED (Seed RNG)

**Memory & Data:**
- CLFLUSHOPT, CLWB (Cache line flush)
- MOVDIRI, MOVDIR64B (Direct store)
- FSRM (Fast Short REP MOVSB)
- SERIALIZE

**Advanced Features:**
- BMI1, BMI2 (Bit manipulation)
- POPCNT (Population count)
- RDTSCP (Read timestamp counter)
- INVPCID (Invalidate process-context ID)
- GFNI (Galois Field instructions)
- VAES, VPCLMULQDQ (Vector AES/CLMUL)
- WAITPKG (User-level wait)
- PCONFIG (Platform configuration)

### Virtualization
- **Technology:** Intel VT-x
- **Features:** VMX, SMX, EPT, VPID
- **EPT:** Extended Page Tables with 1GB pages
- **VPID:** Virtual Processor IDs supported
- **Posted Interrupts:** Yes
- **APIC Virtualization:** Yes

### Power Management
- **Intel Speed Shift (HWP):** Yes
- **HWP Notifications:** Yes
- **HWP Activity Window:** Yes
- **HWP Energy Performance Preference:** Yes
- **HWP Package Level Request:** Yes
- **Hardware Feedback Interface (HFI):** Yes
- **Thermal Monitor:** Yes (TM, TM2)
- **ACPI Support:** Yes

### Security Mitigations
**Not Affected:**
- Meltdown, Spectre v1 (mitigated), Spectre v2 (mitigated)
- L1TF, MDS, MMIO Stale Data
- TAA, TSX Async Abort

**Mitigations Active:**
- Enhanced IBRS (Indirect Branch Restricted Speculation)
- IBPB (Indirect Branch Predictor Barrier)
- STIBP (Single Thread Indirect Branch Predictors)
- SSBD (Speculative Store Bypass Disable)
- Register File Data Sampling mitigation
- BHI (Branch History Injection) - BHI_DIS_S

---

## GPU Specifications

### Graphics Processor
- **Model:** Intel(R) Iris(R) Xe Graphics (RPL-P)
- **PCI Device ID:** 8086:a7a0
- **Revision:** 04
- **Type:** Integrated GPU
- **Location:** PCI 0000:00:02.0

### Driver Information
- **Driver:** Intel i915 (open-source Mesa)
- **Driver ID:** DRIVER_ID_INTEL_OPEN_SOURCE_MESA
- **Mesa Version:** 25.2.3-arch1.2
- **Kernel Modules:** i915, xe

### Memory Configuration
- **Video Memory:** 39729 MB (~38.8 GB)
- **Memory Type:** Unified Memory Architecture (shared with system RAM)
- **Memory Region 1:** 16 MB @ 0x6004000000 (non-prefetchable, 64-bit)
- **Memory Region 2:** 256 MB @ 0x4000000000 (prefetchable, 64-bit)
- **I/O Ports:** 64 bytes @ 0x3000

### Vulkan Support

#### API Version
- **Vulkan Version:** 1.4.318
- **Driver Version:** 25.2.3
- **Conformance Version:** 1.4.0.0

#### Device IDs
- **Vendor ID:** 0x8086 (Intel)
- **Device ID:** 0xa7a0
- **Device UUID:** 8680a0a7-0400-0000-0002-000000000000
- **Driver UUID:** 4d25c383-1470-5a22-b41a-fd2d0b9a14fb

#### Vulkan Limits (Key Performance Metrics)

**Compute:**
- **Max Compute Shared Memory:** 65536 bytes (64 KB)
- **Max Compute Work Group Count:** [65535, 65535, 65535]
- **Max Compute Work Group Invocations:** 1024
- **Max Compute Work Group Size:** [1024, 1024, 1024]

**Memory & Buffers:**
- **Max Memory Allocation Count:** 4294967295
- **Max Sampler Allocation Count:** 65536
- **Buffer-Image Granularity:** 1 byte
- **Sparse Address Space Size:** 0xFFF00000000 (~16 TB)
- **Min Memory Map Alignment:** 4096 bytes
- **Min Texel Buffer Offset Alignment:** 16 bytes
- **Min Uniform Buffer Offset Alignment:** 64 bytes
- **Min Storage Buffer Offset Alignment:** 4 bytes
- **Non-Coherent Atom Size:** 64 bytes
- **Optimal Buffer Copy Offset Alignment:** 128 bytes
- **Optimal Buffer Copy Row Pitch Alignment:** 128 bytes

**Descriptors:**
- **Max Bound Descriptor Sets:** 8
- **Max Per-Stage Descriptor Samplers:** 402,653,184
- **Max Per-Stage Descriptor Uniform Buffers:** 201,326,592
- **Max Per-Stage Descriptor Storage Buffers:** 201,326,592
- **Max Per-Stage Descriptor Sampled Images:** 201,326,592
- **Max Per-Stage Descriptor Storage Images:** 201,326,592
- **Max Per-Stage Descriptor Input Attachments:** 64
- **Max Per-Stage Resources:** 201,326,592
- **Max Descriptor Set Uniform Buffers Dynamic:** 8
- **Max Descriptor Set Storage Buffers Dynamic:** 8

**Rendering:**
- **Max Image Dimensions 1D:** 16384
- **Max Image Dimensions 2D:** 16384
- **Max Image Dimensions 3D:** 2048
- **Max Image Dimension Cube:** 16384
- **Max Image Array Layers:** 2048
- **Max Framebuffer Width:** 16384
- **Max Framebuffer Height:** 16384
- **Max Framebuffer Layers:** 2048
- **Max Color Attachments:** 8
- **Max Viewports:** 16
- **Max Viewport Dimensions:** [16384, 16384]
- **Viewport Bounds Range:** [-32768, 32767]
- **Viewport SubPixel Bits:** 13

**Sampling & Filtering:**
- **Max Sampler LOD Bias:** 16
- **Max Sampler Anisotropy:** 16
- **Framebuffer Sample Counts:** 1, 2, 4, 8, 16
- **Sampled Image Sample Counts:** 1, 2, 4, 8, 16
- **Storage Image Sample Counts:** 1
- **Max Sample Mask Words:** 1

**Vertex Processing:**
- **Max Vertex Input Attributes:** 29
- **Max Vertex Input Bindings:** 33
- **Max Vertex Input Attribute Offset:** 2047
- **Max Vertex Input Binding Stride:** 4095
- **Max Vertex Output Components:** 128

**Tessellation:**
- **Max Tessellation Generation Level:** 64
- **Max Tessellation Patch Size:** 32
- **Max Tessellation Control Per-Vertex Input Components:** 128
- **Max Tessellation Control Per-Vertex Output Components:** 128
- **Max Tessellation Control Per-Patch Output Components:** 128
- **Max Tessellation Control Total Output Components:** 2048
- **Max Tessellation Evaluation Input Components:** 128
- **Max Tessellation Evaluation Output Components:** 128

**Geometry Shader:**
- **Max Geometry Shader Invocations:** 32
- **Max Geometry Input Components:** 128
- **Max Geometry Output Components:** 128
- **Max Geometry Output Vertices:** 256
- **Max Geometry Total Output Components:** 1024

**Fragment Shader:**
- **Max Fragment Input Components:** 116
- **Max Fragment Output Attachments:** 8
- **Max Fragment Dual Source Attachments:** 1
- **Max Fragment Combined Output Resources:** 402,653,192

**Precision & Timing:**
- **SubPixel Precision Bits:** 8
- **SubTexel Precision Bits:** 8
- **Mipmap Precision Bits:** 8
- **Timestamp Compute and Graphics:** true
- **Timestamp Period:** 52.0833 nanoseconds

**Line & Point Rendering:**
- **Point Size Range:** [0.125, 255.875]
- **Point Size Granularity:** 0.125
- **Line Width Range:** [0, 8]
- **Line Width Granularity:** 0.0078125
- **Strict Lines:** false

**Clipping & Culling:**
- **Max Clip Distances:** 8
- **Max Cull Distances:** 8
- **Max Combined Clip and Cull Distances:** 8

**Sparse Resources:**
- **Residency Standard 2D Block Shape:** true
- **Residency Standard 3D Block Shape:** true
- **Residency Non-Resident Strict:** true

#### OpenGL Support
- **OpenGL Version:** 4.6 (Core & Compatibility Profile)
- **GLSL Version:** 4.60
- **OpenGL ES Version:** 3.2
- **GLSL ES Version:** 3.20

#### Vulkan Extensions (Instance - 24 total)
- VK_KHR_surface, VK_KHR_wayland_surface, VK_KHR_xcb_surface, VK_KHR_xlib_surface
- VK_KHR_display, VK_KHR_get_display_properties2
- VK_KHR_device_group_creation
- VK_KHR_external_fence_capabilities
- VK_KHR_external_memory_capabilities
- VK_KHR_external_semaphore_capabilities
- VK_KHR_get_physical_device_properties2
- VK_KHR_get_surface_capabilities2
- VK_KHR_surface_protected_capabilities
- VK_EXT_debug_report, VK_EXT_debug_utils
- VK_EXT_acquire_drm_display, VK_EXT_acquire_xlib_display
- VK_EXT_direct_mode_display
- VK_EXT_display_surface_counter
- VK_EXT_headless_surface
- VK_EXT_surface_maintenance1
- VK_EXT_swapchain_colorspace
- VK_LUNARG_direct_driver_loading

#### Vulkan Layers (6 available)
- VK_LAYER_KHRONOS_validation (1.4.321)
- VK_LAYER_MESA_device_select (1.4.303)
- VK_LAYER_MESA_overlay (1.4.303)
- VK_LAYER_MESA_screenshot (1.4.303)
- VK_LAYER_MESA_vram_report_limit (1.4.303)
- VK_LAYER_INTEL_nullhw (1.1.73)

#### Surface Capabilities
- **Min Image Count:** 3
- **Max Image Count:** Unlimited (0)
- **Current Extent:** Dynamic (4294967295 × 4294967295)
- **Min Image Extent:** 1 × 1
- **Max Image Extent:** 16384 × 16384
- **Max Image Array Layers:** 1
- **Supported Transforms:** IDENTITY
- **Supported Composite Alpha:** OPAQUE, PRE_MULTIPLIED
- **Present Modes:** MAILBOX, FIFO, IMMEDIATE

**Supported Usage Flags:**
- TRANSFER_SRC, TRANSFER_DST
- SAMPLED, STORAGE
- COLOR_ATTACHMENT, INPUT_ATTACHMENT
- ATTACHMENT_FEEDBACK_LOOP

#### Color Spaces & Formats
Supports 72 surface formats including:
- sRGB (SRGB_NONLINEAR)
- Display P3 (LINEAR & NONLINEAR)
- BT709 (LINEAR)
- BT2020 (LINEAR)
- HDR10 ST2084
- Adobe RGB (LINEAR)
- DCI-P3 (NONLINEAR & LINEAR)
- Extended sRGB (LINEAR)

**Format Types:**
- A2R10G10B10_UNORM_PACK32
- B8G8R8A8_SRGB/UNORM
- R8G8B8A8_SRGB/UNORM
- R16G16B16A16_SFLOAT/UNORM
- R5G6B5_UNORM_PACK16

---

## RAM Specifications

### Memory Configuration
- **Total Installed RAM:** 40 GB (40683076 KB / 39729 MB)
- **Available Memory:** ~32 GB (32055300 KB)
- **Memory Slots:** 2 SODIMM slots
- **Maximum Capacity:** 64 GB
- **Error Correction:** None (non-ECC)

### Memory Modules

#### Module 1 (Slot: Controller0-ChannelA)
- **Size:** 8 GB
- **Type:** DDR4 SODIMM
- **Speed:** 3200 MT/s (configured)
- **Manufacturer:** Micron Technology
- **Manufacturer ID:** Bank 1, Hex 0x2C
- **Form Factor:** SODIMM
- **Data Width:** 64 bits
- **Total Width:** 64 bits
- **Rank:** 1
- **Voltage:** 1.2V (min/max/configured)
- **Technology:** DRAM (Volatile)
- **Bank Locator:** BANK 0

#### Module 2 (Slot: Controller1-ChannelA-DIMM0)
- **Size:** 32 GB
- **Type:** DDR4 SODIMM
- **Speed:** 3200 MT/s (configured)
- **Manufacturer:** A-DATA Technology
- **Manufacturer ID:** Bank 5, Hex 0xCB
- **Serial Number:** 81840000
- **Form Factor:** SODIMM
- **Data Width:** 64 bits
- **Total Width:** 64 bits
- **Rank:** 2
- **Voltage:** 1.2V (min/max/configured)
- **Technology:** DRAM (Volatile)
- **Bank Locator:** BANK 0

### Memory Performance Characteristics
- **Type Detail:** Synchronous
- **Operating Mode:** Volatile memory
- **Non-Volatile Size:** None
- **Cache Size:** None
- **Logical Size:** None

### Memory Usage (at measurement time)
- **Total:** 39729 MB
- **Used:** 8.2 GB
- **Free:** 22 GB
- **Shared:** 807 MB
- **Buff/Cache:** 9.9 GB
- **Available:** 30 GB

### Swap Configuration
- **Total Swap:** 19 GB (20971516 KB)
- **Used Swap:** 5.0 GB
- **Free Swap:** 14 GB (15558724 KB)
- **Swap Cached:** 1854280 KB

### Detailed Memory Statistics (/proc/meminfo)
- **MemTotal:** 40683076 kB
- **MemFree:** 23142324 kB
- **MemAvailable:** 32055300 kB
- **Buffers:** 591708 kB
- **Cached:** 8644168 kB
- **Active:** 11897532 kB
- **Inactive:** 3449956 kB
- **Active(anon):** 5161488 kB
- **Inactive(anon):** 1780312 kB
- **Active(file):** 6736044 kB
- **Inactive(file):** 1669644 kB
- **Unevictable:** 344980 kB
- **Mlocked:** 116 kB

### Huge Pages
- **AnonHugePages:** 1028096 kB
- **ShmemHugePages:** 579584 kB
- **FileHugePages:** 110592 kB
- **Hugepagesize:** 2048 kB
- **HugePages_Total:** 0
- **HugePages_Free:** 0

### Memory Mapping
- **DirectMap4k:** 212296 kB
- **DirectMap2M:** 5697536 kB
- **DirectMap1G:** 35651584 kB
- **VmallocTotal:** 34359738367 kB
- **VmallocUsed:** 79168 kB

### NUMA Configuration
- **NUMA Nodes:** 1
- **Node 0 CPUs:** 0-19 (all cores)
- **Node 0 Size:** 39729 MB
- **Node 0 Free:** 22119 MB
- **Node Distance:** 10 (local)

---

## System Information

### Operating System
- **Distribution:** Arch Linux
- **Kernel:** 6.16.8-arch3-1
- **Architecture:** x86_64
- **Kernel Type:** SMP PREEMPT_DYNAMIC
- **Build Date:** Mon, 22 Sep 2025 22:08:35 +0000
- **Compiler:** GNU/Linux

### SMBIOS
- **Version:** 3.5.0
- **Manufacturer:** ASUSTeK Computer Inc.
- **Device ID:** 1643

### System Topology
- **Machine:** 39GB total
- **Packages:** 1
- **NUMA Nodes:** 1
- **PCI Devices:**
  - VGA Controller (00:02.0)
  - RAID Controller (00:0e.0) - NVMe storage
  - Network Controller (01:00.0)

### I/O & Memory Management
- **Page Size:** 4096 bytes
- **Byte Order:** Little Endian
- **IOMMU:** Enabled (group 0 for GPU)

---

## Performance Optimization Notes for Inference Engine

### CPU Optimization Targets
1. **Hybrid Architecture:** Leverage P-cores (6) for compute-intensive tasks, E-cores (8) for background/parallel tasks
2. **SIMD:** Utilize AVX2, AVX-VNNI, FMA for vectorized operations
3. **Cache Awareness:** 
   - L1: 48KB data per P-core (ultra-fast)
   - L2: 1.25MB per P-core, 2MB per E-core cluster
   - L3: 24MB shared (optimize for cache locality)
4. **Memory Alignment:** Align to 64-byte cache lines
5. **NUMA:** Single node - no cross-node penalties

### GPU/Vulkan Optimization Targets
1. **Unified Memory:** 39GB shared pool - optimize CPU↔GPU transfers
2. **Compute Groups:** Max 1024 invocations per group, [1024, 1024, 1024] dimensions
3. **Shared Memory:** 64KB per compute shader
4. **Descriptor Sets:** Massive limits (200M+) - batch descriptors efficiently
5. **Buffer Alignment:** 
   - Uniform buffers: 64-byte alignment
   - Storage buffers: 4-byte alignment
   - Optimal copy: 128-byte alignment
6. **Sparse Resources:** Supported for large tensor management
7. **Timestamp Queries:** 52.08ns period for profiling

### Memory Optimization Targets
1. **Bandwidth:** DDR4-3200 dual-channel
2. **Capacity:** 40GB total (32GB available typically)
3. **Huge Pages:** Available (2MB pages) - enable for large allocations
4. **Direct Mapping:** Prefer 2MB/1GB pages for large buffers
5. **Swap:** 19GB available but avoid for hot paths

### Recommended Command Reference
```bash
# CPU info
lscpu
cat /proc/cpuinfo
lstopo-no-graphics --of console

# Memory info
free -h
cat /proc/meminfo
numactl --hardware
sudo dmidecode -t memory

# GPU info
lspci -v -s 00:02.0
vulkaninfo --summary
vulkaninfo | grep -A 100 "VkPhysicalDeviceLimits"
glxinfo -B

# Cache info
cat /sys/devices/system/cpu/cpu*/cache/index*/size
sudo dmidecode -t cache

# System info
uname -a
getconf PAGE_SIZE
```

---

## Commands Used to Generate This Report

All commands executed to gather the system specifications:

```bash
# CPU Information
lscpu
cat /proc/cpuinfo
lstopo-no-graphics --of console

# Cache Information
cat /sys/devices/system/cpu/cpu0/cache/index*/size
cat /sys/devices/system/cpu/cpu0/cache/index*/level
sudo dmidecode -t cache
sudo dmidecode -t processor

# GPU Information
lspci -v | grep -A 20 VGA
lspci -v -s 00:02.0
lspci -nn | grep -E "VGA|3D"
glxinfo -B
find /sys/class/drm -name "card*" -type l

# Vulkan Information
vulkaninfo --summary
vulkaninfo 2>&1 | head -500
vulkaninfo 2>&1 | grep -A 200 "VkPhysicalDeviceProperties"
vulkaninfo 2>&1 | grep -A 100 "VkPhysicalDeviceLimits"

# Memory Information
free -h
cat /proc/meminfo
sudo dmidecode -t memory
numactl --hardware

# System Information
uname -a
getconf PAGE_SIZE
```

---

**End of Report**

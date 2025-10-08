# Inference Optimization Methods Explained

## What We're Testing and Why

### Current Performance Problem
- **GPU**: 5.75 tok/s (19% of 30 tok/s target)
- **CPU**: 6.42 tok/s (21% of target) - actually FASTER than GPU!

This suggests the inference configuration is not optimized for our hardware.

---

## Optimization Categories

### 1. Batch Size (`-b` and `-ub`)

**What it does**: Controls how many tokens are processed at once.
- `-b` (batch): Logical maximum batch size (how many tokens can be "prepared")
- `-ub` (ubatch): Physical batch size (how many tokens processed in one GPU call)

**Why it matters**:
- **Small batches**: More CPU↔GPU transfers, overhead dominates
- **Large batches**: Better GPU utilization, fewer transfers
- **GPU works best with large batches** (hundreds to thousands of tokens)

**Current**: batch=2048, ubatch=512 (default)
**Testing**: 512/128, 1024/256, 4096/512, 8192/1024

**Expected Impact**: Could improve GPU performance by 2-5x if batch size is bottleneck.

---

### 2. Flash Attention (`-fa`)

**What it does**: Memory-efficient attention mechanism that reduces VRAM usage and can speed up inference.

**Options**:
- `auto` (default): Let llama.cpp decide
- `on`: Force enable
- `off`: Disable

**Why it matters**:
- **Pro**: Reduces memory bandwidth (critical for UMA like Intel Iris Xe)
- **Pro**: Can be faster for large context lengths
- **Con**: Might be slower for small batches or short sequences
- **Con**: Intel Vulkan driver might not optimize it well

**Current**: Auto (enabled for our tests)
**Testing**: ON vs OFF

**Expected Impact**: Could help or hurt - Intel Vulkan implementation might be buggy.

---

### 3. Thread Count (`-t`)

**What it does**: Controls CPU parallelism for CPU-based operations.

**Why it matters**:
- Your i9-13900H has 20 threads (6 P-cores + 8 E-cores)
- **Too few threads**: CPU underutilized
- **Too many threads**: Context switching overhead
- **Optimal**: Usually 50-75% of available threads

**Current**: 6 threads (default)
**Testing**: 4, 8, 12, 20 threads

**Expected Impact**: Could improve CPU performance by 30-50% with optimal thread count.

---

### 4. KV Cache Type (`-ctk`, `-ctv`)

**What it does**: Controls quantization level of Key-Value cache in memory.

**Options**:
- `f16` (default): Full precision, 2 bytes per value
- `q8_0`: 8-bit quantization, 1 byte per value (50% memory savings)
- `q4_0`: 4-bit quantization, 0.5 bytes per value (75% memory savings)

**Why it matters**:
- **Your 4B model**: 576 MiB KV cache in f16
  - With q8_0: 288 MiB (saves 288 MiB)
  - With q4_0: 144 MiB (saves 432 MiB)
- **Less memory = less bandwidth pressure** (critical for UMA)
- **Trade-off**: Slightly lower quality (usually negligible)

**Current**: f16 (full precision)
**Testing**: q8_0, q4_0

**Expected Impact**: Could improve performance by 10-20% on memory-bandwidth-limited Intel GPU.

---

### 5. Memory Mapping

#### `--mlock`
**What it does**: Forces OS to keep model in RAM (no swapping to disk).

**Why it matters**:
- Prevents page faults during inference
- Ensures consistent performance
- **Downside**: Uses 2.4GB of RAM permanently

**Expected Impact**: Minor (5-10% improvement if swapping was occurring).

#### `--no-mmap`
**What it does**: Load entire model into memory instead of memory-mapping.

**Why it matters**:
- **Memory mapping** (default): OS loads model pages on-demand
- **No mmap**: Load everything upfront
- Trade-off: Slower startup, but might be faster for inference

**Expected Impact**: Likely neutral or slightly worse.

---

### 6. Alternative Inference Engines

#### `llama-batched`
**What it does**: Optimized for batch processing multiple requests.

**Why it matters**:
- Better GPU utilization through batching
- Designed for server/API workloads
- Might have better defaults for GPU

**Expected Impact**: Unknown - might be 2-3x faster.

#### `llama-simple`
**What it does**: Minimal implementation with fewer features.

**Why it matters**:
- Less overhead
- Simpler code path
- Might expose raw performance better

**Expected Impact**: Likely similar to llama-cli, but worth testing.

---

## Combined Optimizations (Test #8)

We'll combine the best settings from each category:

**GPU Optimized**:
```bash
-ngl 99           # All layers on GPU
-b 8192           # Large batch
-ub 1024          # Large ubatch
-fa on            # Flash Attention
--mlock           # Lock in RAM
-ctk q8_0         # Quantized KV cache
-ctv q8_0         # Quantized KV cache
```

**CPU Optimized**:
```bash
-ngl 0            # CPU only
-b 8192           # Large batch
-ub 1024          # Large ubatch
-t 20             # All threads
--mlock           # Lock in RAM
```

---

## What to Expect

### Best Case Scenario
- Find optimal batch size → 2-5x improvement
- KV cache quantization → +10-20%
- Thread optimization → +30-50% (CPU)
- **Total potential**: 3-8x improvement
- **Result**: 17-46 tok/s (might hit 30 tok/s target!)

### Worst Case Scenario
- Optimizations don't help → ~6-7 tok/s
- Intel Vulkan driver is fundamentally slow
- **Conclusion**: Need different hardware or inference engine

### Most Likely Outcome
- Some improvements, but not enough
- Get to 10-15 tok/s (better, but still short)
- Confirms we need smaller model (1.7B or 0.8B)

---

## After This Test

Based on results, we'll know:

1. **If optimizations help** → Apply best config to all models
2. **If GPU is still slower** → Stick with CPU inference
3. **If still below target** → Test 1.7B model with best config
4. **If nothing helps** → Consider:
   - Different inference engine (vLLM, TensorRT-LLM)
   - Cloud GPU (NVIDIA CUDA)
   - Custom Rust implementation (back to original plan, but informed)

---

## Real-Time Monitoring

To watch GPU utilization during tests:
```bash
# In another terminal:
watch -n 1 intel_gpu_top
```

This will show if GPU is actually being utilized or sitting idle.

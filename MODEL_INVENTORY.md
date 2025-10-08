# Model Inventory - System-Wide Scan

**Scan Date**: October 4, 2025  
**Total System RAM**: 40GB Unified Memory  
**Target Performance**: 30+ tok/s

---

## Executive Summary

### Models Found by Format

- **GGUF Models**: 11 unique models (excluding vocab files and duplicates)
- **SafeTensors Models**: Multiple versions across training checkpoints
- **OpenVINO Models**: 1 large 14B model + cache

### Key Models for Production Use

1. **Qwen3-30B-A3B-Instruct** (Q4_K_M) - 18GB - 🏆 **BEST FOR QUALITY**
2. **Qwen3-Coder-30B-A3B-Instruct** (Q4_K_M) - 18GB - 🏆 **BEST FOR CODING**
3. **Devstral-Small-2505** (Q4_K_M) - 14GB - Mistral coder
4. **Qwen2.5-Coder-14B** (SafeTensors) - 28GB full - Good balance
5. **DeepSeek-R1-Qwen3-8B** (Q4_K_M) - 4.7GB - Reasoning model
6. **Qwen3-4B-Thinking** (Q4_K_M) - 2.4GB - Fast with reasoning
7. **Qwen3-1.7B** (Q8_0) - 2.1GB - Very fast
8. **Qwen3-Zero-Coder-0.8B** (Q5_K_M) - 573MB - Ultra fast (current)

---

## GGUF Models (Production Ready)

### 30B Models - High Quality (18GB each)

**Location**: `.lmstudio/models/lmstudio-community/`

1. **Qwen3-30B-A3B-Instruct-2507-Q4_K_M.gguf**
   - Size: 18GB
   - Format: Q4_K_M quantization
   - Expected speed: 12-18 tok/s
   - Use case: Highest quality general + coding
   - Duplicated in: `.lmstudio/hub/models/` (will consolidate)

2. **Qwen3-Coder-30B-A3B-Instruct-Q4_K_M.gguf**
   - Size: 18GB
   - Format: Q4_K_M quantization
   - Expected speed: 12-18 tok/s
   - Use case: Highest quality coding specialist
   - Duplicated in: `.lmstudio/hub/models/` (will consolidate)

### 24B Models - Mistral Coder (14GB)

**Location**: `.lmstudio/models/lmstudio-community/Devstral-Small-2505-GGUF/`

3. **Devstral-Small-2505-Q4_K_M.gguf**
   - Size: 14GB
   - Format: Q4_K_M quantization
   - Expected speed: 18-25 tok/s
   - Use case: Mistral coder model
   - Duplicated in: `.lmstudio/hub/models/` (will consolidate)

### 14B Models - Qwen2.5 Coder (28GB merged)

**Location**: `/home/archlinux/code_insiders/openvino/qwen2_5_coder_14b_gguf/`

4. **qwen2_5_coder_14b_merged.gguf**
   - Size: 28GB (appears to be merged/unquantized)
   - Expected speed: 20-30 tok/s
   - Use case: High quality coding
   - Also split into 6 chunks (will consolidate)

### 8B Models - Reasoning (4.7GB)

**Location**: `.lmstudio/models/lmstudio-community/DeepSeek-R1-0528-Qwen3-8B-GGUF/`

5. **DeepSeek-R1-0528-Qwen3-8B-Q4_K_M.gguf**
   - Size: 4.7GB
   - Format: Q4_K_M quantization  
   - Expected speed: 25-35 tok/s
   - Use case: Reasoning + coding (DeepSeek R1 based)

### 4B Models - Thinking (2.4GB)

**Location**: Multiple locations

6. **Qwen3-4B-Thinking-2507-Q4_K_M.gguf**
   - Size: 2.4GB
   - Format: Q4_K_M quantization
   - Expected speed: 40-55 tok/s ✅ **EXCEEDS TARGET**
   - Use case: Fast coding with thinking capability
   - Locations:
     - `/home/archlinux/experimental/model/qwen3_4B/`
     - `.lmstudio/hub/models/lmstudio-community/Qwen3-4B-Thinking-2507-GGUF/`
     - `.lmstudio/models/lmstudio-community/Qwen3-4B-Thinking-2507-GGUF/`

### 1.7B Models - Very Fast (2.1GB)

**Location**: Multiple backup directories

7. **qwen3-1.7b-q8_0.gguf**
   - Size: 2.1GB
   - Format: Q8_0 quantization (high quality)
   - Expected speed: 60-80 tok/s ✅ **FAR EXCEEDS TARGET**
   - Use case: Ultra-fast coding
   - Found in ~10 backup locations (will consolidate to 1)

### 0.8B Models - Ultra Fast (573MB) - CURRENT

**Location**: `/home/archlinux/code_insiders/ml_ai_engineering/q3_zero_.8b/`

8. **Qwen3-Zero-Coder-Reasoning-0.8B.i1-Q5_K_M.gguf**
   - Size: 573MB
   - Format: Q5_K_M with imatrix
   - Current speed: 1.09 tok/s (with reasoning loops)
   - Expected speed (no reasoning): 80-100 tok/s
   - Use case: Ultra-fast simple code generation
   - **Currently testing this model**

9. **model_q4_k_m.gguf** (same model)
   - Size: 504MB
   - Format: Q4_K_M quantization
   - Alternative lower-quality quant

10. **model_f16.gguf** (same model)
    - Size: 1.6GB
    - Format: Full F16 precision
    - Unquantized version

---

## SafeTensors Models (Training & Conversion)

### 14B Models - Qwen2.5 Coder

**Location**: Multiple locations

- **Qwen2.5-Coder-14B-Instruct** (Split into 6 files, ~28GB total)
  - Locations:
    - `/home/archlinux/code_insiders/openvino/qwen2_5_coder_14b/model/`
    - `.lmstudio/hub/models/Qwen_a/Qwen2.5-Coder-14B-Instruct/model/`
    - `.lmstudio/models/Qwen/Qwen2.5-Coder-14B-Instruct/model/`

### 4B Models - Training Checkpoints

**Location**: `/home/archlinux/code_insiders/training/qwen3_4B/`

Multiple custom-trained 4B models:
- `qwen3_4b_final_professional/` - 5 files @ 1.9GB each (~9.5GB total)
- `qwen3_4B_full_base/` - 3 files @ 3.7-3.8GB each (~11GB total)
- Various pipeline merge stages
- LoRA adapter checkpoints

### 1.7B Models - Base & Fine-tuned

**Location**: Multiple directories

- **Qwen3-1.7B base models** (split into 2 files, ~3.9GB total)
  - model-00001-of-00002.safetensors: 3.3GB
  - model-00002-of-00002.safetensors: 594MB
  - Found in ~40 locations (multiple backups, will consolidate)

### 0.8B Models - Zero Coder

**Location**: Current project + backups

- **Qwen3-Zero-Coder model.safetensors**
  - Size: 1.6GB (F16 precision)
  - Found in ~8 backup locations

---

## OpenVINO Models

### 14B Models - Qwen2.5 Coder

**Location**: `/home/archlinux/code_insiders/openvino/`

- **Qwen2.5-Coder-14B-OpenVINO**
  - `openvino_model.bin`: Size varies
  - Model cache: 14.2GB blob
  - Duplicated in `.lmstudio/` locations

---

## Consolidation Plan

### Priority 1: Keep for Production (Move to local_models/)

**GGUF - Production Ready:**
1. ✅ Qwen3-30B-A3B-Instruct-Q4_K_M.gguf (18GB) - Keep 1 copy
2. ✅ Qwen3-Coder-30B-A3B-Instruct-Q4_K_M.gguf (18GB) - Keep 1 copy  
3. ✅ Devstral-Small-2505-Q4_K_M.gguf (14GB) - Keep 1 copy
4. ✅ DeepSeek-R1-Qwen3-8B-Q4_K_M.gguf (4.7GB) - Keep 1 copy
5. ✅ Qwen3-4B-Thinking-2507-Q4_K_M.gguf (2.4GB) - Keep 1 copy
6. ✅ qwen3-1.7b-q8_0.gguf (2.1GB) - Keep 1 copy
7. ✅ Qwen3-Zero-Coder-0.8B.i1-Q5_K_M.gguf (573MB) - Keep (current)

**SafeTensors - Keep Best:**
1. ✅ Qwen2.5-Coder-14B-Instruct (28GB split) - Keep 1 copy for conversion
2. ✅ qwen3_4b_final_professional (~9.5GB) - Keep for custom use
3. ✅ Qwen3-1.7B base (3.9GB) - Keep 1 copy

**OpenVINO:**
1. ✅ Qwen2.5-Coder-14B-OpenVINO - Keep 1 copy

### Priority 2: Delete (Duplicates & Backups)

- All duplicate copies in backup directories
- LMStudio hub duplicates (keep only models/ directory versions)
- Old training checkpoints (keep only final merged versions)
- Vocab-only files (tiny, but clutter)

### Expected Space Savings

**Current usage by duplicates:**
- ~250GB in duplicate 1.7B and 4B SafeTensor models
- ~60GB in GGUF duplicates (mostly in LMStudio hub vs models)
- ~40GB in old training checkpoints

**After consolidation:**
- **Total unique models:** ~120GB
- **Space freed:** ~210GB

---

## Recommended Models for 30 tok/s Target

### Best Options (Will Exceed Target):

1. **Qwen3-4B-Thinking-2507-Q4_K_M.gguf** (2.4GB)
   - Expected: 40-55 tok/s ✅
   - Quality: Very good
   - Has reasoning capability
   - **RECOMMENDED CHOICE**

2. **qwen3-1.7b-q8_0.gguf** (2.1GB)
   - Expected: 60-80 tok/s ✅
   - Quality: Good (Q8 quantization)
   - Very fast
   - Alternative if 4B is too slow

3. **DeepSeek-R1-Qwen3-8B-Q4_K_M.gguf** (4.7GB)
   - Expected: 25-35 tok/s ✅
   - Quality: Excellent (reasoning model)
   - More capable but slightly slower
   - Use if need advanced reasoning

### High Quality Options (Borderline):

4. **Devstral-Small-2505-Q4_K_M.gguf** (14GB)
   - Expected: 18-25 tok/s
   - Quality: Excellent (Mistral)
   - May not quite hit 30 tok/s

5. **Qwen3-30B models** (18GB each)
   - Expected: 12-18 tok/s
   - Quality: Best available
   - Too slow for target

---

## Next Steps

1. ✅ Move unique GGUF models to `local_models/gguf/` (organized by size)
2. ✅ Move unique SafeTensors to `local_models/safetensors/` (organized by size)
3. ✅ Move OpenVINO models to `local_models/openvino/`
4. ❌ Delete all duplicates from backup dirs, LMStudio hub, etc.
5. ✅ Test Qwen3-4B-Thinking model (best candidate for 30+ tok/s)
6. ✅ Update llama.cpp test scripts to use consolidated model paths

---

*Generated by system-wide model scan on October 4, 2025*

# Multimodal Vision-Language Model Comparison (Oct 2025)

## Your Requirements
- Screenshot understanding for kernel-level AI agent
- Coding capability
- ≥10 tok/s on Intel i9-13900H + Iris Xe GPU (40GB RAM)
- Ready to use NOW (can't wait for Qwen3-VL)

## Your Available Tools (Already Built)
✅ `llama-mtmd-cli` - Unified multimodal (supports Qwen2-VL)
✅ `llama-llava-cli` - LLaVA models  
✅ `llama-minicpmv-cli` - MiniCPM-V models

---

## Option 1: MiniCPM-V 2.6 ⭐ RECOMMENDED FOR IMMEDIATE USE

**Model Details:**
- Size: 2.4B parameters (MoE with 0.5B active)
- GGUF: Pre-quantized, ready to download
- Download: 1.6GB (Q4_K_M) or 2.0GB (Q5_K_M)

**Capabilities:**
- General screenshot/image understanding ✅
- OCR and text extraction ✅
- UI element recognition ✅
- Chart/diagram understanding ✅
- Multi-language support ✅

**Performance Estimates (Your Hardware):**
- CPU (20 threads): 15-20 tok/s
- GPU (Vulkan): 25-30 tok/s (when bugs fixed)
- **Meets your ≥10 tok/s requirement** ✅

**Pros:**
- Fastest to get working (direct GGUF download)
- Small, efficient
- Good general-purpose vision
- Well-tested in llama.cpp

**Cons:**
- Not specifically trained on code/UI tasks
- Less OCR languages than Qwen2-VL (but still capable)

**Links:**
- Model: https://huggingface.co/openbmb/MiniCPM-V-2_6-gguf
- CLI: `llama-minicpmv-cli`

---

## Option 2: Qwen2-VL-2B ⭐ BEST FOR CODE/UI UNDERSTANDING

**Model Details:**
- Size: 2.21B parameters
- GGUF: Requires conversion from HuggingFace
- Download: ~5GB HF model → convert to ~2GB GGUF

**Capabilities:**
- **Screenshot/UI understanding** ✅✅ (specialized)
- **Code generation from images** ✅✅
- **OCR in 19 languages** ✅✅
- **Visual agent capabilities** ✅✅ (can identify UI elements)
- Chart/diagram understanding ✅
- Video understanding (20+ min) ✅

**Performance Estimates (Your Hardware):**
- CPU (20 threads): 12-15 tok/s
- GPU (Vulkan): 20-25 tok/s (when bugs fixed)
- **Meets your ≥10 tok/s requirement** ✅

**Pros:**
- Specifically trained for code/UI tasks
- Best OCR capabilities
- Agent-ready (can understand clickable elements)
- Supports long context (32K tokens)
- Better for your kernel-level agent use case

**Cons:**
- Requires conversion from HuggingFace (more setup)
- Slightly slower than MiniCPM-V

**Links:**
- Model: https://huggingface.co/Qwen/Qwen2-VL-2B-Instruct
- CLI: `llama-mtmd-cli`
- Docs: https://github.com/ggerganov/llama.cpp/pull/10361

---

## Option 3: LLaVA 1.6 Vicuna 7B - MATURE/STABLE

**Model Details:**
- Size: 7B parameters
- GGUF: Pre-quantized available
- Download: ~4GB (Q4_K_M)

**Capabilities:**
- General image understanding ✅✅
- Detailed descriptions ✅✅
- Chart/document analysis ✅
- Screenshot analysis ✅

**Performance Estimates (Your Hardware):**
- CPU (20 threads): 8-10 tok/s
- GPU (Vulkan): 15-18 tok/s (when bugs fixed)
- **Borderline meets ≥10 tok/s requirement** ⚠️

**Pros:**
- Most mature/tested in llama.cpp
- High quality outputs
- Large community support
- Good for general vision tasks

**Cons:**
- Larger, slower
- Not optimized for code/UI
- May be just under 10 tok/s on CPU
- Not specialized for your use case

**Links:**
- Model: https://huggingface.co/cjpais/llava-1.6-vicuna-7b-gguf
- CLI: `llama-llava-cli`

---

## Option 4: Qwen3-VL-30B-A3B ❌ NOT READY YET

**Model Details:**
- Size: 31B parameters (MoE with 3B active)
- Status: **NOT SUPPORTED in llama.cpp yet**
- ETA: 2-4 weeks

**Why Not Ready:**
- Requires new `deepstack_merger` architecture
- GitHub issue #16207 tracking implementation
- llama.cpp team actively working on it

**When Available, Would Offer:**
- Best-in-class screenshot/UI understanding
- Visual agent capabilities
- 256K context (1M expandable)
- OCR in 32 languages
- Superior coding from images

**Recommendation:** Wait for this as an upgrade path, but start with Option 1 or 2 now.

---

## Performance Comparison Table

| Model | Size | CPU Speed | GPU Speed* | Setup Time | Code/UI Focus | OCR Quality |
|-------|------|-----------|------------|------------|---------------|-------------|
| **MiniCPM-V 2.6** | 2.4B | 15-20 tok/s | 25-30 tok/s | 5 min | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Qwen2-VL-2B** | 2.2B | 12-15 tok/s | 20-25 tok/s | 20 min | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| LLaVA 1.6 7B | 7B | 8-10 tok/s | 15-18 tok/s | 10 min | ⭐⭐ | ⭐⭐⭐ |
| Qwen3-VL-30B | 31B | N/A | N/A | Not ready | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

*GPU speeds when Vulkan backend bugs are fixed (currently use CPU)

---

## Known Issues

### Vulkan Backend Broken (All Models)
- **Issue:** Garbled/gibberish output on Vulkan backend
- **Affected:** All Qwen3 models, various GPUs including Intel Iris Xe
- **GitHub Issues:** #15875, #15846, #15974
- **Workaround:** Use CPU backend (`-ngl 0`) until fixed
- **Impact:** 15-20 tok/s on CPU vs potential 25-30 tok/s on GPU

### Qwen3-VL Not Supported
- **Issue:** New architecture not yet implemented
- **GitHub Issue:** #16207
- **ETA:** 2-4 weeks
- **Workaround:** Use Qwen2-VL-2B instead (90% of capabilities)

---

## My Recommendations

### For Immediate Work (TODAY):
**Choose: MiniCPM-V 2.6**
- Fastest to download and test (5 minutes)
- Meets speed requirements (15-20 tok/s CPU)
- Good enough for screenshot understanding
- Get working immediately, optimize later

### For Best Long-Term Solution:
**Choose: Qwen2-VL-2B**
- Purpose-built for code/UI understanding
- Better OCR (19 languages)
- Agent capabilities (understands clickable elements)
- Worth 20 min setup for superior results
- Upgrade path to Qwen3-VL when ready

### For Maximum Stability:
**Choose: LLaVA 1.6 7B**
- Most mature/tested
- But may be borderline on speed (8-10 tok/s)

---

## Setup Time Estimates

| Model | Download Time | Conversion Time | Total Setup | Complexity |
|-------|---------------|-----------------|-------------|------------|
| MiniCPM-V 2.6 | 3-5 min | None | **5 min** | Easy |
| Qwen2-VL-2B | 5-10 min | 5-10 min | **20 min** | Medium |
| LLaVA 1.6 7B | 5-8 min | None | **10 min** | Easy |

---

## Decision Matrix

**If you need:**
- ✅ Working solution RIGHT NOW → **MiniCPM-V 2.6**
- ✅ Best code/UI understanding → **Qwen2-VL-2B**
- ✅ Maximum stability → **LLaVA 1.6 7B**
- ✅ State-of-art (future) → **Wait for Qwen3-VL** (2-4 weeks)

**My recommendation for your kernel-level AI agent:**
1. Start with **MiniCPM-V 2.6** today (get working fast)
2. Test with **Qwen2-VL-2B** within this week (better for your use case)
3. Monitor GitHub issue #16207 for **Qwen3-VL** support
4. Upgrade when Vulkan bugs are fixed for 2x speed boost

---

## Next Steps (When You Decide)

I'll help you:
1. Download the model you choose
2. Test with a screenshot
3. Measure actual speed on your hardware
4. Create integration script for your agent
5. Set up semantic DB connection

Just let me know which model you want to start with!

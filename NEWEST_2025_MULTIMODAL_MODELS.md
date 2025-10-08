# Newest 2025 Multimodal Vision-Language Models

## 🔥 Latest Cutting-Edge Models (Sept-Oct 2025)

### 1. **Granite Docling 258M** ⭐ NEWEST TINY MODEL (Sept 17, 2025)
- **Size:** 258M parameters (0.25B!)
- **Architecture:** Idefics3 + SigLIP2 + Granite 165M LLM
- **Release:** September 17, 2025 (2 weeks old!)
- **Speed Estimate:** 30-40+ tok/s on your hardware

**Capabilities:**
- Document parsing & conversion ✅✅✅
- OCR (English + experimental Japanese/Arabic/Chinese) ✅✅✅
- Code extraction from images ✅✅
- Formula/LaTeX recognition ✅✅✅
- Table extraction (including rotated/borderless) ✅✅✅
- Chart understanding ✅✅
- Screenshot analysis ✅

**llama.cpp Status:**
- ❓ NOT CONFIRMED - Uses Idefics3 architecture
- May need conversion work
- 4 quantized GGUF versions available on HuggingFace

**Best For:**
- **Document-heavy workflows**
- OCR and text extraction
- Fastest inference (smallest model)
- Perfect for your kernel agent's screenshot needs!

**Links:**
- Model: https://huggingface.co/ibm-granite/granite-docling-258M
- GGUF: https://huggingface.co/ibm-granite/granite-docling-258M/tree/main (check for .gguf files)

---

### 2. **Moondream3 Preview** 🌙 SOTA SMALL MODEL (September 2025)
- **Size:** 9B total (MoE with 2B active)
- **Architecture:** Custom MoE with 64 experts, 8 active per token
- **Release:** September 2025
- **Speed Estimate:** 12-18 tok/s on your hardware

**Capabilities:**
- Visual reasoning ✅✅✅✅
- Open vocabulary detection ✅✅✅
- Point counting ✅✅
- Structured outputs ✅✅✅
- Object detection with bounding boxes ✅✅✅
- Screenshot understanding ✅✅
- Code understanding ✅✅
- 32K context window ✅✅✅

**llama.cpp Status:**
- ❌ NOT SUPPORTED - Custom architecture
- Requires transformers + custom code
- May not be portable to llama.cpp

**Licensing:**
- ⚠️ BSL 1.1 (Business Source License)
- Can use internally but NOT for external APIs
- Contact required for commercial offerings

**Best For:**
- Best-in-class visual reasoning
- Complex screenshot analysis
- Object detection needs
- BUT: Not open enough for some commercial use

**Links:**
- Model: https://huggingface.co/moondream/moondream3-preview

---

### 3. **MinerU2.5 1.2B** 📄 DOCUMENT SPECIALIST (Sept 22, 2025)
- **Size:** 1.2B parameters  
- **Architecture:** Qwen2-VL based (decoupled two-stage)
- **Release:** September 22, 2025
- **Speed Estimate:** 20-25 tok/s on your hardware

**Capabilities:**
- **Document parsing (state-of-the-art)** ✅✅✅✅✅
- Formula recognition (complex/long equations) ✅✅✅✅✅
- Table parsing (rotated/borderless/partial) ✅✅✅✅
- Layout analysis (comprehensive & granular) ✅✅✅✅
- Code block recognition ✅✅✅
- Mixed Chinese-English formulas ✅✅✅
- Screenshot understanding ✅✅

**llama.cpp Status:**
- 🟡 BASED ON QWEN2-VL (supported architecture)
- May work with existing Qwen2-VL support
- 3 quantized versions available

**Performance:**
- 2.12 FPS on A100 (async vllm)
- Extremely fast for document tasks

**Best For:**
- Technical document parsing
- Academic papers with formulas
- Complex table extraction
- PDF/document screenshot analysis

**Links:**
- Model: https://huggingface.co/opendatalab/MinerU2.5-2509-1.2B
- Paper: https://arxiv.org/abs/2509.22186

---

## Comparison with "Old" Models

| Model | Released | Size | Active Params | Architecture | llama.cpp | Speed (est) |
|-------|----------|------|---------------|--------------|-----------|-------------|
| **Granite Docling** | Sept 17, 2025 | 258M | 258M | Idefics3 | ❓ Unknown | 30-40 tok/s |
| **MinerU2.5** | Sept 22, 2025 | 1.2B | 1.2B | Qwen2-VL | 🟡 Possible | 20-25 tok/s |
| **Moondream3** | Sept 2025 | 9B | 2B | Custom MoE | ❌ No | 12-18 tok/s |
| Qwen2-VL-2B | Aug 2024 | 2.2B | 2.2B | Qwen2-VL | ✅ Yes | 12-15 tok/s |
| MiniCPM-V 2.6 | Jun 2024 | 2.4B | 0.5B | MiniCPM | ✅ Yes | 15-20 tok/s |

---

## llama.cpp Support Status Check

Let me check which of these new models might work:

<function_calls>
<invoke name="run_in_terminal">
<parameter name="explanation">Check if any new model support was added to llama.cpp recently
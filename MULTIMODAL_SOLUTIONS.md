# IMMEDIATE Multimodal Vision Solutions for Work (Oct 4, 2025)

## ✅ You Already Have the Tools Built!
- `llama-mtmd-cli` (unified multimodal - supports Qwen2-VL)
- `llama-llava-cli` (LLaVA models)
- `llama-minicpmv-cli` (MiniCPM-V models)

---

## 🚀 FASTEST SOLUTION: MiniCPM-V 2.6 (2.4GB, ~15-20 tok/s)

**Why MiniCPM-V:**
- Small (2.4B params)
- Fast on your hardware (~15-20 tok/s estimated)
- Excellent screenshot/UI understanding
- Easy to download and run TODAY

### Step 1: Download Model
```bash
cd /home/archlinux/code_insiders/ml_ai_engineering/local_models

# Create directory
mkdir -p minicpm-v

# Download from HuggingFace (choose one):
# Option A: Q4_K_M (smaller, 1.6GB)
wget https://huggingface.co/openbmb/MiniCPM-V-2_6-gguf/resolve/main/ggml-model-Q4_K_M.gguf -O minicpm-v/model-q4.gguf
wget https://huggingface.co/openbmb/MiniCPM-V-2_6-gguf/resolve/main/mmproj-model-f16.gguf -O minicpm-v/mmproj-f16.gguf

# Option B: Q5_K_M (better quality, 2.0GB)
wget https://huggingface.co/openbmb/MiniCPM-V-2_6-gguf/resolve/main/ggml-model-Q5_K_M.gguf -O minicpm-v/model-q5.gguf
wget https://huggingface.co/openbmb/MiniCPM-V-2_6-gguf/resolve/main/mmproj-model-f16.gguf -O minicpm-v/mmproj-f16.gguf
```

### Step 2: Test with Screenshot
```bash
cd /home/archlinux/code_insiders/ml_ai_engineering

# Take a screenshot first (use your screenshot tool, or):
# scrot screenshot.png  # or use GUI tool

# Test with CPU (Vulkan has bugs currently)
./llama.cpp/build/bin/llama-minicpmv-cli \
  -m local_models/minicpm-v/model-q4.gguf \
  --mmproj local_models/minicpm-v/mmproj-f16.gguf \
  --image screenshot.png \
  -p "Describe what you see in this screenshot in detail." \
  -ngl 0 -t 20
```

---

## 🎯 SOLUTION 2: Qwen2-VL-2B (Better for Code/UI, ~12-15 tok/s)

**Why Qwen2-VL:**
- Specifically trained on code and UI understanding
- Better OCR (19 languages)
- Agent capabilities for UI interaction
- Already supported by llama-mtmd-cli

### Step 1: Download HuggingFace Model
```bash
cd /home/archlinux/code_insiders/ml_ai_engineering/local_models
mkdir -p qwen2-vl-2b

# Install HuggingFace CLI if needed
pip install -U "huggingface_hub[cli]"

# Download model
huggingface-cli download Qwen/Qwen2-VL-2B-Instruct \
  --local-dir qwen2-vl-2b/hf_model \
  --local-dir-use-symlinks False
```

### Step 2: Convert to GGUF
```bash
cd /home/archlinux/code_insiders/ml_ai_engineering

# Convert LLM part
python3 llama.cpp/convert_hf_to_gguf.py \
  local_models/qwen2-vl-2b/hf_model \
  --outfile local_models/qwen2-vl-2b/qwen2-vl-2b-f16.gguf \
  --outtype f16

# Convert vision encoder
python3 llama.cpp/examples/llava/qwen2_vl_surgery.py \
  local_models/qwen2-vl-2b/hf_model

# Move vision encoder
mv qwen2vl-vision.gguf local_models/qwen2-vl-2b/

# Quantize for speed (optional)
./llama.cpp/build/bin/llama-quantize \
  local_models/qwen2-vl-2b/qwen2-vl-2b-f16.gguf \
  local_models/qwen2-vl-2b/qwen2-vl-2b-q4.gguf \
  Q4_K_M
```

### Step 3: Test
```bash
# Use CPU backend (Vulkan broken)
./llama.cpp/build/bin/llama-mtmd-cli \
  -m local_models/qwen2-vl-2b/qwen2-vl-2b-q4.gguf \
  --mmproj local_models/qwen2-vl-2b/qwen2vl-vision.gguf \
  --image screenshot.png \
  -p "What UI elements do you see? List all buttons and their functions." \
  -ngl 0 -t 20
```

---

## 🔥 SOLUTION 3: LLaVA 1.6 Vicuna 7B (General Purpose)

**Why LLaVA:**
- Most mature, stable support
- Good general vision understanding
- Pre-quantized GGUF available

### Quick Setup
```bash
cd /home/archlinux/code_insiders/ml_ai_engineering/local_models
mkdir -p llava

# Download pre-quantized GGUF
wget https://huggingface.co/cjpais/llava-1.6-vicuna-7b-gguf/resolve/main/llava-1.6-vicuna-7b.Q4_K_M.gguf -O llava/model.gguf
wget https://huggingface.co/cjpais/llava-1.6-vicuna-7b-gguf/resolve/main/mmproj-vicuna7b-f16.gguf -O llava/mmproj.gguf

# Test
./llama.cpp/build/bin/llama-llava-cli \
  -m local_models/llava/model.gguf \
  --mmproj local_models/llava/mmproj.gguf \
  --image screenshot.png \
  -p "Analyze this screenshot and describe what the user is doing." \
  -ngl 0 -t 20
```

---

## ⚡ Quick Download Commands (Choose One)

### FASTEST TO GET WORKING (Recommended for immediate use):
```bash
cd /home/archlinux/code_insiders/ml_ai_engineering/local_models
mkdir -p minicpm-v && cd minicpm-v
wget https://huggingface.co/openbmb/MiniCPM-V-2_6-gguf/resolve/main/ggml-model-Q4_K_M.gguf -O model.gguf
wget https://huggingface.co/openbmb/MiniCPM-V-2_6-gguf/resolve/main/mmproj-model-f16.gguf -O mmproj.gguf
cd ../..

# Test immediately:
./llama.cpp/build/bin/llama-minicpmv-cli \
  -m local_models/minicpm-v/model.gguf \
  --mmproj local_models/minicpm-v/mmproj.gguf \
  --image YOUR_SCREENSHOT.png \
  -p "What do you see?" \
  -ngl 0 -t 20
```

---

## 🐛 Why CPU Backend (-ngl 0)?

Your Vulkan backend has known bugs (Issues #15875, #15846):
- Garbled output with Qwen3 models
- Gibberish generation on various GPUs
- Regression since build b6264

**CPU Performance on your i9-13900H:**
- 20 threads available
- Expected: 12-20 tok/s for 2-3B models
- Acceptable for work use

---

## 📊 Speed Expectations

| Model | Size | CPU Speed | GPU Speed (when fixed) |
|-------|------|-----------|------------------------|
| MiniCPM-V 2.6 Q4 | 1.6GB | ~15-18 tok/s | ~25-30 tok/s |
| Qwen2-VL-2B Q4 | ~2GB | ~12-15 tok/s | ~20-25 tok/s |
| LLaVA 1.6 7B Q4 | ~4GB | ~8-10 tok/s | ~15-18 tok/s |

---

## 🎯 MY RECOMMENDATION FOR TODAY:

**Start with MiniCPM-V 2.6** - It's the fastest to download and test (2 wget commands), and should give you ~15 tok/s on CPU which exceeds your 10 tok/s requirement.

Once working, you can test Qwen2-VL-2B for better code/UI understanding if needed.

---

## 🔧 If Download Fails

Alternative using huggingface-cli:
```bash
pip install -U "huggingface_hub[cli]"

# MiniCPM-V
huggingface-cli download openbmb/MiniCPM-V-2_6-gguf \
  ggml-model-Q4_K_M.gguf mmproj-model-f16.gguf \
  --local-dir local_models/minicpm-v
```

---

## Next Steps After Getting Working:

1. Create Python wrapper for automation
2. Integrate with semantic DB
3. Set up auto-screenshot capture
4. Wait for Vulkan fixes for GPU acceleration
5. Wait for Qwen3-VL support (~2-4 weeks)

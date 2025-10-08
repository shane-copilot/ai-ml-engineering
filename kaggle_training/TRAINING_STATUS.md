# Kaggle Training Setup - COMPLETED ✅

## What We've Done

### 1. ✅ Kaggle API Configured
- API token installed in `~/.kaggle/kaggle.json`
- Connection verified (can list competitions)

### 2. ✅ Model Files Uploaded (1.57 GB)
- **Model:** Qwen3-Zero-Coder-Reasoning-0.8B
- **Files uploaded:**
  - model.safetensors (1.52 GB)
  - tokenizer.json (10.9 MB)
  - config.json
  - tokenizer_config.json
  - special_tokens_map.json
  - added_tokens.json

### 3. ✅ Training Notebook Created
- Location: `/home/archlinux/code_insiders/ml_ai_engineering/kaggle_training/phase1_training.ipynb`
- Dataset: CodeAlpaca-20k (20,000 code examples)
- Expected time: 2-3 hours on T4 GPU

## Next Steps (Do This Now)

### Step 1: Verify Dataset Upload
Go to: https://www.kaggle.com/ericgross1/datasets

You should see "Qwen3 0.8B Coder Model Safetensors" dataset

### Step 2: Create Kaggle Notebook
1. Go to: https://www.kaggle.com/code
2. Click "New Notebook"
3. Click "File" → "Upload Notebook"
4. Upload: `/home/archlinux/code_insiders/ml_ai_engineering/kaggle_training/phase1_training.ipynb`

### Step 3: Configure Notebook
1. Click "Add Data" → Search "qwen3-coder-08b-safetensors" → Add your dataset
2. Click "Accelerator" → Select "GPU T4 x2" or "GPU P100"
3. Click "Save Version" → "Save & Run All"

### Step 4: Monitor Training
Training will take **2-3 hours**. You can:
- Close browser (training continues)
- Check progress: https://www.kaggle.com/code/ericgross1
- Download when complete: Output section → `qwen3-08b-phase1-codealpaca.zip`

## Alternative: Upload Notebook via CLI

If web interface doesn't work:

```bash
cd /home/archlinux/code_insiders/ml_ai_engineering/kaggle_training

# Create kernel metadata
cat > kernel-metadata.json << 'EOF'
{
  "id": "ericgross1/qwen3-phase1-codealpaca",
  "title": "Qwen3 0.8B Phase 1 - CodeAlpaca Training",
  "code_file": "phase1_training.ipynb",
  "language": "python",
  "kernel_type": "notebook",
  "is_private": true,
  "enable_gpu": true,
  "enable_internet": true,
  "dataset_sources": ["ericgross1/qwen3-coder-08b-safetensors"],
  "competition_sources": [],
  "kernel_sources": []
}
EOF

# Push notebook
kaggle kernels push -p .

# Check status
kaggle kernels status ericgross1/qwen3-phase1-codealpaca
```

## Training Configuration

```
Model: Qwen3-0.8B (816M parameters)
Dataset: CodeAlpaca-20k
Method: LoRA (Parameter-Efficient Fine-Tuning)
  - Rank: 16
  - Alpha: 32
  - Target modules: q_proj, k_proj, v_proj, o_proj
  
Hardware: T4 GPU (16GB VRAM)
Batch Size: 4 (effective 16 with gradient accumulation)
Learning Rate: 2e-4
Epochs: 3
Optimizer: Paged AdamW 8-bit
Precision: FP16
Max Sequence Length: 2048

Expected Memory Usage: ~12 GB
Expected Time: 2-3 hours
```

## After Training

1. Download the zip file from Kaggle output
2. Extract to: `/home/archlinux/code_insiders/ml_ai_engineering/trained_models/phase1/`
3. Convert to GGUF for fast inference with llama.cpp
4. Test with: `--reasoning-budget 0` for non-thinking mode

## Phase 2-4 Planning

Once Phase 1 completes, we'll train on:
- **Phase 2:** Python-specific dataset
- **Phase 3:** Advanced Python (libraries, frameworks)
- **Phase 4:** Linux/OS commands

Each phase builds on the previous, progressively specializing the model.

---

**Status:** Ready to start training! ✅
**Your next action:** Go to https://www.kaggle.com/code and upload the notebook

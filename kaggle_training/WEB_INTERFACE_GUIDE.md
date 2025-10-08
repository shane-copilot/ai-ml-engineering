# Kaggle Web Interface Training Guide

## The CLI is having API issues, so use the web interface instead:

### Step 1: Upload the Training Notebook
1. Go to: **https://www.kaggle.com/code**
2. Click **"+ New Notebook"** (top right)
3. Click **"File" → "Upload Notebook"**
4. Select file: `/home/archlinux/code_insiders/ml_ai_engineering/kaggle_training/phase1_training.ipynb.bak`

### Step 2: Add Your Model Dataset
1. In the notebook, click **"+ Add Data"** (right sidebar)
2. Search for: **"qwen3-08b-coder-reasoning"**
3. Click **"Add"** next to your dataset

### Step 3: Enable GPU
1. Click **"Accelerator"** dropdown (right sidebar)
2. Select **"GPU T4 x2"** or **"GPU P100"**
3. Confirm GPU is enabled (should show green checkmark)

### Step 4: Start Training
1. Review the notebook cells
2. Click **"Save Version"** (top right)
3. Select **"Save & Run All (Commit)"**
4. Click **"Save"**

### Step 5: Monitor Progress
- Training URL: https://www.kaggle.com/code/ericgross1
- Expected time: **2-3 hours**
- You can close the browser - training continues!

### Step 6: Download Results
1. When complete, go to your notebook
2. Click **"Output"** tab
3. Download: `qwen3-08b-phase1-codealpaca.zip`
4. Extract to: `/home/archlinux/code_insiders/ml_ai_engineering/trained_models/phase1/`

## Alternative: Copy-Paste Approach

If upload doesn't work, manually create the notebook:

1. Go to https://www.kaggle.com/code
2. Click "+ New Notebook"
3. Copy cells from `/home/archlinux/code_insiders/ml_ai_engineering/kaggle_training/phase1_training.ipynb.bak`
4. Paste into web notebook
5. Add dataset and enable GPU
6. Run!

## Training Details

**Dataset:** CodeAlpaca-20k (automatically downloads from HuggingFace)
**Model:** Your Qwen3-0.8B from dataset
**Method:** LoRA fine-tuning
**GPU:** T4 (16GB VRAM)
**Time:** 2-3 hours
**Output:** Fine-tuned model ready for Phase 2

## Troubleshooting

**"Dataset not found":**
- Make sure you added "qwen3-08b-coder-reasoning" dataset
- Check it appears in the Input section

**"Out of memory":**
- Reduce BATCH_SIZE from 4 to 2
- Or use GPU T4 x1 instead of x2

**"Kernel crashes":**
- Session timeout - just restart and resume
- Kaggle free tier has 9-12 hour session limit

---

**Status:** Ready to train via web interface!
**Your dataset:** https://www.kaggle.com/datasets/ericgross1/qwen3-08b-coder-reasoning

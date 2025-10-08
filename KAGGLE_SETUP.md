# Kaggle Training Setup Guide

## Step 1: Get Your Kaggle API Credentials ✅ (Do this now)

1. Go to https://www.kaggle.com/
2. Sign in or create account
3. Click your profile picture (top right) → **Settings**
4. Scroll down to **API** section
5. Click **"Create New Token"**
6. A file `kaggle.json` will download

## Step 2: Install API Token

Run these commands:
```bash
mkdir -p ~/.kaggle
mv ~/Downloads/kaggle.json ~/.kaggle/
chmod 600 ~/.kaggle/kaggle.json
```

## Step 3: Test Connection
```bash
kaggle competitions list
```

You should see a list of Kaggle competitions if it worked!

## Next Steps After Setup

Once you have the API token installed, we'll:
1. Upload your Qwen3-1.7B model as a Kaggle dataset
2. Create training notebook with CodeAlpaca-20k
3. Enable T4 GPU
4. Start training!

---

## Training Plan Overview - BANDWIDTH-OPTIMIZED STRATEGY 🚀

**IMPORTANT:** Using sequential LoRA training with on-Kaggle merging to save 74% bandwidth!

### 🎯 Project Goal
**Linux Sidebar AI Assistant** - Always-available help integrated at compositor/kernel level
- **70% Use Case:** Natural language → Linux commands (pacman, systemctl, file ops)
- **30% Use Case:** Generate Python system automation scripts
- **Target:** <8GB final model size (starting from 0.8B base)

### 💾 Bandwidth-Saving Strategy
**The Problem:** Full model transfers = 9.6GB total bandwidth
**The Solution:** Only transfer LoRA adapters = 2.8GB total (74% savings!)

**How it works:**
1. Base model (1.6GB) uploaded ONCE - stays on Kaggle forever
2. Each phase trains a LoRA adapter (~150MB)
3. Download only the LoRA adapter (NOT the full model)
4. Upload LoRA to Kaggle (~150MB)
5. Next phase: Load base + LoRA → merge on Kaggle → train new LoRA
6. Repeat for all phases

**Bandwidth Breakdown:**
- Base model upload: 1.6GB (one-time)
- Phase 1→2: 300MB (150MB down + 150MB up)
- Phase 2→3: 300MB (150MB down + 150MB up)
- Phase 3→4: 300MB (150MB down + 150MB up)
- **Total: 2.5GB** vs 9.6GB traditional approach

---

### Phase 1: General Coding Foundation ✅ CURRENTLY RUNNING
**Dataset:** `sahil2801/CodeAlpaca-20k` (20,022 examples)
**Model Input:** Qwen3-0.8B Base (`/kaggle/input/qwen3-08b-coder-reasoning`)
**Output:** Phase 1 LoRA adapter (~150MB)
**Expected Time:** 2-3 hours on T4 GPU
**Purpose:** General coding reasoning baseline

**After Phase 1 completes:**
```bash
./upload_lora.sh 1  # Downloads LoRA (~150MB), uploads to Kaggle
```

---

### Phase 2: Linux Command Mastery (Primary Use Case - 70%)
**Datasets:** 
- Kaggle: `kushagragoyal060705/complex-linux-commands-from-natual-language` (1M → sample 40K)
- Kaggle: `cyberprince/linux-terminal-commands-dataset` (~32K)
- HuggingFace: `aelhalili/bash-commands-dataset`
- HuggingFace: `m-a-p/CodeFeedback-Filtered-Instruction` (bash/shell filtered)

**Total:** ~50-70K examples
**Model Input:** Base model + Phase 1 LoRA (merged on Kaggle at start)
**Output:** Phase 2 LoRA adapter (~150MB)
**Expected Time:** 3-4 hours
**Purpose:** Natural language → Linux command translation

**Key Training Focus:**
- Package management: `pacman -S`, `yay`, `apt install`
- System control: `systemctl`, service management
- File operations: permissions, ownership, find, grep
- Common troubleshooting commands
- Shell scripting patterns

**After Phase 2 completes:**
```bash
./upload_lora.sh 2  # Downloads Phase 2 LoRA, uploads to Kaggle
```

---

### Phase 3: Python System Automation (Secondary Use Case - 30%)
**Datasets:**
- HuggingFace: `RazinAleks/SO-Python_QA-System_Administration_and_DevOps_class` ⭐ Perfect fit!
- HuggingFace: `infinite-dataset-hub/ShellScriptDataset`
- HuggingFace: `flytech/python-codes-25k` (FILTERED for system-relevant only)

**Filtering python-codes-25k:**
- ✅ Keep: File I/O, process management, system calls, automation
- ❌ Remove: Web scraping, data science, algorithms, LeetCode problems

**Total:** ~20-30K examples (after filtering)
**Model Input:** Base model + Phase 2 LoRA (merged on Kaggle at start)
**Output:** Phase 3 LoRA adapter (~150MB)
**Expected Time:** 3-4 hours
**Purpose:** Generate Python scripts for system automation

**After Phase 3 completes:**
```bash
./upload_lora.sh 3  # Downloads Phase 3 LoRA, uploads to Kaggle
```

---

### Phase 4: Advanced System Work & Troubleshooting
**Datasets:**
- HuggingFace: `m-a-p/CodeFeedback-Filtered-Instruction` (complexity 4-5, systems-focused)
- HuggingFace: `KonradSzafer/stackoverflow_linux`
- Advanced examples from previous phases

**Total:** ~15-20K examples
**Model Input:** Base model + Phase 3 LoRA (merged on Kaggle at start)
**Output:** Phase 4 LoRA adapter (~150MB) **← FINAL MODEL**
**Expected Time:** 3-4 hours
**Purpose:** Complex multi-step solutions, advanced troubleshooting

**After Phase 4 completes:**
```bash
# Download Phase 4 LoRA (~150MB)
# Merge locally with base model for deployment
```

---

## Resource Summary

**Total GPU Time:** 12-16 hours
**Total Bandwidth:** 2.5GB (vs 9.6GB traditional)
**Kaggle Free Tier:** ✅ 30 hours/week - plenty of headroom!

**Can complete:**
- All 4 phases in one week
- Or spread across 2 weeks for safety

---

## Critical Configuration Notes

**Padding Token Consistency:**
- Token ID 151645 (eos_token) used for padding
- Must be consistent across ALL phases
- Automatically handled by notebooks ✅

**Sequential Learning:**
- Each phase builds on previous knowledge
- Merging happens on Kaggle (no local bandwidth)
- Final model includes: Base + Phase1 + Phase2 + Phase3 + Phase4

---

## Workflow Tools Created

### `upload_lora.sh` - Automated Script
```bash
./upload_lora.sh <phase_number>
```
Automates: Download → Extract → Upload to Kaggle

### `PHASE_WORKFLOW.md` - Detailed Guide
Complete step-by-step instructions for phase transitions

### Notebooks
- ✅ `phase1_training.ipynb` - RUNNING
- ✅ `phase2_training.ipynb` - Ready (loads base + P1 LoRA, merges on Kaggle)
- 📝 `phase3_training.ipynb` - TODO
- 📝 `phase4_training.ipynb` - TODO

---

## Files We'll Create

1. `kaggle_upload_model.py` - Upload your local model to Kaggle
2. `training_notebook.ipynb` - Main training script
3. `phase1_config.json` - Training hyperparameters
4. `convert_to_gguf.py` - Convert trained model back to GGUF for inference

---

## Return here after completing Steps 1-3 above!

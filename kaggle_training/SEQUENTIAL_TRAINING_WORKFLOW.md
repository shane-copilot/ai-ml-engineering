# Sequential Training Workflow for Qwen3-0.8B

## Overview

This training pipeline uses **sequential fine-tuning** where each phase builds on the previous phase's knowledge. This ensures:
- ✅ Phase 2 benefits from Phase 1's coding knowledge
- ✅ Phase 3 benefits from Phase 1 + Phase 2's knowledge
- ✅ Phase 4 has the full accumulated knowledge from all phases

## Critical: Padding Token Consistency

**⚠️ MUST maintain padding token ID across all phases!**

Phase 1 sets: `tokenizer.pad_token = tokenizer.eos_token` (ID: 151645)

All subsequent phases MUST use the same padding token to avoid:
- Gibberish responses
- Model confusion
- Training instability

**Solution implemented:** Each notebook verifies and preserves the padding token from the previous phase.

---

## Phase 1: General Coding Foundation

### Dataset
- `sahil2801/CodeAlpaca-20k` (20,022 examples)

### Process
1. Load base Qwen3-0.8B model
2. Train LoRA adapter on CodeAlpaca
3. **Merge LoRA into base model** ← Critical for Phase 2!
4. Save both:
   - LoRA adapter (`qwen3-08b-phase1-codealpaca-lora.zip`)
   - **Merged model** (`qwen3-08b-phase1-codealpaca-merged.zip`)

### Output for Phase 2
Upload: `qwen3-08b-phase1-codealpaca-merged.zip` as Kaggle dataset

### Status
✅ Running (Version 16+)

---

## Phase 2: Linux Command Mastery

### Datasets
- `kushagragoyal060705/complex-linux-commands-from-natual-language` (1M→40K sampled)
- `cyberprince/linux-terminal-commands-dataset`
- `aelhalili/bash-commands-dataset` (HuggingFace)
- `m-a-p/CodeFeedback-Filtered-Instruction` (bash/shell filtered)

### Process
1. Load Phase 1 **merged** model
2. Verify padding token (ID: 151645)
3. Train LoRA adapter on Linux commands
4. **Merge LoRA into Phase 1 model**
5. Save both:
   - LoRA adapter (`qwen3-08b-phase2-linux-lora.zip`)
   - **Merged model** (`qwen3-08b-phase2-linux-merged.zip`)

### Output for Phase 3
Upload: `qwen3-08b-phase2-linux-merged.zip` as Kaggle dataset

### Status
⏳ Notebook ready, waiting for Phase 1 completion

---

## Phase 3: Python System Automation

### Datasets
- `RazinAleks/SO-Python_QA-System_Administration_and_DevOps_class` (HuggingFace)
- `infinite-dataset-hub/ShellScriptDataset` (HuggingFace)
- `flytech/python-codes-25k` (filtered for system-relevant code)

### Process
1. Load Phase 2 **merged** model
2. Verify padding token (ID: 151645)
3. Train LoRA adapter on Python system automation
4. **Merge LoRA into Phase 2 model**
5. Save both outputs

### Output for Phase 4
Upload: `qwen3-08b-phase3-python-merged.zip` as Kaggle dataset

### Status
⏳ To be created after Phase 2 completes

---

## Phase 4: Advanced Troubleshooting

### Datasets
- `m-a-p/CodeFeedback-Filtered-Instruction` (complexity 4-5, systems focus)
- `KonradSzafer/stackoverflow_linux` (HuggingFace)
- Mixed advanced examples

### Process
1. Load Phase 3 **merged** model
2. Verify padding token (ID: 151645)
3. Train LoRA adapter on advanced troubleshooting
4. **Final merge** - this is your production model!
5. Save final merged model

### Output
**Final production model:** `qwen3-08b-final-merged.zip`

### Status
⏳ To be created after Phase 3 completes

---

## Why Merge After Each Phase?

### Without Merging (LoRA stacking - doesn't work well)
```
Base Model (0.8B)
  ↓ + LoRA 1 (Phase 1)
  ↓ + LoRA 2 (Phase 2) ← Conflicts with LoRA 1
  ↓ + LoRA 3 (Phase 3) ← Conflicts with LoRA 1 & 2
  ↓ + LoRA 4 (Phase 4) ← Messy!
```

### With Merging (Sequential fine-tuning - what we're doing)
```
Base Model (0.8B)
  ↓ + LoRA 1 → Merge → Model v1
Model v1
  ↓ + LoRA 2 → Merge → Model v2
Model v2
  ↓ + LoRA 3 → Merge → Model v3
Model v3
  ↓ + LoRA 4 → Merge → Model v4 (FINAL)
```

Each phase **permanently** learns from all previous phases!

---

## Checklist for Each Phase

### Before Training
- [ ] Download previous phase's **merged** model
- [ ] Upload merged model as Kaggle dataset
- [ ] Add Kaggle datasets as data sources in notebook settings
- [ ] Enable GPU (T4)
- [ ] Enable Internet (for HuggingFace datasets)

### After Training
- [ ] Download **merged** model zip file
- [ ] Upload merged model for next phase
- [ ] Keep LoRA adapter as backup
- [ ] Verify padding token ID is preserved

---

## Expected Timeline

- **Phase 1**: 2-3 hours (✅ Currently running)
- **Phase 2**: 3-4 hours
- **Phase 3**: 3-4 hours  
- **Phase 4**: 3-4 hours

**Total**: ~15-20 hours GPU time (fits in Kaggle's 30hr/week free tier!)

---

## Troubleshooting

### If you get gibberish outputs
→ Check padding token ID matches across phases (should be 151645)

### If training fails to load model
→ Ensure you uploaded the **merged** model, not just the LoRA adapter

### If dataset loading fails
→ Check internet is enabled (for HuggingFace datasets)
→ Verify Kaggle datasets are added as data sources

### If memory errors occur
→ Model is already using 4-bit quantization (should fit in T4's 16GB)
→ Try reducing batch size from 4 to 2

---

## Final Model Size

After all phases:
- Base model: ~1.6GB (FP16)
- Each LoRA adapter: ~150MB
- **Final merged model**: ~1.6GB (all knowledge baked in!)

Perfect for your sidebar AI deployment! 🎉

# 🚀 Next Session Onboarding - Qwen3-0.8B Training Project

**Date:** October 5, 2025  
**Current Status:** Phase 2 stopped due to padding token issue - ready to fix and restart

---

## 📍 WHERE WE ARE NOW

### Training Pipeline Status
- ✅ **Phase 1 (CodeAlpaca):** COMPLETE - 77.7% accuracy, 42MB adapter
- ❌ **Phase 2 (Linux Commands):** STOPPED - padding token mismatch detected
- ⏳ **Phase 3 (Creative Writing):** Ready to create after Phase 2 completes
- ⏳ **Phase 4 (Conversational):** Ready to create after Phase 3 completes

### Critical Issue That Must Be Fixed
**PADDING TOKEN MISMATCH:**
- Phase 1 used: `pad_token_id = 151645` (EOS token)
- Phase 2 v4 used: `pad_token_id = 151654` (vision_pad token) ❌
- **Problem:** Inconsistent padding causes gibberish output and training instability
- **User told us 3-4 times** - we failed to fix it before pushing v4

---

## 🔧 IMMEDIATE ACTION REQUIRED

### Fix Phase 2 Notebook
**File:** `/home/archlinux/code_insiders/ml_ai_engineering/kaggle_training/phase2_training.ipynb`

**Cell to fix (around line 95-105):**
```python
# Current (WRONG):
if tokenizer.pad_token is None:
    print("⚠️  No pad_token found, setting to eos_token")
    tokenizer.pad_token = tokenizer.eos_token
    tokenizer.padding_side = "right"
else:
    print(f"✓ Pad token already configured: {tokenizer.pad_token}")  # ← This branch is being taken!
    tokenizer.padding_side = "right"

# Should be (CORRECT):
# FORCE eos_token as pad_token for consistency
tokenizer.pad_token = tokenizer.eos_token
tokenizer.pad_token_id = tokenizer.eos_token_id  # 151645
tokenizer.padding_side = "right"
print(f"✓ Pad token set to EOS token: {tokenizer.pad_token} (ID: {tokenizer.pad_token_id})")
```

**Verification should show:**
```
✓ Pad token set to EOS token: <|endoftext|> (ID: 151645)
✅ CORRECT: Matches Phase 1 configuration
```

---

## 🎯 TRAINING CONFIGURATION

### Hardware Constraints (Kaggle T4 GPU)
- **Total GPU Memory:** 15.89 GiB
- **After LoRA Merge:** 12.47 GB used, 3.41 GB free for training
- **Max Dataset Size:** ~25,000 examples (tested and works)
- **Batch Config:** `batch_size=2` + `gradient_accumulation=8` = effective batch 16

### LoRA Configuration (Consistent Across All Phases)
```python
lora_config = LoraConfig(
    r=16,                    # Rank
    lora_alpha=32,           # Scaling factor
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)
```

### Training Hyperparameters
```python
training_args = TrainingArguments(
    output_dir="./phase2_results",
    num_train_epochs=3,
    per_device_train_batch_size=2,
    gradient_accumulation_steps=8,    # Effective batch = 16
    gradient_checkpointing=True,      # Saves memory
    learning_rate=2e-4,
    logging_steps=50,
    save_strategy="epoch",
    fp16=True,
    optim="paged_adamw_8bit"
)
```

---

## 📦 PHASE 2 DATASET DETAILS

### Sources (4 datasets combined, capped at 25K)
1. **Complex Linux Commands** (Kaggle): 1M examples → sample 10K
2. **Terminal Commands** (Kaggle): Has JSON parsing issues, skip for now
3. **Bash Commands** (HuggingFace): 840 examples
4. **CodeFeedback** (HuggingFace): 156K total → filter bash/shell → ~36K → sample 14K

**Final:** 25,000 examples after combining and sampling

---

## 🚨 CRITICAL LESSONS LEARNED

### 1. Padding Token Consistency
- **MUST** use same `pad_token_id` across all phases
- Phase 1 set it to `151645` (EOS token)
- **NEVER** trust `if tokenizer.pad_token is None` - FORCE it explicitly
- Inconsistent padding → gibberish output

### 2. Kaggle CLI Workflow
- **409 Conflict:** Can't push while notebook is RUNNING
- Check status: `kaggle kernels status <user>/<slug>`
- Must wait for COMPLETE or ERROR before pushing

### 3. VS Code Notebook Quirk
- **VS Code does NOT auto-save notebooks**
- Manual save (Ctrl+S) required before `edit_notebook_file` changes persist
- Caused Phase 2 v2-v3 failures

### 4. Memory Management on T4
- LoRA merge expands 1.6GB model → 12.47GB in GPU
- Only 3.41GB left for training
- Dataset must be ≤25K examples
- Use gradient checkpointing + 8-bit optimizer

---

## 📁 PROJECT STRUCTURE

```
kaggle_training/
├── phase1_training.ipynb          # ✅ COMPLETE (v16)
├── phase2_training.ipynb          # ❌ NEEDS PADDING FIX (v4 stopped)
├── kernel-metadata.json           # Phase 2 metadata
└── TRAINING_STATUS.md             # Phase 1 completion notes

Key Files:
├── STATUS.md                      # Overall project status
├── KAGGLE_SETUP.md               # Setup instructions
└── .github/copilot-instructions.md  # AI assistant guidelines
```

---

## 🎬 NEXT STEPS (In Order)

### Step 1: Fix Phase 2 Padding Token
1. Open `kaggle_training/phase2_training.ipynb`
2. Find tokenizer loading cell (around line 95-105)
3. Replace conditional logic with forced EOS token assignment
4. Save file (Ctrl+S) - verify it's saved!
5. Verify metadata: `cat kaggle_training/kernel-metadata.json`

### Step 2: Push Phase 2 v5
```bash
cd /home/archlinux/code_insiders/ml_ai_engineering/kaggle_training
kaggle kernels push -p .
```

### Step 3: Monitor Training
```bash
# Check status (wait for COMPLETE)
kaggle kernels status ericgross1/qwen3-phase2-linux-training-v2

# Download logs when done
kaggle kernels output ericgross1/qwen3-phase2-linux-training-v2 -p ./phase2_v5_output
```

### Step 4: Create Phase 3 Notebook
- Dataset: Creative writing (fiction, poetry)
- Input: Phase 2 LoRA adapter
- Same LoRA config, pad_token_id = 151645

### Step 5: Create Phase 4 Notebook
- Dataset: Conversational/instruction following
- Input: Phase 3 LoRA adapter
- Final phase, same consistency

---

## 🧠 SEMANTIC MEMORY ADDED

Successfully stored in MCP memory server (`/home/archlinux/Documents/mcp_memory/knowledge_graph.json`):

**Entities:**
- `KaggleNotebookMetadata` - Kernelspec requirements
- `KaggleT4GPU` - Hardware specs (15.89 GiB)
- `KaggleMemoryConstraints` - LoRA merge memory expansion
- `KaggleCLI` - CLI commands and 409 errors
- `VSCodeNotebookSave` - Auto-save quirk
- `Qwen3Phase1Training` - Complete results
- `Qwen3Phase2Training` - Current status and failures
- `BandwidthConstraint` - 13-hour upload limitation
- `LoRAMergingMemory` - Memory expansion facts

---

## 🔗 IMPORTANT LINKS

- **Kaggle Notebook:** https://www.kaggle.com/code/ericgross1/qwen3-phase2-linux-training-v2
- **Base Model:** Qwen/Qwen2.5-0.8B-Instruct (1.6GB)
- **Phase 1 Dataset:** https://www.kaggle.com/datasets/ericgross1/qwen3-phase1-codealpaca-lora
- **GitHub Repo (cloned):** `/home/archlinux/code_insiders/ml_ai_engineering/kaggle_api_docs`

---

## ⚡ BANDWIDTH CONTEXT

**Critical Constraint:**
- Upload speed: ~13 hours for 1.6GB model
- **Solution:** LoRA adapters only (~42MB each)
- Base model stays on Kaggle permanently
- Merge LoRAs on Kaggle before each phase

**Bandwidth Savings:**
- Traditional: 9.6GB total uploads (6x 1.6GB)
- Our approach: 2.5GB total (1x base + 5x adapters)
- **Savings: 74%**

---

## 🎯 SUCCESS CRITERIA

### Phase 2 Complete When:
- ✅ Training completes 3 epochs without OOM
- ✅ Final loss < 0.8
- ✅ Token accuracy > 75%
- ✅ Padding token verified as 151645 in logs
- ✅ Adapter saved (~27MB safetensors file)

---

## 📞 IF THINGS GO WRONG

### OOM Error
- Reduce dataset to 20K examples
- Check gradient checkpointing is enabled
- Verify gradient_accumulation_steps=8

### 409 Conflict
- Wait 5 minutes, check status
- If still RUNNING, notebook may be stuck
- May need to stop manually on Kaggle website

### Padding Token Issues
- Check logs for pad_token_id value
- Should be 151645, not 151654
- Gibberish output = wrong padding

### Dataset Loading Fails
- Check internet is enabled in notebook settings
- Verify dataset sources are added as inputs
- Terminal commands dataset has parsing issues (skip it)

---

**🎯 PRIMARY GOAL FOR NEXT SESSION:**
Fix padding token in Phase 2 notebook → Push v5 → Monitor training → Complete Phase 2

**⏱️ ESTIMATED TIME:** 3-4 hours for Phase 2 training once pushed correctly

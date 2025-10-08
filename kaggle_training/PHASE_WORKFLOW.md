# Multi-Phase Training Workflow

## Bandwidth-Saving Strategy

Instead of downloading full models (1.6GB each), we only download/upload small LoRA adapters (~150MB).

## How It Works

```
Base Model (1.6GB) ──────────────> Stays on Kaggle FOREVER
                                   (uploaded once)
                                        
Phase 1: Base + Train LoRA ──> Save LoRA (~150MB)
         ↓
      Download LoRA only (fast!)
         ↓
      Upload LoRA to Kaggle
         ↓
Phase 2: Base + Phase1 LoRA ──> Merge on Kaggle ──> Train Phase2 LoRA
         ↓
      Download Phase2 LoRA only
         ↓
      Upload Phase2 LoRA to Kaggle
         ↓
Phase 3: Base + Phase2 LoRA ──> Merge on Kaggle ──> Train Phase3 LoRA
         ↓
         etc...
```

## Phase 1 → Phase 2 Workflow

### Step 1: Wait for Phase 1 to Complete
Monitor status:
```bash
kaggle kernels status ericgross1/qwen3-0-8b-phase1-codealpaca-training
```

### Step 2: Download Phase 1 LoRA Adapter
```bash
cd /home/archlinux/code_insiders/ml_ai_engineering/kaggle_training

# Download all outputs
kaggle kernels output ericgross1/qwen3-0-8b-phase1-codealpaca-training -p ./phase1_output

# The LoRA adapter will be in the zip file
# Extract it:
cd phase1_output
unzip qwen3-08b-phase1-codealpaca.zip
# This creates: qwen3-08b-phase1-codealpaca/final/ (the LoRA adapter)
```

**Size:** ~150MB (fast download even on slow connection!)

### Step 3: Prepare LoRA for Upload
```bash
cd /home/archlinux/code_insiders/ml_ai_engineering/kaggle_training

# Create upload directory
mkdir -p phase1_lora_upload
cp -r phase1_output/qwen3-08b-phase1-codealpaca/final/* phase1_lora_upload/

# Initialize Kaggle dataset metadata
cd phase1_lora_upload
kaggle datasets init -p .
```

### Step 4: Edit Metadata
Edit `dataset-metadata.json`:
```json
{
  "title": "Qwen3 Phase 1 LoRA Adapter",
  "id": "ericgross1/qwen3-phase1-lora-adapter",
  "licenses": [{"name": "apache-2.0"}]
}
```

### Step 5: Upload to Kaggle
```bash
# Still in phase1_lora_upload directory
kaggle datasets create -p .
```

**Upload time:** ~5-10 minutes (vs 4-8 hours for full model!)

### Step 6: Verify Upload
Check that the dataset appears:
```bash
kaggle datasets list -s "qwen3-phase1-lora"
```

Should show: `ericgross1/qwen3-phase1-lora-adapter`

### Step 7: Run Phase 2
The Phase 2 notebook is already configured to:
1. Load base model: `/kaggle/input/qwen3-08b-coder-reasoning`
2. Load Phase 1 LoRA: `/kaggle/input/qwen3-phase1-lora-adapter`
3. Merge them on Kaggle
4. Train Phase 2

When pushing Phase 2 notebook, add data sources:
- Base model (already uploaded)
- Phase 1 LoRA (just uploaded)
- Kaggle datasets for Linux commands
- Enable internet for HuggingFace datasets

```bash
cd /home/archlinux/code_insiders/ml_ai_engineering/kaggle_training
kaggle kernels push -p .
```

## Phase 2 → Phase 3 Workflow

**Repeat the same process:**
1. Download Phase 2 LoRA (~150MB)
2. Upload as `qwen3-phase2-lora-adapter`
3. Phase 3 loads base + Phase 2 LoRA → merges → trains

## Phase 3 → Phase 4 Workflow

**Same again:**
1. Download Phase 3 LoRA (~150MB)
2. Upload as `qwen3-phase3-lora-adapter`  
3. Phase 4 loads base + Phase 3 LoRA → merges → trains

## Final Output

After Phase 4, you'll have:
- **Phase 4 LoRA adapter** (~150MB) - download this
- On Kaggle: Base model + all LoRA checkpoints

To create the final deployable model locally:
```python
from transformers import AutoModelForCausalLM
from peft import PeftModel

# Load base
base = AutoModelForCausalLM.from_pretrained("./q3_zero_.8b")

# Load and merge Phase 4 LoRA
model = PeftModel.from_pretrained(base, "./phase4_lora")
final_model = model.merge_and_unload()

# Save final model
final_model.save_pretrained("./qwen3_linux_assistant_final")
```

## Bandwidth Comparison

### Old Approach (Download/Upload Full Models):
- Phase 1 → Phase 2: 1.6GB download + 1.6GB upload = 3.2GB
- Phase 2 → Phase 3: 1.6GB download + 1.6GB upload = 3.2GB  
- Phase 3 → Phase 4: 1.6GB download + 1.6GB upload = 3.2GB
- **Total: 9.6GB bandwidth**

### New Approach (LoRA Adapters Only):
- Base model upload: 1.6GB (one time)
- Phase 1 → Phase 2: 150MB download + 150MB upload = 300MB
- Phase 2 → Phase 3: 150MB download + 150MB upload = 300MB
- Phase 3 → Phase 4: 150MB download + 150MB upload = 300MB
- **Total: 2.5GB bandwidth (74% reduction!)**

## Troubleshooting

**Q: What if Phase 1 didn't save the LoRA adapter separately?**
A: The current Phase 1 notebook saves it to `OUTPUT_DIR + "/final"`. Check the zip file contents.

**Q: Can I skip the merge step and just stack LoRAs?**
A: No, for sequential learning you need to merge each phase so the next phase builds on previous knowledge.

**Q: What if the upload fails?**
A: Use `kaggle datasets version` to retry:
```bash
kaggle datasets version -p /path/to/lora -m "Retry upload"
```

**Q: How do I verify the LoRA uploaded correctly?**
A: Check file count and size:
```bash
kaggle datasets files ericgross1/qwen3-phase1-lora-adapter
```

Should show: adapter_config.json, adapter_model.safetensors, etc.

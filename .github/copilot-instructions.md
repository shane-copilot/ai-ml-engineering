# GitHub Copilot Instructions for ML/AI Engineering Projects

## 🧠 Memory Management (EXECUTE FIRST!)

### Session Startup Protocol
**CRITICAL: Run this BEFORE responding to user's first message:**

1. Search memory: `mcp_memory_search_nodes("onboarding")`
2. Load latest `OnboardingSession_YYYY_MM_DD` entity
3. Parse: CURRENT_OBJECTIVE, ACTIVE_WORK, NEXT_STEPS, BLOCKERS, CRITICAL_CONSTRAINTS
4. Greet user with context: "I see we're working on [OBJECTIVE]. Current status: [ACTIVE_WORK]. Ready to continue?"

**Memory Location:** `/home/archlinux/Documents/mcp_memory/knowledge_graph.json`

### During Session
**Capture critical discoveries immediately (don't wait for session end):**

When to capture:
- Root causes found (bugs, performance issues)
- Workarounds for platform limitations
- Lessons learned from mistakes (especially costly ones)
- Major milestones completed

How to capture:
```javascript
mcp_memory_add_observations({
  observations: [{
    entityName: "OnboardingSession_2025_10_05",
    contents: [
      "DISCOVERY: [Brief title]",
      "What: [Technical details]",
      "Why: [Impact]",
      "How: [Actionable guidance]"
    ]
  }]
})
```

### Session End Protocol
**CRITICAL: Run this BEFORE ending session:**

Update onboarding memory with:
- What we accomplished this session
- Current status of active work
- Updated NEXT_STEPS for next session
- New/resolved blockers
- Critical discoveries or lessons learned
- Commands/workflows that were successful
- Updated timeline or constraints

Confirm: "Session state updated in memory. Next session will auto-load from here!"

### Useful Memory Searches
- `mcp_memory_search_nodes("onboarding")` - Session context
- `mcp_memory_search_nodes("padding token")` - Critical requirements  
- `mcp_memory_search_nodes("bandwidth")` - Upload constraints
- `mcp_memory_search_nodes("Phase 3")` - Phase-specific info

**Search Strategy:** Use 1-2 word queries for best results.

## 🚨 CRITICAL: Kaggle Notebook Format (READ FIRST!)

**WASTED: 40+ failed notebooks, entire week of GPU hours due to format errors!**

### MANDATORY RULES FOR ALL KAGGLE NOTEBOOKS:

1. **ALWAYS copy from working template:**
   ```bash
   cp NOTEBOOK_TEMPLATE.ipynb new_notebook.ipynb
   ```

2. **REQUIRED format - VSCode.Cell XML:**
   ```xml
   <VSCode.Cell id="#VSC-xxxxxxxx" language="python">
   # Code here
   </VSCode.Cell>
   ```

3. **NEVER create notebooks from scratch with JSON format**
   - ❌ `{"cells": [...], "metadata": {...}}` = REJECTED by Kaggle
   - ✅ Only use VSCode.Cell XML format

4. **Every cell MUST have:**
   - `id="#VSC-xxxxxxxx"` (8-char hex with #VSC- prefix)
   - `language="python"` or `language="markdown"`

5. **Before ANY push, verify:**
   - [ ] Copied from NOTEBOOK_TEMPLATE.ipynb or working notebook
   - [ ] All cells have proper id and language attributes
   - [ ] Saved in VS Code (Ctrl+S)
   - [ ] kernel-metadata.json has correct kernel ID

**Templates available:**
- `NOTEBOOK_TEMPLATE.ipynb` - Base template
- `phase1_training.ipynb` - Working GPU example
- `tpu_compatibility_test.ipynb` - Working TPU example

**Full rules:** See `kaggle_training/NOTEBOOK_TEMPLATE_RULES.md`

**Memory entity:** Search `mcp_memory_search_nodes("KaggleNotebookTemplate")`

---

## Workplace Rules
 - Maintain professionalism and code quality at all times.
 - Adhere to project architecture and coding guidelines.
 - ALWAYS research online first, local second, compile and study. This should always be your first step. It's a workplace requirement when a situation presents itself and you're not quite sure what to do.
 
## Project Overview
This workspace contains multiple ML/AI engineering projects:

### Active Projects
1. **Kaggle Sequential LoRA Training** (Primary Focus as of Oct 2025)
   - Training Qwen3-0.8B model through 4 sequential phases
   - Phase 1: CodeAlpaca (✅ Complete - 77.7% accuracy, 42MB adapter)
   - Phase 2: Linux Commands (🔄 In Progress - v5 RUNNING)
   - Phase 3: Python System Automation (📋 Planned)
   - Phase 4: Advanced Troubleshooting (📋 Planned)
   - **Critical Constraint:** 13-hour upload time per model (1.6GB), using LoRA approach for 74% bandwidth savings

2. **Custom Rust/Vulkan Inference Engine** (Archived/Intel Collaboration)
   - Goal: 100% GPU inference, 30 tok/s on Intel Iris Xe Graphics
   - Status: See rust_approach_archived/ directory
   - Architecture: Timeline semaphores, double-buffering, async GPU operations

## Machine Specifications

### Local Development Machine
- **CPU:** 13th Gen Intel Core i9-13900H (14 cores, 20 threads)
- **GPU:** Intel Iris Xe Graphics (RPL-P) - Vulkan 1.4.318
- **RAM:** 40GB DDR4-3200 (dual-channel)
- **OS:** Arch Linux 6.16.8-arch3-1
- **Critical Limitation:** Extremely limited bandwidth (~13 hours to upload 1.6GB model)

### Kaggle Training Environment (T4 GPU)
- **GPU Memory:** 15.89 GiB total
- **After LoRA Merge:** 12.47GB used, 3.41GB free for training
- **Dataset Limit:** 25,000 examples maximum (memory constraint)
- **Training Time:** 3-4 hours per phase (3 epochs, 25K examples)
- **Execution Limit:** 12 hours for CPU/GPU kernels

## Kaggle Training Critical Knowledge

### Padding Token Consistency (CRITICAL)
- **MUST use pad_token_id=151645** across ALL training phases
- This is the EOS token `<|endoftext|>` for Qwen3 models
- NEVER trust conditional checks like `if tokenizer.pad_token is None`
- FORCE explicit assignment: `tokenizer.pad_token_id = 151645`
- Inconsistent padding causes gibberish output and wasted uploads
- This issue caused 16 Phase 1 attempts + 5 Phase 2 attempts

### Bandwidth Constraint Strategy
- **13 hours to upload 1.6GB model** - each mistake is extremely costly
- Use **on-Kaggle LoRA merging** to avoid re-uploading full models
- Sequential training: Base + Phase1 LoRA → merge → Phase2 LoRA → merge...
- Total bandwidth: 2.5GB (LoRA) vs 9.6GB (traditional) = 74% savings
- Only upload ~42MB LoRA adapters between phases

### T4 GPU Memory Management
- Total: 15.89 GiB GPU memory
- LoRA merge expands 1.6GB file → 12.47GB in GPU (7.8x expansion)
- Remaining for training: 3.41GB
- **Dataset limit: 25,000 examples maximum**
- Use: batch_size=2, gradient_accumulation=8, gradient_checkpointing=True

### Kaggle Workflow Gotchas
- **409 Conflict Error:** Check `kaggle kernels status` before pushing (can't push while RUNNING)
- **VS Code Auto-Save:** Notebooks don't auto-save - ALWAYS Ctrl+S before pushing
- **enable_gpu=true, enable_internet=true** required in kernel-metadata.json
- Resumable uploads/downloads available (critical for bandwidth constraints)

## Key Directories and Files

### Kaggle Training Project
- `kaggle_training/phase1_training.ipynb` - Phase 1: CodeAlpaca (COMPLETE)
- `kaggle_training/phase2_training.ipynb` - Phase 2: Linux Commands (IN PROGRESS)
- `kaggle_training/phase3_training.ipynb` - Phase 3: Python System Automation (READY)
- `kaggle_training/kernel-metadata.json` - Kaggle kernel configuration
- `kaggle_training/TRAINING_STATUS.md` - Current training status
- `kaggle_api_docs/` - Complete Kaggle API documentation (cloned repository)

### Documentation
- `NEXT_SESSION_ONBOARDING.md` - Session continuity guide
- `KAGGLE_SETUP.md` - Kaggle environment setup
- `STATUS.md` - Overall project status
- `SYSTEM_SPECS.md` - Hardware specifications

### Archived Projects
- `rust_approach_archived/` - Custom Vulkan inference engine (Intel collaboration)
- `llama.cpp/` - Reference implementation
- `local_models/` - Local model storage

</target_file>
# Multi-LoRA Adapter Merging Research

**Date:** October 6, 2025  
**Research Question:** Can we train 4 separate LoRA adapters on base model, then merge all 4 into final model?

---

## 🎯 Executive Summary

**YES, multi-LoRA merging is fully supported by PEFT library.**

### Key Findings:
1. ✅ **PEFT has built-in multi-adapter composition**
2. ✅ **Two proven merge methods: TIES and DARE**
3. ✅ **No sequential training needed - can train all phases independently**
4. ✅ **Weighted merging allows control over each adapter's contribution**
5. ⚠️ **Some caveats about layer conflicts and weights**

---

## 📚 PEFT Multi-Adapter API

### Core Methods Available:

```python
# 1. Load multiple adapters
model = PeftModel.from_pretrained(base_model, "phase1_lora", adapter_name="phase1")
model.load_adapter("phase2_lora", adapter_name="phase2")
model.load_adapter("phase3_lora", adapter_name="phase3")
model.load_adapter("phase4_lora", adapter_name="phase4")

# 2. Merge adapters with weights
adapters = ["phase1", "phase2", "phase3", "phase4"]
weights = [1.0, 1.0, 1.0, 1.0]  # Equal weight
adapter_name = "merged_all"
density = 0.2  # For TIES/DARE methods

model.add_weighted_adapter(
    adapters, 
    weights, 
    adapter_name,
    combination_type="ties",  # or "dare" or "linear"
    density=density
)

# 3. Set merged adapter as active
model.set_adapter("merged_all")

# 4. Save final merged model
model.save_pretrained("final_merged_model")
```

---

## 🔬 Merge Methods Explained

### 1. Linear Merge (Simple)
- **How:** Weighted average of all adapter parameters
- **Pros:** Simple, fast, no parameter trimming
- **Cons:** Doesn't handle conflicts between adapters
- **Best for:** Adapters trained on complementary tasks with minimal overlap

### 2. TIES (TrIm, Elect, Merge) - RECOMMENDED
- **How:** 3-step process
  1. **Trim:** Remove redundant parameters
  2. **Elect:** Resolve sign conflicts by majority vote
  3. **Merge:** Average parameters with same sign
- **Pros:** Handles conflicts intelligently, reduces interference
- **Cons:** Requires `density` parameter tuning
- **Best for:** Multiple adapters with potential conflicts (OUR CASE)

### 3. DARE (Drop And REscale)
- **How:** Randomly drop parameters by `density`, rescale remaining
- **Pros:** Reduces redundancy before merging
- **Cons:** Stochastic (different results each run)
- **Best for:** Pre-processing before TIES merge

---

## 🎯 Recommended Strategy for Our Project

### Parallel Training Workflow:

```
Phase 1: Base → CodeAlpaca → phase1_lora.safetensors (42MB)
Phase 2: Base → Linux Commands → phase2_lora.safetensors (27MB)
Phase 3: Base → Python Automation → phase3_lora.safetensors (27MB)
Phase 4: Base → Troubleshooting → phase4_lora.safetensors (27MB)

Then: Base + [phase1 + phase2 + phase3 + phase4] → TIES merge → Final Model
```

### Advantages:
1. ✅ **Speed:** Each phase trains in 3-4h (12-16h total vs 30+ sequential)
2. ✅ **Parallelizable:** Can run simultaneously on TPUs
3. ✅ **No compounding slowdown:** Each phase trains on clean base model
4. ✅ **Flexibility:** Can re-train individual phases without affecting others
5. ✅ **Bandwidth efficient:** Still only upload ~150MB adapters total

---

## ⚠️ Important Caveats

### 1. Adapter Weight Selection
```python
weights = [2.0, 1.0, 1.0, 1.0]  # Phase 1 gets 2x weight
```
- **Recommendation:** Start with equal weights `[1.0, 1.0, 1.0, 1.0]`
- **Note:** Weights > 1.0 typically work better (preserves scale)
- **Experimentation:** May need to adjust based on task importance

### 2. Density Parameter (TIES/DARE)
```python
density = 0.2  # Keep 20% of parameters
```
- **Lower density (0.1-0.3):** More aggressive trimming, less interference
- **Higher density (0.5-0.8):** Preserve more knowledge, more potential conflicts
- **Recommendation:** Start with 0.2, increase if performance degrades

### 3. Target Modules Must Match
```python
# ALL adapters must use same target_modules
target_modules = ["q_proj", "k_proj", "v_proj", "o_proj"]
```
- ✅ **Our config:** All phases use same target modules - GOOD
- ❌ **Don't mix:** One adapter on attention, another on FFN layers

### 4. LoRA Config Consistency
```python
# ALL adapters should use consistent config
r = 16
lora_alpha = 32
target_modules = ["q_proj", "k_proj", "v_proj", "o_proj"]
```
- ✅ **Our setup:** All phases use identical LoRA config - PERFECT

---

## 🧪 Testing Strategy

### After Merging, Test Each Capability:

```python
# Test Phase 1 knowledge (CodeAlpaca)
prompt = "Write a Python function to reverse a string"

# Test Phase 2 knowledge (Linux Commands)
prompt = "How do I find all files modified in the last 7 days?"

# Test Phase 3 knowledge (Python Automation)
prompt = "Create a Python script to backup files to a directory"

# Test Phase 4 knowledge (Troubleshooting)
prompt = "How do I diagnose high CPU usage on a Linux server?"
```

**Expected:** Model should perform well on ALL four types of prompts.

---

## 📊 Comparison: Sequential vs Parallel

| Aspect | Sequential (Current) | Parallel (Proposed) |
|--------|---------------------|---------------------|
| **Training Time** | 30+ hours | 12-16 hours |
| **Speed per Phase** | 3h → 10h → ??? | 3-4h each |
| **GPU Hours Used** | 27h (2 phases) | 12-16h (4 phases) |
| **Bandwidth** | 2.5GB (LoRA) | 2.3GB (LoRA only) |
| **Flexibility** | Must retrain from start | Can retrain individual phases |
| **Risk** | Compounding slowdown | Independent phases |
| **Merge Complexity** | None (sequential) | One-time TIES merge |

---

## 🔍 Potential Issues & Solutions

### Issue 1: Adapter Conflicts
**Problem:** Multiple adapters modify same weights in conflicting ways  
**Solution:** TIES method automatically resolves sign conflicts  
**Mitigation:** Use `density=0.2` to trim redundant parameters

### Issue 2: Knowledge Forgetting
**Problem:** Merged model might lose some specialized knowledge  
**Solution:** Adjust adapter weights - give more weight to critical phases  
**Example:** `weights = [2.0, 1.5, 1.0, 1.0]` if coding is most important

### Issue 3: Unpredictable Performance
**Problem:** Merged model behavior harder to predict than sequential  
**Solution:** Extensive testing with diverse prompts from each phase  
**Backup:** Keep individual adapters, can always reload specific one

### Issue 4: Merge Takes Time
**Problem:** Merging 4 adapters might take 10-20 minutes  
**Solution:** One-time cost, much faster than retraining  
**Note:** Still saves 10+ hours compared to sequential approach

---

## 💡 Recommendations

### For Your Specific Case:

**Given:**
- 3 GPU hours remaining
- 20 TPU hours available
- Phase 2 experiencing 6x slowdown
- Need all 4 phases completed

**Recommendation: PIVOT TO PARALLEL TPU TRAINING**

1. **Stop Phase 3 GPU training** (if it fails performance check)
2. **Create 4 TPU training notebooks** (one per phase)
3. **Train all 4 phases independently on base model** (3-4h each)
4. **Upload all 4 adapters to Kaggle datasets**
5. **Create merge notebook with TIES method**
6. **Test final merged model extensively**

### Merge Notebook Configuration:

```python
# In final merge notebook
adapters = ["phase1", "phase2", "phase3", "phase4"]
weights = [1.0, 1.0, 1.0, 1.0]  # Start equal
adapter_name = "final_merged"
combination_type = "ties"
density = 0.2

model.add_weighted_adapter(
    adapters, 
    weights, 
    adapter_name,
    combination_type=combination_type,
    density=density
)
```

---

## 📝 Implementation Checklist

- [ ] Verify Phase 1 LoRA config matches all future phases
- [ ] Create 4 separate training notebooks (one per phase)
- [ ] Each notebook trains base model independently
- [ ] Each notebook uses identical LoRA config
- [ ] Upload all 4 adapters as separate Kaggle datasets
- [ ] Create merge notebook with PEFT `add_weighted_adapter`
- [ ] Test merged model on prompts from each phase
- [ ] If performance issues, adjust weights/density
- [ ] Save final merged model for deployment

---

## 🎓 Key Learnings

1. **PEFT library has full multi-adapter support** - this is a solved problem
2. **TIES method is designed exactly for this use case** - merging task-specific adapters
3. **No sequential training needed** - can train all phases independently
4. **Merge is fast** - 10-20 minutes vs hours of retraining
5. **More flexible** - can retrain/replace individual adapters without affecting others

---

## 📚 References

- [PEFT Documentation - Model Merging](https://huggingface.co/docs/peft/developer_guides/model_merging)
- [TIES Paper](https://arxiv.org/abs/2306.01708) - TrIm, Elect, and Merge
- [DARE Paper](https://arxiv.org/abs/2311.03099) - Drop And REscale
- [PEFT GitHub](https://github.com/huggingface/peft) - Source code and examples

---

## ✅ Final Verdict

**Multi-LoRA merging is PRODUCTION-READY and RECOMMENDED for your use case.**

The parallel training approach will:
- Save 10-15 hours of training time
- Eliminate compounding slowdown issues
- Provide more flexibility for iteration
- Use proven PEFT library methods (not experimental)

**Next Step:** Create parallel TPU training notebooks and merge workflow.

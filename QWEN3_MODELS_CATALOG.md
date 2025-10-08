# Qwen3 Models Catalog - DavidAU Collection

**Source**: https://huggingface.co/DavidAU/Qwen2.5-MOE-2x-4x-6x-8x__7B__Power-CODER__19B-30B-42B-53B-gguf

**Date**: October 4, 2025

---

## Qwen3 4B Models - Blitzar-Coder Series

### 1. Qwen3-4B-Blitzar-Coder-4B-F.1-bs20-2-Q6_K.gguf
- **Size**: 6B parameters
- **Tensors**: 607
- **Layers**: 55
- **Context**: 40k tokens
- **Features**: 
  - Brainstorm 20x applied
  - Fused with Blitzar-Coder (Qwen3)
  - Coding model fine-tune
- **Type**: NOT a MOE model

### 2. Qwen3-4B-Blitzar-Coder-4B-F.1-75-75-merge-Q6_K.gguf
- **Size**: 5.85B parameters
- **Tensors**: 596
- **Layers**: 54
- **Context**: 40k tokens
- **Features**:
  - Blitzar-Coder fused with Qwen3 Instruct 4B (75%/75% merge)
  - Coding model fine-tune
- **Type**: NOT a MOE model

### 3. Qwen3-4B-Blitzar-Coder-4B-F.1-75-75-merge-20-2-Q6_K.gguf
- **Size**: 7.75B parameters
- **Tensors**: 805
- **Layers**: 73
- **Context**: 40k tokens
- **Features**:
  - Brainstorm 20x applied
  - Fused with Blitzar-Coder (Qwen3)
  - Also fused with Qwen3 Instruct 4B
  - 2 merged models + Brainstorm
  - Coding model fine-tune
- **Type**: NOT a MOE model

---

## Qwen3 4B Models - Jan-Nano Series (128k Context)

### 4. Qwen3-4B-Jan-nano-128k-4B-bs20-2-Q6_K.gguf
- **Size**: 6B parameters
- **Tensors**: 607
- **Layers**: 55
- **Context**: 128k tokens ⚡
- **Features**:
  - Brainstorm 20x applied
  - Fused with Jan-Nano (Qwen3)
  - General all-purpose model that also does coding
  - **Note**: Slower t/s due to added tensors/layers
- **Type**: NOT a MOE model

### 5. Qwen3-4B-Jan-nano-128k-4B-75-75-merge-Q6_K.gguf
- **Size**: 5.85B parameters
- **Tensors**: 596
- **Layers**: 54
- **Context**: 128k tokens ⚡
- **Features**:
  - Jan-Nano fused with Qwen3 Instruct 4B (75%/75% merge)
  - General all-purpose model that also does coding
  - **Note**: Slower t/s due to added tensors/layers
- **Type**: NOT a MOE model

### 6. Qwen3-4B-Jan-nano--2--128k-4B-75-75-merge-20-2-Q6_K.gguf
- **Size**: 7.75B parameters
- **Tensors**: 805
- **Layers**: 73
- **Context**: 128k tokens ⚡
- **Features**:
  - Brainstorm 20x applied
  - Fused with Jan-Nano (Qwen3)
  - Also fused with Qwen3 Instruct 4B
  - 2 merged models + Brainstorm
  - General all-purpose model that also does coding
  - **Thinking blocks fully reactivated** (unexpected side effect)
  - **Note**: Slower t/s due to added tensors/layers
- **Type**: NOT a MOE model

---

## Qwen3 OpenCoder Multi-Expert Series

### 7. Qwen3-OpenCoder-Multi-exp5-11-Q6_K.gguf
- **Size**: 8.5B parameters
- **Features**:
  - Brainstorm 5x Matrix Mind Series
  - Components:
    - Nemo Opencoder 7B (main)
    - MSCoder 7B
    - Olympic 7B
    - Qwen Coder Instruct 7B
  - **Reasoning instruct coder generation**
- **Type**: NOT a MOE model (despite multi-expert name)

### 8. Qwen3-OpenCoder-Multi-exp5-11-v2-Q6_K.gguf
- **Size**: 8.5B parameters
- **Features**:
  - Brainstorm 5x Matrix Mind Series
  - Components:
    - Nemo Opencoder 7B (main)
    - MSCoder 7B (2x)
    - Qwen Coder Instruct 7B
  - **Reasoning instruct coder generation**
- **Type**: NOT a MOE model

### 9. Qwen3-OpenCoder-Multi-14B-exp5-11-Q6_K.gguf
- **Size**: 16B parameters
- **Features**:
  - Brainstorm 5x Matrix Mind Series
  - Components:
    - Nemo Opencoder 14B (main)
    - MSCoder 7B (2x)
    - Qwen Coder Instruct 14B
  - **Reasoning instruct coder generation**
- **Type**: NOT a MOE model

### 10. Qwen3-OpenCoder-Multi-32B-exp5-11-Q4_K_S.gguf
- **Size**: 35B parameters
- **Features**:
  - Brainstorm 5x Matrix Mind Series
  - Components:
    - Nemo Opencoder 32B (main)
    - MSCoder 32B
    - Olympic 32B
    - Qwen Coder Instruct 32B
  - **Reasoning instruct coder generation**
- **Type**: NOT a MOE model

### 11. Qwen3-OpenCoder-Multi-32B-exp5-11-V2-Q4_K_S.gguf
- **Size**: 35B parameters
- **Features**:
  - Brainstorm 5x Matrix Mind Series
  - Components:
    - Nemo Opencoder 32B (main)
    - MSCoder 32B (2x)
    - Qwen Coder Instruct 32B
  - **Reasoning instruct coder generation**
- **Type**: NOT a MOE model

---

## Summary Statistics

### By Size Category
- **~6B models**: 3 models (Blitzar + Jan-Nano basic)
- **~8B models**: 2 models (OpenCoder Multi)
- **16B models**: 1 model (OpenCoder Multi 14B)
- **35B models**: 2 models (OpenCoder Multi 32B)

### By Context Length
- **40k context**: 3 models (Blitzar-Coder series)
- **128k context**: 3 models (Jan-Nano series) ⚡

### By Use Case
- **Pure Coding**: 3 models (Blitzar-Coder series)
- **General + Coding**: 3 models (Jan-Nano series)
- **Reasoning + Coding**: 5 models (OpenCoder Multi series)

### Key Features
- **All models are in Q6_K or Q4_K_S quantization** (high quality)
- **None are true MOE models** (despite the repo name)
- **Several use "Brainstorm" technique** for enhanced reasoning
- **Jan-Nano series has massive 128k context**
- **OpenCoder Multi series focuses on reasoning**

---

## Recommended Settings (From Source)

### Temperature Recommendations
- **Simple code, few restrictions**: Temp 0.25-0.35
- **Complex requirements, many restrictions**: Temp 0.8-0.9 (or even >1.0)
- **Code with no dependencies**: Higher temps help "think outside the box"

### Suggested Test Settings #1
```
Temp: 0.3 to 0.7
Rep pen: 1.05 to 1.1
Top-p: 0.8
Min-p: 0.05
Top-k: 20
System prompt: None
```

### Suggested Test Settings #2
```
Temp: 0.55
Rep pen: 1.05
Top-p: 0.95
Min-p: 0.05
Top-k: 100
System prompt: None
```

### Template Requirements
- **Jinja (embedded)** or **ChatML** template
- **Max context**: 40k (most models) or 128k (Jan-Nano)
- **Min context suggested**: 8k to 16k

### Quality Recommendations
- **Simple coding problems**: Lower quants work well
- **Complex/multi-step problems**: Suggest Q6 or Q8

---

## Notes for Our Use Case (30 tok/s Target)

**Potential Candidates**:
1. **Qwen3-4B-Blitzar-Coder-4B-F.1-75-75-merge-Q6_K.gguf** (5.85B)
   - Smallest viable coding model
   - 40k context
   - Pure coding focus
   - **Expected speed: 35-50 tok/s** ✅

2. **Qwen3-4B-Jan-nano-128k-4B-75-75-merge-Q6_K.gguf** (5.85B)
   - Same size as above
   - 128k context (overkill but nice)
   - General + coding
   - **Expected speed: 30-45 tok/s** (slightly slower due to 128k) ✅

3. **Qwen3-OpenCoder-Multi-exp5-11-Q6_K.gguf** (8.5B)
   - Reasoning capabilities
   - Multi-expert merged
   - **Expected speed: 20-30 tok/s** (borderline)

**Avoid**:
- Jan-Nano series with Brainstorm 20x (7.75B) - explicitly noted as slower
- OpenCoder 14B+ models - too large for 30 tok/s target

---

**Next Step**: Download and test the 5.85B models first (best speed/quality balance)

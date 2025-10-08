# Model Specifications: Qwen3-Zero-Coder-Reasoning-0.8B

## Overview

**Model Name**: Qwen3-Zero-Coder-Reasoning-0.8B  
**Author**: DavidAU  
**Base Models**: Merge of Qwen/Qwen3-0.6B and suayptalha/Qwen3-0.6B-Code-Expert  
**HuggingFace**: [DavidAU/Qwen3-Zero-Coder-Reasoning-0.8B](https://huggingface.co/DavidAU/Qwen3-Zero-Coder-Reasoning-0.8B)  
**License**: Apache 2.0  
**Model Type**: Causal Language Model (Code Generation + Reasoning)

## Performance Claims

- **Speed**: 150+ tokens/second on moderate hardware
- **CPU Performance**: 50+ tokens/second on CPU only
- **Use Case**: Generalist coding model with full reasoning capabilities

## Architecture Specifications

| Parameter | Value |
|-----------|-------|
| **Total Parameters** | 816M (0.8B) |
| **Architecture** | Qwen3ForCausalLM |
| **Number of Layers** | 42 (merge of two 0.6B models) |
| **Hidden Size** | 1,024 |
| **Intermediate Size** | 3,072 |
| **Number of Attention Heads** | 16 |
| **Number of KV Heads (GQA)** | 8 |
| **Head Dimension** | 128 |
| **Vocabulary Size** | 151,936 tokens |
| **Max Context Length** | 40,960 tokens |
| **Recommended Min Context** | 8,192 - 16,384 tokens |
| **Activation Function** | SiLU |
| **Positional Encoding** | RoPE (theta=1,000,000) |
| **Normalization** | RMSNorm (eps=1e-6) |
| **Attention Bias** | False |
| **Tied Word Embeddings** | True |
| **Precision** | BFloat16 |
| **Number of Tensors** | 464 |

## Special Features

- **Reasoning Capability**: Full reasoning support for complex code requests
- **Dense Architecture**: 42 layers with 464 tensors (very dense for 0.8B size)
- **Long Context**: Supports up to 40K context window
- **Code-Optimized**: Specialized for programming tasks with brainstorming capabilities
- **Fast Inference**: Optimized for high throughput on both GPU and CPU

## Template & Context Requirements ⚠️

**CRITICAL REQUIREMENTS**:
- **Template**: Jinja (embedded) or ChatML template - **REQUIRED**
- **Max Context**: 40,960 tokens
- **Suggested Min Context**: 8,192 to 16,384 tokens
- **System Prompt**: Not required (tested with blank system prompt)

**EOS Token ID**: 151645  
**PAD Token ID**: 151654

## Recommended Settings

### Temperature Strategy 🎯

**IMPORTANT**: Temperature choice depends on task complexity:

- **Simple code, few restrictions**: 
  - Temperature: **0.25 - 0.35** (low temp for focused output)
  - Rep pen: 1.05
  
- **Complex requirements with many restrictions**: 
  - Temperature: **0.8 - 0.9** (or even **> 1.0**)
  - Rep pen: 1.05 (± 0.03)
  - Higher temps help model "think outside the box"
  
- **Code with no dependencies** (very challenging):
  - Temperature: **Higher** (0.8+)
  - Allows creative problem-solving approaches

### Settings Used for Testing #1 (Suggested)

```
Temperature: 0.3 to 0.7
Repetition Penalty: 1.05 to 1.1
Top-P: 0.8
Min-P: 0.05
Top-K: 20
System Prompt: None
```

### Settings Used for Testing #2 (Suggested)

```
Temperature: 0.55
Repetition Penalty: 1.05
Top-P: 0.95
Min-P: 0.05
Top-K: 100
System Prompt: None
```

### Alternative Settings

**Smoothing Factor**: 1.5 (for chat/roleplay in KoboldCpp, text-generation-webui, Silly Tavern)

## Quantization Options

| Format | Size | Quality | Speed | Use Case |
|--------|------|---------|-------|----------|
| **BF16** | 1.63GB | 100% | Baseline | Maximum accuracy |
| **F16** | 1.63GB | 100% | Baseline | Maximum accuracy |
| **Q8_0** | ~900MB | 99%+ | Fast | High quality |
| **Q6_K** | ~700MB | 98%+ | Faster | Balanced |
| **Q5_K_M (imatrix)** | ~600MB | 98% | Fast | **Recommended** |
| **Q4_K_M** | ~500MB | 95% | Very Fast | Good balance |
| **Q4_K_M (imatrix NEO)** | ~500MB | 97% | Very Fast | Best speed/quality |

### Current Setup

- **Active Model**: Q5_K_M with imatrix optimization
- **File**: `Qwen3-Zero-Coder-Reasoning-0.8B.i1-Q5_K_M.gguf`
- **Size**: ~572MB
- **Quality**: 98% of full precision
- **Expected Performance**: 40-60 tokens/second on Intel i9-13900H + Iris Xe GPU

## Template Requirements

**Supported Templates**:
- Jinja (embedded in model)
- ChatML

**EOS Token ID**: 151645  
**PAD Token ID**: 151654

## Training Information

- **Transformers Version**: 4.52.0.dev0
- **Unsloth Optimized**: Yes (version 2025.4.7)
- **Use Cache**: Enabled
- **Sliding Window**: Disabled

## Best Practices 📋

### Code Generation Strategy

1. **For Simple Code**: 
   - Use lower temperatures (0.25-0.35)
   - Minimal restrictions work best
   - Lower quants (Q4_K_M) acceptable

2. **For Complex Code**: 
   - Use higher temperatures (0.8-1.0+)
   - Enables creative problem-solving
   - Q6 or Q8 quants recommended

3. **For No-Dependency Code**: 
   - Higher temps recommended (0.8+)
   - This is more challenging - needs creative solutions
   - Use detailed instructions

4. **Quant Selection**: 
   - **Simple problems**: Q4_K_M+ works well
   - **Complex/multi-step problems**: Q6 or Q8 recommended
   - **Current setup**: Q5_K_M with imatrix (good balance)

### Prompting Strategy

5. **Instructions**: 
   - Model responds well to **detailed instructions**
   - Supports **step-by-step refinement and additions** to code
   - Can iteratively improve code through conversation

6. **System Prompt**: 
   - Not required (tested with blank)
   - **But will benefit from detailed system prompt** as instruct model
   - Use statements to tell it what you want and want to disallow

7. **Keeping Model On Track**:
   - Use explicit statements about what to allow/disallow
   - Helps prevent reasoning loops
   - Clear constraints work better than vague ones

## Hardware Requirements

### Minimum
- **RAM**: 1GB
- **VRAM**: 600MB (Q5_K_M)
- **CPU**: Any modern processor

### Recommended (Our Setup)
- **CPU**: Intel i9-13900H (14 cores)
- **GPU**: Intel Iris Xe Graphics (integrated)
- **RAM**: 8GB+ available
- **Storage**: 1GB free space

### Expected Performance (Our Hardware)
- **Target**: 30+ tokens/second
- **Context**: Up to 40K tokens
- **Latency**: <100ms per token

## Version Notes

This is Version 1 of the model. A Version 2 exists with claimed improvements:
- [Qwen3-Zero-Coder-Reasoning-V2-0.8B](https://huggingface.co/DavidAU/Qwen3-Zero-Coder-Reasoning-V2-0.8B)

## Additional Resources

- **Optimization Guide**: [Maximizing Model Performance](https://huggingface.co/DavidAU/Maximizing-Model-Performance-All-Quants-Types-And-Full-Precision-by-Samplers_Parameters)
- **NEO Quants**: [NEO-EX-GGUF Repository](https://huggingface.co/DavidAU/Qwen3-Zero-Coder-Reasoning-0.8B-NEO-EX-GGUF)
- **Regular Quants**: [mradermacher GGUF](https://huggingface.co/mradermacher/Qwen3-Zero-Coder-Reasoning-0.8B-GGUF)
- **Imatrix Quants**: [mradermacher i1-GGUF](https://huggingface.co/mradermacher/Qwen3-Zero-Coder-Reasoning-0.8B-i1-GGUF)

---

*Last Updated: October 4, 2025*  
*Project: ml_ai_engineering - C++ llama.cpp Implementation*

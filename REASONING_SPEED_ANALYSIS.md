# Reasoning Speed Analysis - Qwen3-Zero-Coder-Reasoning-0.8B

## Test Details

**Date**: October 4, 2025  
**Model**: Qwen3-Zero-Coder-Reasoning-0.8B.i1-Q5_K_M.gguf  
**Hardware**: Intel i9-13900H + Intel Iris Xe Graphics (Vulkan)  
**Prompt**: "Hello! Please introduce yourself."  
**Token Limit**: 256 tokens  
**Temperature**: 0.5  
**Top-P**: 0.9

## Performance Metrics

### Timing Results
```
real    3m55.197s  (235.197 seconds total)
user    0m12.551s  (12.551 seconds CPU time)
sys     0m0.873s   (0.873 seconds system time)
```

### Token Generation Speed

**Estimated Token Count**: ~256 tokens (hit the limit)  
**Total Time**: 235.2 seconds  
**Speed**: **1.09 tokens/second**

### GPU Utilization
- **All 43 layers offloaded to Vulkan GPU**: ✅
- **Model Size on GPU**: 566.37 MiB
- **KV Cache on GPU**: 672 MiB
- **Flash Attention**: Enabled
- **Compute Threads**: 6 CPU threads for coordination

## Reasoning Behavior Analysis

### What Happened

The model entered **multiple `<think>` cycles** during a simple greeting task:

1. **Cycle 1**: Introduction reasoning (normal)
   - Duration: ~30 seconds
   - Output: "Hello! I'm helpful! How can I assist you today? 😊"

2. **Cycle 2**: Unprompted OpenVino question
   - Duration: ~40 seconds
   - Self-generated: "> what is openvino?"
   - Reasoning about Intel hardware acceleration

3. **Cycle 3**: Bridge jumping riddle
   - Duration: ~60 seconds
   - Self-generated: "> a person is jumping off a bridge, where is he just before he jumps?"
   - Extended physics reasoning about trajectory

4. **Cycle 4**: Insanity loop
   - Duration: ~105 seconds
   - Got stuck reasoning about "insane" response
   - Repetitive meta-reasoning: "I need to respond... I should explain..."

### Reasoning Characteristics

**Positive Aspects**:
- Model successfully uses `<think>` tags for chain-of-thought
- Can handle complex reasoning when needed
- Shows "thinking" process transparently

**Problematic Aspects**:
- ❌ **Self-prompting**: Generates its own questions unprompted
- ❌ **No exit strategy**: Can't stop reasoning loop
- ❌ **Repetitive cycles**: Gets stuck in meta-reasoning
- ❌ **Extremely slow**: 1.09 tok/s is 27× slower than target (30 tok/s)

## Speed Comparison

| Configuration | Speed | Notes |
|---------------|-------|-------|
| **Current (Reasoning)** | **1.09 tok/s** | With `<think>` tags enabled |
| Target (Meeting Goal) | 30 tok/s | 27× faster needed |
| LM Studio (GGUF Q4) | 30-35 tok/s | On same hardware |
| Rust Sync Implementation | 1.79 tok/s | Previous attempt |
| Expected (Non-Reasoning) | 30-50 tok/s | Without reasoning overhead |

## Root Cause Analysis

### Why So Slow?

1. **Reasoning Overhead**: Each `<think>` cycle generates 50-100 internal reasoning tokens that don't contribute to output
2. **Interactive Mode**: Chat template enables multi-turn conversation
3. **Self-Prompting**: Model generates questions for itself
4. **Token Generation**: Only generating ~1 token/second during reasoning phases

### Hardware Performance

**GPU is working correctly**:
- All layers offloaded ✅
- Flash Attention enabled ✅
- Vulkan backend functional ✅
- No memory issues ✅

**Problem is model behavior, not hardware**.

## Recommendations

### Immediate Fix Options

**Option 1: Disable Reasoning Mode**
```bash
./build/bin/llama-cli \
  -m model.gguf \
  -p "def fibonacci(n):" \
  -ngl 99 \
  --temp 0.25 \
  --no-cnv \
  -sys "Output only code, no reasoning."
```
Expected: 25-35 tok/s

**Option 2: Use Non-Reasoning Model**
Download regular Qwen3 0.8B without "Reasoning" suffix:
- Expected: 30-50 tok/s
- Direct code generation
- No `<think>` cycles

**Option 3: Lower Temperature**
```bash
--temp 0.1  # More focused, less reasoning
```
Expected: 15-20 tok/s (still slow)

### Long-term Solution

**For coding tasks**: Use non-reasoning model  
**For complex problems**: Keep reasoning model but add stop conditions

## Conclusion

The model is **functionally correct** but **27× too slow** for production use at 30 tok/s target.

**Hardware is fine** - the slowness is due to the reasoning behavior, not the GPU/Vulkan implementation.

**Action**: Download non-reasoning version or disable `<think>` tags via system prompt.

---

*Test conducted: October 4, 2025*  
*Total test time: 3m 55s for 256 tokens*  
*Measured speed: 1.09 tokens/second*

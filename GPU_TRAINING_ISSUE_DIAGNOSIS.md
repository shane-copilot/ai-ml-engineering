# GPU Training Issue Diagnosis

**Date:** October 4, 2025  
**System:** Intel i9-13900H + Intel Iris Xe Graphics (RPL-P)

## Problem Summary
PyTorch with Intel Extension (IPEX) fails with "UR error" (Unified Runtime error) when running transformer models on Intel XPU GPU.

## Environment Details
```
PyTorch: 2.8.0+xpu
IPEX: 2.8.0+cpu
Transformers: 4.56.1
Intel Unified Runtime: 2025.1.1
Intel Compute Runtime: 25.35.35096.9-1
Level Zero: 1.24.2
```

## Test Results

### ✅ Working: Basic XPU Operations
```python
x = torch.randn(10, 10).to('xpu')
y = x @ x.t()  # Matrix multiply works
torch.xpu.synchronize()  # Success
```

### ❌ Failing: Transformers Model Inference
```
RuntimeError: UR error
Location: transformers/masking_utils.py:722
Operation: attention_mask.to(device=cache_position.device, dtype=torch.bool)
```

### Error Details
- Basic tensor operations on XPU work fine
- XPU is detected and accessible (96 EU, 38GB memory)
- Error occurs specifically in attention masking during model.generate()
- Fails with both eager and optimized attention implementations
- Fails with both fp16 and bfloat16 dtypes

## Inference Performance (Current Workaround)
| Backend | Model | Speed | Status |
|---------|-------|-------|--------|
| llama.cpp CPU | Qwen3-0.8B Q5_K_M | 27.01 tok/s | ✅ **WORKING** |
| PyTorch CPU | Qwen3-1.7B fp32 | 2.76 tok/s | ✅ Working but slow |
| llama.cpp Vulkan | Qwen3-0.8B Q5_K_M | 24.51 tok/s | ✅ Working but slower than CPU |
| llama.cpp OpenCL | Qwen3-0.8B Q5_K_M | 18.39 tok/s | ✅ Working but slowest |
| PyTorch XPU | Qwen3-1.7B fp16 | N/A | ❌ RuntimeError: UR error |

## Root Cause Analysis
The "UR error" suggests a problem in the Intel Unified Runtime layer when:
1. Converting tensor dtypes on XPU device
2. Specifically during attention mask operations
3. Likely a bug in IPEX 2.8.0 or UR 2025.1.1

This is NOT a driver issue (i915 driver is healthy, no kernel errors).

## Potential Solutions

### Short Term (For Inference)
✅ **Use llama.cpp on CPU: 27 tok/s** - Fast enough for development

### Medium Term (For Training)
The following approaches need investigation:

1. **Downgrade IPEX/UR versions**
   - Try IPEX 2.6.0 or 2.7.0 with older UR
   - Risk: May lose other features/fixes

2. **Use PyTorch native XPU support (without IPEX)**
   - PyTorch 2.8.0+xpu might have native support
   - Test if transformers works without IPEX import

3. **Report bug to Intel**
   - File issue on Intel Extension for PyTorch GitHub
   - Include minimal reproducible example

4. **Use alternative training framework**
   - Try with ONNX Runtime + DirectML
   - Try with Intel Neural Compressor

5. **Container with known-working versions**
   - Intel provides Docker images with validated combinations
   - May avoid local environment issues

## Recommended Immediate Action Plan

### For Inference (Now)
- ✅ Use llama.cpp with CPU: `-ngl 0`
- ✅ Use `--reasoning-budget 0` to disable thinking
- ✅ Achieves 27 tok/s (2.7x requirement)

### For Training (When Needed)
1. Test PyTorch XPU without IPEX import
2. If still failing, try IPEX 2.6.0/2.7.0
3. If still failing, report bug and use PyTorch ROCm/CUDA via cloud
4. Consider AMD GPU or NVIDIA GPU for local training as backup

## Command Reference

### Working Inference Command
```bash
cd /home/archlinux/code_insiders/ml_ai_engineering
/home/archlinux/code_insiders/ml_ai_engineering/llama.cpp/build/bin/llama-cli \
  -m q3_zero_.8b/Qwen3-Zero-Coder-Reasoning-0.8B.i1-Q5_K_M.gguf \
  -p "def fibonacci(n):" \
  -n 100 -ngl 0 --temp 0.7 \
  --reasoning-budget 0 -no-cnv
```

### Test XPU Availability
```python
source /home/archlinux/code_insiders/ai_engineering/.venv/bin/activate
python -c "import torch; print(f'XPU: {torch.xpu.is_available()}')"
```

## System Monitor Note
The system's GPU monitoring stops updating after 10-15 minutes of use. This appears to be a separate monitoring tool issue, not affecting actual GPU functionality. GPU frequency remains at 1500 MHz (max) during this time.

## Files to Check Before Training
- `/home/archlinux/code_insiders/ai_engineering/.venv` - IPEX environment
- `/home/archlinux/experimental/training_env` - CPU-only PyTorch (no IPEX)
- Local models: `/home/archlinux/code_insiders/ml_ai_engineering/local_models/safetensors/`

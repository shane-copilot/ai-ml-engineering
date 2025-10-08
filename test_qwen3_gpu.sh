#!/bin/bash

# Test Qwen3-Zero-0.8B with GPU to diagnose Vulkan issues
# Date: October 4, 2025

MODEL_PATH="/home/archlinux/code_insiders/ml_ai_engineering/q3_zero_.8b/Qwen3-Zero-Coder-Reasoning-0.8B.i1-Q5_K_M.gguf"
LLAMA_BIN="/home/archlinux/code_insiders/ml_ai_engineering/llama.cpp/build/bin/llama-cli"

echo "=================================="
echo "Qwen3-Zero-0.8B GPU Test"
echo "=================================="
echo ""

# Test 1: CPU only (baseline - should work)
echo "Test 1: CPU Only (Baseline)"
echo "----------------------------"
echo "" | $LLAMA_BIN \
    -m "$MODEL_PATH" \
    -p "Write a hello world program in Python." \
    -n 50 \
    -ngl 0 \
    --no-display-prompt \
    -c 2048 \
    -t 8 \
    --temp 0.7 \
    2>&1 | tee test1_cpu_output.txt

echo ""
echo ""

# Test 2: GPU with 32 layers
echo "Test 2: GPU with 32 layers"
echo "----------------------------"
echo "" | $LLAMA_BIN \
    -m "$MODEL_PATH" \
    -p "Write a hello world program in Python." \
    -n 50 \
    -ngl 32 \
    --no-display-prompt \
    -c 2048 \
    -t 8 \
    --temp 0.7 \
    2>&1 | tee test2_gpu_output.txt

echo ""
echo ""

# Test 3: GPU with all layers
echo "Test 3: GPU with 99 layers (all)"
echo "----------------------------"
echo "" | $LLAMA_BIN \
    -m "$MODEL_PATH" \
    -p "Write a hello world program in Python." \
    -n 50 \
    -ngl 99 \
    --no-display-prompt \
    -c 2048 \
    -t 8 \
    --temp 0.7 \
    2>&1 | tee test3_gpu_all_output.txt

echo ""
echo ""
echo "=================================="
echo "Tests complete!"
echo "=================================="
echo ""
echo "Check output files:"
echo "  - test1_cpu_output.txt (CPU baseline)"
echo "  - test2_gpu_output.txt (GPU 32 layers)"
echo "  - test3_gpu_all_output.txt (GPU all layers)"

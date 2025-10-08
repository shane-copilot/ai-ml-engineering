#!/bin/bash
# Quick DeepSeek-R1-8B Performance Test
# Optimized for Intel i9-13900H + Iris Xe GPU

MODEL="local_models/gguf/7-8B/DeepSeek-R1-0528-Qwen3-8B-Q4_K_M.gguf"
PROMPT="def binary_search(arr, target):"

echo "════════════════════════════════════════════════════════"
echo "  DeepSeek-R1-8B Speed Test (CPU vs GPU)"
echo "  Model: 8.19B params, Q4_K quantization"
echo "════════════════════════════════════════════════════════"
echo ""

echo "TEST 1: CPU-ONLY (20 threads)"
echo "────────────────────────────────────────────────────────"
./llama.cpp/build/bin/llama-cli \
    -m "$MODEL" \
    -p "$PROMPT" \
    -n 256 \
    -t 20 \
    -ngl 0 \
    -c 8192 \
    -b 2048 \
    --temp 0.3 \
    -no-cnv \
    --log-disable 2>&1 | grep -E "(load time|sample time|prompt eval|eval time|total time)"

echo ""
echo ""
echo "TEST 2: GPU-FULL (all 36 layers on Vulkan, 6 P-core threads)"
echo "────────────────────────────────────────────────────────"
./llama.cpp/build/bin/llama-cli \
    -m "$MODEL" \
    -p "$PROMPT" \
    -n 256 \
    -t 6 \
    -ngl 99 \
    -c 8192 \
    -b 2048 \
    --temp 0.3 \
    -no-cnv \
    --log-disable 2>&1 | grep -E "(load time|sample time|prompt eval|eval time|total time)"

echo ""
echo "════════════════════════════════════════════════════════"
echo "  ✓ Tests complete!"
echo "  Compare 'eval time' for tokens/second performance"
echo "════════════════════════════════════════════════════════"

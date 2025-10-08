#!/bin/bash
# Simple DeepSeek-R1-8B Performance Test
# Tests CPU vs GPU inference speed

set -e

MODEL="local_models/gguf/7-8B/DeepSeek-R1-0528-Qwen3-8B-Q4_K_M.gguf"
CLI="./llama.cpp/build/bin/llama-cli"
PROMPT="Write a Python function to implement binary search. Include error handling."

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     DeepSeek-R1-8B Speed Test (CPU vs GPU)                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Test 1: CPU-only
echo "TEST 1: CPU-ONLY (20 threads, no GPU)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
time "$CLI" \
    -m "$MODEL" \
    -p "$PROMPT" \
    -n 256 \
    -t 20 \
    -ngl 0 \
    -c 8192 \
    -b 2048 \
    --temp 0.3 \
    --top-p 0.9 \
    -no-cnv \
    --log-disable 2>&1 | tail -20

echo ""
echo ""

# Test 2: GPU full offload
echo "TEST 2: GPU-FULL (all layers on Vulkan, 6 threads)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
time "$CLI" \
    -m "$MODEL" \
    -p "$PROMPT" \
    -n 256 \
    -t 6 \
    -ngl 99 \
    -c 8192 \
    -b 2048 \
    --temp 0.3 \
    --top-p 0.9 \
    -no-cnv \
    --log-disable 2>&1 | tail -20

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Tests complete! Compare the tok/s values above."

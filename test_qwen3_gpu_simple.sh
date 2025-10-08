#!/bin/bash

# Simple GPU test - non-interactive, completion mode
MODEL_PATH="/home/archlinux/code_insiders/ml_ai_engineering/q3_zero_.8b/Qwen3-Zero-Coder-Reasoning-0.8B.i1-Q5_K_M.gguf"
LLAMA_BIN="/home/archlinux/code_insiders/ml_ai_engineering/llama.cpp/build/bin/llama-cli"

echo "Testing GPU inference with Qwen3-Zero-0.8B (completion mode)"
echo "=============================================================="
echo ""

$LLAMA_BIN \
    -m "$MODEL_PATH" \
    -p "def hello_world():\n    " \
    -n 100 \
    -ngl 99 \
    --temp 0.3 \
    -c 2048 \
    -e \
    2>&1

echo ""
echo ""
echo "Test complete! Check speed above."

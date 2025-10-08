#!/bin/bash
# Quick Model Tester
# Tests models from the consolidated library

set -e

PROJECT_ROOT="/home/archlinux/code_insiders/ml_ai_engineering"
LLAMA_CPP="$PROJECT_ROOT/llama.cpp/build/bin/llama-cli"
MODELS_DIR="$PROJECT_ROOT/local_models/gguf"

echo "=== MODEL LIBRARY QUICK TESTER ==="
echo ""
echo "Available Models:"
echo "1. Qwen3-4B-Thinking (2.4GB) - RECOMMENDED - Expected: 40-55 tok/s"
echo "2. Qwen3-1.7B-Q8 (2.1GB) - FASTEST - Expected: 60-80 tok/s"
echo "3. DeepSeek-R1-8B (4.7GB) - REASONING - Expected: 25-35 tok/s"
echo "4. Qwen3-Zero-0.8B (573MB) - CURRENT - Expected: 80-100 tok/s (no reasoning)"
echo ""

read -p "Select model to test (1-4): " choice

case $choice in
    1)
        MODEL="$MODELS_DIR/4B/Qwen3-4B-Thinking-2507-Q4_K_M.gguf"
        NAME="Qwen3-4B-Thinking"
        ;;
    2)
        MODEL="$MODELS_DIR/1.7B/qwen3-1.7b-q8_0.gguf"
        NAME="Qwen3-1.7B-Q8"
        ;;
    3)
        MODEL="$MODELS_DIR/7-8B/DeepSeek-R1-0528-Qwen3-8B-Q4_K_M.gguf"
        NAME="DeepSeek-R1-8B"
        ;;
    4)
        MODEL="$MODELS_DIR/0.8B/Qwen3-Zero-Coder-Reasoning-0.8B.i1-Q5_K_M.gguf"
        NAME="Qwen3-Zero-0.8B"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "Testing: $NAME"
echo "Model: $MODEL"
echo ""
echo "Running simple Fibonacci test..."
echo ""

time "$LLAMA_CPP" \
    -m "$MODEL" \
    -n 256 \
    -p "Write a Python function to calculate fibonacci numbers. Output only code, no explanations:" \
    -ngl 99 \
    --temp 0.3 \
    --top-p 0.9 \
    --top-k 40 \
    -no-cnv \
    2>&1 | tee "${PROJECT_ROOT}/test_${NAME}_$(date +%Y%m%d_%H%M%S).txt"

echo ""
echo "Test complete! Results saved to test_${NAME}_*.txt"

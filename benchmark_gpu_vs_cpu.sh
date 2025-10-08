#!/bin/bash
# GPU vs CPU Performance Benchmark
# Tests same model with full GPU offload vs CPU-only

set -e

PROJECT_ROOT="/home/archlinux/code_insiders/ml_ai_engineering"
LLAMA_CPP="$PROJECT_ROOT/llama.cpp/build/bin/llama-cli"
MODELS_DIR="$PROJECT_ROOT/local_models/gguf"

# Use the recommended 4B model
MODEL="$MODELS_DIR/4B/Qwen3-4B-Thinking-2507-Q4_K_M.gguf"
MODEL_NAME="Qwen3-4B-Thinking"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="${PROJECT_ROOT}/benchmark_gpu_vs_cpu_${TIMESTAMP}.txt"

echo "╔═══════════════════════════════════════════════════════════════╗" | tee "$RESULTS_FILE"
echo "║           GPU vs CPU PERFORMANCE BENCHMARK                    ║" | tee -a "$RESULTS_FILE"
echo "║           Model: $MODEL_NAME" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# Test prompt - simple and consistent
PROMPT="Write a Python function to calculate fibonacci numbers up to n. Include error handling:"

echo "Test Configuration:" | tee -a "$RESULTS_FILE"
echo "  Model: $MODEL_NAME (2.4GB Q4_K_M)" | tee -a "$RESULTS_FILE"
echo "  Tokens to generate: 256" | tee -a "$RESULTS_FILE"
echo "  Prompt: \"$PROMPT\"" | tee -a "$RESULTS_FILE"
echo "  Temperature: 0.3 (consistent output)" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# ============================================================================
# TEST 1: FULL GPU OFFLOAD (all layers on Vulkan)
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$RESULTS_FILE"
echo "TEST 1: GPU MODE (Full Vulkan Offload)" | tee -a "$RESULTS_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$RESULTS_FILE"
echo "Parameters: -ngl 99 (offload all layers to GPU)" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

echo "Running GPU test..." | tee -a "$RESULTS_FILE"
GPU_OUTPUT=$("$LLAMA_CPP" \
    -m "$MODEL" \
    -n 256 \
    -p "$PROMPT" \
    -ngl 99 \
    --temp 0.3 \
    --top-p 0.9 \
    --top-k 40 \
    -no-cnv \
    2>&1)

echo "$GPU_OUTPUT" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# Extract GPU performance metrics
GPU_TOKPS=$(echo "$GPU_OUTPUT" | grep -oP 'eval time.*?\K[0-9]+\.[0-9]+(?= tokens per second)' | tail -1)
GPU_LOAD_TIME=$(echo "$GPU_OUTPUT" | grep -oP 'load time.*?=\s*\K[0-9]+\.[0-9]+' | head -1)
GPU_LAYERS=$(echo "$GPU_OUTPUT" | grep -oP 'llm_load_tensors: offloaded \K[0-9]+')

echo "┌─────────────────────────────────────────────────────────┐" | tee -a "$RESULTS_FILE"
echo "│ GPU TEST RESULTS                                        │" | tee -a "$RESULTS_FILE"
echo "├─────────────────────────────────────────────────────────┤" | tee -a "$RESULTS_FILE"
echo "│ Speed:        $GPU_TOKPS tok/s" | tee -a "$RESULTS_FILE"
echo "│ Load Time:    $GPU_LOAD_TIME ms" | tee -a "$RESULTS_FILE"
echo "│ GPU Layers:   $GPU_LAYERS" | tee -a "$RESULTS_FILE"
echo "└─────────────────────────────────────────────────────────┘" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# ============================================================================
# TEST 2: CPU ONLY (no GPU offload)
# ============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$RESULTS_FILE"
echo "TEST 2: CPU MODE (No GPU Offload)" | tee -a "$RESULTS_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$RESULTS_FILE"
echo "Parameters: -ngl 0 (CPU only, no GPU)" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

echo "Running CPU test..." | tee -a "$RESULTS_FILE"
CPU_OUTPUT=$("$LLAMA_CPP" \
    -m "$MODEL" \
    -n 256 \
    -p "$PROMPT" \
    -ngl 0 \
    --temp 0.3 \
    --top-p 0.9 \
    --top-k 40 \
    -no-cnv \
    2>&1)

echo "$CPU_OUTPUT" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# Extract CPU performance metrics
CPU_TOKPS=$(echo "$CPU_OUTPUT" | grep -oP 'eval time.*?\K[0-9]+\.[0-9]+(?= tokens per second)' | tail -1)
CPU_LOAD_TIME=$(echo "$CPU_OUTPUT" | grep -oP 'load time.*?=\s*\K[0-9]+\.[0-9]+' | head -1)

echo "┌─────────────────────────────────────────────────────────┐" | tee -a "$RESULTS_FILE"
echo "│ CPU TEST RESULTS                                        │" | tee -a "$RESULTS_FILE"
echo "├─────────────────────────────────────────────────────────┤" | tee -a "$RESULTS_FILE"
echo "│ Speed:        $CPU_TOKPS tok/s" | tee -a "$RESULTS_FILE"
echo "│ Load Time:    $CPU_LOAD_TIME ms" | tee -a "$RESULTS_FILE"
echo "│ GPU Layers:   0 (CPU only)" | tee -a "$RESULTS_FILE"
echo "└─────────────────────────────────────────────────────────┘" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# ============================================================================
# COMPARISON SUMMARY
# ============================================================================
echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
echo "║                    PERFORMANCE COMPARISON                     ║" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# Calculate speedup
SPEEDUP=$(echo "scale=2; $GPU_TOKPS / $CPU_TOKPS" | bc)

echo "┌──────────────────────┬──────────────┬──────────────┬──────────┐" | tee -a "$RESULTS_FILE"
echo "│ Metric               │ GPU Mode     │ CPU Mode     │ Speedup  │" | tee -a "$RESULTS_FILE"
echo "├──────────────────────┼──────────────┼──────────────┼──────────┤" | tee -a "$RESULTS_FILE"
printf "│ %-20s │ %12s │ %12s │ %8s │\n" "Speed (tok/s)" "$GPU_TOKPS" "$CPU_TOKPS" "${SPEEDUP}x" | tee -a "$RESULTS_FILE"
printf "│ %-20s │ %12s │ %12s │ %8s │\n" "Load Time (ms)" "$GPU_LOAD_TIME" "$CPU_LOAD_TIME" "-" | tee -a "$RESULTS_FILE"
printf "│ %-20s │ %12s │ %12s │ %8s │\n" "Offloaded Layers" "$GPU_LAYERS" "0" "-" | tee -a "$RESULTS_FILE"
echo "└──────────────────────┴──────────────┴──────────────┴──────────┘" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# Performance assessment
echo "Performance Assessment:" | tee -a "$RESULTS_FILE"
echo "  • GPU Speed: $GPU_TOKPS tok/s" | tee -a "$RESULTS_FILE"
echo "  • CPU Speed: $CPU_TOKPS tok/s" | tee -a "$RESULTS_FILE"
echo "  • GPU Speedup: ${SPEEDUP}x faster than CPU" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# Target assessment
TARGET=30.0
if (( $(echo "$GPU_TOKPS >= $TARGET" | bc -l) )); then
    echo "  ✅ GPU MODE MEETS 30 tok/s TARGET!" | tee -a "$RESULTS_FILE"
    MARGIN=$(echo "scale=1; (($GPU_TOKPS - $TARGET) / $TARGET) * 100" | bc)
    echo "  🎯 Exceeds target by ${MARGIN}%" | tee -a "$RESULTS_FILE"
else
    echo "  ❌ GPU mode: $GPU_TOKPS tok/s (below 30 tok/s target)" | tee -a "$RESULTS_FILE"
    SHORTFALL=$(echo "scale=1; $TARGET - $GPU_TOKPS" | bc)
    echo "  📉 Short by ${SHORTFALL} tok/s" | tee -a "$RESULTS_FILE"
fi
echo "" | tee -a "$RESULTS_FILE"

if (( $(echo "$CPU_TOKPS >= $TARGET" | bc -l) )); then
    echo "  ✅ Even CPU-only mode meets target!" | tee -a "$RESULTS_FILE"
else
    echo "  ℹ️  CPU-only mode: $CPU_TOKPS tok/s (below target)" | tee -a "$RESULTS_FILE"
fi
echo "" | tee -a "$RESULTS_FILE"

echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
echo "║ Benchmark complete! Results saved to:" | tee -a "$RESULTS_FILE"
echo "║ $RESULTS_FILE" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"

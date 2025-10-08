#!/bin/bash
# Test Different Inference Methods and Optimizations
# Goal: Find configuration that maximizes tok/s

set -e

PROJECT_ROOT="/home/archlinux/code_insiders/ml_ai_engineering"
MODEL="$PROJECT_ROOT/local_models/gguf/4B/Qwen3-4B-Thinking-2507-Q4_K_M.gguf"
PROMPT="Write a Python function to calculate fibonacci:"
TOKENS=128
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="${PROJECT_ROOT}/inference_optimization_results_${TIMESTAMP}.txt"

echo "╔═══════════════════════════════════════════════════════════════╗" | tee "$RESULTS_FILE"
echo "║        INFERENCE METHOD & OPTIMIZATION TESTING                ║" | tee -a "$RESULTS_FILE"
echo "║        Model: Qwen3-4B-Thinking (2.4GB Q4_K_M)                ║" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# Function to extract tok/s from llama.cpp output
extract_tokps() {
    grep -oP 'eval time.*?\K[0-9]+\.[0-9]+(?= tokens per second)' | tail -1
}

# Function to run test and capture performance
run_test() {
    local test_name="$1"
    local binary="$2"
    shift 2
    local args=("$@")
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$RESULTS_FILE"
    echo "TEST: $test_name" | tee -a "$RESULTS_FILE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$RESULTS_FILE"
    echo "Binary: $binary" | tee -a "$RESULTS_FILE"
    echo "Args: ${args[*]}" | tee -a "$RESULTS_FILE"
    echo "" | tee -a "$RESULTS_FILE"
    
    local output
    output=$("$binary" "${args[@]}" 2>&1)
    
    local tokps
    tokps=$(echo "$output" | extract_tokps)
    
    if [ -z "$tokps" ]; then
        tokps="FAILED"
    fi
    
    echo "Result: $tokps tok/s" | tee -a "$RESULTS_FILE"
    echo "" | tee -a "$RESULTS_FILE"
    echo "$output" >> "$RESULTS_FILE"
    echo "" | tee -a "$RESULTS_FILE"
    
    # Store result for comparison
    echo "$test_name|$tokps" >> "${PROJECT_ROOT}/test_results_temp.txt"
}

# Clean temp file
rm -f "${PROJECT_ROOT}/test_results_temp.txt"

echo "Testing various inference methods and optimizations..." | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# ============================================================================
# BASELINE TESTS
# ============================================================================
echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
echo "║ PART 1: BASELINE TESTS (Current Configuration)               ║" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

run_test "Baseline GPU (ngl=99)" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv

run_test "Baseline CPU (ngl=0)" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 --temp 0.3 -no-cnv

# ============================================================================
# BATCH SIZE OPTIMIZATIONS
# ============================================================================
echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
echo "║ PART 2: BATCH SIZE OPTIMIZATIONS                             ║" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

run_test "GPU: Batch 512, UBatch 128" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv -b 512 -ub 128

run_test "GPU: Batch 1024, UBatch 256" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv -b 1024 -ub 256

run_test "GPU: Batch 4096, UBatch 512" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv -b 4096 -ub 512

run_test "GPU: Batch 8192, UBatch 1024" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv -b 8192 -ub 1024

# ============================================================================
# FLASH ATTENTION TESTS
# ============================================================================
echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
echo "║ PART 3: FLASH ATTENTION TOGGLE                               ║" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

run_test "GPU: Flash Attention OFF" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv -fa off

run_test "GPU: Flash Attention ON" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv -fa on

# ============================================================================
# THREAD OPTIMIZATION
# ============================================================================
echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
echo "║ PART 4: THREAD COUNT OPTIMIZATION                            ║" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

run_test "CPU: 4 threads" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 --temp 0.3 -no-cnv -t 4

run_test "CPU: 8 threads" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 --temp 0.3 -no-cnv -t 8

run_test "CPU: 12 threads" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 --temp 0.3 -no-cnv -t 12

run_test "CPU: 20 threads (all)" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 --temp 0.3 -no-cnv -t 20

# ============================================================================
# KV CACHE OPTIMIZATION
# ============================================================================
echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
echo "║ PART 5: KV CACHE TYPE OPTIMIZATION                           ║" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

run_test "GPU: KV Cache Q8_0 (smaller)" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv -ctk q8_0 -ctv q8_0

run_test "GPU: KV Cache Q4_0 (smallest)" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv -ctk q4_0 -ctv q4_0

# ============================================================================
# MMAP AND MLOCK
# ============================================================================
echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
echo "║ PART 6: MEMORY MAPPING OPTIONS                               ║" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

run_test "GPU: With MLOCK" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv --mlock

run_test "GPU: No MMAP" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv --no-mmap

# ============================================================================
# ALTERNATIVE INFERENCE METHODS
# ============================================================================
echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
echo "║ PART 7: ALTERNATIVE INFERENCE ENGINES                        ║" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

run_test "Batched Inference" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-batched" \
    -m "$MODEL" -ngl 99 -p "$PROMPT" -n "$TOKENS"

run_test "Simple Inference" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-simple" \
    -m "$MODEL" -ngl 99 -p "$PROMPT" -n "$TOKENS"

# ============================================================================
# COMBINED OPTIMIZATIONS
# ============================================================================
echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
echo "║ PART 8: COMBINED BEST OPTIMIZATIONS                          ║" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

run_test "GPU: ALL OPTIMIZATIONS" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 --temp 0.3 -no-cnv \
    -b 8192 -ub 1024 -fa on --mlock -ctk q8_0 -ctv q8_0

run_test "CPU: ALL OPTIMIZATIONS" \
    "$PROJECT_ROOT/llama.cpp/build/bin/llama-cli" \
    -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 --temp 0.3 -no-cnv \
    -b 8192 -ub 1024 -t 20 --mlock

# ============================================================================
# RESULTS SUMMARY
# ============================================================================
echo "" | tee -a "$RESULTS_FILE"
echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
echo "║                    RESULTS SUMMARY                            ║" | tee -a "$RESULTS_FILE"
echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
echo "" | tee -a "$RESULTS_FILE"

# Sort results by tok/s
echo "Ranking by Performance (tok/s):" | tee -a "$RESULTS_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$RESULTS_FILE"

if [ -f "${PROJECT_ROOT}/test_results_temp.txt" ]; then
    # Sort by tok/s (second column) in descending order
    sort -t'|' -k2 -rn "${PROJECT_ROOT}/test_results_temp.txt" | \
    awk -F'|' '{printf "%3d. %-50s %10s tok/s\n", NR, $1, $2}' | tee -a "$RESULTS_FILE"
    
    # Find best result
    BEST_RESULT=$(sort -t'|' -k2 -rn "${PROJECT_ROOT}/test_results_temp.txt" | head -1)
    BEST_NAME=$(echo "$BEST_RESULT" | cut -d'|' -f1)
    BEST_TOKPS=$(echo "$BEST_RESULT" | cut -d'|' -f2)
    
    echo "" | tee -a "$RESULTS_FILE"
    echo "╔═══════════════════════════════════════════════════════════════╗" | tee -a "$RESULTS_FILE"
    echo "║ 🏆 BEST CONFIGURATION                                         ║" | tee -a "$RESULTS_FILE"
    echo "║                                                               ║" | tee -a "$RESULTS_FILE"
    printf "║ %-61s ║\n" "  $BEST_NAME" | tee -a "$RESULTS_FILE"
    printf "║ %-61s ║\n" "  Performance: $BEST_TOKPS tok/s" | tee -a "$RESULTS_FILE"
    echo "║                                                               ║" | tee -a "$RESULTS_FILE"
    
    # Check if it meets target
    if (( $(echo "$BEST_TOKPS >= 30.0" | bc -l 2>/dev/null || echo 0) )); then
        echo "║ ✅ MEETS 30 TOK/S TARGET!                                    ║" | tee -a "$RESULTS_FILE"
    else
        SHORTFALL=$(echo "scale=1; 30.0 - $BEST_TOKPS" | bc 2>/dev/null || echo "?")
        printf "║ ❌ Still %-51s ║\n" "$SHORTFALL tok/s short of target" | tee -a "$RESULTS_FILE"
    fi
    
    echo "╚═══════════════════════════════════════════════════════════════╝" | tee -a "$RESULTS_FILE"
    
    # Clean up temp file
    rm -f "${PROJECT_ROOT}/test_results_temp.txt"
fi

echo "" | tee -a "$RESULTS_FILE"
echo "Full results saved to: $RESULTS_FILE" | tee -a "$RESULTS_FILE"

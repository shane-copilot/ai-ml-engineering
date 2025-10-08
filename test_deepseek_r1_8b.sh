#!/bin/bash
# DeepSeek-R1-8B Performance Test Script
# Optimized for Intel i9-13900H + Iris Xe GPU (40GB RAM)
# Tests both CPU and GPU inference with system-optimized settings

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MODEL_PATH="local_models/gguf/7-8B/DeepSeek-R1-0528-Qwen3-8B-Q4_K_M.gguf"
LLAMA_CLI="./llama.cpp/build/bin/llama-cli"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="test_results_deepseek_r1"

# System-optimized settings based on Intel i9-13900H specs
CPU_THREADS=20              # Use all 20 logical threads
P_CORES=6                   # Performance cores for compute
E_CORES=8                   # Efficiency cores for background
BATCH_SIZE=2048             # Large batch for 24MB L3 cache
CONTEXT_LENGTH=8192         # DeepSeek R1 supports long context
PREDICT_TOKENS=512          # Measure tokens for benchmarking

# Test prompts
CODING_PROMPT="Write a Python function to implement binary search on a sorted array. Include error handling and docstrings."
REASONING_PROMPT="Solve this problem step by step: If a train travels 120 km in 2 hours, then stops for 30 minutes, then travels another 180 km in 3 hours, what is the average speed for the entire journey including the stop?"

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     DeepSeek-R1-8B Performance Test Suite                 ║${NC}"
echo -e "${BLUE}║     Intel i9-13900H + Iris Xe GPU (40GB RAM)              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if model exists
if [ ! -f "$MODEL_PATH" ]; then
    echo -e "${RED}Error: Model not found at $MODEL_PATH${NC}"
    exit 1
fi

# Check if llama-cli exists
if [ ! -f "$LLAMA_CLI" ]; then
    echo -e "${RED}Error: llama-cli not found at $LLAMA_CLI${NC}"
    exit 1
fi

# Display model info
MODEL_SIZE=$(du -h "$MODEL_PATH" | cut -f1)
echo -e "${GREEN}Model:${NC} DeepSeek-R1-0528-Qwen3-8B (Q4_K_M)"
echo -e "${GREEN}Size:${NC} $MODEL_SIZE"
echo -e "${GREEN}Path:${NC} $MODEL_PATH"
echo ""

# Function to parse timing output
parse_timing() {
    local output_file=$1
    local test_name=$2
    
    # Extract timing information
    local load_time=$(grep "load time" "$output_file" | awk '{print $(NF-1)}')
    local sample_time=$(grep "sample time" "$output_file" | awk '{print $(NF-3)}')
    local prompt_eval_time=$(grep "prompt eval time" "$output_file" | awk '{print $(NF-3)}')
    local eval_time=$(grep "eval time" "$output_file" | awk '{print $(NF-3)}')
    local total_time=$(grep "total time" "$output_file" | awk '{print $(NF-1)}')
    
    # Extract token counts
    local prompt_tokens=$(grep "prompt eval time" "$output_file" | awk '{print $4}')
    local eval_tokens=$(grep "eval time" "$output_file" | awk '{print $4}')
    
    # Calculate tokens per second
    local tps=$(echo "scale=2; $eval_tokens / $eval_time * 1000" | bc 2>/dev/null || echo "N/A")
    
    echo -e "\n${YELLOW}═══ $test_name Results ═══${NC}"
    echo -e "${GREEN}Load time:${NC}        ${load_time} ms"
    echo -e "${GREEN}Prompt tokens:${NC}    ${prompt_tokens}"
    echo -e "${GREEN}Eval tokens:${NC}      ${eval_tokens}"
    echo -e "${GREEN}Prompt eval:${NC}      ${prompt_eval_time} ms"
    echo -e "${GREEN}Generation:${NC}       ${eval_time} ms"
    echo -e "${GREEN}Total time:${NC}       ${total_time} ms"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}⚡ Speed:${NC}          ${YELLOW}${tps} tokens/second${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Function to run test
run_test() {
    local test_name=$1
    local ngl=$2
    local threads=$3
    local prompt=$4
    local output_file="${OUTPUT_DIR}/${test_name}_${TIMESTAMP}.txt"
    
    echo -e "\n${BLUE}▶ Running: $test_name${NC}"
    echo -e "${GREEN}GPU layers:${NC} $ngl | ${GREEN}CPU threads:${NC} $threads"
    echo -e "${GREEN}Output:${NC} $output_file"
    
    # Run inference with timing
    time "$LLAMA_CLI" \
        -m "$MODEL_PATH" \
        -p "$prompt" \
        -n $PREDICT_TOKENS \
        -t $threads \
        -ngl $ngl \
        -c $CONTEXT_LENGTH \
        -b $BATCH_SIZE \
        --temp 0.3 \
        --top-p 0.9 \
        --top-k 40 \
        --repeat-penalty 1.1 \
        --chat-template deepseek \
        --log-disable \
        2>&1 | tee "$output_file"
    
    # Parse and display results
    parse_timing "$output_file" "$test_name"
}

echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  TEST 1: CPU-ONLY INFERENCE (All 20 threads)              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

# Test 1: Pure CPU inference with all threads
run_test "cpu_only_coding" 0 $CPU_THREADS "$CODING_PROMPT"

echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  TEST 2: GPU INFERENCE (Vulkan - All layers)              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

# Test 2: Full GPU offload (all layers to Vulkan)
# DeepSeek-R1-8B has 32 layers, offload all to GPU
run_test "gpu_all_layers_coding" 99 6 "$CODING_PROMPT"

echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  TEST 3: HYBRID (P-cores + GPU) - Partial offload         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

# Test 3: Hybrid mode - half layers on GPU, P-cores for CPU compute
run_test "hybrid_half_gpu_coding" 16 6 "$CODING_PROMPT"

echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  TEST 4: CPU-ONLY REASONING (All threads)                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

# Test 4: CPU reasoning test
run_test "cpu_only_reasoning" 0 $CPU_THREADS "$REASONING_PROMPT"

echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  TEST 5: GPU REASONING (Vulkan - All layers)              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

# Test 5: Full GPU reasoning test
run_test "gpu_all_layers_reasoning" 99 6 "$REASONING_PROMPT"

# Generate summary report
SUMMARY_FILE="${OUTPUT_DIR}/summary_${TIMESTAMP}.md"

echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Generating Summary Report                                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"

cat > "$SUMMARY_FILE" << EOF
# DeepSeek-R1-8B Performance Test Results

**Date:** $(date)
**Model:** DeepSeek-R1-0528-Qwen3-8B-Q4_K_M.gguf
**Size:** $MODEL_SIZE
**System:** Intel i9-13900H + Iris Xe GPU (40GB RAM)

---

## Test Configuration

- **Context Length:** $CONTEXT_LENGTH tokens
- **Batch Size:** $BATCH_SIZE
- **Prediction Tokens:** $PREDICT_TOKENS
- **CPU Threads (full):** $CPU_THREADS (6 P-cores + 8 E-cores)
- **CPU Threads (hybrid):** 6 (P-cores only)
- **Temperature:** 0.3
- **Top-P:** 0.9
- **Chat Template:** DeepSeek
- **Reasoning Format:** DeepSeek

---

## Results Summary

| Test | GPU Layers | CPU Threads | Task | Speed (tok/s) |
|------|-----------|-------------|------|---------------|
$(for file in ${OUTPUT_DIR}/*_${TIMESTAMP}.txt; do
    test_name=$(basename "$file" "_${TIMESTAMP}.txt")
    tps=$(grep "eval time" "$file" | awk '{tokens=$4; time=$(NF-3); printf "%.2f", tokens/time*1000}' 2>/dev/null || echo "N/A")
    
    case "$test_name" in
        cpu_only_coding)
            echo "| CPU Only | 0 | 20 | Coding | $tps |"
            ;;
        gpu_all_layers_coding)
            echo "| GPU Full | 99 | 6 | Coding | $tps |"
            ;;
        hybrid_half_gpu_coding)
            echo "| Hybrid | 16 | 6 | Coding | $tps |"
            ;;
        cpu_only_reasoning)
            echo "| CPU Only | 0 | 20 | Reasoning | $tps |"
            ;;
        gpu_all_layers_reasoning)
            echo "| GPU Full | 99 | 6 | Reasoning | $tps |"
            ;;
    esac
done)

---

## System Specifications

### CPU: Intel i9-13900H
- **P-Cores:** 6 @ up to 5.4 GHz (Hyper-Threading)
- **E-Cores:** 8 @ up to 4.0 GHz (Hyper-Threading)
- **Total Threads:** 20
- **Cache:** L3 24MB, L2 11.5MB total
- **SIMD:** AVX2, AVX-VNNI, FMA

### GPU: Intel Iris Xe Graphics
- **Memory:** 39GB unified (shared with system RAM)
- **Backend:** Vulkan 1.4.318
- **Compute:** 1024 work group invocations max

### Memory
- **Total RAM:** 40GB DDR4-3200 (dual-channel)
- **Available:** ~32GB

---

## Analysis

### Best Configuration
EOF

# Find best result
best_cpu_tps=$(grep "eval time" "${OUTPUT_DIR}/cpu_only_coding_${TIMESTAMP}.txt" | awk '{printf "%.2f", $4/$(NF-3)*1000}')
best_gpu_tps=$(grep "eval time" "${OUTPUT_DIR}/gpu_all_layers_coding_${TIMESTAMP}.txt" | awk '{printf "%.2f", $4/$(NF-3)*1000}')
best_hybrid_tps=$(grep "eval time" "${OUTPUT_DIR}/hybrid_half_gpu_coding_${TIMESTAMP}.txt" | awk '{printf "%.2f", $4/$(NF-3)*1000}')

cat >> "$SUMMARY_FILE" << EOF

- **CPU-Only:** ${best_cpu_tps} tok/s
- **GPU-Full:** ${best_gpu_tps} tok/s  
- **Hybrid:** ${best_hybrid_tps} tok/s

### Winner
EOF

if (( $(echo "$best_gpu_tps > $best_cpu_tps && $best_gpu_tps > $best_hybrid_tps" | bc -l) )); then
    echo "**GPU Full Offload** provides the best performance!" >> "$SUMMARY_FILE"
elif (( $(echo "$best_hybrid_tps > $best_cpu_tps && $best_hybrid_tps > $best_gpu_tps" | bc -l) )); then
    echo "**Hybrid Mode** provides the best performance!" >> "$SUMMARY_FILE"
else
    echo "**CPU-Only** provides the best performance!" >> "$SUMMARY_FILE"
fi

cat >> "$SUMMARY_FILE" << EOF

### Recommendations

1. **For maximum speed:** Use the winning configuration above
2. **For reasoning tasks:** DeepSeek R1 excels at step-by-step reasoning
3. **Memory usage:** Model fits comfortably in 40GB unified memory
4. **Target achieved:** $(if (( $(echo "$best_gpu_tps >= 10" | bc -l) )); then echo "✅ Yes (>10 tok/s target met)"; else echo "⚠️  Below 10 tok/s target"; fi)

---

## Detailed Logs

All test outputs saved to: \`$OUTPUT_DIR/\`

EOF

echo -e "${GREEN}✓ Summary report saved to: $SUMMARY_FILE${NC}"

# Display final results
echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  FINAL RESULTS                                             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}CPU-Only (20 threads):${NC}    ${best_cpu_tps} tok/s"
echo -e "${YELLOW}GPU-Full (all layers):${NC}    ${best_gpu_tps} tok/s"
echo -e "${YELLOW}Hybrid (16 layers):${NC}       ${best_hybrid_tps} tok/s"
echo ""

if (( $(echo "$best_gpu_tps > $best_cpu_tps && $best_gpu_tps > $best_hybrid_tps" | bc -l) )); then
    echo -e "${GREEN}🏆 Winner: GPU Full Offload (${best_gpu_tps} tok/s)${NC}"
elif (( $(echo "$best_hybrid_tps > $best_cpu_tps && $best_hybrid_tps > $best_gpu_tps" | bc -l) )); then
    echo -e "${GREEN}🏆 Winner: Hybrid Mode (${best_hybrid_tps} tok/s)${NC}"
else
    echo -e "${GREEN}🏆 Winner: CPU-Only (${best_cpu_tps} tok/s)${NC}"
fi

if (( $(echo "$best_gpu_tps >= 10" | bc -l) )) || (( $(echo "$best_cpu_tps >= 10" | bc -l) )) || (( $(echo "$best_hybrid_tps >= 10" | bc -l) )); then
    echo -e "${GREEN}✓ Target achieved: Speed exceeds 10 tok/s requirement${NC}"
else
    echo -e "${RED}⚠ Target not met: Below 10 tok/s requirement${NC}"
fi

echo ""
echo -e "${BLUE}All results saved to:${NC} $OUTPUT_DIR/"
echo -e "${BLUE}Summary report:${NC} $SUMMARY_FILE"
echo ""
echo -e "${GREEN}Testing complete!${NC}"

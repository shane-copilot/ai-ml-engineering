#!/bin/bash
# Optimized 4B Model Testing - Tuned for i9-13900H
# Goal: Find best configuration for 30 tok/s target

set -e

MODEL="local_models/gguf/4B/Qwen3-4B-Thinking-2507-Q4_K_M.gguf"
LLAMA_CLI="llama.cpp/build/bin/llama-cli"
PROMPT="Write a Python function to calculate fibonacci/no_think"
TOKENS=128

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║     4B MODEL OPTIMIZATION - i9-13900H Tuned Tests            ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Function to extract tok/s
extract_tokps() {
    grep -oP 'eval time.*?\K[0-9]+\.[0-9]+(?= tokens per second)' | tail -1
}

# Test 1: CPU with P-cores only (6 threads)
echo "Test 1: CPU - P-cores only (6 threads)..."
RESULT=$(timeout 60 $LLAMA_CLI -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 -t 6 -b 4096 --temp 0.3 -no-cnv 2>&1 | extract_tokps)
echo "  Result: $RESULT tok/s"
echo ""

# Test 2: CPU with P+E cores (12 threads)
echo "Test 2: CPU - P+E cores (12 threads, large batch)..."
RESULT=$(timeout 60 $LLAMA_CLI -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 -t 12 -b 8192 -ub 1024 --temp 0.3 -no-cnv 2>&1 | extract_tokps)
echo "  Result: $RESULT tok/s"
echo ""

# Test 3: CPU with all threads (20)
echo "Test 3: CPU - All threads (20, optimized batch)..."
RESULT=$(timeout 60 $LLAMA_CLI -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 -t 20 -b 4096 -ub 512 --temp 0.3 -no-cnv 2>&1 | extract_tokps)
echo "  Result: $RESULT tok/s"
echo ""

# Test 4: CPU with 14 threads (all physical cores)
echo "Test 4: CPU - 14 threads (physical cores only)..."
RESULT=$(timeout 60 $LLAMA_CLI -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 -t 14 -b 6144 -ub 768 --temp 0.3 -no-cnv 2>&1 | extract_tokps)
echo "  Result: $RESULT tok/s"
echo ""

# Test 5: GPU with Flash Attention OFF
echo "Test 5: GPU - Flash Attention OFF..."
RESULT=$(timeout 60 $LLAMA_CLI -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 -b 8192 -ub 2048 -fa off --temp 0.3 -no-cnv 2>&1 | extract_tokps)
echo "  Result: $RESULT tok/s"
echo ""

# Test 6: GPU with Q8 KV cache
echo "Test 6: GPU - Q8 KV cache (memory bandwidth optimization)..."
RESULT=$(timeout 60 $LLAMA_CLI -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 -b 8192 -ub 2048 -ctk q8_0 -ctv q8_0 --temp 0.3 -no-cnv 2>&1 | extract_tokps)
echo "  Result: $RESULT tok/s"
echo ""

# Test 7: GPU with Q4 KV cache
echo "Test 7: GPU - Q4 KV cache (maximum bandwidth optimization)..."
RESULT=$(timeout 60 $LLAMA_CLI -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 99 -b 8192 -ub 2048 -ctk q4_0 -ctv q4_0 --temp 0.3 -no-cnv 2>&1 | extract_tokps)
echo "  Result: $RESULT tok/s"
echo ""

# Test 8: Hybrid - partial GPU offload (20 layers)
echo "Test 8: Hybrid - 20 layers GPU, rest CPU..."
RESULT=$(timeout 60 $LLAMA_CLI -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 20 -t 12 -b 6144 --temp 0.3 -no-cnv 2>&1 | extract_tokps)
echo "  Result: $RESULT tok/s"
echo ""

# Test 9: CPU with MLOCK
echo "Test 9: CPU - MLOCK enabled (12 threads)..."
RESULT=$(timeout 60 $LLAMA_CLI -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 -t 12 -b 8192 --mlock --temp 0.3 -no-cnv 2>&1 | extract_tokps)
echo "  Result: $RESULT tok/s"
echo ""

# Test 10: CPU with optimized affinity (P-cores preferred)
echo "Test 10: CPU - High priority (12 threads)..."
RESULT=$(timeout 60 $LLAMA_CLI -m "$MODEL" -n "$TOKENS" -p "$PROMPT" -ngl 0 -t 12 -b 8192 --prio 2 --temp 0.3 -no-cnv 2>&1 | extract_tokps)
echo "  Result: $RESULT tok/s"
echo ""

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  All tests complete! Check results above.                    ║"
echo "╚═══════════════════════════════════════════════════════════════╝"

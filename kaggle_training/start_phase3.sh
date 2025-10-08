#!/bin/bash
# Upload Phase 2 adapter and start Phase 3 training

set -e

echo "=========================================="
echo "PHASE 2 → PHASE 3 TRANSITION"
echo "=========================================="

# Step 1: Upload Phase 2 adapter
echo -e "\n📤 STEP 1: Upload Phase 2 adapter to Kaggle..."
cd phase2_lora_upload
kaggle datasets create -p . -r zip
cd ..

echo "✅ Phase 2 adapter uploaded (27 MB)"
echo "   Dataset: ericgross1/qwen3-phase2-linux-lora-adapter"

# Step 2: Create Phase 3 kernel
echo -e "\n📤 STEP 2: Create Phase 3 kernel..."
kaggle kernels init -p phase3_training_fixed.ipynb

# Update kernel metadata
cat > kernel-metadata.json <<EOF
{
  "id": "ericgross1/qwen3-phase3-python-training",
  "title": "Qwen3 Phase 3: Python Automation Training",
  "code_file": "phase3_training_fixed.ipynb",
  "language": "python",
  "kernel_type": "notebook",
  "is_private": true,
  "enable_gpu": true,
  "enable_internet": true,
  "dataset_sources": [
    "ericgross1/qwen3-08b-coder-reasoning",
    "ericgross1/qwen3-phase1-lora-adapter",
    "ericgross1/qwen3-phase2-linux-lora-adapter"
  ],
  "competition_sources": [],
  "kernel_sources": []
}
EOF

echo "✅ Phase 3 kernel metadata created"

# Step 3: Push to Kaggle
echo -e "\n📤 STEP 3: Push Phase 3 notebook to Kaggle..."
kaggle kernels push -p .

echo -e "\n✅ Phase 3 notebook pushed!"
echo "   URL: https://www.kaggle.com/code/ericgross1/qwen3-phase3-python-training"

# Step 4: Monitor training
echo -e "\n📊 STEP 4: Monitor training status..."
echo "   Command: kaggle kernels status ericgross1/qwen3-phase3-python-training"
echo "   Expected time: ~2 hours (with performance fix)"
echo ""
echo "⏱️  PERFORMANCE TARGETS:"
echo "   • Phase 2 (slow): 23.48 sec/step = 10.2 hours"
echo "   • Phase 3 (fixed): <5 sec/step = ~2 hours"
echo ""
echo "🎯 GPU BUDGET:"
echo "   • Used so far: 27 hours"
echo "   • Remaining: ~3 hours"
echo "   • Phase 3 target: 2 hours"
echo "   • Phase 4 remaining: 1 hour"
echo ""
echo "=========================================="

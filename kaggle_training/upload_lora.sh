#!/bin/bash
# Upload LoRA Adapter to Kaggle
# Usage: ./upload_lora.sh <phase_number>

set -e

PHASE=$1
if [ -z "$PHASE" ]; then
    echo "Usage: ./upload_lora.sh <phase_number>"
    echo "Example: ./upload_lora.sh 1"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=========================================="
echo "Uploading Phase $PHASE LoRA Adapter"
echo "=========================================="

# Download kernel output
echo ""
echo "Step 1: Downloading Phase $PHASE output..."
KERNEL_NAME="ericgross1/qwen3-0-8b-phase${PHASE}-"
case $PHASE in
    1) KERNEL_NAME="${KERNEL_NAME}codealpaca-training" ;;
    2) KERNEL_NAME="${KERNEL_NAME}linux-commands" ;;
    3) KERNEL_NAME="${KERNEL_NAME}python-system" ;;
    4) KERNEL_NAME="${KERNEL_NAME}advanced" ;;
    *) echo "Invalid phase number"; exit 1 ;;
esac

OUTPUT_DIR="phase${PHASE}_output"
mkdir -p "$OUTPUT_DIR"
kaggle kernels output "$KERNEL_NAME" -p "$OUTPUT_DIR"

# Extract LoRA adapter
echo ""
echo "Step 2: Extracting LoRA adapter..."
cd "$OUTPUT_DIR"

# Find the zip file
ZIP_FILE=$(ls *.zip 2>/dev/null | head -1)
if [ -z "$ZIP_FILE" ]; then
    echo "Error: No zip file found in output"
    exit 1
fi

unzip -q "$ZIP_FILE"
echo "✓ Extracted $ZIP_FILE"

# Find the LoRA adapter directory (usually in final/)
LORA_DIR=$(find . -type d -name "final" | head -1)
if [ -z "$LORA_DIR" ]; then
    echo "Error: Could not find LoRA adapter directory"
    exit 1
fi

echo "✓ Found LoRA adapter in $LORA_DIR"

# Prepare upload directory
cd "$SCRIPT_DIR"
UPLOAD_DIR="phase${PHASE}_lora_upload"
rm -rf "$UPLOAD_DIR"
mkdir -p "$UPLOAD_DIR"
cp -r "$OUTPUT_DIR/$LORA_DIR"/* "$UPLOAD_DIR/"

echo ""
echo "Step 3: Creating dataset metadata..."
cd "$UPLOAD_DIR"

# Create metadata
cat > dataset-metadata.json <<EOF
{
  "title": "Qwen3 Phase $PHASE LoRA Adapter",
  "id": "ericgross1/qwen3-phase${PHASE}-lora-adapter",
  "licenses": [{"name": "apache-2.0"}]
}
EOF

echo "✓ Metadata created"

# List files
echo ""
echo "Files to upload:"
ls -lh

# Check file sizes
TOTAL_SIZE=$(du -sh . | cut -f1)
echo ""
echo "Total size: $TOTAL_SIZE"

# Upload
echo ""
echo "Step 4: Uploading to Kaggle..."
echo "Dataset will be: ericgross1/qwen3-phase${PHASE}-lora-adapter"
echo ""
read -p "Continue with upload? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    kaggle datasets create -p .
    echo ""
    echo "=========================================="
    echo "✓ Upload complete!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. Verify upload:"
    echo "   kaggle datasets files ericgross1/qwen3-phase${PHASE}-lora-adapter"
    echo ""
    echo "2. Add to Phase $((PHASE + 1)) notebook data sources:"
    echo "   - qwen3-08b-coder-reasoning (base model)"
    echo "   - qwen3-phase${PHASE}-lora-adapter (just uploaded)"
    echo ""
    echo "3. Run Phase $((PHASE + 1)) training"
else
    echo "Upload cancelled"
fi

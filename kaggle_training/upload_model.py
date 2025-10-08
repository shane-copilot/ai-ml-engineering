#!/usr/bin/env python3
"""
Upload Qwen3-0.8B model to Kaggle as a dataset
"""
import json
import os
import shutil
from pathlib import Path

# Configuration
MODEL_DIR = "/home/archlinux/code_insiders/ml_ai_engineering/q3_zero_.8b"
DATASET_NAME = "qwen3-08b-coder-reasoning"
USERNAME = "ericgross1"

def create_dataset_metadata():
    """Create dataset-metadata.json for Kaggle"""
    metadata = {
        "title": "Qwen3-0.8B-Coder-Reasoning",
        "id": f"{USERNAME}/{DATASET_NAME}",
        "licenses": [{"name": "apache-2.0"}],
        "keywords": ["nlp", "qwen3", "transformer", "code-generation"]
    }
    return metadata

def prepare_upload_directory():
    """Prepare directory with only essential files for training"""
    upload_dir = Path("./kaggle_upload_temp")
    upload_dir.mkdir(exist_ok=True)
    
    # Files needed for training
    essential_files = [
        "model.safetensors",
        "config.json",
        "tokenizer.json",
        "tokenizer_config.json",
        "special_tokens_map.json",
        "added_tokens.json"
    ]
    
    print("Preparing upload directory...")
    for filename in essential_files:
        src = Path(MODEL_DIR) / filename
        if src.exists():
            dst = upload_dir / filename
            shutil.copy2(src, dst)
            size_mb = src.stat().st_size / (1024 * 1024)
            print(f"  ✓ {filename} ({size_mb:.1f} MB)")
        else:
            print(f"  ⚠ {filename} not found (optional)")
    
    # Create metadata
    metadata = create_dataset_metadata()
    with open(upload_dir / "dataset-metadata.json", "w") as f:
        json.dump(metadata, f, indent=2)
    
    print(f"\n✓ Upload directory ready: {upload_dir}")
    return upload_dir

def main():
    print("=" * 60)
    print("Kaggle Dataset Upload: Qwen3-0.8B Model")
    print("=" * 60)
    
    upload_dir = prepare_upload_directory()
    
    print("\n" + "=" * 60)
    print("Next steps:")
    print("=" * 60)
    print(f"\n1. Review files in: {upload_dir}")
    print(f"\n2. Run this command to upload:")
    print(f"   cd {upload_dir}")
    print(f"   kaggle datasets create -p .")
    print(f"\n3. Or to update existing dataset:")
    print(f"   cd {upload_dir}")
    print(f"   kaggle datasets version -p . -m 'Updated model files'")
    print(f"\n4. After upload completes, the dataset will be at:")
    print(f"   https://www.kaggle.com/datasets/{USERNAME}/{DATASET_NAME}")
    print("\n" + "=" * 60)

if __name__ == "__main__":
    main()

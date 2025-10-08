#!/usr/bin/env python3
"""
Phase 3 Computer Use Dataset Generator Helper

This script helps track and merge dataset generation batches.
Copilot/Claude can generate batches, and this script manages them.

Usage:
  python dataset_manager.py --status        # Show generation progress
  python dataset_manager.py --merge         # Merge all batches into final dataset
  python dataset_manager.py --validate      # Validate dataset format
"""

import json
import os
from pathlib import Path
from datetime import datetime

DATASET_DIR = Path(__file__).parent
PROGRESS_FILE = DATASET_DIR / "generation_progress.json"

def load_progress():
    """Load generation progress"""
    if PROGRESS_FILE.exists():
        with open(PROGRESS_FILE, 'r') as f:
            return json.load(f)
    return None

def save_progress(progress):
    """Save generation progress"""
    progress['last_updated'] = datetime.now().isoformat()
    with open(PROGRESS_FILE, 'w') as f:
        json.dump(progress, f, indent=2)

def show_status():
    """Show current generation status"""
    progress = load_progress()
    if not progress:
        print("❌ No progress file found")
        return
    
    print(f"📊 Dataset Generation Progress")
    print(f"=" * 60)
    print(f"Total Target: {progress['total_target']:,}")
    print(f"Total Generated: {progress['total_generated']:,}")
    print(f"Progress: {progress['total_generated']/progress['total_target']*100:.1f}%")
    print(f"\n📋 By Category:")
    print(f"-" * 60)
    
    for cat_name, cat_data in progress['categories'].items():
        pct = cat_data['generated'] / cat_data['target'] * 100 if cat_data['target'] > 0 else 0
        status = "✅" if cat_data['generated'] >= cat_data['target'] else "🔄"
        print(f"{status} {cat_name.replace('_', ' ').title()}: {cat_data['generated']}/{cat_data['target']} ({pct:.1f}%)")
    
    print(f"\n🗂️  Batches Completed: {len(progress['batches_completed'])}")
    print(f"📅 Last Updated: {progress['last_updated']}")

def merge_batches():
    """Merge all batch files into single dataset"""
    print("🔄 Merging all batches...")
    
    all_examples = []
    batch_files = sorted(DATASET_DIR.glob("batch_*.json"))
    
    for batch_file in batch_files:
        print(f"  Loading {batch_file.name}...")
        with open(batch_file, 'r') as f:
            batch_data = json.load(f)
            all_examples.extend(batch_data)
    
    output_file = DATASET_DIR / "combined_dataset.json"
    with open(output_file, 'w') as f:
        json.dump(all_examples, f, indent=2)
    
    print(f"\n✅ Merged {len(all_examples):,} examples into {output_file.name}")
    print(f"📦 File size: {output_file.stat().st_size / 1024 / 1024:.2f} MB")
    
    return len(all_examples)

def validate_dataset():
    """Validate dataset format and completeness"""
    print("🔍 Validating dataset...")
    
    batch_files = list(DATASET_DIR.glob("batch_*.json"))
    if not batch_files:
        print("❌ No batch files found")
        return False
    
    total_examples = 0
    required_fields = ['id', 'scenario', 'problem', 'solution', 'steps', 'commands', 'packages', 'complexity', 'tags']
    
    for batch_file in batch_files:
        with open(batch_file, 'r') as f:
            try:
                batch_data = json.load(f)
                for i, example in enumerate(batch_data):
                    # Check required fields
                    missing = [f for f in required_fields if f not in example]
                    if missing:
                        print(f"⚠️  {batch_file.name} example {i}: Missing fields: {missing}")
                    
                    # Check packages structure
                    if 'packages' in example:
                        if 'debian_ubuntu' not in example['packages'] or 'arch' not in example['packages']:
                            print(f"⚠️  {batch_file.name} example {i}: Incomplete package info")
                
                total_examples += len(batch_data)
                print(f"✅ {batch_file.name}: {len(batch_data)} examples")
            except json.JSONDecodeError as e:
                print(f"❌ {batch_file.name}: JSON error - {e}")
                return False
    
    print(f"\n📊 Total: {total_examples:,} examples validated")
    return True

def main():
    import sys
    
    if len(sys.argv) < 2:
        print(__doc__)
        return
    
    command = sys.argv[1]
    
    if command == "--status":
        show_status()
    elif command == "--merge":
        merge_batches()
    elif command == "--validate":
        validate_dataset()
    else:
        print(f"Unknown command: {command}")
        print(__doc__)

if __name__ == "__main__":
    main()

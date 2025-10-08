#!/usr/bin/env python3
"""Fix the problematic line in phase1_training.ipynb"""
import json

# Read the notebook
with open('phase1_training.ipynb', 'r') as f:
    notebook = json.load(f)

# Find and fix the problematic cell
for cell in notebook['cells']:
    if cell['cell_type'] == 'code':
        source = cell['source']
        # Check if this is the cell with train_dataloader
        for i, line in enumerate(source):
            if 'trainer.train_dataloader' in line:
                # Remove this line
                source.pop(i)
                print(f"✓ Removed problematic line: {line.strip()}")
                break

# Write back
with open('phase1_training.ipynb', 'w') as f:
    json.dump(notebook, f, indent=1)

print("✓ Notebook fixed!")

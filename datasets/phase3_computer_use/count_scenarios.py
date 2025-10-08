#!/usr/bin/env python3
"""
Count total scenarios across all batch JSON files.
Validates JSON and provides detailed statistics.
"""

import json
import sys
from pathlib import Path
from collections import defaultdict

def count_scenarios():
    """Count scenarios in all batch_*.json files."""
    
    # Get all batch files
    batch_files = sorted(Path('.').glob('batch_*.json'))
    
    if not batch_files:
        print("No batch_*.json files found in current directory!")
        return 1
    
    total_scenarios = 0
    valid_files = 0
    invalid_files = []
    scenarios_per_file = []
    scenario_ids = set()
    duplicate_ids = []
    
    print(f"Found {len(batch_files)} batch files to analyze...")
    print()
    
    for batch_file in batch_files:
        try:
            with open(batch_file, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            # Validate it's a list
            if not isinstance(data, list):
                invalid_files.append((batch_file.name, "Not a JSON array"))
                continue
            
            # Count scenarios in this file
            scenario_count = len(data)
            scenarios_per_file.append((batch_file.name, scenario_count))
            total_scenarios += scenario_count
            valid_files += 1
            
            # Check for duplicate IDs
            for scenario in data:
                if isinstance(scenario, dict) and 'id' in scenario:
                    scenario_id = scenario['id']
                    if scenario_id in scenario_ids:
                        duplicate_ids.append((batch_file.name, scenario_id))
                    scenario_ids.add(scenario_id)
            
        except json.JSONDecodeError as e:
            invalid_files.append((batch_file.name, f"JSON parse error: {e}"))
        except Exception as e:
            invalid_files.append((batch_file.name, f"Error: {e}"))
    
    # Print results
    print("=" * 70)
    print("SCENARIO COUNT SUMMARY")
    print("=" * 70)
    print()
    print(f"Total batch files:     {len(batch_files)}")
    print(f"Valid files:           {valid_files}")
    print(f"Invalid files:         {len(invalid_files)}")
    print(f"Total scenarios:       {total_scenarios}")
    print(f"Unique scenario IDs:   {len(scenario_ids)}")
    print()
    
    # Show invalid files if any
    if invalid_files:
        print("⚠️  INVALID FILES:")
        for filename, error in invalid_files:
            print(f"  - {filename}: {error}")
        print()
    
    # Show duplicates if any
    if duplicate_ids:
        print("⚠️  DUPLICATE SCENARIO IDs:")
        for filename, scenario_id in duplicate_ids:
            print(f"  - {filename}: {scenario_id}")
        print()
    
    # Statistics
    if scenarios_per_file:
        counts = [count for _, count in scenarios_per_file]
        avg_count = sum(counts) / len(counts)
        min_count = min(counts)
        max_count = max(counts)
        
        print("STATISTICS:")
        print(f"  Average scenarios/file: {avg_count:.1f}")
        print(f"  Min scenarios/file:     {min_count}")
        print(f"  Max scenarios/file:     {max_count}")
        print()
        
        # Distribution
        distribution = defaultdict(int)
        for _, count in scenarios_per_file:
            distribution[count] += 1
        
        print("DISTRIBUTION:")
        for count in sorted(distribution.keys()):
            files_with_count = distribution[count]
            print(f"  {count:3d} scenario(s): {files_with_count:3d} file(s)")
        print()
    
    # Show files with most/least scenarios
    if scenarios_per_file:
        print("FILES WITH MOST SCENARIOS:")
        for filename, count in sorted(scenarios_per_file, key=lambda x: x[1], reverse=True)[:5]:
            print(f"  {count:3d} - {filename}")
        print()
        
        print("FILES WITH LEAST SCENARIOS:")
        for filename, count in sorted(scenarios_per_file, key=lambda x: x[1])[:5]:
            print(f"  {count:3d} - {filename}")
        print()
    
    print("=" * 70)
    print(f"✓ FINAL COUNT: {total_scenarios} scenarios")
    print("=" * 70)
    
    return 0 if not invalid_files and not duplicate_ids else 1

if __name__ == '__main__':
    sys.exit(count_scenarios())

import json

# Read the large file
with open('sourced_3_to_8', 'r') as f:
    data = json.load(f)

print(f"Total scenarios: {len(data)}")

# Split into batches of 20
batch_size = 20
for i in range(0, len(data), batch_size):
    batch_num = (i // batch_size) + 77  # Start from batch 77
    batch_data = data[i:i+batch_size]
    
    filename = f'batch_{batch_num:03d}_gemini_flash_systems_{(i//batch_size)+1:02d}.json'
    with open(filename, 'w') as f:
        json.dump(batch_data, f, indent=2)
    
    print(f"Created {filename} with {len(batch_data)} scenarios")

print("Split complete!")

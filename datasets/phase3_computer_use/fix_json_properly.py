import re
import json
from pathlib import Path

raw_path = Path('sourced_3_to_8')
text = raw_path.read_text()

# Remove trailing commas before closing brackets
text = re.sub(r',\s*]', ']', text)

# Replace adjacent arrays with commas
text = re.sub(r']\s*\[', ', ', text)

# Ensure it's wrapped in a single array
text = text.strip()
if not text.startswith('['):
    text = '[' + text
if not text.endswith(']'):
    text = text + ']'

# Attempt to parse and fix
try:
    data = json.loads(text)
    print(f'Successfully parsed {len(data)} scenarios')
except json.JSONDecodeError as e:
    print(f'Still failed: {e}')
    # Write debug file
    Path('debug_fixed.json').write_text(text)
    raise

# Now split into batches
batch_size = 20
for i in range(0, len(data), batch_size):
    batch_index = i // batch_size
    batch_num = 77 + batch_index
    filename = f'batch_{batch_num:03d}_gemini_flash_systems_{batch_index+1:02d}.json'
    with open(filename, 'w') as f:
        json.dump(data[i:i+batch_size], f, indent=2)
    print(f'Wrote {filename} ({len(data[i:i+batch_size])} entries)')

print('All done!')

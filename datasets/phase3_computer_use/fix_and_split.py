import re
import json
from pathlib import Path

raw_path = Path('sourced_3_to_8')
text = raw_path.read_text()

# Replace adjacent arrays with commas
text = re.sub(r'\]\s*\[', ', ', text)

# Ensure it's a single JSON array (wrap if not already)
text = text.strip()
if not text.startswith('['):
    raise SystemExit('Unexpected format: does not start with [')

# Attempt to parse
try:
    data = json.loads(text)
except json.JSONDecodeError as e:
    print(f'JSON decode failed initially: {e}')
    Path('debug_failed.json').write_text(text)
    raise

print(f'Parsed {len(data)} scenarios')

batch_size = 20
for i in range(0, len(data), batch_size):
    batch_index = i // batch_size
    batch_num = 77 + batch_index
    filename = f'batch_{batch_num:03d}_gemini_flash_systems_{batch_index+1:02d}.json'
    with open(filename, 'w') as f:
        json.dump(data[i:i+batch_size], f, indent=2)
    print(f'Wrote {filename} ({len(data[i:i+batch_size])} entries)')

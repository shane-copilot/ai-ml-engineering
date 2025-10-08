import re

# Read the file
with open('sourced_3_to_8', 'r') as f:
    content = f.read()

# Fix trailing commas before ] or }
content = re.sub(r',(\s*[\]}])', r'\1', content)

# Write back
with open('sourced_3_to_8_fixed.json', 'w') as f:
    f.write(content)

print("Fixed JSON written to sourced_3_to_8_fixed.json")

# Try to validate it
import json
try:
    with open('sourced_3_to_8_fixed.json', 'r') as f:
        data = json.load(f)
    print(f"✅ Valid JSON! Found {len(data)} scenarios")
except json.JSONDecodeError as e:
    print(f"❌ Still has errors: {e}")

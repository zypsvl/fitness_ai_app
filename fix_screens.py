import os
import re

# Directory to process
screens_dir = r"d:\flutter\fitness_ai_app\lib\screens"

# Pattern to match withOpacity calls
pattern = r'\.withOpacity\(([0-9.]+)\)'
replacement = r'.withValues(alpha: \1)'

# Process all Dart files
for filename in os.listdir(screens_dir):
    if filename.endswith('.dart'):
        filepath = os.path.join(screens_dir, filename)
        
        # Read file
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Replace pattern
        new_content = re.sub(pattern, replacement, content)
        
        # Write back if changed
        if new_content != content:
            with open(filepath, 'w', encoding='utf-8', newline='\r\n') as f:
                f.write(new_content)
            print(f"Updated: {filename}")
        else:
            print(f"No changes: {filename}")

print("Done!")

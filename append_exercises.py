
import json

# Read the original file
with open('assets/data/exercises.json', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Truncate at line 2555 (keep first 2555 lines)
# Line 2556 is where skater_hops starts, which we want to replace
# We need to make sure line 2555 ends with a comma if it doesn't already, 
# or if the new content starts with a comma.
# The new content starts with a comma (it's a list of objects, but printed as string with leading comma if we are not careful).
# Let's check temp_exercises.json content.
# It starts with:
#   {
#     "id": "skater_hops",
# ...
# So we need a comma after the previous object.

kept_lines = lines[:2555]

# Check the last kept line
last_line = kept_lines[-1].strip()
if last_line == '}' or last_line == '},':
    # Ensure it has a comma
    if not kept_lines[-1].strip().endswith(','):
        kept_lines[-1] = kept_lines[-1].rstrip() + ',\n'

# Read the new content
with open('temp_exercises.json', 'r', encoding='utf-8') as f:
    new_content = f.read()

# Write back to exercises.json
with open('assets/data/exercises.json', 'w', encoding='utf-8') as f:
    f.writelines(kept_lines)
    f.write(new_content)
    f.write('\n]') # Close the array

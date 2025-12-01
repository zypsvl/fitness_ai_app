import json
import os

# Paths
exercises_path = 'assets/data/exercises.json'
img_dir = 'assets/img'

# Load exercises
with open(exercises_path, 'r', encoding='utf-8') as f:
    exercises = json.load(f)

# Get list of image files
img_files_map = {}
files = os.listdir(img_dir)

for filename in files:
    name, ext = os.path.splitext(filename)
    key = name.lower()
    
    if key in img_files_map:
        existing_filename = img_files_map[key]
        existing_ext = os.path.splitext(existing_filename)[1].lower()
        new_ext = ext.lower()
        
        if new_ext == '.gif' and existing_ext != '.gif':
            img_files_map[key] = filename
    else:
        img_files_map[key] = filename

# Update exercises
updated_count = 0
for exercise in exercises:
    ex_id = exercise.get('id', '').lower()
    
    if ex_id in img_files_map:
        exercise['gif'] = img_files_map[ex_id]
        updated_count += 1

print(f"Updated {updated_count} exercises with GIF filenames.")

# Write back
with open(exercises_path, 'w', encoding='utf-8') as f:
    json.dump(exercises, f, indent=2)
    
print("Done!")

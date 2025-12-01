import json
import os

path = 'assets/data/exercises.json'
try:
    with open(path, 'r', encoding='utf-8') as f:
        exercises = json.load(f)
except Exception as e:
    print(f"Error reading file: {e}")
    exit(1)

ids = {ex['id'] for ex in exercises}

to_add = [
    {
        "id": "squat",
        "name": "Squat",
        "mechanic": "compound",
        "equipment_tier": "home",
        "primary_muscle": "quadriceps",
        "secondary_muscles": ["glutes", "hamstrings"],
        "body_part": "legs",
        "difficulty": 1,
        "gif": "bodyweight_squat.gif"
    },
    {
        "id": "calf_raises",
        "name": "Calf Raises",
        "mechanic": "isolation",
        "equipment_tier": "home",
        "primary_muscle": "calves",
        "secondary_muscles": [],
        "body_part": "legs",
        "difficulty": 1,
        "gif": "standing_calf_raise.gif"
    }
]

added_count = 0
for item in to_add:
    if item['id'] not in ids:
        exercises.append(item)
        ids.add(item['id'])
        print(f"Added {item['id']}")
        added_count += 1
    else:
        print(f"Skipped {item['id']} (already exists)")

# Fix bicycle_crunch gif if missing
fixed_gifs = 0
for ex in exercises:
    if ex['id'] == 'bicycle_crunch' and not ex.get('gif'):
        ex['gif'] = 'bicycle_crunches.gif'
        print("Fixed bicycle_crunch gif")
        fixed_gifs += 1

if added_count > 0 or fixed_gifs > 0:
    try:
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(exercises, f, indent=2)
        print(f"Saved changes. Added {added_count}, Fixed GIFs {fixed_gifs}")
    except Exception as e:
        print(f"Error writing file: {e}")
else:
    print("No changes needed.")

import json

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
        "id": "cable_crossover",
        "name": "Cable Crossover",
        "mechanic": "isolation",
        "equipment_tier": "gym",
        "primary_muscle": "chest",
        "secondary_muscles": ["front_delts"],
        "body_part": "upper_body",
        "difficulty": 2,
        "gif": "cable_crossover.gif"
    },
    {
        "id": "overhead_tricep_extension",
        "name": "Overhead Tricep Extension",
        "mechanic": "isolation",
        "equipment_tier": "dumbbell",
        "primary_muscle": "triceps",
        "secondary_muscles": [],
        "body_part": "upper_body",
        "difficulty": 1,
        "gif": "skullcrusher.gif"
    }
]

added_count = 0
for item in to_add:
    if item['id'] not in ids:
        exercises.append(item)
        print(f"Added {item['id']}")
        added_count += 1
    else:
        print(f"Skipped {item['id']} (already exists)")

if added_count > 0:
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(exercises, f, indent=2)
    print(f"Saved. Total exercises: {len(exercises)}")
else:
    print(f"No changes. Total exercises: {len(exercises)}")

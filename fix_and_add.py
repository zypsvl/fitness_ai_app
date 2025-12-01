import json

# Load exercises
with open('assets/data/exercises.json', 'r', encoding='utf-8') as f:
    exercises = json.load(f)

print(f"Original count: {len(exercises)}")

# Fix the corrupted dumbbell_fly
for i, ex in enumerate(exercises):
    if ex['id'] == 'dumbbell_fly':
        ex['primary_muscle'] = 'chest'
        ex['secondary_muscles'] = ['front_delts']
        ex['difficulty'] = 1
        ex['gif'] = 'dumbbell_fly.gif'
        # Remove duplicate key if exists
        if 'equipment_tier' in ex and isinstance(ex.get('equipment_tier'), str):
            ex['equipment_tier'] = 'dumbbell'
        print(f"Fixed dumbbell_fly at index {i}")
        break

# Add missing exercises
new_exercises = [
    {
        "id": "incline_dumbbell_press",
        "name": "Incline Dumbbell Press",
        "mechanic": "compound",
        "equipment_tier": "dumbbell",
        "primary_muscle": "upper_chest",
        "secondary_muscles": ["front_delts", "triceps"],
        "body_part": "upper_body",
        "difficulty": 2,
        "gif": "incline_dumbbell_press.gif"
    },
    {
        "id": "close_grip_bench_press",
        "name": "Close Grip Bench Press",
        "mechanic": "compound",
        "equipment_tier": "gym",
        "primary_muscle": "triceps",
        "secondary_muscles": ["chest", "front_delts"],
        "body_part": "upper_body",
        "difficulty": 2,
        "gif": "close_grip_bench_press.gif"
    },
    {
        "id": "dumbbell_flyes",
        "name": "Dumbbell Flyes",
        "mechanic": "isolation",
        "equipment_tier": "dumbbell",
        "primary_muscle": "chest",
        "secondary_muscles": ["front_delts"],
        "body_part": "upper_body",
        "difficulty": 1,
        "gif": "dumbbell_fly.gif"
    },
    {
        "id": "tricep_pushdown",
        "name": "Tricep Pushdown",
        "mechanic": "isolation",
        "equipment_tier": "gym",
        "primary_muscle": "triceps",
        "secondary_muscles": [],
        "body_part": "upper_body",
        "difficulty": 1,
        "gif": "tricep_dips.gif"
    }
]

# Check which ones don't exist
existing_ids = [ex['id'] for ex in exercises]
for new_ex in new_exercises:
    if new_ex['id'] not in existing_ids:
        exercises.append(new_ex)
        print(f"Added {new_ex['id']}")
    else:
        print(f"Skipped {new_ex['id']} (already exists)")

print(f"New count: {len(exercises)}")

# Save
with open('assets/data/exercises.json', 'w', encoding='utf-8') as f:
    json.dump(exercises, f, indent=2)

print("Saved successfully!")

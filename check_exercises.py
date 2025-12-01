import json

# Load exercises
with open('assets/data/exercises.json', 'r', encoding='utf-8') as f:
    exercises = json.load(f)

# Get all IDs
all_ids = sorted([ex['id'] for ex in exercises])

print("Total exercises:", len(all_ids))
print("\nChest exercises:")
for ex in exercises:
    if ex.get('primary_muscle') in ['chest', 'upper_chest', 'lower_chest'] or 'chest' in ex.get('secondary_muscles', []):
        print(f"  {ex['id']}")

print("\nTricep exercises:")
for ex in exercises:
    if 'tricep' in ex.get('primary_muscle', '') or 'tricep' in ex.get('secondary_muscles', []):
        print(f"  {ex['id']}")


import json

try:
    with open('assets/data/exercises.json', 'r') as f:
        data = json.load(f)
    
    print(f"JSON is valid. Total exercises: {len(data)}")
    
    ids = [e['id'] for e in data]
    unique_ids = set(ids)
    
    if len(ids) != len(unique_ids):
        print("Duplicate IDs found!")
        from collections import Counter
        duplicates = [item for item, count in Counter(ids).items() if count > 1]
        print(f"Duplicates: {duplicates}")
    else:
        print("No duplicate IDs found.")
        
    # Check for missing fields
    required_fields = ['id', 'name', 'mechanic', 'equipment_tier', 'primary_muscle', 'body_part', 'difficulty', 'gif']
    for e in data:
        missing = [field for field in required_fields if field not in e]
        if missing:
            print(f"Exercise {e.get('id', 'UNKNOWN')} is missing fields: {missing}")

except json.JSONDecodeError as e:
    print(f"JSON Error: {e}")
except Exception as e:
    print(f"Error: {e}")

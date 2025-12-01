
import json

try:
    with open('assets/data/exercises.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    unique_data = []
    seen_ids = set()
    
    # Keep the first occurrence of each ID
    for exercise in data:
        if exercise['id'] not in seen_ids:
            unique_data.append(exercise)
            seen_ids.add(exercise['id'])
            
    print(f"Original count: {len(data)}")
    print(f"Unique count: {len(unique_data)}")
    
    with open('assets/data/exercises.json', 'w', encoding='utf-8') as f:
        json.dump(unique_data, f, indent=2)
        
    print("Duplicates removed.")

except Exception as e:
    print(f"Error: {e}")

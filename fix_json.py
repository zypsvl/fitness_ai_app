import json

# Load the potentially corrupted file
try:
    with open('assets/data/exercises.json', 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Try to find where the corruption starts
    # The issue is around the dumbbell_fly exercise
    
    # Let me try to parse it
    exercises = json.loads(content)
    print(f"Loaded {len(exercises)} exercises")
    
    # Find and remove the corrupted dumbbell_fly entry
    corrupted_index = None
    for i, ex in enumerate(exercises):
        if ex['id'] == 'dumbbell_fly':
            print(f"Found dumbbell_fly at index {i}")
            print(json.dumps(ex, indent=2))
            corrupted_index = i
            break
    
except json.JSONDecodeError as e:
    print(f"JSON Error: {e}")
    print("File is corrupted, need manual fix")

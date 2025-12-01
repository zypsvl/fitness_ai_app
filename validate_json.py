import json

try:
    with open('assets/data/exercises.json', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check for duplicates using a custom decoder
    def duplicate_check(ordered_pairs):
        d = {}
        for k, v in ordered_pairs:
            if k in d:
                print(f"Duplicate key found: {k} with value {v}")
            d[k] = v
        return d

    exercises = json.loads(content, object_pairs_hook=duplicate_check)
    print(f"Successfully loaded {len(exercises)} exercises.")
    
    # Check for specific IDs
    target_ids = ['squat', 'leg_press', 'leg_extension', 'hamstring_curl', 'calf_raises', 'plank']
    found_ids = [ex['id'] for ex in exercises]
    
    print("\nChecking target IDs:")
    for tid in target_ids:
        if tid in found_ids:
            print(f"  [FOUND] {tid}")
        else:
            print(f"  [MISSING] {tid}")
            
except Exception as e:
    print(f"Error: {e}")

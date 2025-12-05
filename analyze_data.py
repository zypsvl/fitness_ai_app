import json
import os

def analyze_exercises():
    file_path = r'd:\flutter\fitness_ai_app\assets\data\exercises.json'
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            exercises = json.load(f)
            
        print(f"Total exercises: {len(exercises)}")
        
        equipment_tiers = {}
        unknown_tier_exercises = []
        dumbbell_exercises = []
        
        for ex in exercises:
            tier = ex.get('equipment_tier', 'UNKNOWN')
            ex_id = ex.get('id', '')
            name = ex.get('name', '')
            
            # Count tiers
            equipment_tiers[tier] = equipment_tiers.get(tier, 0) + 1
            
            if tier == 'UNKNOWN':
                unknown_tier_exercises.append(f"{ex_id} ({name})")
                
            if tier == 'dumbbell':
                dumbbell_exercises.append(f"{ex_id}")

        print("\n--- Equipment Tier Distribution ---")
        for tier, count in equipment_tiers.items():
            print(f"{tier}: {count}")
            
        print("\n--- Exercises with UNKNOWN Tier ---")
        if unknown_tier_exercises:
            for ex in unknown_tier_exercises:
                print(ex)
        else:
            print("None found.")
            
        print("\n--- Dumbbell Exercises (Sample 10) ---")
        for ex in dumbbell_exercises[:10]:
            print(ex)

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    analyze_exercises()

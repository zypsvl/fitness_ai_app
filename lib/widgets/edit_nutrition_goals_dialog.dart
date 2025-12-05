import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme_config.dart';

class EditNutritionGoalsDialog extends StatefulWidget {
  final int currentCalories;
  final int currentProtein;
  final int currentCarbs;
  final int currentFat;
  final Function(int calories, int protein, int carbs, int fat) onSave;

  const EditNutritionGoalsDialog({
    super.key,
    required this.currentCalories,
    required this.currentProtein,
    required this.currentCarbs,
    required this.currentFat,
    required this.onSave,
  });

  @override
  State<EditNutritionGoalsDialog> createState() => _EditNutritionGoalsDialogState();
}

class _EditNutritionGoalsDialogState extends State<EditNutritionGoalsDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;

  @override
  void initState() {
    super.initState();
    _caloriesController = TextEditingController(text: widget.currentCalories.toString());
    _proteinController = TextEditingController(text: widget.currentProtein.toString());
    _carbsController = TextEditingController(text: widget.currentCarbs.toString());
    _fatController = TextEditingController(text: widget.currentFat.toString());
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1F38),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Edit Daily Goals', style: TextStyle(color: Colors.white)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInput(_caloriesController, 'Daily Calories (kcal)', icon: Icons.local_fire_department),
              const SizedBox(height: 12),
              _buildInput(_proteinController, 'Daily Protein (g)', icon: Icons.fitness_center),
              const SizedBox(height: 12),
              _buildInput(_carbsController, 'Daily Carbs (g)', icon: Icons.bakery_dining),
              const SizedBox(height: 12),
              _buildInput(_fatController, 'Daily Fat (g)', icon: Icons.opacity),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryPurple,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Save Goals', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildInput(TextEditingController controller, String label, {required IconData icon}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: AppTheme.primaryPurple, size: 20),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final calories = int.tryParse(_caloriesController.text) ?? 2000;
      final protein = int.tryParse(_proteinController.text) ?? 150;
      final carbs = int.tryParse(_carbsController.text) ?? 200;
      final fat = int.tryParse(_fatController.text) ?? 65;

      widget.onSave(calories, protein, carbs, fat);
      Navigator.pop(context);
    }
  }
}

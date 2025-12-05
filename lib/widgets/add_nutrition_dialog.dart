import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';

class AddNutritionDialog extends StatefulWidget {
  final Function(int calories, int protein, int carbs, int fat) onAdd;

  const AddNutritionDialog({super.key, required this.onAdd});

  @override
  State<AddNutritionDialog> createState() => _AddNutritionDialogState();
}

class _AddNutritionDialogState extends State<AddNutritionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

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
    // Hardcoded strings for now, should be moved to AppStrings later
    const String title = 'Add Nutrition';
    const String add = 'Add';
    const String cancel = 'Cancel';
    const String caloriesLabel = 'Calories (kcal)';
    const String proteinLabel = 'Protein (g)';
    const String carbsLabel = 'Carbs (g)';
    const String fatLabel = 'Fat (g)';

    return AlertDialog(
      backgroundColor: const Color(0xFF1A1F38),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(title, style: TextStyle(color: Colors.white)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInput(_caloriesController, caloriesLabel, icon: Icons.local_fire_department),
              const SizedBox(height: 12),
              _buildInput(_proteinController, proteinLabel, icon: Icons.fitness_center),
              const SizedBox(height: 12),
              _buildInput(_carbsController, carbsLabel, icon: Icons.bakery_dining),
              const SizedBox(height: 12),
              _buildInput(_fatController, fatLabel, icon: Icons.opacity),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(cancel, style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryPurple,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(add, style: TextStyle(color: Colors.white)),
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
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final calories = int.tryParse(_caloriesController.text) ?? 0;
      final protein = int.tryParse(_proteinController.text) ?? 0;
      final carbs = int.tryParse(_carbsController.text) ?? 0;
      final fat = int.tryParse(_fatController.text) ?? 0;

      widget.onAdd(calories, protein, carbs, fat);
      Navigator.pop(context);
    }
  }
}

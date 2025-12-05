import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_button.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';
import 'edit_program_screen.dart';

class CreateProgramSetupScreen extends StatefulWidget {
  const CreateProgramSetupScreen({super.key});

  @override
  State<CreateProgramSetupScreen> createState() => _CreateProgramSetupScreenState();
}

class _CreateProgramSetupScreenState extends State<CreateProgramSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  double _days = 3;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createProgram() {
    final strings = AppStrings(context);
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.programNameError),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    provider.createManualProgram(_nameController.text.trim(), _days.toInt());

    // Navigate to EditProgramScreen to start adding exercises
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProgramScreen(programId: 'current'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppStrings(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.createProgramTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.designYourProgram,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate().fadeIn().slideX(begin: -0.2),
                
                const SizedBox(height: 8),
                
                Text(
                  strings.designProgramDesc,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),

                const SizedBox(height: 40),

                // Program Name Input
                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.programName,
                        style: theme.textTheme.titleMedium?.copyWith(color: Colors.white60),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: strings.programNameHint,
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.secondaryCyan),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms).scale(),

                const SizedBox(height: 24),

                // Days Selection
                GlassContainer(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 20,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            strings.weeklyTraining,
                            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white60),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: AppTheme.secondaryGradient,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: AppTheme.neonShadow(AppTheme.secondaryCyan),
                            ),
                            child: Text(
                              "${_days.toInt()} ${strings.days}",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppTheme.secondaryCyan,
                          inactiveTrackColor: Colors.white10,
                          thumbColor: AppTheme.secondaryCyan,
                          overlayColor: AppTheme.secondaryCyan.withValues(alpha: 0.2),
                          trackHeight: 6,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                        ),
                        child: Slider(
                          value: _days,
                          min: 1,
                          max: 7,
                          divisions: 6,
                          onChanged: (val) => setState(() => _days = val),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).scale(),

                const Spacer(),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  child: PremiumButton(
                    text: strings.createAndEdit,
                    gradient: AppTheme.primaryGradient,
                    onPressed: _createProgram,
                  ),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

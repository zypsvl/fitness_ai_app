import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/program_card.dart';
import '../widgets/save_program_dialog.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';
import 'onboarding_screen.dart';
import 'result_screen.dart';
import 'create_program_setup_screen.dart';

class MyProgramsScreen extends StatelessWidget {
  const MyProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context);
    final strings = AppStrings(context);
    // Show newest programs first by reversing the list
    final programs = provider.savedPrograms.reversed.toList();
    print("👀 MyProgramsScreen building. Programs count: ${programs.length}");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.myPrograms),
        centerTitle: true,
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: programs.isEmpty
              ? _buildEmptyState(context, strings)
              : _buildProgramsList(context, provider, programs, strings),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateOptions(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: AppTheme.neonShadow(AppTheme.primaryPurple, opacity: 0.5),
          ),
          child: Row(
            children: [
              const Icon(Icons.add, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                strings.newProgram,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 300.ms).scale(),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppStrings strings) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.primaryGradient.scale(0.3),
              ),
              child: Icon(
                Icons.fitness_center,
                size: 80,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ).animate().scale(duration: 600.ms),
            
            const SizedBox(height: 32),
            
            Text(
              strings.noProgramsYet,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 16),
            
            Text(
              strings.createFirstProgram,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms),
            
            const SizedBox(height: 40),
            
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.secondaryGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.neonShadow(AppTheme.secondaryCyan),
              ),
              child: ElevatedButton.icon(
                onPressed: () => _showCreateOptions(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 24),
                label: Text(
                  strings.createFirstProgram,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }

  void _showCreateOptions(BuildContext context) {
    final strings = AppStrings(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassContainer(
        borderRadius: 24,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              strings.createProgramTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            _buildOptionTile(
              context,
              icon: Icons.auto_awesome,
              title: strings.createWithAI,
              subtitle: strings.createWithAIDesc,
              color: AppTheme.primaryPurple,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildOptionTile(
              context,
              icon: Icons.edit_note,
              title: strings.createManually,
              subtitle: strings.createManuallyDesc,
              color: AppTheme.secondaryCyan,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateProgramSetupScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withValues(alpha: 0.3), size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProgramsList(
    BuildContext context,
    WorkoutProvider provider,
    List programs,
    AppStrings strings,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        GlassContainer(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppTheme.secondaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.list_alt,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.savedPrograms,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${programs.length} ${strings.programs}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: -0.2),

        // Programs List
        ...programs.asMap().entries.map((entry) {
          final index = entry.key;
          final program = entry.value;
          
          return ProgramCard(
            program: program,
            onTap: () {
              provider.loadProgramById(program.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResultScreen(),
                ),
              );
            },
            onDelete: () => _showDeleteConfirmation(context, provider, program, strings),
            onRename: () => _showRenameDialog(context, provider, program),
          ).animate().fadeIn(delay: ((index + 1) * 100).ms).slideX(begin: 0.2);
        }),
        
        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WorkoutProvider provider,
    program,
    AppStrings strings,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          padding: const EdgeInsets.all(24),
          borderRadius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              
              const SizedBox(height: 20),
              
              Text(
                strings.deleteConfirm,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                "'${program.name}'",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        strings.cancel,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade600, Colors.red.shade800],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          provider.deleteProgram(program.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          strings.delete,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    WorkoutProvider provider,
    program,
  ) async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => const SaveProgramDialog(),
    );
    
    if (newName != null && newName.isNotEmpty && context.mounted) {
      await provider.renameProgram(program.id, newName);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("'${program.name}' → '$newName'"),
            backgroundColor: AppTheme.primaryPurple,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/saved_program_model.dart';
import '../widgets/glass_container.dart';
import '../widgets/glass_card.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';

class ProgramCard extends StatelessWidget {
  final SavedProgram program;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onRename;

  const ProgramCard({
    super.key,
    required this.program,
    required this.onTap,
    required this.onDelete,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context);
    
    return GlassCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppTheme.neonShadow(
                    AppTheme.primaryPurple,
                    opacity: 0.3,
                  ),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Name and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.formatDate(program.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Actions Menu
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                color: AppTheme.surfaceDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                onSelected: (value) {
                  if (value == 'rename') {
                    onRename();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: const [
                        Icon(Icons.edit, size: 20, color: Colors.white70),
                        SizedBox(width: 12),
                        Text('Yeniden Adlandır'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: const [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Sil', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Badges
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildBadge(
                Icons.calendar_today,
                "${program.daysPerWeek} ${strings.daysCount(program.daysPerWeek)}",
                AppTheme.secondaryCyan,
              ),
              _buildBadge(
                Icons.flag,
                strings.getGoal(program.goal),
                AppTheme.primaryPurple,
              ),
              _buildBadge(
                Icons.trending_up,
                strings.getLevel(program.level),
                AppTheme.accentOrange,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Stats
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  Icons.fitness_center,
                  "${program.totalExercises}",
                  strings.exercise,
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                _buildStat(
                  Icons.location_on,
                  strings.getLocation(program.location),
                  strings.location,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryPurple, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

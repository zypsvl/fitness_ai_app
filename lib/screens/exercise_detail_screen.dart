import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/exercise_model.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(exercise.name),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Media Section (GIF or Video)
                if (exercise.hasMedia) ...[
                  _buildMediaSection(context),
                  const SizedBox(height: 24),
                ],

                // Muscles Worked Section
                _buildMusclesSection(context, strings),
                const SizedBox(height: 24),

                // Instructions Section
                if (exercise.hasInstructions) ...[
                  _buildInstructionsSection(context, strings),
                  const SizedBox(height: 24),
                ],

                // Tips Section
                if (exercise.hasTips) ...[
                  _buildTipsSection(context, strings),
                  const SizedBox(height: 24),
                ],

                // Common Mistakes Section
                if (exercise.hasCommonMistakes) ...[
                  _buildCommonMistakesSection(context, strings),
                  const SizedBox(height: 24),
                ],

                // If no content, show placeholder
                if (!exercise.hasInstructions &&
                    !exercise.hasTips &&
                    !exercise.hasCommonMistakes) ...[
                  _buildPlaceholder(context, strings),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaSection(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        children: [
          // GIF Preview
          if (exercise.gifUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: exercise.gifUrl!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 250,
                  color: Colors.white.withValues(alpha: 0.1),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 250,
                  color: Colors.white.withValues(alpha: 0.1),
                  child: const Center(
                    child: Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ] else if (exercise.videoUrl != null) ...[
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 64,
                  color: Colors.white54,
                ),
              ),
            ),
          ],

          // Watch Video Button
          if (exercise.videoUrl != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _launchVideo(exercise.videoUrl!),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Watch Video'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildMusclesSection(BuildContext context, AppStrings strings) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                strings.musclesWorked,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildMuscleItem(strings.primaryMuscle, exercise.primaryMuscle, true),
          if (exercise.secondaryMuscles.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildMuscleItem(
              strings.secondaryMuscle,
              exercise.secondaryMuscles.join(', '),
              false,
            ),
          ],
          const SizedBox(height: 12),
          _buildDifficultyBadge(),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1);
  }

  Widget _buildMuscleItem(String label, String value, bool isPrimary) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPrimary ? AppTheme.secondaryCyan : Colors.white54,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyBadge() {
    Color color;
    switch (exercise.difficulty) {
      case 1:
        color = AppTheme.neonGreen;
        break;
      case 3:
        color = Colors.redAccent; // Or a neon red if available, otherwise keep redAccent for high difficulty
        break;
      default:
        color = AppTheme.accentOrange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bar_chart, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            exercise.difficultyLabel,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection(BuildContext context, AppStrings strings) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.list_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                strings.howToDoIt,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...exercise.instructions!.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Plus Jakarta Sans', // Ensure font consistency
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1);
  }

  Widget _buildTipsSection(BuildContext context, AppStrings strings) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryCyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.secondaryCyan,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                strings.tips,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...exercise.tips!.map((tip) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.secondaryCyan,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1);
  }

  Widget _buildCommonMistakesSection(BuildContext context, AppStrings strings) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentOrange.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppTheme.accentOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                strings.commonMistakes,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...exercise.commonMistakes!.map((mistake) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.close,
                    color: AppTheme.accentOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      mistake,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1);
  }

  Widget _buildPlaceholder(BuildContext context, AppStrings strings) {
    return GlassContainer(
      padding: const EdgeInsets.all(32),
      borderRadius: 16,
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.info_outline,
              size: 64,
              color: Colors.white54,
            ),
            const SizedBox(height: 16),
            Text(
              'Detailed instructions coming soon!',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

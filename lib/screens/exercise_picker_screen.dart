import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../models/exercise_model.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';

class ExercisePickerScreen extends StatefulWidget {
  final String? targetMuscle;
  final String? currentEquipment;

  const ExercisePickerScreen({
    super.key,
    this.targetMuscle,
    this.currentEquipment,
  });

  @override
  State<ExercisePickerScreen> createState() => _ExercisePickerScreenState();
}

class _ExercisePickerScreenState extends State<ExercisePickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedMuscle;
  String? _selectedEquipment;

  @override
  void initState() {
    super.initState();
    _selectedMuscle = widget.targetMuscle;
    _selectedEquipment = widget.currentEquipment;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Exercise> _filterExercises(List<Exercise> exercises) {
    return exercises.where((exercise) {
      final matchesSearch = _searchQuery.isEmpty ||
          exercise.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          exercise.primaryMuscle.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesMuscle = _selectedMuscle == null ||
          exercise.primaryMuscle == _selectedMuscle ||
          exercise.secondaryMuscles.contains(_selectedMuscle);

      final matchesEquipment =
          _selectedEquipment == null || exercise.equipmentTier == _selectedEquipment;

      return matchesSearch && matchesMuscle && matchesEquipment;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context);
    final strings = AppStrings(context);
    final filteredExercises = _filterExercises(provider.allExercises);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.selectExercise),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  borderRadius: 16,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: strings.searchExercise,
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.search,
                        color: AppTheme.secondaryCyan,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white70),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: -0.2),
              ),

              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip(
                      strings.allMuscles,
                      _selectedMuscle == null,
                      () => setState(() => _selectedMuscle = null),
                    ),
                    _buildFilterChip(
                      strings.getMuscleName('chest'),
                      _selectedMuscle == 'chest',
                      () => setState(() => _selectedMuscle = 'chest'),
                    ),
                    _buildFilterChip(
                      strings.getMuscleName('lats'),
                      _selectedMuscle == 'lats',
                      () => setState(() => _selectedMuscle = 'lats'),
                    ),
                    _buildFilterChip(
                      strings.getMuscleName('shoulders'),
                      _selectedMuscle == 'shoulders',
                      () => setState(() => _selectedMuscle = 'shoulders'),
                    ),
                    _buildFilterChip(
                      strings.getMuscleName('quadriceps'),
                      _selectedMuscle == 'quadriceps',
                      () => setState(() => _selectedMuscle = 'quadriceps'),
                    ),
                    _buildFilterChip(
                      strings.getMuscleName('biceps'),
                      _selectedMuscle == 'biceps',
                      () => setState(() => _selectedMuscle = 'biceps'),
                    ),
                    _buildFilterChip(
                      strings.getMuscleName('triceps'),
                      _selectedMuscle == 'triceps',
                      () => setState(() => _selectedMuscle = 'triceps'),
                    ),
                  ],
                ),
              ).animate(delay: 100.ms).fadeIn().slideY(begin: -0.1),

              const SizedBox(height: 16),

              // Results count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      strings.exercisesFound(filteredExercises.length),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    if (_selectedMuscle != null || _selectedEquipment != null) ...
                      [
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedMuscle = null;
                            _selectedEquipment = null;
                          });
                        },
                        icon: const Icon(Icons.clear, size: 18),
                        label: Text(strings.clearFilters),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.secondaryCyan,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Exercise List
              Expanded(
                child: filteredExercises.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              strings.noExercisesFound,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = filteredExercises[index];
                          return _buildExerciseCard(exercise, index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected ? AppTheme.primaryGradient : null,
            color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryPurple
                  : Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise, int index) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        final strings = AppStrings(context);
        final isFav = provider.isFavorite(exercise.id);
        
        return GlassContainer(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          borderRadius: 16,
          child: InkWell(
            onTap: () {
              Navigator.pop(context, exercise);
            },
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      exercise.assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.fitness_center,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 32,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings.getMuscleName(exercise.primaryMuscle),
                        style: TextStyle(
                          color: AppTheme.secondaryCyan,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        strings.getEquipmentName(exercise.equipmentTier),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFav ? Icons.star : Icons.star_border,
                    color: isFav 
                      ? AppTheme.accentOrange 
                      : Colors.white.withValues(alpha: 0.5),
                    size: 24,
                  ),
                  onPressed: () async {
                    await provider.toggleFavorite(exercise.id);
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            !isFav ? strings.addedToFavorites : strings.removedFromFavorites,
                          ),
                          duration: const Duration(milliseconds: 1500),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ).animate(delay: (index * 50).ms).fadeIn().slideX(begin: 0.2);
      },
    );
  }
}

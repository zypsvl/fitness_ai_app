import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_button.dart';
import '../widgets/equipment_icon_card.dart';
import '../widgets/anatomical_body_selector.dart';
import '../widgets/glass_card.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';
import 'result_screen.dart';
import 'my_programs_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // User Selections
  String _genderKey = 'male';
  String _goalKey = 'loseWeight';
  String _levelKey = 'beginner';
  String _locationKey = 'gym';
  String? _equipmentKey;
  Set<String> _focusAreasKeys = {};
  double _days = 3;
  
  // Enhanced Onboarding
  Set<String> _selectedEquipment = {};
  String? _bodyType;
  String? _experience;
  Set<String> _injuries = {};

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressAnimation = Tween<double>(begin: 1/9, end: 1/9).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _updateProgress(int page) {
   setState(() {
      _currentPage = page;
      const totalPages = 9;
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: (page + 1) / totalPages,
      ).animate(
        CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
      );
      _progressController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkoutProvider>(context);
    final theme = Theme.of(context);
    final strings = AppStrings(context);
    
    final titles = [
      strings.genderQuestion,
      strings.goalQuestion,
      strings.levelQuestion,
      strings.equipmentSelectionTitle,
      strings.selectFocusAreas,
      strings.bodyTypeQuestion,
      strings.experienceQuestion,
      strings.injuryQuestion,
      strings.planDetailsTitle,
    ];

    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header & Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    GlassContainer(
                      borderRadius: 12,
                      padding: const EdgeInsets.all(8),
                      child: IconButton(
                        icon: Icon(
                          _currentPage > 0 ? Icons.arrow_back_ios_new : Icons.close,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_currentPage > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutQuart,
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progressAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: AppTheme.neonShadow(AppTheme.primaryPurple),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "${_currentPage + 1}/9",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    titles[_currentPage],
                    key: ValueKey<int>(_currentPage),
                    style: theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: _updateProgress,
                  children: [
                    _buildGenderPage(),
                    _buildGoalPage(),
                    _buildLevelPage(),
                    _buildEnhancedEquipmentPage(),
                    _buildAnatomicalFocusPage(),
                    _buildBodyTypePage(),
                    _buildExperiencePage(),
                    _buildInjuryPage(),
                    _buildDetailsPage(provider),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- PAGES ---

  Widget _buildGenderPage() {
    final strings = AppStrings(context);
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAvatarCard(strings.male, Icons.male, _genderKey == 'male', () {
            setState(() => _genderKey = 'male');
            _nextPage();
          }).animate().fadeIn(duration: 400.ms).scale(delay: 100.ms),
          const SizedBox(width: 24),
          _buildAvatarCard(strings.female, Icons.female, _genderKey == 'female', () {
            setState(() => _genderKey = 'female');
            _nextPage();
          }).animate().fadeIn(duration: 400.ms).scale(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildGoalPage() {
    final strings = AppStrings(context);
    final goals = [
      {'key': 'loseWeight', 'text': strings.loseWeight, 'icon': Icons.local_fire_department},
      {'key': 'buildMuscle', 'text': strings.buildMuscle, 'icon': Icons.fitness_center},
      {'key': 'getStronger', 'text': strings.getStronger, 'icon': Icons.flash_on},
      {'key': 'getFit', 'text': strings.getFit, 'icon': Icons.favorite},
    ];
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return _buildOptionCard(
          goal['text'] as String,
          _goalKey == goal['key'],
          () {
            setState(() => _goalKey = goal['key'] as String);
            _nextPage();
          },
          icon: goal['icon'] as IconData,
        ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.2);
      },
    );
  }

  Widget _buildLevelPage() {
    final strings = AppStrings(context);
    final levels = [
      {'key': 'beginner', 'text': strings.beginner, 'icon': Icons.star_border},
      {'key': 'intermediate', 'text': strings.intermediate, 'icon': Icons.star_half},
      {'key': 'advanced', 'text': strings.advanced, 'icon': Icons.star},
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: levels.asMap().entries.map((entry) {
            final index = entry.key;
            final level = entry.value;
            return _buildOptionCard(
              level['text'] as String,
              _levelKey == level['key'],
              () {
                setState(() => _levelKey = level['key'] as String);
                _nextPage();
              },
              icon: level['icon'] as IconData,
            ).animate().fadeIn(delay: (index * 100).ms).scale();
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDetailsPage(WorkoutProvider provider) {
    final theme = Theme.of(context);
    final strings = AppStrings(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassContainer(
            padding: const EdgeInsets.all(24),
            borderRadius: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      strings.weeklyWorkout,
                      style: theme.textTheme.titleLarge,
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
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.secondaryCyan,
                    inactiveTrackColor: Colors.white10,
                    thumbColor: Colors.white,
                    overlayColor: AppTheme.secondaryCyan.withValues(alpha: 0.2),
                    trackHeight: 8,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
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
          ).animate().fadeIn(delay: 300.ms).scale(),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: PremiumButton(
              text: strings.createProgramButton,
              isLoading: provider.isLoading,
              gradient: AppTheme.primaryGradient,
              onPressed: provider.isLoading
                  ? null
                  : () async {
                      final gender = _genderKey == 'male' ? strings.male : strings.female;
                      final goal = _getGoalText(strings);
                      final level = _getLevelText(strings);
                      final location = _locationKey == 'gym' ? strings.gym : strings.homeDumbbell;
                      
                      final result = await provider.generateWeeklyPlan(
                        gender,
                        goal,
                        level,
                        _days.toInt(),
                        location,
                        _equipmentKey,
                        _focusAreasKeys.isNotEmpty ? _focusAreasKeys.toList() : null,
                      );
                      
                      if (!mounted) return;
                      
                      if (result['success'] == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResultScreen(),
                          ),
                        );
                      } else {
                        final errorMessage = result['error'] ?? 'Bir hata oluştu';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      }
                    },
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  // --- HELPERS ---

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
    );
  }

  Widget _buildAvatarCard(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 140,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: AppTheme.glassDecoration(
          color: isSelected ? AppTheme.secondaryCyan.withValues(alpha: 0.2) : null,
          showBorder: isSelected,
        ).copyWith(
          boxShadow: isSelected ? AppTheme.neonShadow(AppTheme.secondaryCyan) : [],
          border: isSelected ? Border.all(color: AppTheme.secondaryCyan, width: 2) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 60,
              color: isSelected ? AppTheme.secondaryCyan : Colors.white54,
            ),
            const SizedBox(height: 20),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(String text, bool isSelected, VoidCallback onTap, {IconData? icon}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.glassDecoration(
          color: isSelected ? AppTheme.primaryPurple.withValues(alpha: 0.2) : null,
          showBorder: isSelected,
        ).copyWith(
          boxShadow: isSelected ? AppTheme.neonShadow(AppTheme.primaryPurple) : [],
          border: isSelected ? Border.all(color: AppTheme.primaryPurple, width: 2) : null,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? AppTheme.primaryPurple : Colors.white54,
                size: 28,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppTheme.primaryPurple),
          ],
        ),
      ),
    );
  }
  
  String _getGoalText(AppStrings strings) {
    switch (_goalKey) {
      case 'loseWeight': return strings.loseWeight;
      case 'buildMuscle': return strings.buildMuscle;
      case 'getStronger': return strings.getStronger;
      case 'getFit': return strings.getFit;
      default: return strings.loseWeight;
    }
  }
  
  String _getLevelText(AppStrings strings) {
    switch (_levelKey) {
      case 'beginner': return strings.beginner;
      case 'intermediate': return strings.intermediate;
      case 'advanced': return strings.advanced;
      default: return strings.beginner;
    }
  }
  

  
  // --- ENHANCED ONBOARDING PAGES (NEW) ---
  
  Widget _buildEnhancedEquipmentPage() {
    final strings = AppStrings(context);
    
    final equipmentOptions = [
      {'key': 'fullGym', 'label': strings.fullGym, 'desc': strings.fullGymDesc, 'icon': Icons.fitness_center},
      {'key': 'barbells', 'label': strings.barbells, 'desc': strings.barbellsDesc, 'icon': Icons.compress},
      {'key': 'dumbbells', 'label': strings.dumbbell, 'desc': strings.dumbbellDesc, 'icon': Icons.fitness_center},
      {'key': 'kettlebells', 'label': strings.kettlebells, 'desc': strings.kettlebellsDesc, 'icon': Icons.sports_gymnastics},
      {'key': 'machines', 'label': strings.machines, 'desc': strings.machinesDesc, 'icon': Icons.settings},
      {'key': 'bodyweight', 'label': strings.bodyweightOnly, 'desc': strings.bodyweightOnlyDesc, 'icon': Icons.self_improvement},
    ];
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            strings.equipmentSelectionDesc,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(),
          
          const SizedBox(height: 24),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: equipmentOptions.length,
              itemBuilder: (context, index) {
                final option = equipmentOptions[index];
                final key = option['key'] as String;
                final isSelected = _selectedEquipment.contains(key);
                
                return EquipmentIconCard(
                  label: option['label'] as String,
                  description: option['desc'] as String,
                  icon: option['icon'] as IconData,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedEquipment.remove(key);
                      } else {
                        _selectedEquipment.add(key);
                      }
                    });
                  },
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: PremiumButton(
              text: '${strings.continueButton} (${_selectedEquipment.length} ${strings.selectedCount})',
              gradient: _selectedEquipment.isNotEmpty 
                ? AppTheme.primaryGradient 
                : LinearGradient(colors: [Colors.grey.shade700, Colors.grey.shade600]),
              onPressed: _selectedEquipment.isEmpty ? null : _nextPage,
            ),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
  
  Widget _buildAnatomicalFocusPage() {
    final strings = AppStrings(context);
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            strings.selectFocusAreas,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(),
          
          const SizedBox(height: 24),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 7, // Chest, Back, Shoulders, Arms, Legs, Core, Glutes
              itemBuilder: (context, index) {
                final options = [
                  {'key': 'chest', 'label': strings.chest, 'icon': Icons.favorite},
                  {'key': 'back', 'label': strings.back, 'icon': Icons.back_hand},
                  {'key': 'shoulders', 'label': strings.shoulders, 'icon': Icons.accessibility_new},
                  {'key': 'arms', 'label': strings.arms, 'icon': Icons.fitness_center},
                  {'key': 'legs', 'label': strings.legs, 'icon': Icons.directions_run},
                  {'key': 'core', 'label': strings.core, 'icon': Icons.center_focus_strong},
                  {'key': 'glutes', 'label': strings.glutes, 'icon': Icons.sports_gymnastics},
                ];
                
                final option = options[index];
                final key = option['key'] as String;
                final label = option['label'] as String;
                final icon = option['icon'] as IconData;
                final isSelected = _focusAreasKeys.contains(key);
                
                return GlassCard(
                  isSelected: isSelected,
                  selectedColor: AppTheme.primaryPurple,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _focusAreasKeys.remove(key);
                      } else {
                        _focusAreasKeys.add(key);
                      }
                    });
                  },
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 32,
                        color: isSelected ? AppTheme.primaryPurple : Colors.white54,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: PremiumButton(
              text: _focusAreasKeys.isNotEmpty 
                ? '${strings.continueButton} (${_focusAreasKeys.length} ${strings.selectedCount})'
                : strings.continueButton,
              gradient: _focusAreasKeys.isNotEmpty 
                ? AppTheme.secondaryGradient 
                : LinearGradient(colors: [Colors.grey.shade700, Colors.grey.shade600]),
              onPressed: _focusAreasKeys.isEmpty ? null : _nextPage,
            ),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }
  
  Widget _buildBodyTypePage() {
    final strings = AppStrings(context);
    
    final bodyTypes = [
      {'key': 'ectomorph', 'label': strings.ectomorph, 'desc': strings.ectomorphDesc},
      {'key': 'mesomorph', 'label': strings.mesomorph, 'desc': strings.mesomorphDesc},
      {'key': 'endomorph', 'label': strings.endomorph, 'desc': strings.endomorphDesc},
    ];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            strings.bodyTypeOptional,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ).animate().fadeIn(),
          
          const SizedBox(height: 24),
          
          Expanded(
            child: ListView.builder(
              itemCount: bodyTypes.length,
              itemBuilder: (context, index) {
                final type = bodyTypes[index];
                final key = type['key'] as String;
                final isSelected = _bodyType == key;
                
                return GestureDetector(
                  onTap: () {
                    setState(() => _bodyType = key);
                    Future.delayed(const Duration(milliseconds: 300), _nextPage);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? AppTheme.primaryPurple.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryPurple : Colors.white.withValues(alpha: 0.1),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                type['label'] as String,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? AppTheme.primaryPurple : Colors.white,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle, color: AppTheme.primaryPurple),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          type['desc'] as String,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.2);
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _nextPage,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                strings.skipQuestion,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
  
  Widget _buildExperiencePage() {
    final strings = AppStrings(context);
    
    final experienceLevels = [
      {'key': 'newbie', 'label': strings.newbie},
      {'key': 'beginner', 'label': strings.beginnerExp},
      {'key': 'intermediate', 'label': strings.intermediateExp},
      {'key': 'advanced', 'label': strings.advancedExp},
    ];
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...experienceLevels.asMap().entries.map((entry) {
              final index = entry.key;
              final level = entry.value;
              final key = level['key'] as String;
              final isSelected = _experience == key;
              
              return GestureDetector(
                onTap: () {
                  setState(() => _experience = key);
                  Future.delayed(const Duration(milliseconds: 300), _nextPage);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? AppTheme.secondaryCyan.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppTheme.secondaryCyan : Colors.white.withValues(alpha: 0.1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        level['label'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppTheme.secondaryCyan : Colors.white,
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle, color: AppTheme.secondaryCyan),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (index * 100).ms).scale();
            }),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _nextPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  strings.skipQuestion,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ).animate().fadeIn(delay: 500.ms),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInjuryPage() {
    final strings = AppStrings(context);
    
    final injuryOptions = [
      {'key': 'back', 'label': strings.backPain},
      {'key': 'knee', 'label': strings.kneePain},
      {'key': 'shoulder', 'label': strings.shoulderPain},
      {'key': 'other', 'label': strings.otherInjury},
      {'key': 'none', 'label': strings.noInjuries},
    ];
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            strings.bodyTypeOptional,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
            ),
          ).animate().fadeIn(),
          
          const SizedBox(height: 24),
          
          Expanded(
            child: ListView.builder(
              itemCount: injuryOptions.length,
              itemBuilder: (context, index) {
                final option = injuryOptions[index];
                final key = option['key'] as String;
                final isSelected = _injuries.contains(key);
                
                // If "none" is selected, disable others
                final isDisabled = _injuries.contains('none') && key != 'none';
                
                return GestureDetector(
                  onTap: isDisabled ? null : () {
                    setState(() {
                      if (key == 'none') {
                        _injuries.clear();
                        _injuries.add('none');
                      } else {
                        _injuries.remove('none');
                        if (isSelected) {
                          _injuries.remove(key);
                        } else {
                          _injuries.add(key);
                        }
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? AppTheme.accentOrange.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppTheme.accentOrange : Colors.white.withValues(alpha: 0.1),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                          color: isSelected 
                            ? AppTheme.accentOrange 
                            : isDisabled
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option['label'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDisabled 
                                ? Colors.white.withValues(alpha: 0.3)
                                : isSelected ? AppTheme.accentOrange : Colors.white,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.2);
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: PremiumButton(
              text: strings.continueButton,
              gradient: AppTheme.primaryGradient,
              onPressed: _nextPage,
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/premium_button.dart';
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

  // User Selections - using keys instead of localized strings
  String _genderKey = 'male';  // 'male' or 'female'
  String _goalKey = 'loseWeight';  // 'loseWeight', 'buildMuscle', 'getStronger', 'getFit'
  String _levelKey = 'beginner';  // 'beginner', 'intermediate', 'advanced'
  String _locationKey = 'gym';  // 'gym' or 'home'
  double _days = 3;

  // Titles will be generated dynamically based on locale

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressAnimation = Tween<double>(begin: 0.25, end: 0.25).animate(
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
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: (page + 1) / 4,
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
      strings.planDetailsTitle,
    ];

    return Scaffold(
      body: AnimatedGradientBackground(
        colors: const [
          Color(0xFF0A0E27),
          Color(0xFF1A1F38),
          Color(0xFF0F1229),
        ],
        child: SafeArea(
          child: Column(
            children: [
              // Header & Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      GlassContainer(
                        borderRadius: 12,
                        padding: const EdgeInsets.all(4),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutQuart,
                            );
                          },
                        ),
                      )
                    else
                      GlassContainer(
                        borderRadius: 12,
                        padding: const EdgeInsets.all(4),
                        child: IconButton(
                          icon: const Icon(Icons.list_alt, size: 20),
                          tooltip: strings.myPrograms,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyProgramsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    
                    const SizedBox(width: 16),
                    
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return GlassContainer(
                            borderRadius: 10,
                            padding: const EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: _progressAnimation.value,
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        gradient: AppTheme.secondaryGradient,
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.secondaryCyan.withValues(alpha: 0.5),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "${_currentPage + 1}/4",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.only(bottom: 30, top: 20),
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
                    style: theme.textTheme.displayLarge,
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
      {'key': 'loseWeight', 'text': strings.loseWeight},
      {'key': 'buildMuscle', 'text': strings.buildMuscle},
      {'key': 'getStronger', 'text': strings.getStronger},
      {'key': 'getFit', 'text': strings.getFit},
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
        ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.2);
      },
    );
  }

  Widget _buildLevelPage() {
    final strings = AppStrings(context);
    final levels = [
      {'key': 'beginner', 'text': strings.beginner},
      {'key': 'intermediate', 'text': strings.intermediate},
      {'key': 'advanced', 'text': strings.advanced},
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
          Text(
            strings.whereToWorkout,
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white60),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSmallOption(strings.gym, Icons.fitness_center, 'gym')
                    .animate()
                    .fadeIn(delay: 100.ms)
                    .scale(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSmallOption(strings.homeDumbbell, Icons.home, 'home')
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .scale(),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      strings.weeklyWorkout,
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.white60),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: AppTheme.secondaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppTheme.glowShadow(AppTheme.secondaryCyan),
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
                      // Convert keys to localized strings for API
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
                      );
                      
                      if (!mounted) return;
                      
                      if (result['success'] == true) {
                        // Success - navigate to result screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResultScreen(),
                          ),
                        );
                      } else {
                        // Error - show error message with action
                        final errorMessage = result['error'] ?? 'Bir hata oluştu';
                        final isNetworkError = errorMessage.contains('İnternet') || 
                                             errorMessage.contains('bağlantı');
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isNetworkError ? Icons.wifi_off : Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        errorMessage,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isNetworkError) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.lightbulb_outline, 
                                             color: Colors.amber, size: 18),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'İpucu: Manuel program oluşturmayı deneyin - internet gerektirmez!',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            backgroundColor: isNetworkError 
                                ? Colors.orange.shade700 
                                : Colors.red.shade700,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.all(16),
                            duration: const Duration(seconds: 6),
                            action: isNetworkError
                                ? SnackBarAction(
                                    label: 'Manuel Oluştur',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/create-manual');
                                    },
                                  )
                                : null,
                          ),
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
    final theme = Theme.of(context);
    return GlassCard(
      isSelected: isSelected,
      selectedColor: AppTheme.secondaryCyan,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: SizedBox(
        width: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 50,
              color: isSelected ? AppTheme.secondaryCyan : Colors.white54,
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.secondaryCyan : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(String text, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GlassCard(
      isSelected: isSelected,
      selectedColor: AppTheme.primaryPurple,
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
          if (isSelected)
            Icon(Icons.check_circle, color: AppTheme.primaryPurple),
        ],
      ),
    );
  }

  Widget _buildSmallOption(String label, IconData icon, String key) {
    final theme = Theme.of(context);
    bool isSelected = _locationKey == key;
    return GlassCard(
      isSelected: isSelected,
      selectedColor: AppTheme.secondaryCyan,
      onTap: () => setState(() => _locationKey = key),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppTheme.secondaryCyan : Colors.white54,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            label.split(' ')[0],
            style: TextStyle(
              color: isSelected ? AppTheme.secondaryCyan : Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper methods to convert keys to localized text
  String _getGoalText(AppStrings strings) {
    switch (_goalKey) {
      case 'loseWeight':
        return strings.loseWeight;
      case 'buildMuscle':
        return strings.buildMuscle;
      case 'getStronger':
        return strings.getStronger;
      case 'getFit':
        return strings.getFit;
      default:
        return strings.loseWeight;
    }
  }
  
  String _getLevelText(AppStrings strings) {
    switch (_levelKey) {
      case 'beginner':
        return strings.beginner;
      case 'intermediate':
        return strings.intermediate;
      case 'advanced':
        return strings.advanced;
      default:
        return strings.beginner;
    }
  }
}

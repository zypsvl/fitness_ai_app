import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Animation Controller for progress bar
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // User Selections
  String _gender = 'Erkek';
  String _goal = 'Kilo Vermek';
  String _level = 'Başlangıç';
  String _location = 'Spor Salonu';
  double _days = 3;

  final List<String> _titles = [
    "Cinsiyetin?",
    "Hedefin Ne?",
    "Seviyen?",
    "Plan Detayları",
  ];

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

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.background,
                  const Color(0xFF1A1F38),
                  const Color(0xFF0F1229),
                ],
              ),
            ),
          ),
          
          // Decorative Circles
          // Decorative Circles
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                    blurRadius: 100,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header & Progress
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    children: [
                      if (_currentPage > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutQuart,
                            );
                          },
                        )
                      else
                        const SizedBox(width: 40), // Placeholder for alignment
                      
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _progressAnimation.value,
                                backgroundColor: Colors.white10,
                                valueColor: AlwaysStoppedAnimation(
                                  theme.colorScheme.primary,
                                ),
                                minHeight: 8,
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
                  padding: const EdgeInsets.only(bottom: 30),
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
                      _titles[_currentPage],
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
        ],
      ),
    );
  }

  // --- PAGES ---

  Widget _buildGenderPage() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildAvatarCard("Erkek", Icons.male, _gender == 'Erkek', () {
            setState(() => _gender = 'Erkek');
            _nextPage();
          }),
          const SizedBox(width: 24),
          _buildAvatarCard("Kadın", Icons.female, _gender == 'Kadın', () {
            setState(() => _gender = 'Kadın');
            _nextPage();
          }),
        ],
      ),
    );
  }

  Widget _buildGoalPage() {
    final goals = ['Kilo Vermek', 'Kas Yapmak', 'Güçlenmek', 'Fit Olmak'];
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final g = goals[index];
        return _buildOptionCard(g, _goal == g, () {
          setState(() => _goal = g);
          _nextPage();
        });
      },
    );
  }

  Widget _buildLevelPage() {
    final levels = ['Başlangıç', 'Orta', 'İleri'];
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: levels.map((l) => _buildOptionCard(l, _level == l, () {
            setState(() => _level = l);
            _nextPage();
          })).toList(),
        ),
      ),
    );
  }

  Widget _buildDetailsPage(WorkoutProvider provider) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nerede Çalışacaksın?",
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white60),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSmallOption("Spor Salonu", Icons.fitness_center),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildSmallOption("Ev (Dambıl)", Icons.home)),
            ],
          ),
          
          const SizedBox(height: 40),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Haftalık Antrenman",
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.white60),
              ),
              Text(
                "${_days.toInt()} Gün",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: theme.colorScheme.primary,
              inactiveTrackColor: Colors.white10,
              thumbColor: theme.colorScheme.primary,
              overlayColor: theme.colorScheme.primary.withValues(alpha: 0.2),
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

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: Colors.white,
                elevation: 10,
                shadowColor: theme.colorScheme.secondary.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: provider.isLoading
                  ? null
                  : () async {
                      await provider.generateWeeklyPlan(
                        _gender,
                        _goal,
                        _level,
                        _days.toInt(),
                        _location,
                      );
                      if (mounted && provider.weeklyPlan.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResultScreen(),
                          ),
                        );
                      }
                    },
              child: provider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "PROGRAMI OLUŞTUR 🚀",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
            ),
          ),
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        height: 180,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: isSelected ? theme.colorScheme.primary : Colors.white54,
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? theme.colorScheme.primary : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(String text, bool isSelected, VoidCallback onTap) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.secondary.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.secondary : Colors.transparent,
            width: 1.5,
          ),
        ),
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
              Icon(Icons.check_circle, color: theme.colorScheme.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallOption(String label, IconData icon) {
    final theme = Theme.of(context);
    bool isSelected = _location == label;
    return GestureDetector(
      onTap: () => setState(() => _location = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 90,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : Colors.white54,
            ),
            const SizedBox(height: 8),
            Text(
              label.split(' ')[0],
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

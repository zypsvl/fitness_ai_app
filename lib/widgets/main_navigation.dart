import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import '../screens/home_dashboard_screen.dart';
import '../screens/my_programs_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/social_hub_screen.dart';
import '../screens/user_profile_screen.dart';

/// Main navigation scaffold with bottom navigation bar
/// Organizes app into 5 main sections for better UX
class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  // Define all main screens
  final List<Widget> _screens = const [
    HomeDashboardScreen(),
    MyProgramsScreen(),
    StatisticsScreen(),
    SocialHubScreen(),
    UserProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      // Haptic feedback for better UX
      HapticFeedback.lightImpact();
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surfaceDark,
          selectedItemColor: AppColors.primaryPurple,
          unselectedItemColor: AppColors.textSecondaryDark,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home),
              label: 'Ana Sayfa',
              tooltip: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_rounded),
              activeIcon: Icon(Icons.fitness_center),
              label: 'Programlar',
              tooltip: 'Antrenman Programları',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              activeIcon: Icon(Icons.bar_chart),
              label: 'İstatistikler',
              tooltip: 'İstatistikler ve İlerleme',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded),
              activeIcon: Icon(Icons.people),
              label: 'Sosyal',
              tooltip: 'Arkadaşlar ve Liderlik Tablosu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
              tooltip: 'Profilim',
            ),
          ],
        ),
      ),
    );
  }
}

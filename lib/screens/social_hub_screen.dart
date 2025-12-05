import 'package:flutter/material.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/standard_card.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import 'leaderboard_screen.dart';
import 'friends_screen.dart';
import 'search_users_screen.dart';

/// Social hub combining Friends, Leaderboard, and Search
/// Organizes all social features in one place with tab navigation
class SocialHubScreen extends StatefulWidget {
  const SocialHubScreen({super.key});

  @override
  State<SocialHubScreen> createState() => _SocialHubScreenState();
}

class _SocialHubScreenState extends State<SocialHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context);

    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_rounded,
                      color: AppColors.primaryPurple,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Sosyal',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: StandardCard(
                  padding: const EdgeInsets.all(4),
                  borderRadius: 12,
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textSecondaryDark,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.people, size: 20),
                        text: 'Arkadaşlar',
                      ),
                      Tab(
                        icon: Icon(Icons.leaderboard, size: 20),
                        text: 'Liderlik',
                      ),
                      Tab(
                        icon: Icon(Icons.search, size: 20),
                        text: 'Ara',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    FriendsScreen(embeddedMode: true),
                    LeaderboardScreen(embeddedMode: true),
                    SearchUsersScreen(embeddedMode: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

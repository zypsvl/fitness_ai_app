import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';
import '../services/auth_service.dart';

class LeaderboardScreen extends StatefulWidget {
  final bool embeddedMode;
  
  const LeaderboardScreen({
    super.key,
    this.embeddedMode = false,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showGlobal = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: !widget.embeddedMode,
      appBar: widget.embeddedMode ? null : AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('🏆 Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.secondaryCyan,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'This Week'),
            Tab(text: 'This Month'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showGlobal ? Icons.public : Icons.people,
              color: AppTheme.secondaryCyan,
            ),
            onPressed: () {
              setState(() => _showGlobal = !_showGlobal);
            },
            tooltip: _showGlobal ? 'Show Friends' : 'Show Global',
          ),
        ],
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildLeaderboard('weekly'),
              _buildLeaderboard('monthly'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboard(String period) {
    final db = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: 'fitness',
    );
    return StreamBuilder<QuerySnapshot>(
      stream: db
          .collection('leaderboards')
          .doc(period)
          .collection('users')
          .orderBy('totalVolume', descending: true)
          .limit(100)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading leaderboard\n${snapshot.error}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No leaderboard data yet\nComplete workouts to rank!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;
        final currentUserId = AuthService().currentUser?.uid;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final userId = docs[index].id;
            final rank = index + 1;
            final isCurrentUser = userId == currentUserId;

            return _buildLeaderboardCard(
              rank: rank,
              userName: data['userName'] ?? 'User',
              workoutCount: data['workoutCount'] ?? 0,
              totalVolume: (data['totalVolume'] ?? 0).toDouble(),
              isCurrentUser: isCurrentUser,
              delay: index * 50,
            );
          },
        );
      },
    );
  }

  Widget _buildLeaderboardCard({
    required int rank,
    required String userName,
    required int workoutCount,
    required double totalVolume,
    required bool isCurrentUser,
    required int delay,
  }) {
    Color? rankColor;
    IconData? medal;

    if (rank == 1) {
      rankColor = const Color(0xFFFFD700);
      medal = Icons.emoji_events;
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0);
      medal = Icons.emoji_events;
    } else if (rank == 3) {
      rankColor = const Color(0xFFCD7F32);
      medal = Icons.emoji_events;
    }

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: rankColor != null
                  ? LinearGradient(
                      colors: [rankColor, rankColor.withOpacity(0.7)],
                    )
                  : null,
              color: rankColor == null ? Colors.white.withOpacity(0.1) : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: medal != null
                  ? Icon(medal, color: Colors.white, size: 28)
                  : Text(
                      '$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryCyan,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'YOU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$workoutCount workouts',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(totalVolume / 1000).toStringAsFixed(1)}K',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'kg total',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: delay.ms).fadeIn().slideX(begin: -0.2);
  }
}

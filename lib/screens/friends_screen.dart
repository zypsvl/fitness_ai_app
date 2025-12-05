import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../utils/app_strings.dart';

class FriendsScreen extends StatefulWidget {
  final bool embeddedMode;
  
  const FriendsScreen({
    super.key,
    this.embeddedMode = false,
  });

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _authService = AuthService();
  final _firestoreService = FirestoreService();

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
    final currentUserId = _authService.currentUser?.uid ?? '';
    final strings = AppStrings(context);

    return Scaffold(
      extendBodyBehindAppBar: !widget.embeddedMode,
      appBar: widget.embeddedMode ? null : AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.friendsTitle),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.secondaryCyan,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: strings.friends),
            Tab(text: strings.requests),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.pushNamed(context, '/search-users');
            },
            tooltip: strings.addFriend,
          ),
        ],
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              if (widget.embeddedMode)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: GlassContainer(
                    padding: const EdgeInsets.all(4),
                    borderRadius: 12,
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: AppTheme.primaryPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                      tabs: [
                        Tab(text: strings.friends),
                        Tab(text: strings.requests),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFriendsList(currentUserId),
                    _buildRequestsList(currentUserId),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsList(String userId) {
    final strings = AppStrings(context);
    
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getFriends(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              '${strings.error}: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.noFriendsYet,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/search-users');
                  },
                  icon: const Icon(Icons.person_add),
                  label: Text(strings.addFriends),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            // Fix: The field is 'fromUserId' (since we queried where toUserId == currentUserId)
            // or we need to handle both cases if the query changes.
            // For now, based on getFriends query:
            final friendId = (data['fromUserId'] ?? '') as String;
            
            if (friendId.isEmpty) return const SizedBox.shrink();
            // Fetch latest user data instead of relying on stored name
            return FutureBuilder<DocumentSnapshot>(
              future: _firestoreService.getUserProfile(friendId),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()));
                }
                
                final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                final name = userData?['name'] ?? strings.user;
                final username = userData?['username'] ?? '';
                
                // User wants to see username primarily
                final displayName = username.isNotEmpty ? username : name;

                return _buildFriendCard(
                  friendId: friendId,
                  friendName: displayName,
                  username: '', // Hide secondary username since it's now primary
                  onRemove: () => _removeFriend(userId, friendId),
                  delay: index * 50,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildRequestsList(String userId) {
    final strings = AppStrings(context);
    
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getFriendRequests(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  strings.noPendingRequests,
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

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final fromUserId = data['fromUserId'] as String;
            
            // Fetch latest user data
            return FutureBuilder<DocumentSnapshot>(
              future: _firestoreService.getUserProfile(fromUserId),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()));
                }

                final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                final name = userData?['name'] ?? strings.user;
                final username = userData?['username'] ?? '';
                
                // User wants to see username primarily
                final displayName = username.isNotEmpty ? username : name;

                return _buildRequestCard(
                  fromUserId: fromUserId,
                  fromUserName: displayName,
                  username: '', // Hide secondary username since it's now primary
                  onAccept: () => _acceptRequest(userId, fromUserId),
                  onReject: () => _rejectRequest(userId, fromUserId),
                  delay: index * 50,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFriendCard({
    required String friendId,
    required String friendName,
    required String username,
    required VoidCallback onRemove,
    required int delay,
  }) {
    final strings = AppStrings(context);
    
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppTheme.primaryPurple,
            child: Text(
              friendName.isNotEmpty ? friendName[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friendName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (username.isNotEmpty)
                  Text(
                    '@$username',
                    style: TextStyle(
                      color: AppTheme.secondaryCyan,
                      fontSize: 13,
                    ),
                  )
                else
                  Text(
                    strings.friend,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_remove, color: Colors.red),
            onPressed: onRemove,
            tooltip: strings.removeFriend,
          ),
        ],
      ),
    ).animate(delay: delay.ms).fadeIn().slideX(begin: -0.2);
  }

  Widget _buildRequestCard({
    required String fromUserId,
    required String fromUserName,
    required String username,
    required VoidCallback onAccept,
    required VoidCallback onReject,
    required int delay,
  }) {
    final strings = AppStrings(context);
    
    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppTheme.accentOrange,
            child: Text(
              fromUserName.isNotEmpty ? fromUserName[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fromUserName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (username.isNotEmpty)
                  Text(
                    '@$username',
                    style: TextStyle(
                      color: AppTheme.secondaryCyan,
                      fontSize: 13,
                    ),
                  )
                else
                  Text(
                    strings.friendRequest,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: onAccept,
            tooltip: strings.accept,
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: onReject,
            tooltip: strings.reject,
          ),
        ],
      ),
    ).animate(delay: delay.ms).fadeIn().slideX(begin: -0.2);
  }

  Future<void> _removeFriend(String userId, String friendId) async {
    final strings = AppStrings(context);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: Text(strings.removeFriend, style: const TextStyle(color: Colors.white)),
        content: Text(
          strings.removeFriendConfirm,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.removeFriend, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _firestoreService.removeFriend(userId, friendId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(strings.friendRemoved)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${strings.error}: $e')),
          );
        }
      }
    }
  }

  Future<void> _acceptRequest(String userId, String fromUserId) async {
    final strings = AppStrings(context);
    
    try {
      await _firestoreService.acceptFriendRequest(userId, fromUserId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(strings.friendRequestAccepted),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${strings.error}: $e')),
        );
      }
    }
  }

  Future<void> _rejectRequest(String userId, String fromUserId) async {
    final strings = AppStrings(context);
    
    try {
      await _firestoreService.rejectFriendRequest(userId, fromUserId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.requestRejected)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${strings.error}: $e')),
        );
      }
    }
  }
}

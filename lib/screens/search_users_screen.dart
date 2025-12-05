import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../utils/app_strings.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';

class SearchUsersScreen extends StatefulWidget {
  final bool embeddedMode;
  
  const SearchUsersScreen({
    super.key,
    this.embeddedMode = false,
  });

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final _searchController = TextEditingController();
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isSearching = true);

    try {
      // Remove @ if user typed it
      final searchQuery = query.startsWith('@') ? query.substring(1) : query;
      
      final db = FirebaseFirestore.instanceFor(
        app: Firebase.app(),
        databaseId: 'fitness',
      );
      final snapshot = await db
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: searchQuery.toLowerCase())
          .where('username', isLessThanOrEqualTo: '${searchQuery.toLowerCase()}\uf8ff')
          .limit(20)
          .get();

      final currentUserId = _authService.currentUser?.uid;
      
      setState(() {
        _searchResults = snapshot.docs
            .where((doc) => doc.id != currentUserId) // Exclude current user
            .map((doc) => {
                  'id': doc.id,
                  'name': doc.data()['name'] ?? 'User',
                  'username': doc.data()['username'] ?? '',
                  'email': doc.data()['email'] ?? '',
                })
            .toList();
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
      if (mounted) {
        final strings = AppStrings(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${strings.searchError}: $e')),
        );
      }
    }
  }

  Future<void> _sendFriendRequest(String toUserId, String toUserName) async {
    try {
      final currentUserId = _authService.currentUser?.uid ?? '';
      final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
      final currentUserName = userProfileProvider.profile?.name ?? 'User';

      final result = await _firestoreService.sendFriendRequest(
        currentUserId,
        currentUserName,
        toUserId,
        toUserName,
      );

      if (mounted) {
        final strings = AppStrings(context);
        
        if (result == 'accepted') {
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(strings.friendRequestAccepted),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(strings.friendRequestSent),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final strings = AppStrings(context);
        String errorMessage = '${strings.error}: $e';
        
        if (e.toString().contains('Already friends')) {
          errorMessage = strings.alreadyFriends ?? 'Already friends';
        } else if (e.toString().contains('Request already sent')) {
          errorMessage = strings.requestAlreadySent ?? 'Request already sent';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context);
    
    return Scaffold(
      extendBodyBehindAppBar: !widget.embeddedMode,
      appBar: widget.embeddedMode ? null : AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.searchUsers),
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
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: strings.searchByUsername,
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: AppTheme.secondaryCyan),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white54),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchResults = []);
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      _searchUsers(value);
                    },
                  ),
                ).animate().fadeIn().slideY(begin: -0.2),
              ),

              // Results
              if (_isSearching)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          strings.noUsersFound,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_searchResults.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 80,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          strings.searchForFriends,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      return _buildUserCard(
                        userId: user['id'],
                        userName: user['name'],
                        username: user['username'],
                        userEmail: user['email'],
                        delay: index * 50,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard({
    required String userId,
    required String userName,
    required String username,
    required String userEmail,
    required int delay,
  }) {
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
              userName[0].toUpperCase(),
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
                  userName,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                else if (userEmail.isNotEmpty)
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _sendFriendRequest(userId, userName),
            icon: const Icon(Icons.person_add, size: 18),
            label: Text(AppStrings(context).add),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: delay.ms).fadeIn().slideX(begin: -0.2);
  }
}

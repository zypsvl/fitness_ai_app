import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Firestore Database Service
/// Handles all Firestore database operations for users, workouts, friends, and leaderboards
class FirestoreService {
  // Use the 'fitness' database instead of default
  final FirebaseFirestore _db = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'fitness',
  );

  // Collection references
  CollectionReference get users => _db.collection('users');
  CollectionReference get workouts => _db.collection('workouts');
  CollectionReference get friends => _db.collection('friends');
  CollectionReference get leaderboards => _db.collection('leaderboards');
  CollectionReference get challenges => _db.collection('challenges');

  // ---------------------------------------------------
  // USER OPERATIONS
  // ---------------------------------------------------

  /// Create or update user profile
  Future<void> saveUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await users.doc(userId).set({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('✅ User profile saved: $userId');
    } catch (e) {
      print('❌ Error saving user profile: $e');
      rethrow;
    }
  }

  /// Get user profile
  Future<DocumentSnapshot> getUserProfile(String userId) async {
    try {
      return await users.doc(userId).get();
    } catch (e) {
      print('❌ Error getting user profile: $e');
      rethrow;
    }
  }

  /// Listen to user profile changes
  Stream<DocumentSnapshot> userProfileStream(String userId) {
    return users.doc(userId).snapshots();
  }

  /// Update user stats (XP, level, workouts, etc.)
  Future<void> updateUserStats(String userId, Map<String, dynamic> stats) async {
    try {
      await users.doc(userId).update(stats);
      print('✅ User stats updated: $userId');
    } catch (e) {
      print('❌ Error updating user stats: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------
  // WORKOUT OPERATIONS
  // ---------------------------------------------------

  /// Save workout session
  Future<String> saveWorkout(String userId, Map<String, dynamic> workout) async {
    try {
      final docRef = await workouts.add({
        ...workout,
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('✅ Workout saved: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error saving workout: $e');
      rethrow;
    }
  }

  /// Get user's workouts
  Future<QuerySnapshot> getUserWorkouts(String userId, {int limit = 20}) async {
    try {
      return await workouts
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();
    } catch (e) {
      print('❌ Error getting workouts: $e');
      rethrow;
    }
  }

  /// Listen to user's workouts stream
  Stream<QuerySnapshot> userWorkoutsStream(String userId) {
    return workouts
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  /// Get workout by ID
  Future<DocumentSnapshot> getWorkout(String workoutId) async {
    try {
      return await workouts.doc(workoutId).get();
    } catch (e) {
      print('❌ Error getting workout: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------
  // FRIEND OPERATIONS
  // ---------------------------------------------------

  /// Send friend request
  Future<String> sendFriendRequest(
    String fromUserId,
    String fromUserName,
    String toUserId,
    String toUserName,
  ) async {
    try {
      // 1. Check if already friends
      final friendCheck1 = await friends
          .where('fromUserId', isEqualTo: fromUserId)
          .where('toUserId', isEqualTo: toUserId)
          .where('status', isEqualTo: 'accepted')
          .get();
      
      final friendCheck2 = await friends
          .where('fromUserId', isEqualTo: toUserId)
          .where('toUserId', isEqualTo: fromUserId)
          .where('status', isEqualTo: 'accepted')
          .get();

      if (friendCheck1.docs.isNotEmpty || friendCheck2.docs.isNotEmpty) {
        throw Exception('Already friends');
      }

      // 2. Check if request already pending (from me to them)
      final pendingCheck1 = await friends
          .where('fromUserId', isEqualTo: fromUserId)
          .where('toUserId', isEqualTo: toUserId)
          .where('status', isEqualTo: 'pending')
          .get();

      if (pendingCheck1.docs.isNotEmpty) {
        throw Exception('Request already sent');
      }

      // 3. Check if request already pending (from them to me)
      final pendingCheck2 = await friends
          .where('fromUserId', isEqualTo: toUserId)
          .where('toUserId', isEqualTo: fromUserId)
          .where('status', isEqualTo: 'pending')
          .get();

      if (pendingCheck2.docs.isNotEmpty) {
        // Auto-accept if they already sent me a request
        await acceptFriendRequest(fromUserId, toUserId);
        return 'accepted';
      }

      final docRef = await friends.add({
        'fromUserId': fromUserId,
        'fromUserName': fromUserName,
        'toUserId': toUserId,
        'toUserName': toUserName,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Friend request sent: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error sending friend request: $e');
      rethrow;
    }
  }

  /// Accept friend request
  Future<void> acceptFriendRequest(String userId, String fromUserId) async {
    try {
      // Find the friend request
      final snapshot = await friends
          .where('fromUserId', isEqualTo: fromUserId)
          .where('toUserId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await friends.doc(snapshot.docs.first.id).update({
          'status': 'accepted',
          'acceptedAt': FieldValue.serverTimestamp(),
        });
        print('✅ Friend request accepted');
      }
    } catch (e) {
      print('❌ Error accepting friend request: $e');
      rethrow;
    }
  }

  /// Reject friend request
  Future<void> rejectFriendRequest(String userId, String fromUserId) async {
    try {
      // Find and delete the friend request
      final snapshot = await friends
          .where('fromUserId', isEqualTo: fromUserId)
          .where('toUserId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await friends.doc(snapshot.docs.first.id).delete();
        print('✅ Friend request rejected');
      }
    } catch (e) {
      print('❌ Error rejecting friend request: $e');
      rethrow;
    }
  }

  /// Remove friend
  Future<void> removeFriend(String userId, String friendId) async {
    try {
      // Find friendship where either user is involved
      final snapshot1 = await friends
          .where('fromUserId', isEqualTo: userId)
          .where('toUserId', isEqualTo: friendId)
          .where('status', isEqualTo: 'accepted')
          .limit(1)
          .get();

      if (snapshot1.docs.isNotEmpty) {
        await friends.doc(snapshot1.docs.first.id).delete();
        print('✅ Friend removed');
        return;
      }

      final snapshot2 = await friends
          .where('fromUserId', isEqualTo: friendId)
          .where('toUserId', isEqualTo: userId)
          .where('status', isEqualTo: 'accepted')
          .limit(1)
          .get();

      if (snapshot2.docs.isNotEmpty) {
        await friends.doc(snapshot2.docs.first.id).delete();
        print('✅ Friend removed');
      }
    } catch (e) {
      print('❌ Error removing friend: $e');
      rethrow;
    }
  }

  /// Get user's friends (stream)
  Stream<QuerySnapshot> getFriends(String userId) {
    // Return accepted friendships where user is the recipient
    return friends
        .where('toUserId', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .snapshots();
  }

  /// Get pending friend requests (stream)
  Stream<QuerySnapshot> getFriendRequests(String userId) {
    return friends
        .where('toUserId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  /// Get user's friends (future)
  Future<QuerySnapshot> getUserFriends(String userId) async {
    try {
      return await friends
          .where('toUserId', isEqualTo: userId)
          .where('status', isEqualTo: 'accepted')
          .get();
    } catch (e) {
      print('❌ Error getting friends: $e');
      rethrow;
    }
  }

  /// Get pending friend requests (future)
  Future<QuerySnapshot> getPendingFriendRequests(String userId) async {
    try {
      return await friends
          .where('toUserId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .get();
    } catch (e) {
      print('❌ Error getting friend requests: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------
  // LEADERBOARD OPERATIONS
  // ---------------------------------------------------

  /// Get weekly leaderboard
  Future<QuerySnapshot> getWeeklyLeaderboard({int limit = 50}) async {
    try {
      final week = _getCurrentWeek();
      return await leaderboards
          .doc('weekly')
          .collection(week)
          .orderBy('totalVolume', descending: true)
          .limit(limit)
          .get();
    } catch (e) {
      print('❌ Error getting weekly leaderboard: $e');
      rethrow;
    }
  }

  /// Get monthly leaderboard
  Future<QuerySnapshot> getMonthlyLeaderboard({int limit = 50}) async {
    try {
      final month = _getCurrentMonth();
      return await leaderboards
          .doc('monthly')
          .collection(month)
          .orderBy('totalVolume', descending: true)
          .limit(limit)
          .get();
    } catch (e) {
      print('❌ Error getting monthly leaderboard: $e');
      rethrow;
    }
  }

  /// Update user's leaderboard stats (called after workout)
  Future<void> updateLeaderboardStats(
    String userId,
    String userName,
    int workoutCount,
    double totalVolume,
  ) async {
    try {
      final week = _getCurrentWeek();
      final month = _getCurrentMonth();

      // Update weekly
      await leaderboards
          .doc('weekly')
          .collection(week)
          .doc(userId)
          .set({
        'userId': userId,
        'userName': userName,
        'workoutCount': FieldValue.increment(workoutCount),
        'totalVolume': FieldValue.increment(totalVolume),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update monthly
      await leaderboards
          .doc('monthly')
          .collection(month)
          .doc(userId)
          .set({
        'userId': userId,
        'userName': userName,
        'workoutCount': FieldValue.increment(workoutCount),
        'totalVolume': FieldValue.increment(totalVolume),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ Leaderboard stats updated for $userName');
    } catch (e) {
      print('❌ Error updating leaderboard: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------
  // CHALLENGE OPERATIONS
  // ---------------------------------------------------

  /// Create a challenge
  Future<String> createChallenge(Map<String, dynamic> challengeData) async {
    try {
      final docRef = await challenges.add({
        ...challengeData,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ Challenge created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error creating challenge: $e');
      rethrow;
    }
  }

  /// Get active challenges
  Future<QuerySnapshot> getActiveChallenges() async {
    try {
      final now = Timestamp.now();
      return await challenges
          .where('endDate', isGreaterThan: now)
          .orderBy('endDate')
          .get();
    } catch (e) {
      print('❌ Error getting challenges: $e');
      rethrow;
    }
  }

  /// Join a challenge
  Future<void> joinChallenge(String challengeId, String userId) async {
    try {
      await challenges.doc(challengeId).update({
        'participants': FieldValue.arrayUnion([userId]),
      });
      print('✅ Joined challenge: $challengeId');
    } catch (e) {
      print('❌ Error joining challenge: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------
  // HELPER METHODS
  // ---------------------------------------------------

  /// Get current week string (e.g., "2024-W48")
  String _getCurrentWeek() {
    final now = DateTime.now();
    final weekNumber = ((now.difference(DateTime(now.year, 1, 1)).inDays) / 7).ceil();
    return '${now.year}-W${weekNumber.toString().padLeft(2, '0')}';
  }

  /// Get current month string (e.g., "2024-12")
  String _getCurrentMonth() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }
}

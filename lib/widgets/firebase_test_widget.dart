import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

/// Simple Firebase test widget to verify connection
class FirebaseTestWidget extends StatefulWidget {
  const FirebaseTestWidget({super.key});

  @override
  State<FirebaseTestWidget> createState() => _FirebaseTestWidgetState();
}

class _FirebaseTestWidgetState extends State<FirebaseTestWidget> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  
  String _status = 'Testing Firebase...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _testFirebase();
  }

  Future<void> _testFirebase() async {
    try {
      // Test 1: Check Authentication
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        setState(() => _status = 'No user, signing in anonymously...');
        await _authService.signInAnonymously();
      }

      final userId = _authService.currentUser?.uid ?? '';
      setState(() => _status = 'User ID: ${userId.substring(0, 8)}...');

      // Test 2: Write to Firestore
      await _firestoreService.saveUserProfile(userId, {
        'name': 'Test User',
        'testField': 'Firebase is working! 🔥',
        'timestamp': DateTime.now().toIso8601String(),
      });

      setState(() => _status = 'Firestore write successful!');

      // Test 3: Read from Firestore
      final doc = await _firestoreService.getUserProfile(userId);
      if (doc.exists) {
        setState(() {
          _status = 'Firebase ✅ Working!\nUser: ${doc.get('name')}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else
            const Icon(Icons.check_circle, color: Colors.green, size: 32),
          const SizedBox(height: 8),
          Text(
            _status,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

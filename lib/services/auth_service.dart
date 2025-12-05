import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Authentication Service
/// Handles user authentication including anonymous, email/password, and account linking
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user ID (never null - creates anonymous user if needed)
  Future<String> getCurrentUserId() async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    
    // Create anonymous user if none exists
    final credential = await signInAnonymously();
    return credential?.user?.uid ?? '';
  }

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is anonymous
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  // Check if user is authenticated with email
  bool get hasEmail => _auth.currentUser?.email != null;

  /// Anonymous sign in (for new users)
  Future<UserCredential?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      print('✅ Signed in anonymously: ${credential.user?.uid}');
      return credential;
    } catch (e) {
      print('❌ Error signing in anonymously: $e');
      return null;
    }
  }

  /// Email/password registration
  Future<UserCredential?> registerWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ User registered: ${credential.user?.email}');
      return credential;
    } catch (e) {
      print('❌ Error registering: $e');
      return null;
    }
  }

  /// Email/password sign in
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ User signed in: ${credential.user?.email}');
      return credential;
    } catch (e) {
      print('❌ Error signing in: $e');
      return null;
    }
  }

  /// Link anonymous account to email/password
  Future<UserCredential?> linkAnonymousToEmail(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null || !user.isAnonymous) {
        print('❌ No anonymous user to link');
        return null;
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      final linkedCredential = await user.linkWithCredential(credential);
      print('✅ Anonymous account linked to email: $email');
      return linkedCredential;
    } catch (e) {
      print('❌ Error linking account: $e');
      return null;
    }
  }

  /// Password reset
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('✅ Password reset email sent to: $email');
      return true;
    } catch (e) {
      print('❌ Error sending password reset: $e');
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('✅ User signed out');
    } catch (e) {
      print('❌ Error signing out: $e');
    }
  }

  /// Delete current user account
  Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await user.delete();
      print('✅ User account deleted');
      return true;
    } catch (e) {
      print('❌ Error deleting account: $e');
      return false;
    }
  }

  /// Update user email
  Future<bool> updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await user.verifyBeforeUpdateEmail(newEmail);
      print('✅ Verification email sent to: $newEmail');
      return true;
    } catch (e) {
      print('❌ Error updating email: $e');
      return false;
    }
  }

  /// Update user password
  Future<bool> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await user.updatePassword(newPassword);
      print('✅ Password updated');
      return true;
    } catch (e) {
      print('❌ Error updating password: $e');
      return false;
    }
  }
}

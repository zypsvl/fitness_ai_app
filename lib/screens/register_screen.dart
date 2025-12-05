import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../utils/app_strings.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _linkAnonymous = false;

  @override
  void initState() {
    super.initState();
    _checkAnonymousUser();
  }

  void _checkAnonymousUser() {
    final authService = AuthService();
    if (authService.currentUser != null && authService.isAnonymous) {
      setState(() => _linkAnonymous = true);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> _checkUsernameAvailability(String username) async {
    try {
      final db = FirebaseFirestore.instanceFor(
        app: Firebase.app(),
        databaseId: 'fitness',
      );
      final snapshot = await db
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .limit(1)
          .get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Check username availability
    final usernameAvailable = await _checkUsernameAvailability(_usernameController.text.trim());
    if (!usernameAvailable) {
      setState(() => _isLoading = false);
      if (mounted) {
        final strings = AppStrings(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(strings.usernameAlreadyTaken),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final authService = AuthService();
    dynamic result;

    if (_linkAnonymous && authService.isAnonymous) {
      result = await authService.linkAnonymousToEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } else {
      result = await authService.registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }

    // Save username to Firestore
    if (result != null && mounted) {
      try {
        final userId = authService.currentUser?.uid;
        if (userId != null) {
          final db = FirebaseFirestore.instanceFor(
            app: Firebase.app(),
            databaseId: 'fitness',
          );
          await db.collection('users').doc(userId).set({
            'username': _usernameController.text.trim().toLowerCase(),
            'name': _emailController.text.split('@')[0],
            'email': _emailController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      } catch (e) {
        print('Error saving username: $e');
      }
    }

    if (mounted) {
      final strings = AppStrings(context);
      setState(() => _isLoading = false);

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_linkAnonymous 
              ? strings.registerSuccessDataSaved 
              : strings.registerSuccess),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(strings.registerFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.register),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.primaryGradient,
                      ),
                      child: const Icon(
                        Icons.person_add,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Title
                    Text(
                      strings.createAccount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    if (_linkAnonymous)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.accentOrange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.accentOrange),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: AppTheme.accentOrange),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                strings.guestAccountLinking,
                                style: TextStyle(color: Colors.white.withOpacity(0.9)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 32),

                    // Email Field
                    GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      borderRadius: 16,
                      child: TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: strings.emailHint,
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                          icon: Icon(Icons.email, color: AppTheme.secondaryCyan),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return strings.emailRequired;
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return strings.emailInvalid;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Username Field
                    GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      borderRadius: 16,
                      child: TextFormField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: strings.usernameHint,
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                          icon: Icon(Icons.alternate_email, color: AppTheme.secondaryCyan),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return strings.usernameRequired;
                          }
                          if (value.length < 3) {
                            return strings.usernameMinLength;
                          }
                          if (value.length > 20) {
                            return strings.usernameMaxLength;
                          }
                          if (!RegExp(r'^[a-z0-9_]+$').hasMatch(value)) {
                            return strings.usernameFormat;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      borderRadius: 16,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: strings.passwordHint,
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                          icon: Icon(Icons.lock, color: AppTheme.secondaryCyan),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return strings.passwordRequired;
                          }
                          if (value.length < 6) {
                            return strings.passwordMinLength;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Field
                    GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      borderRadius: 16,
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: strings.confirmPassword,
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                          icon: Icon(Icons.lock_outline, color: AppTheme.secondaryCyan),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            onPressed: () {
                              setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return strings.confirmPasswordRequired;
                          }
                          if (value != _passwordController.text) {
                            return strings.passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                _linkAnonymous ? strings.saveGuestAccount : strings.register,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Login Link
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        strings.alreadyHaveAccount,
                        style: TextStyle(
                          color: AppTheme.secondaryCyan,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                
                // App Logo/Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryPurple.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    size: 60,
                    color: Colors.white,
                  ),
                ).animate().scale(delay: 200.ms, duration: 600.ms),
                
                const SizedBox(height: 40),
                
                // App Name
                const Text(
                  'GymGenius',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
                
                const SizedBox(height: 16),
                
                // Tagline
                Text(
                  'AI-Powered Fitness Coaching',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ).animate().fadeIn(delay: 600.ms),
                
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'Transform your body, elevate your mind',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.secondaryCyan,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate().fadeIn(delay: 800.ms),
                
                const SizedBox(height: 48),
                
                // Features
                _buildFeature(
                  icon: Icons.psychology,
                  text: 'AI-Generated Workout Plans',
                  delay: 1000,
                ),
                const SizedBox(height: 16),
                _buildFeature(
                  icon: Icons.trending_up,
                  text: 'Track Your Progress',
                  delay: 1100,
                ),
                const SizedBox(height: 16),
                _buildFeature(
                  icon: Icons.emoji_events,
                  text: 'Achieve Your Goals',
                  delay: 1200,
                ),
                
                const SizedBox(height: 48),
                
                // Continue with Google (placeholder for now)
                GlassContainer(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  borderRadius: 16,
                  child: InkWell(
                    onTap: () {
                      // TODO: Google Sign-In
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google Sign-In coming soon!')),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.g_mobiledata, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate(delay: 1300.ms).fadeIn().slideY(begin: 0.2),
                
                // Continue with Email
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Continue with Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ).animate(delay: 1400.ms).fadeIn().slideY(begin: 0.2),
                
                // Already have account
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Already have an account? Sign In',
                    style: TextStyle(
                      color: AppTheme.secondaryCyan,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ).animate(delay: 1500.ms).fadeIn(),
                
                const SizedBox(height: 8),
                
                // Skip / Try Free
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text(
                    'Try Free Without Account',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ).animate(delay: 1600.ms).fadeIn(),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String text,
    required int delay,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ).animate(delay: delay.ms).fadeIn().slideX(begin: -0.2);
  }
}

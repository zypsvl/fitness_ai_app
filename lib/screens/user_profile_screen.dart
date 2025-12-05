import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/body_metrics_calculator_widget.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';
import '../services/auth_service.dart';
import 'settings_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() {
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    final profile = provider.profile;

    if (profile != null) {
      _nameController.text = profile.name;
      _ageController.text = profile.age?.toString() ?? '';
      _heightController.text = profile.height?.toString() ?? '';
      _targetWeightController.text = profile.targetWeight?.toString() ?? '';
      _selectedGender = profile.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    final strings = AppStrings(context);

    await provider.updateProfile(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text),
      gender: _selectedGender,
      height: double.tryParse(_heightController.text),
      targetWeight: double.tryParse(_targetWeightController.text),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.profileUpdated),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<Map<String, dynamic>> _getAccountInfo() async {
    final authService = AuthService();
    final user = authService.currentUser;
    
    return {
      'isAnonymous': authService.isAnonymous,
      'email': user?.email ?? 'Misafir Kullanıcı',
    };
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context);
    final strings = AppStrings(context);
    final currentBMI = provider.getCurrentBMI();
    final bmiCategoryRaw = provider.getBMICategory();
    
    // Localize BMI category
    String bmiCategory;
    if (bmiCategoryRaw.contains('Bilinmiyor') || bmiCategoryRaw.contains('Unknown')) {
      bmiCategory = strings.unknown;
    } else if (bmiCategoryRaw.contains('Zayıf') || bmiCategoryRaw.contains('Underweight')) {
      bmiCategory = strings.underweight;
    } else if (bmiCategoryRaw.contains('Normal')) {
      bmiCategory = strings.normal;
    } else if (bmiCategoryRaw.contains('Fazla') || bmiCategoryRaw.contains('Overweight')) {
      bmiCategory = strings.overweight;
    } else if (bmiCategoryRaw.contains('Obez') || bmiCategoryRaw.contains('Obese')) {
      bmiCategory = strings.obese;
    } else {
      bmiCategory = bmiCategoryRaw;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Avatar
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.primaryGradient,
                        boxShadow: AppTheme.neonShadow(
                          AppTheme.primaryPurple,
                          opacity: 0.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                  ),
                  const SizedBox(height: 32),

                  // Account Section
                  GlassContainer(
                    padding: const EdgeInsets.all(20),
                    borderRadius: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_circle, color: AppTheme.secondaryCyan, size: 24),
                            const SizedBox(width: 12),
                            const Text(
                              'Hesap Bilgileri',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder(
                          future: _getAccountInfo(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            
                            final accountInfo = snapshot.data as Map<String, dynamic>? ?? {};
                            final isAnonymous = accountInfo['isAnonymous'] ?? true;
                            final email = accountInfo['email'] ?? 'Misafir Kullanıcı';
                            
                            return Column(
                              children: [
                                // Email/Status
                                Row(
                                  children: [
                                    Icon(
                                      isAnonymous ? Icons.person_outline : Icons.email,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        email,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    if (isAnonymous)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.accentOrange.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppTheme.accentOrange),
                                        ),
                                        child: const Text(
                                          'Misafir',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Action Buttons
                                if (isAnonymous) ...[ 
                                  // Upgrade to Email Account
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/register');
                                      },
                                      icon: const Icon(Icons.upgrade, color: Colors.white),
                                      label: const Text(
                                        'Hesap Oluştur',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryPurple,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  // Logout Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: () async {
                                        final confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: const Color(0xFF1E1E2E),
                                            title: const Text(
                                              'Çıkış Yap',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            content: const Text(
                                              'Çıkış yapmak istediğinizden emin misiniz?',
                                              style: TextStyle(color: Colors.white70),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, false),
                                                child: const Text('İptal'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, true),
                                                child: const Text(
                                                  'Çıkış Yap',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        
                                        if (confirmed == true && mounted) {
                                          await AuthService().signOut();
                                          if (mounted) {
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/welcome',
                                              (route) => false,
                                            );
                                          }
                                        }
                                      },
                                      icon: const Icon(Icons.logout, color: Colors.red),
                                      label: const Text(
                                        'Çıkış Yap',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.red),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ).animate(delay: 50.ms).fadeIn().slideY(begin: -0.2),
                  const SizedBox(height: 24),

                  // Name Field
                  Text(
                    strings.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    borderRadius: 16,
                    child: TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: strings.yourName,
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return strings.nameRequired;
                        }
                        return null;
                      },
                    ),
                  ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.2),
                  const SizedBox(height: 20),

                  // Gender Selection
                  Text(
                    strings.gender,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGenderButton(strings.male, 'Male'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGenderButton(strings.female, 'Female'),
                      ),
                    ],
                  ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.2),
                  const SizedBox(height: 20),

                  // Age Field
                  Text(
                    strings.age,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    borderRadius: 16,
                    child: TextFormField(
                      controller: _ageController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: strings.yourAge,
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        suffixText: strings.years,
                        suffixStyle: const TextStyle(color: Colors.white54),
                      ),
                    ),
                  ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.2),
                  const SizedBox(height: 20),

                  // Height Field
                  Text(
                    strings.height,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    borderRadius: 16,
                    child: TextFormField(
                      controller: _heightController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: strings.yourHeight,
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        suffixText: strings.cm,
                        suffixStyle: const TextStyle(color: Colors.white54),
                      ),
                    ),
                  ).animate(delay: 400.ms).fadeIn().slideX(begin: -0.2),
                  const SizedBox(height: 20),

                  // Target Weight Field
                  Text(
                    strings.targetWeight,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GlassContainer(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    borderRadius: 16,
                    child: TextFormField(
                      controller: _targetWeightController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: strings.yourTargetWeight,
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        suffixText: strings.kg,
                        suffixStyle: const TextStyle(color: Colors.white54),
                      ),
                    ),
                  ).animate(delay: 500.ms).fadeIn().slideX(begin: -0.2),
                  const SizedBox(height: 32),

                  // BMI Information
                  if (currentBMI != null) ...[
                    GlassContainer(
                      padding: const EdgeInsets.all(20),
                      borderRadius: 20,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                strings.bmi,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  bmiCategory,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            currentBMI.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ).animate(delay: 600.ms).fadeIn().scale(),
                    const SizedBox(height: 24),
                  ],

                  // Body Metrics Calculator
                  Text(
                    strings.bodyMetricsCalculator,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate(delay: 650.ms).fadeIn(),
                  const SizedBox(height: 12),
                  BodyMetricsCalculatorWidget(
                    gender: _selectedGender ?? 'Male',
                  ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            strings.save,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate(delay: 700.ms).fadeIn().slideY(begin: 0.2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String label, String value) {
    final isSelected = _selectedGender == value || _selectedGender == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.secondaryCyan
                : Colors.white.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              value == 'Male' ? Icons.male : Icons.female,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

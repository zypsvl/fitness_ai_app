import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_config.dart';
import '../widgets/glass_container.dart';
import '../utils/app_strings.dart';

class RestTimerBottomSheet extends StatefulWidget {
  final VoidCallback? onSkip;
  final Function(int)? onStartTimer;

  const RestTimerBottomSheet({
    super.key,
    this.onSkip,
    this.onStartTimer,
  });

  @override
  State<RestTimerBottomSheet> createState() => _RestTimerBottomSheetState();
}

class _RestTimerBottomSheetState extends State<RestTimerBottomSheet> {
  static const List<int> presetDurations = [30, 60, 90, 120];
  int _selectedDuration = 90; // Default 90 seconds
  bool _isCustom = false;

  @override
  void initState() {
    super.initState();
    _loadLastUsedDuration();
  }

  Future<void> _loadLastUsedDuration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastDuration = prefs.getInt('lastRestDuration') ?? 90;
      setState(() {
        _selectedDuration = lastDuration;
        _isCustom = !presetDurations.contains(lastDuration);
      });
    } catch (e) {
      // If loading fails, use default
    }
  }

  Future<void> _savePreference(int duration) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('lastRestDuration', duration);
    } catch (e) {
      // Silently fail if save doesn't work
    }
  }

  void _handleStartRest() {
    _savePreference(_selectedDuration);
    widget.onStartTimer?.call(_selectedDuration);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context);

    return SafeArea(
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        borderRadius: 24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ).animate().fadeIn(),

            // Title
            Text(
              strings.selectRestDuration,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn().slideY(begin: -0.1),

            const SizedBox(height: 24),

            // Preset duration buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ...presetDurations.map((duration) {
                  final isSelected = _selectedDuration == duration && !_isCustom;
                  return _buildDurationButton(
                    duration: duration,
                    label: '${duration}${strings.seconds.substring(0, 1)}',
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedDuration = duration;
                        _isCustom = false;
                      });
                    },
                  );
                }),
                
                // Custom button
                _buildDurationButton(
                  duration: _selectedDuration,
                  label: strings.customDuration,
                  isSelected: _isCustom,
                  onTap: () {
                    _showCustomDurationPicker(context, strings);
                  },
                ),
              ],
            ).animate(delay: 100.ms).fadeIn().scale(),

            const SizedBox(height: 32),

            // Selected duration display
            if (_selectedDuration > 0) ...[ Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.neonShadow(AppTheme.primaryPurple, opacity: 0.3),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedDuration} ${strings.seconds}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 200.ms).fadeIn().scale(),
              
              const SizedBox(height: 24),
            ],

            // Action buttons
            Row(
              children: [
                // Skip button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSkip?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.white54, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      strings.skipRest,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Start rest button
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleStartRest();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.secondaryCyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      strings.startRest,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationButton({
    required int duration,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.secondaryCyan
                : Colors.white.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: isSelected
              ? AppTheme.neonShadow(AppTheme.primaryPurple, opacity: 0.4)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showCustomDurationPicker(BuildContext context, AppStrings strings) {
    int customSeconds = _selectedDuration;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          strings.customDuration,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${strings.seconds}:',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (customSeconds > 15) {
                      setState(() {
                        customSeconds -= 15;
                      });
                    (context as Element).markNeedsBuild();
                    }
                  },
                  icon: const Icon(Icons.remove_circle, color: Colors.white),
                  iconSize: 32,
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$customSeconds',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    if (customSeconds < 300) {
                      setState(() {
                        customSeconds += 15;
                      });
                      (context as Element).markNeedsBuild();
                    }
                  },
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                  iconSize: 32,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(strings.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedDuration = customSeconds;
                _isCustom = true;
              });
              Navigator.pop(context);
            },
            child: Text(
              strings.save,
              style: const TextStyle(color: AppTheme.secondaryCyan),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to show the bottom sheet
Future<void> showRestTimerBottomSheet({
  required BuildContext context,
  VoidCallback? onSkip,
  Function(int)? onStartTimer,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => RestTimerBottomSheet(
      onSkip: onSkip,
      onStartTimer: onStartTimer,
    ),
  );
}

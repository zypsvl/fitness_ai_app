import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme_config.dart';
import '../services/notification_service.dart';
import '../utils/app_strings.dart';

class RestTimerWidget extends StatefulWidget {
  final int durationSeconds;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  const RestTimerWidget({
    super.key,
    this.durationSeconds = 90,
    this.onComplete,
    this.onSkip,
  });

  @override
  State<RestTimerWidget> createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends State<RestTimerWidget> {
  late int _remainingSeconds;
  late int _originalDuration;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
    _originalDuration = widget.durationSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        
        // Vibrate at 10 seconds and completion
        if (_remainingSeconds == 10 || _remainingSeconds == 0) {
          HapticFeedback.mediumImpact();
        }
      } else {
        _timer?.cancel();
        setState(() {
          _isRunning = false;
        });
        // Send notification when timer completes
        NotificationService().showRestTimerComplete();
        widget.onComplete?.call();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resumeTimer() {
    _startTimer();
  }

  void _skipTimer() {
    _timer?.cancel();
    widget.onSkip?.call();
  }

  void _addTime() {
    setState(() {
      _remainingSeconds += 15;
      _originalDuration += 15;
    });
    HapticFeedback.lightImpact();
  }

  void _removeTime() {
    if (_remainingSeconds > 15) {
      setState(() {
        _remainingSeconds -= 15;
        _originalDuration -= 15;
      });
      HapticFeedback.lightImpact();
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1.0 - (_remainingSeconds / _originalDuration);
    final strings = AppStrings(context);
    final isWarning = _remainingSeconds <= 10 && _remainingSeconds > 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isWarning 
            ? LinearGradient(
                colors: [AppTheme.accentOrange, AppTheme.primaryPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.neonShadow(
          isWarning ? AppTheme.accentOrange : AppTheme.primaryPurple,
          opacity: 0.4,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timer Icon
          Icon(
            Icons.timer,
            color: Colors.white,
            size: 32,
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).scale(
            duration: isWarning ? 500.ms : 1000.ms,
            begin: const Offset(1, 1),
            end: const Offset(1.1, 1.1),
          ),

          const SizedBox(height: 12),

          // Rest label
          Text(
            strings.restTimer.toUpperCase(),
            style: const TextStyle(
              color: Colors.white70,
              letterSpacing: 2,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Circular Progress
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isWarning ? AppTheme.accentOrange : AppTheme.secondaryCyan,
                  ),
                ),
              ),
              Text(
                _formatTime(_remainingSeconds),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ).animate().fadeIn().scale(delay: 100.ms),

          const SizedBox(height: 20),

          // Quick adjust buttons (+15/-15)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _remainingSeconds > 15 ? _removeTime : null,
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.white,
                iconSize: 28,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                strings.removeTime,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 24),
              Text(
                strings.addTime,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addTime,
                icon: const Icon(Icons.add_circle_outline),
                color: Colors.white,
                iconSize: 28,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pause/Resume button
              IconButton(
                onPressed: _isRunning ? _pauseTimer : _resumeTimer,
                icon: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 28,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  padding: const EdgeInsets.all(12),
                ),
              ),

              const SizedBox(width: 16),

              // Skip button
              ElevatedButton.icon(
                onPressed: _skipTimer,
                icon: const Icon(Icons.skip_next, color: Colors.white),
                label: Text(
                  strings.skip,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryCyan,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }
}

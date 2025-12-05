import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/personal_record_model.dart';
import '../theme_config.dart';

class PRBadgeWidget extends StatelessWidget {
  final PersonalRecord? personalRecord;
  final bool isNewPR;
  final bool compact;

  const PRBadgeWidget({
    super.key,
    this.personalRecord,
    this.isNewPR = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (personalRecord == null && !isNewPR) {
      return const SizedBox.shrink();
    }

    if (compact) {
      return _buildCompactView();
    }

    return _buildFullView(context);
  }

  Widget _buildCompactView() {
    if (personalRecord == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accentOrange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.accentOrange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events,
            size: 14,
            color: AppTheme.accentOrange,
          ),
          const SizedBox(width: 4),
          Text(
            '${personalRecord!.maxWeight}kg × ${personalRecord!.maxReps}',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.accentOrange.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isNewPR
              ? [
                  AppTheme.accentOrange.withOpacity(0.3),
                  AppTheme.accentYellow.withOpacity(0.2),
                ]
              : [
                  AppTheme.primaryPurple.withOpacity(0.2),
                  AppTheme.primaryPink.withOpacity(0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNewPR
              ? AppTheme.accentOrange.withOpacity(0.4)
              : AppTheme.primaryPurple.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Trophy icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isNewPR
                  ? AppTheme.accentOrange.withOpacity(0.3)
                  : AppTheme.primaryPurple.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isNewPR ? Icons.star : Icons.emoji_events,
              color: isNewPR ? AppTheme.accentYellow : AppTheme.accentOrange,
              size: 24,
            ),
          ).animate(
            onPlay: isNewPR ? (controller) => controller.repeat() : null,
          ).rotate(
            duration: 2.seconds,
            begin: 0,
            end: isNewPR ? 1 : 0,
          ),
          
          const SizedBox(width: 12),
          
          // PR info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNewPR)
                  Text(
                    '🎉 NEW PERSONAL RECORD!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentYellow,
                      letterSpacing: 0.5,
                    ),
                  ).animate().fadeIn(duration: 300.ms).shake(),
                
                if (!isNewPR && personalRecord != null) ...[
                  Text(
                    'Personal Record',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                
                if (personalRecord != null)
                  Text(
                    '${personalRecord!.maxWeight}kg × ${personalRecord!.maxReps} reps',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                
                if (personalRecord != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(personalRecord!.achievedDate),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? "week" : "weeks"} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? "month" : "months"} ago';
    }
  }
}

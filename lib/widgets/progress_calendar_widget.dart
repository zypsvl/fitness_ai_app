import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme_config.dart';

/// Calendar widget showing workout completion for the month
class ProgressCalendarWidget extends StatelessWidget {
  final Map<DateTime, bool> completedDays; // date -> completed
  final DateTime currentMonth;

  const ProgressCalendarWidget({
    super.key,
    required this.completedDays,
    required this.currentMonth,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Monday, 7 = Sunday

    return Column(
      children: [
        // Month/Year header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            _getMonthName(currentMonth.month),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        // Weekday labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['P', 'S', 'Ç', 'P', 'C', 'C', 'P'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 8),

        // Calendar grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: 42, // 6 weeks max
          itemBuilder: (context, index) {
            // Calculate day number
            final dayOffset = index - (firstWeekday - 1);
            final dayNumber = dayOffset + 1;

            // Check if this cell is in current month
            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const SizedBox.shrink();
            }

            // Check if workout was completed on this day
            final date = DateTime(currentMonth.year, currentMonth.month, dayNumber);
            final isCompleted = completedDays[_normalizeDate(date)] ?? false;
            final isToday = _isToday(date);

            return _buildDayCell(dayNumber, isCompleted, isToday);
          },
        ),
      ],
    );
  }

  Widget _buildDayCell(int day, bool isCompleted, bool isToday) {
    return Container(
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.secondaryCyan.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: AppTheme.primaryPurple, width: 2)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            '$day',
            style: TextStyle(
              color: isCompleted ? Colors.white : Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isCompleted)
            Positioned(
              top: 4,
              right: 4,
              child: Icon(
                Icons.check_circle,
                color: AppTheme.secondaryCyan,
                size: 12,
              ),
            ),
        ],
      ),
    ).animate(delay: (day * 20).ms).fadeIn().scale();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _getMonthName(int month) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return months[month - 1];
  }
}

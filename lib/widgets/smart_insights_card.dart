import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme_config.dart';
import 'glass_container.dart';

class SmartInsightsCard extends StatelessWidget {
  final List<String> insights;

  const SmartInsightsCard({
    super.key,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryCyan.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.secondaryCyan,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Smart Insights',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...insights.map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, size: 6, color: Colors.white54),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    insight,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }
}

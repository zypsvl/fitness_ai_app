import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme_config.dart';

class VolumeChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const VolumeChartWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Find min and max Y for scaling
    double maxY = 0;
    for (var point in data) {
      if (point['y'] > maxY) maxY = point['y'];
    }
    // Add some padding to top
    maxY = maxY * 1.2;
    if (maxY == 0) maxY = 100;

    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: maxY / 5,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white.withValues(alpha: 0.1),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < data.length) {
                      // Show every 2nd or 3rd label if too many
                      if (data.length > 8 && index % 2 != 0) return const SizedBox.shrink();
                      
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          (index + 1).toString(), // Just show week number
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: maxY / 5,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      _formatVolume(value),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.left,
                    );
                  },
                  reservedSize: 42,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            minX: 0,
            maxX: (data.length - 1).toDouble(),
            minY: 0,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                spots: data.map((point) {
                  return FlSpot(
                    (point['x'] as int).toDouble(),
                    point['y'] as double,
                  );
                }).toList(),
                isCurved: true,
                gradient: AppTheme.primaryGradient,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryPurple.withValues(alpha: 0.3),
                      AppTheme.primaryPurple.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatVolume(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toInt().toString();
  }
}

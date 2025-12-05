import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/body_measurement_model.dart';
import '../theme_config.dart';

class WeightChartWidget extends StatelessWidget {
  final List<BodyMeasurement> measurements;
  final double? targetWeight;

  const WeightChartWidget({
    super.key,
    required this.measurements,
    this.targetWeight,
  });

  @override
  Widget build(BuildContext context) {
    if (measurements.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text(
            'Henüz kilo verisi yok',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Prepare data points
    final sortedMeasurements = List<BodyMeasurement>.from(measurements)
      ..sort((a, b) => a.date.compareTo(b.date));

    final spots = <FlSpot>[];
    for (int i = 0; i < sortedMeasurements.length; i++) {
      spots.add(FlSpot(i.toDouble(), sortedMeasurements[i].weight));
    }

    // Calculate min/max for Y axis
    final weights = sortedMeasurements.map((m) => m.weight).toList();
    final minWeight = weights.reduce((a, b) => a < b ? a : b);
    final maxWeight = weights.reduce((a, b) => a > b ? a : b);
    final yMargin = (maxWeight - minWeight) * 0.1 + 2;

    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 2,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= sortedMeasurements.length) {
                      return const Text('');
                    }
                    final date = sortedMeasurements[index].date;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${date.day}/${date.month}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()} kg',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: AppTheme.primaryPurple.withValues(alpha: 0.1),
              ),
            ),
            minX: 0,
            maxX: (sortedMeasurements.length - 1).toDouble(),
            minY: minWeight - yMargin,
            maxY: maxWeight + yMargin,
            lineBarsData: [
              // Actual weight line
              LineChartBarData(
                spots: spots,
                isCurved: true,
                gradient: AppTheme.primaryGradient,
                barWidth: 3,
                isStrokeCapRound: true,
                shadow: Shadow(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: AppTheme.secondaryCyan,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryPurple.withValues(alpha: 0.3),
                      AppTheme.secondaryCyan.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Target weight line (if provided)
              if (targetWeight != null)
                LineChartBarData(
                  spots: [
                    FlSpot(0, targetWeight!),
                    FlSpot((sortedMeasurements.length - 1).toDouble(), targetWeight!),
                  ],
                  isCurved: false,
                  color: AppTheme.accentOrange.withValues(alpha: 0.5),
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dashArray: [5, 5],
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => AppTheme.primaryPurple,
                tooltipRoundedRadius: 8,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final index = spot.x.toInt();
                    if (index < 0 || index >= sortedMeasurements.length) {
                      return null;
                    }
                    final measurement = sortedMeasurements[index];
                    return LineTooltipItem(
                      '${measurement.weight.toStringAsFixed(1)} kg\n${measurement.date.day}/${measurement.date.month}/${measurement.date.year}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

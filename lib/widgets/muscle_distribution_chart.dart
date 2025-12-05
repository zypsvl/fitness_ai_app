import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme_config.dart';

class MuscleDistributionChartWidget extends StatefulWidget {
  final Map<String, double> data;

  const MuscleDistributionChartWidget({
    super.key,
    required this.data,
  });

  @override
  State<MuscleDistributionChartWidget> createState() => _MuscleDistributionChartWidgetState();
}

class _MuscleDistributionChartWidgetState extends State<MuscleDistributionChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final List<Color> colors = [
      AppTheme.primaryPurple,
      AppTheme.secondaryCyan,
      AppTheme.accentOrange,
      AppTheme.neonGreen,
      Colors.pinkAccent,
      Colors.amber,
      Colors.blueAccent,
    ];

    return AspectRatio(
      aspectRatio: 1.3,
      child: Row(
        children: [
          const SizedBox(height: 18),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: _showingSections(colors),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildIndicators(colors),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(List<Color> colors) {
    final List<MapEntry<String, double>> entries = widget.data.entries.toList();
    
    return List.generate(entries.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final entry = entries[i];
      final color = colors[i % colors.length];

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${entry.value.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    });
  }

  List<Widget> _buildIndicators(List<Color> colors) {
    final List<MapEntry<String, double>> entries = widget.data.entries.toList();
    
    return List.generate(entries.length, (i) {
      final entry = entries[i];
      final color = colors[i % colors.length];
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              entry.key,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: touchedIndex == i ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      );
    });
  }
}

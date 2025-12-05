import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/body_metrics_model.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';
import 'glass_container.dart';

class BodyMetricsCalculatorWidget extends StatefulWidget {
  final String gender;
  final Function(BodyMetrics)? onCalculated;

  const BodyMetricsCalculatorWidget({
    super.key,
    required this.gender,
    this.onCalculated,
  });

  @override
  State<BodyMetricsCalculatorWidget> createState() => _BodyMetricsCalculatorWidgetState();
}

class _BodyMetricsCalculatorWidgetState extends State<BodyMetricsCalculatorWidget> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _neckController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipController = TextEditingController();

  BodyMetrics? _calculatedMetrics;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _neckController.dispose();
    _waistController.dispose();
    _hipController.dispose();
    super.dispose();
  }

  void _calculateMetrics() {
    if (!_formKey.currentState!.validate()) return;

    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    
    if (height == null || weight == null) return;

    final metrics = BodyMetrics(
      height: height,
      weight: weight,
      gender: widget.gender,
      neck: double.tryParse(_neckController.text),
      waist: double.tryParse(_waistController.text),
      hip: double.tryParse(_hipController.text),
    );

    setState(() {
      _calculatedMetrics = metrics;
    });

    widget.onCalculated?.call(metrics);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context);
    final isFemale = widget.gender.toLowerCase() == 'female' || widget.gender.toLowerCase() == 'kadın';

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 20,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.secondaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calculate,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    strings.bmi,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn().slideX(begin: -0.2),

            const SizedBox(height: 24),

            // Required measurements
            Text(
              '${strings.bodyMeasurements} *',
              style: TextStyle(
                color: AppTheme.secondaryCyan,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Height
            _buildNumberField(
              controller: _heightController,
              label: strings.height,
              hint: '170',
              suffix: strings.cm,
              validator: (v) => v == null || v.isEmpty ? strings.thisFieldRequired : null,
            ),

            const SizedBox(height: 12),

            // Weight
            _buildNumberField(
              controller: _weightController,
              label: strings.weight,
              hint: '70',
              suffix: strings.kg,
              validator: (v) => v == null || v.isEmpty ? strings.thisFieldRequired : null,
            ),

            const SizedBox(height: 24),

            // Optional measurements for body fat
            Text(
              '${strings.bodyMeasurements} (${strings.notes})',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.navyMethodNote,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),

            // Neck
            _buildNumberField(
              controller: _neckController,
              label: strings.neckMeasurement,
              hint: '35',
              suffix: strings.cm,
              required: false,
            ),

            const SizedBox(height: 12),

            // Waist
            _buildNumberField(
              controller: _waistController,
              label: strings.waistMeasurement.replaceAll(' (cm)', ''),
              hint: '85',
              suffix: strings.cm,
              required: false,
            ),

            if (isFemale) ...[
              const SizedBox(height: 12),
              // Hip (for women)
              _buildNumberField(
                controller: _hipController,
                label: strings.hipsMeasurement.replaceAll(' (cm)', ''),
                hint: '95',
                suffix: strings.cm,
                required: false,
              ),
            ],

            const SizedBox(height: 24),

            // Calculate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculateMetrics,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calculate, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        strings.calculate,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

            // Results
            if (_calculatedMetrics != null) ...[
              const SizedBox(height: 32),
              _buildResults(_calculatedMetrics!, strings),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String suffix,
    String? Function(String?)? validator,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: AppTheme.accentOrange,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            suffixStyle: TextStyle(
              color: AppTheme.secondaryCyan,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.secondaryCyan, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildResults(BodyMetrics metrics, AppStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.results,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ).animate().fadeIn(),
        
        const SizedBox(height: 16),

        // BMI
        _buildResultCard(
          icon: Icons.monitor_weight,
          title: 'BMI',
          value: metrics.bmi.toStringAsFixed(1),
          category: _getBMILabel(metrics.bmiCategory, strings),
          color: _getBMIColor(metrics.bmiCategory),
        ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.2),

        // Body Fat (if available)
        if (metrics.bodyFatPercentage != null) ...[
          const SizedBox(height: 12),
          _buildResultCard(
            icon: Icons.favorite,
            title: strings.bodyFatPercentage,
            value: '${metrics.bodyFatPercentage!.toStringAsFixed(1)}%',
            category: _getBodyFatLabel(metrics.bodyFatCategory, strings),
            color: _getBodyFatColor(metrics.bodyFatCategory),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2),
        ],

        // WHR (if available)
        if (metrics.waistToHipRatio != null) ...[
          const SizedBox(height: 12),
          _buildResultCard(
            icon: Icons.straighten,
            title: strings.waistHipRatio,
            value: metrics.waistToHipRatio!.toStringAsFixed(2),
            category: _getWHRLabel(metrics.whrCategory, strings),
            color: _getWHRColor(metrics.whrCategory),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.2),
        ],
      ],
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String value,
    required String category,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  category,
                  style: TextStyle(
                    color: color.withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getBMILabel(String category, AppStrings strings) {
    switch (category) {
      case 'underweight':
        return strings.underweight;
      case 'normal':
        return strings.normal;
      case 'overweight':
        return strings.overweight;
      case 'obese':
        return strings.obese;
      default:
        return strings.unknown;
    }
  }

  Color _getBMIColor(String category) {
    switch (category) {
      case 'underweight':
        return Colors.blue;
      case 'normal':
        return Colors.green;
      case 'overweight':
        return Colors.orange;
      case 'obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getBodyFatLabel(String? category, AppStrings strings) {
    if (category == null) return '';
    switch (category) {
      case 'essential':
        return strings.essentialFat;
      case 'athlete':
        return strings.athlete;
      case 'fitness':
        return strings.fitness;
      case 'average':
        return strings.average;
      case 'obese':
        return strings.highBodyFat;
      default:
        return '';
    }
  }

  Color _getBodyFatColor(String? category) {
    if (category == null) return Colors.grey;
    switch (category) {
      case 'essential':
      case 'athlete':
        return Colors.green;
      case 'fitness':
        return AppTheme.secondaryCyan;
      case 'average':
        return Colors.orange;
      case 'obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getWHRLabel(String? category, AppStrings strings) {
    if (category == null) return '';
    switch (category) {
      case 'low_risk':
        return strings.lowRisk;
      case 'moderate_risk':
        return strings.moderateRisk;
      case 'high_risk':
        return strings.highRisk;
      default:
        return '';
    }
  }

  Color _getWHRColor(String? category) {
    if (category == null) return Colors.grey;
    switch (category) {
      case 'low_risk':
        return Colors.green;
      case 'moderate_risk':
        return Colors.orange;
      case 'high_risk':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

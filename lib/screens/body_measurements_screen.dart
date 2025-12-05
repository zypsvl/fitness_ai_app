import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../widgets/weight_chart_widget.dart';
import '../theme_config.dart';
import '../utils/app_strings.dart';

class BodyMeasurementsScreen extends StatefulWidget {
  const BodyMeasurementsScreen({super.key});

  @override
  State<BodyMeasurementsScreen> createState() =>
      _BodyMeasurementsScreenState();
}

class _BodyMeasurementsScreenState extends State<BodyMeasurementsScreen> {
  bool _showAddForm = false;
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipsController = TextEditingController();
  final _armsController = TextEditingController();
  final _thighsController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _armsController.dispose();
    _thighsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _addMeasurement() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    final strings = AppStrings(context);

    await provider.addMeasurement(
      weight: double.parse(_weightController.text),
      chest: _chestController.text.isNotEmpty
          ? double.tryParse(_chestController.text)
          : null,
      waist: _waistController.text.isNotEmpty
          ? double.tryParse(_waistController.text)
          : null,
      hips: _hipsController.text.isNotEmpty
          ? double.tryParse(_hipsController.text)
          : null,
      arms: _armsController.text.isNotEmpty
          ? double.tryParse(_armsController.text)
          : null,
      thighs: _thighsController.text.isNotEmpty
          ? double.tryParse(_thighsController.text)
          : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    _clearForm();
    setState(() {
      _showAddForm = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(strings.measurementAdded),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _clearForm() {
    _weightController.clear();
    _chestController.clear();
    _waistController.clear();
    _hipsController.clear();
    _armsController.clear();
    _thighsController.clear();
    _notesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context);
    final strings = AppStrings(context);
    final measurements = provider.measurements;
    final latestMeasurement = provider.latestMeasurement;
    final weightChange = provider.totalWeightChange;
    final weightChangePercent = provider.totalWeightChangePercent;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(strings.bodyMeasurements),
        actions: [
          IconButton(
            icon: Icon(_showAddForm ? Icons.close : Icons.add),
            onPressed: () {
              setState(() {
                _showAddForm = !_showAddForm;
                if (!_showAddForm) _clearForm();
              });
            },
          ),
        ],
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Add Measurement Form
                if (_showAddForm) ...[
                  GlassContainer(
                    padding: const EdgeInsets.all(20),
                    borderRadius: 20,
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.addNewMeasurement,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            strings.weightRequired,
                            _weightController,
                            required: true,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(strings.chestMeasurement, _chestController),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(strings.waistMeasurement, _waistController),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(strings.hipsMeasurement, _hipsController),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildTextField(strings.armsMeasurement, _armsController),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(strings.thighsMeasurement, _thighsController),
                          const SizedBox(height: 16),
                          _buildTextField(
                            strings.notes,
                            _notesController,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _addMeasurement,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    strings.save,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn().slideY(begin: -0.2),
                ],

                // Current Stats Cards
                if (latestMeasurement != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          strings.currentWeight,
                          '${latestMeasurement.weight.toStringAsFixed(1)} ${strings.kg}',
                          weightChange != null && weightChangePercent != null
                              ? '${weightChange >= 0 ? '+' : ''}${weightChange.toStringAsFixed(1)} ${strings.kg} (${weightChangePercent.toStringAsFixed(1)}%)'
                              : strings.firstMeasurement,
                          Icons.monitor_weight,
                          AppTheme.primaryPurple,
                        ).animate(delay: 100.ms).fadeIn().scale(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Weight Chart
                if (measurements.isNotEmpty) ...[
                  Text(
                    strings.weightChart,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate(delay: 200.ms).fadeIn(),
                  const SizedBox(height: 12),
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 20,
                    child: WeightChartWidget(
                      measurements: provider.getMeasurementsForChart(90),
                      targetWeight: provider.profile?.targetWeight,
                    ),
                  ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2),
                  const SizedBox(height: 24),
                ],

                // Measurement History
                if (measurements.isNotEmpty) ...[
                  Text(
                    strings.measurementHistory,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate(delay: 400.ms).fadeIn(),
                  const SizedBox(height: 12),
                  ...measurements.map((measurement) {
                    return GlassContainer(
                      padding: const EdgeInsets.all(16),
                      borderRadius: 16,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${measurement.date.day}/${measurement.date.month}/${measurement.date.year}',
                                style: TextStyle(
                                  color: AppTheme.secondaryCyan,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${measurement.weight.toStringAsFixed(1)} ${strings.kg}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (measurement.chest != null ||
                              measurement.waist != null ||
                              measurement.hips != null) ...[
                            const SizedBox(height: 12),
                            const Divider(
                              color: Colors.white24,
                              height: 1,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 16,
                              runSpacing: 8,
                              children: [
                                if (measurement.chest != null)
                                  _buildMeasurementChip(
                                    strings.chestMeasurement.replaceAll(' (cm)', ''),
                                    '${measurement.chest} ${strings.cm}',
                                  ),
                                if (measurement.waist != null)
                                  _buildMeasurementChip(
                                    strings.waistMeasurement.replaceAll(' (cm)', ''),
                                    '${measurement.waist} ${strings.cm}',
                                  ),
                                if (measurement.hips != null)
                                  _buildMeasurementChip(
                                    strings.hipsMeasurement.replaceAll(' (cm)', ''),
                                    '${measurement.hips} ${strings.cm}',
                                  ),
                                if (measurement.arms != null)
                                  _buildMeasurementChip(
                                    strings.armsMeasurement.replaceAll(' (cm)', ''),
                                    '${measurement.arms} ${strings.cm}',
                                  ),
                                if (measurement.thighs != null)
                                  _buildMeasurementChip(
                                    strings.thighsMeasurement.replaceAll(' (cm)', ''),
                                    '${measurement.thighs} ${strings.cm}',
                                  ),
                              ],
                            ),
                          ],
                          if (measurement.notes != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              measurement.notes!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                        .animate(delay: 500.ms)
                        .fadeIn()
                        .slideX(begin: 0.2);
                  }),
                ],

                // Empty State
                if (measurements.isEmpty && !_showAddForm) ...[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            size: 80,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            strings.noMeasurementsYet,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            strings.addFirstMeasurement,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool required = false,
    int maxLines = 1,
  }) {
    final strings = AppStrings(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            keyboardType: maxLines == 1
                ? TextInputType.number
                : TextInputType.multiline,
            maxLines: maxLines,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.primaryPurple,
                  width: 2,
                ),
              ),
            ),
            validator: required
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return strings.thisFieldRequired;
                    }
                    return null;
                  }
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryPurple.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.secondaryCyan,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

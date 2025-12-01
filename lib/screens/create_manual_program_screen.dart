import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/workout_provider.dart';
import '../models/weekly_plan_model.dart';
import '../models/exercise_model.dart';
import '../widgets/animated_gradient_background.dart';
import '../widgets/glass_container.dart';
import '../theme_config.dart';
import 'exercise_picker_screen.dart';
import 'result_screen.dart';

class CreateManualProgramScreen extends StatefulWidget {
  const CreateManualProgramScreen({super.key});

  @override
  State<CreateManualProgramScreen> createState() => _CreateManualProgramScreenState();
}

class _CreateManualProgramScreenState extends State<CreateManualProgramScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  // Program details
  String _programName = '';
  int _numberOfDays = 3;
  
  // Days data
  List<Map<String, dynamic>> _days = [];
  
  @override
  void initState() {
    super.initState();
    _initializeDays();
  }
  
  void _initializeDays() {
    _days = List.generate(_numberOfDays, (index) => {
      'name': 'Gün ${index + 1}',
      'focus': '',
      'exercises': <Map<String, dynamic>>[],
    });
  }
  
  void _updateNumberOfDays(int newCount) {
    setState(() {
      _numberOfDays = newCount;
      if (_days.length < newCount) {
        for (int i = _days.length; i < newCount; i++) {
          _days.add({
            'name': 'Gün ${i + 1}',
            'focus': '',
            'exercises': <Map<String, dynamic>>[],
          });
        }
      } else if (_days.length > newCount) {
        _days = _days.sublist(0, newCount);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Kendi Programını Oluştur'),
      ),
      body: AnimatedGradientBackground(
        child: SafeArea(
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: _onStepContinue,
            onStepCancel: _onStepCancel,
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                        ),
                        child: const Text('Geri'),
                      ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: Text(
                        _currentStep == 2 ? 'Oluştur' : 'Devam',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text('Program Detayları', style: TextStyle(color: Colors.white)),
                content: _buildProgramDetailsStep(),
                isActive: _currentStep >= 0,
                state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: const Text('Günleri Doldur', style: TextStyle(color: Colors.white)),
                content: _buildDaysStep(),
                isActive: _currentStep >= 1,
                state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: const Text('Önizleme', style: TextStyle(color: Colors.white)),
                content: _buildPreviewStep(),
                isActive: _currentStep >= 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProgramDetailsStep() {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: _programName,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Program Adı',
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: 'örn: Benim Push/Pull Programım',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Program adı gerekli' : null,
              onChanged: (value) => _programName = value,
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'Kaç gün? ($_numberOfDays gün)',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Slider(
              value: _numberOfDays.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              activeColor: AppTheme.primaryPurple,
              label: '$_numberOfDays gün',
              onChanged: (value) => _updateNumberOfDays(value.toInt()),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDaysStep() {
    return Column(
      children: _days.asMap().entries.map((entry) {
        final dayIndex = entry.key;
        final day = entry.value;
        
        return GlassContainer(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: day['name'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: 'Gün Adı',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                      ),
                      onChanged: (value) => day['name'] = value,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(day['exercises'] as List).length} egzersiz',
                      style: TextStyle(color: AppTheme.secondaryCyan, fontSize: 12),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              TextFormField(
                initialValue: day['focus'],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Fokus (örn: Göğüs & Triceps)',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                ),
                onChanged: (value) => day['focus'] = value,
              ),
              
              const SizedBox(height: 16),
              
              // Exercise list
              ...(day['exercises'] as List).asMap().entries.map((exEntry) {
                final exIndex = exEntry.key;
                final exercise = exEntry.value;
                return _buildExerciseListItem(dayIndex, exIndex, exercise);
              }).toList(),
              
              // Add exercise button
              OutlinedButton.icon(
                onPressed: () => _addExercise(dayIndex),
                icon: const Icon(Icons.add),
                label: const Text('Egzersiz Ekle'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.secondaryCyan,
                  side: BorderSide(color: AppTheme.secondaryCyan),
                ),
              ),
            ],
          ),
        ).animate(delay: (dayIndex * 100).ms).fadeIn().slideX(begin: 0.2);
      }).toList(),
    );
  }
  
  Widget _buildExerciseListItem(int dayIndex, int exIndex, Map<String, dynamic> exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              exercise['exercise']?.name ?? 'Egzersiz seç',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: TextField(
              controller: TextEditingController(text: exercise['sets']),
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: 'Set',
                labelStyle: TextStyle(fontSize: 10, color: Colors.white60),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => exercise['sets'] = value,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 70,
            child: TextField(
              controller: TextEditingController(text: exercise['reps']),
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                labelText: 'Tekrar',
                labelStyle: TextStyle(fontSize: 10, color: Colors.white60),
                isDense: true,
              ),
              onChanged: (value) => exercise['reps'] = value,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () {
              setState(() {
                (_days[dayIndex]['exercises'] as List).removeAt(exIndex);
              });
            },
          ),
        ],
      ),
    );
  }
  
  Future<void> _addExercise(int dayIndex) async {
    final selectedExercise = await Navigator.push<Exercise>(
      context,
      MaterialPageRoute(
        builder: (_) => const ExercisePickerScreen(),
      ),
    );
    
    if (selectedExercise != null && mounted) {
      setState(() {
        (_days[dayIndex]['exercises'] as List).add({
          'exercise': selectedExercise,
          'sets': '3',
          'reps': '8-10',
        });
      });
    }
  }
  
  Widget _buildPreviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassContainer(
          padding: const EdgeInsets.all(20),
          borderRadius: 16,
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.fitness_center, color: AppTheme.primaryPurple, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _programName.isEmpty ? 'Programım' : _programName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '$_numberOfDays Günlük Program',
                style: TextStyle(color: AppTheme.secondaryCyan, fontSize: 16),
              ),
            ],
          ),
        ),
        
        ..._days.asMap().entries.map((entry) {
          final day = entry.value;
          final exercises = day['exercises'] as List;
          
          return GlassContainer(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            borderRadius: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (day['focus'].toString().isNotEmpty)
                  Text(
                    day['focus'],
                    style: TextStyle(color: AppTheme.secondaryCyan, fontSize: 14),
                  ),
                const SizedBox(height: 12),
                ...exercises.map((ex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: Colors.white70, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ex['exercise']?.name ?? 'Egzersiz',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Text(
                          '${ex['sets']} × ${ex['reps']}',
                          style: TextStyle(color: AppTheme.secondaryCyan, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
  
  void _onStepContinue() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep = 1);
      }
    } else if (_currentStep == 1) {
      // Validate at least one exercise per day
      bool hasExercises = _days.every((day) =>
          (day['exercises'] as List).isNotEmpty);
      
      if (!hasExercises) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Her güne en az bir egzersiz eklemelisiniz'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      _createProgram();
    }
  }
  
  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
  
  void _createProgram() {
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    
    // Convert to WorkoutDay list
    final weeklyPlan = _days.map((day) {
      final exercises = (day['exercises'] as List).map((ex) {
        return ScheduledExercise(
          exercise: ex['exercise'] as Exercise,
          sets: ex['sets'] as String,
          reps: ex['reps'] as String,
        );
      }).toList();
      
      return WorkoutDay(
        dayName: day['name'] as String,
        focus: day['focus'] as String,
        exercises: exercises,
      );
    }).toList();
    
    // Update provider
    provider.updateWeeklyPlan(weeklyPlan);
    
    // Navigate to result screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ResultScreen()),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_programName oluşturuldu!'),
        backgroundColor: AppTheme.secondaryCyan,
      ),
    );
  }
}

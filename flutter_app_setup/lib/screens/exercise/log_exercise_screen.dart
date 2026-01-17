import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/exercise.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';

class LogExerciseScreen extends ConsumerStatefulWidget {
  const LogExerciseScreen({super.key});

  @override
  ConsumerState<LogExerciseScreen> createState() => _LogExerciseScreenState();
}

class _LogExerciseScreenState extends ConsumerState<LogExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _activityTypeController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _distanceController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedIntensity = 'moderate';
  final List<String> _intensityLevels = [
    'low',
    'moderate',
    'high',
    'very_high',
  ];

  final List<String> _popularActivities = [
    'Running',
    'Cycling',
    'Swimming',
    'Weightlifting',
    'Yoga',
    'Walking',
    'HIIT',
    'Dance',
  ];

  @override
  void dispose() {
    _activityTypeController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _distanceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _logExercise() {
    if (_formKey.currentState!.validate()) {
      final exercise = Exercise(
        activityID: DateTime.now().millisecondsSinceEpoch.toString(),
        activityType: _activityTypeController.text,
        duration: double.parse(_durationController.text),
        caloriesBurned: double.parse(_caloriesController.text),
        intensity: _selectedIntensity,
        distance: _distanceController.text.isEmpty
            ? 0
            : double.parse(_distanceController.text),
        notes: _notesController.text,
      );

      exercise.completeActivity();
      ref.read(userProvider.notifier).logExercise(exercise);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercise logged successfully!'),
          backgroundColor: AppTheme.exerciseColor,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Exercise')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Popular Activities
              Text(
                'Popular Activities',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _popularActivities.map((activity) {
                  return ChoiceChip(
                    label: Text(activity),
                    selected: _activityTypeController.text == activity,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _activityTypeController.text = activity;
                        });
                      }
                    },
                    selectedColor: AppTheme.exerciseColor.withOpacity(0.3),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Activity Type
              TextFormField(
                controller: _activityTypeController,
                decoration: const InputDecoration(
                  labelText: 'Activity Type',
                  hintText: 'e.g., Running, Cycling',
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter activity type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Duration
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                  hintText: 'e.g., 30',
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Calories
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories Burned',
                  hintText: 'e.g., 250',
                  prefixIcon: Icon(Icons.local_fire_department),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calories burned';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Intensity
              Text(
                'Intensity Level',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: _intensityLevels.map((level) {
                  return ButtonSegment<String>(
                    value: level,
                    label: Text(level.replaceAll('_', ' ').toUpperCase()),
                  );
                }).toList(),
                selected: {_selectedIntensity},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedIntensity = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Distance (Optional)
              TextFormField(
                controller: _distanceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Distance (km) - Optional',
                  hintText: 'e.g., 5.0',
                  prefixIcon: Icon(Icons.straighten),
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Add any notes about your workout',
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 32),

              // Log Button
              ElevatedButton(
                onPressed: _logExercise,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppTheme.exerciseColor,
                ),
                child: const Text(
                  'Log Exercise',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

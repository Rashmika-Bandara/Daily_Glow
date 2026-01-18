import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/services_provider.dart';
import '../../config/theme.dart';

class EditExerciseScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> exercise;

  const EditExerciseScreen({super.key, required this.exercise});

  @override
  ConsumerState<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends ConsumerState<EditExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _activityTypeController;
  late TextEditingController _durationController;
  late TextEditingController _caloriesController;
  late TextEditingController _notesController;

  late String _selectedIntensity;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  final List<String> _intensityLevels = [
    'low',
    'moderate',
    'high',
    'very_high',
  ];

  @override
  void initState() {
    super.initState();

    _activityTypeController = TextEditingController(
      text: widget.exercise['activityType'] as String? ?? '',
    );
    _durationController = TextEditingController(
      text: (widget.exercise['duration'] as num?)?.toString() ?? '',
    );
    _caloriesController = TextEditingController(
      text: (widget.exercise['caloriesBurned'] as num?)?.toString() ?? '',
    );
    _notesController = TextEditingController(
      text: widget.exercise['notes'] as String? ?? '',
    );

    _selectedIntensity = widget.exercise['intensity'] as String? ?? 'moderate';

    // Parse date
    try {
      _selectedDate = DateTime.parse(widget.exercise['date'] as String? ??
          DateTime.now().toIso8601String());
    } catch (e) {
      _selectedDate = DateTime.now();
    }

    // Parse time
    try {
      final startTime = DateTime.parse(
          widget.exercise['startTime'] as String? ??
              DateTime.now().toIso8601String());
      _selectedTime = TimeOfDay(hour: startTime.hour, minute: startTime.minute);
    } catch (e) {
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _activityTypeController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateExercise() async {
    if (_formKey.currentState!.validate()) {
      try {
        final activityService = ref.read(activityServiceProvider);

        // Combine date and time
        final startDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        await activityService.updateExercise(
          exerciseId: widget.exercise['id'] as String,
          activityType: _activityTypeController.text,
          duration: double.parse(_durationController.text),
          caloriesBurned: double.parse(_caloriesController.text),
          intensity: _selectedIntensity,
          startTime: startDateTime,
          date: _selectedDate,
          notes: _notesController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Workout updated successfully!'),
              backgroundColor: AppTheme.exerciseColor,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Workout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date and Time Selection
              Text(
                'Workout Date & Time',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (time != null) {
                          setState(() {
                            _selectedTime = time;
                          });
                        }
                      },
                      icon: const Icon(Icons.access_time),
                      label: Text(_selectedTime.format(context)),
                    ),
                  ),
                ],
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
                  suffixText: 'min',
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
                  suffixText: 'kcal',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calories';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Intensity
              Text(
                'Intensity Level',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: _intensityLevels.map((level) {
                  return ButtonSegment<String>(
                    value: level,
                    label: Text(_capitalizeFirst(level)),
                  );
                }).toList(),
                selected: {_selectedIntensity},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _selectedIntensity = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Add any additional notes...',
                  prefixIcon: Icon(Icons.note),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),

              // Update Button
              ElevatedButton(
                onPressed: _updateExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.exerciseColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update Workout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).replaceAll('_', ' ');
  }
}

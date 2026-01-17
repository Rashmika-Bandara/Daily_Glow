import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/goal.dart';
import '../../providers/user_provider.dart';
import '../../config/theme.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  void _showAddGoalDialog() {
    showDialog(context: context, builder: (context) => const _AddGoalDialog());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final goals = user?.goals ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddGoalDialog,
          ),
        ],
      ),
      body: goals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No goals yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create goals to track your progress',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showAddGoalDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Goal'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final progress =
                    (goal.currentValue / goal.targetValue).clamp(0.0, 1.0);
                final isCompleted = goal.isAchieved();

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? Colors.green.withOpacity(0.1)
                                    : AppTheme.primaryLight.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isCompleted ? Icons.check_circle : Icons.flag,
                                color: isCompleted
                                    ? Colors.green
                                    : AppTheme.primaryLight,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal.goalType,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Goal for ${goal.goalType}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            if (isCompleted)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isCompleted ? Colors.green : AppTheme.primaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${goal.currentValue.toInt()} / ${goal.targetValue.toInt()} ${goal is GoalForPhysicalActivity ? (goal as GoalForPhysicalActivity).unit : 'L'}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isCompleted
                                        ? Colors.green
                                        : AppTheme.primaryLight,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.flag,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Target: ${goal.targetValue.toInt()} ${goal is GoalForPhysicalActivity ? (goal as GoalForPhysicalActivity).unit : 'L'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: goals.isNotEmpty
          ? FloatingActionButton(
              onPressed: _showAddGoalDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _AddGoalDialog extends ConsumerStatefulWidget {
  const _AddGoalDialog();

  @override
  ConsumerState<_AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends ConsumerState<_AddGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _goalNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetValueController = TextEditingController();
  final _targetUnitController = TextEditingController();

  String _goalType = 'physical';
  DateTime _targetDate = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _goalNameController.dispose();
    _descriptionController.dispose();
    _targetValueController.dispose();
    _targetUnitController.dispose();
    super.dispose();
  }

  void _createGoal() {
    if (_formKey.currentState!.validate()) {
      final goal = _goalType == 'physical'
          ? GoalForPhysicalActivity(
              goalID: DateTime.now().millisecondsSinceEpoch.toString(),
              activityType: _goalNameController.text,
              unit: _targetUnitController.text,
              targetValue: double.parse(_targetValueController.text),
              currentValue: 0.0,
            )
          : GoalForHydration(
              goalID: DateTime.now().millisecondsSinceEpoch.toString(),
              dailyTargetLiters: double.parse(_targetValueController.text),
              currentIntakeToday: 0.0,
            );

      ref.read(userProvider.notifier).addGoal(goal);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goal created successfully!'),
          backgroundColor: AppTheme.primaryLight,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Goal'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                    value: 'physical',
                    label: Text('Exercise'),
                    icon: Icon(Icons.fitness_center),
                  ),
                  ButtonSegment<String>(
                    value: 'hydration',
                    label: Text('Water'),
                    icon: Icon(Icons.water_drop),
                  ),
                ],
                selected: {_goalType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _goalType = newSelection.first;
                    if (_goalType == 'hydration') {
                      _targetUnitController.text = 'liters';
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalNameController,
                decoration: const InputDecoration(
                  labelText: 'Goal Name',
                  hintText: 'e.g., Run 100km',
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Optional description',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _targetValueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Target Value',
                  hintText: 'e.g., 100',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (double.tryParse(value!) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              if (_goalType == 'physical')
                TextFormField(
                  controller: _targetUnitController,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    hintText: 'e.g., km, workouts, minutes',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Target Date'),
                subtitle: Text(
                  '${_targetDate.day}/${_targetDate.month}/${_targetDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _targetDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _targetDate = date);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _createGoal, child: const Text('Create')),
      ],
    );
  }
}

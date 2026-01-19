import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/services_provider.dart';
import '../../config/theme.dart';

class LogMealScreen extends ConsumerStatefulWidget {
  const LogMealScreen({super.key});

  @override
  ConsumerState<LogMealScreen> createState() => _LogMealScreenState();
}

class _LogMealScreenState extends ConsumerState<LogMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _foodItemsController = TextEditingController();

  String _selectedMealType = 'breakfast';
  final List<String> _mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _foodItemsController.dispose();
    super.dispose();
  }

  Future<void> _logMeal() async {
    if (_formKey.currentState!.validate()) {
      try {
        final foodItems = _foodItemsController.text
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList();

        final activityService = ref.read(activityServiceProvider);

        await activityService.logMeal(
          mealType: _selectedMealType,
          foodItems: foodItems,
          calories: double.parse(_caloriesController.text),
          protein: double.parse(_proteinController.text),
          carbs: double.parse(_carbsController.text),
          fat: double.parse(_fatController.text),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meal logged successfully!'),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0F2027),
                  const Color(0xFF203A43),
                  const Color(0xFF2C5364),
                ]
              : [
                  const Color(0xFF4158D0),
                  const Color(0xFFC850C0),
                  const Color(0xFFFFCC70),
                ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Log Meal'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.restaurant,
                size: 35,
                color: AppTheme.exerciseColor,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Meal Type
                Text(
                  'Meal Type',
                  style: Theme.of(
                    context,
                  )
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: _mealTypes.map((type) {
                    return ButtonSegment<String>(
                      value: type,
                      label: Text(type[0].toUpperCase() + type.substring(1)),
                      icon: Icon(_getMealIcon(type)),
                    );
                  }).toList(),
                  selected: {_selectedMealType},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _selectedMealType = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Food Items
                TextFormField(
                  controller: _foodItemsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Food Items',
                    hintText: 'e.g., Chicken, Rice, Salad (comma separated)',
                    prefixIcon: Icon(Icons.restaurant_menu),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter food items';
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
                    labelText: 'Calories',
                    hintText: 'e.g., 500',
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
                const SizedBox(height: 16),

                // Macros
                Text(
                  'Macronutrients',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _proteinController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Protein',
                          hintText: '25',
                          suffixText: 'g',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _carbsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Carbs',
                          hintText: '60',
                          suffixText: 'g',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _fatController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Fat',
                          hintText: '15',
                          suffixText: 'g',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Macro Breakdown Preview
                if (_proteinController.text.isNotEmpty &&
                    _carbsController.text.isNotEmpty &&
                    _fatController.text.isNotEmpty)
                  Card(
                    color: Colors.white.withOpacity(0.15),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Macro Breakdown',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          _buildMacroBar(
                            'Protein',
                            double.tryParse(_proteinController.text) ?? 0,
                            Colors.blue,
                          ),
                          const SizedBox(height: 8),
                          _buildMacroBar(
                            'Carbs',
                            double.tryParse(_carbsController.text) ?? 0,
                            Colors.green,
                          ),
                          const SizedBox(height: 8),
                          _buildMacroBar(
                            'Fat',
                            double.tryParse(_fatController.text) ?? 0,
                            Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 32),

                // Log Button
                ElevatedButton(
                  onPressed: _logMeal,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.exerciseColor,
                  ),
                  child: const Text('Log Meal', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snack':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  Widget _buildMacroBar(String label, double value, Color color) {
    final total = (double.tryParse(_proteinController.text) ?? 0) +
        (double.tryParse(_carbsController.text) ?? 0) +
        (double.tryParse(_fatController.text) ?? 0);
    final percentage = total > 0 ? (value / total) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '${value.toInt()}g (${(percentage * 100).toInt()}%)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/services_provider.dart';
import '../../config/theme.dart';
import 'log_meal_screen.dart';

class MealsTab extends ConsumerStatefulWidget {
  const MealsTab({super.key});

  @override
  ConsumerState<MealsTab> createState() => _MealsTabState();
}

class _MealsTabState extends ConsumerState<MealsTab> {
  @override
  Widget build(BuildContext context) {
    final activityService = ref.watch(activityServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: activityService.getTodayMeals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final meals = snapshot.data ?? [];
          final totalCalories = meals.fold<double>(
            0,
            (sum, meal) => sum + (meal['calories'] as num).toDouble(),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Summary Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.restaurant,
                          size: 50,
                          color: AppTheme.exerciseColor,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${totalCalories.toStringAsFixed(0)} kcal',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.exerciseColor,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total Today',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMacroInfo(
                              context,
                              'Protein',
                              '${meals.fold<double>(0, (sum, m) => sum + (m['protein'] as num? ?? 0).toDouble()).toStringAsFixed(0)}g',
                            ),
                            _buildMacroInfo(
                              context,
                              'Carbs',
                              '${meals.fold<double>(0, (sum, m) => sum + (m['carbs'] as num? ?? 0).toDouble()).toStringAsFixed(0)}g',
                            ),
                            _buildMacroInfo(
                              context,
                              'Fat',
                              '${meals.fold<double>(0, (sum, m) => sum + (m['fat'] as num? ?? 0).toDouble()).toStringAsFixed(0)}g',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Today's Meals
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Meals',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${meals.length} meals',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (meals.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No meals logged yet',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap + to log your first meal',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...meals.map((meal) => _buildMealCard(context, meal)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LogMealScreen(),
            ),
          ).then((_) => setState(() {}));
        },
        icon: const Icon(Icons.add),
        label: const Text('Log Meal'),
        backgroundColor: AppTheme.exerciseColor,
      ),
    );
  }

  Widget _buildMacroInfo(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, Map<String, dynamic> meal) {
    final mealType = meal['mealType'] as String? ?? 'meal';
    final foodItems = meal['foodItems'] as List<dynamic>? ?? [];
    final calories = (meal['calories'] as num?)?.toDouble() ?? 0;
    final protein = (meal['protein'] as num?)?.toDouble() ?? 0;
    final carbs = (meal['carbs'] as num?)?.toDouble() ?? 0;
    final fat = (meal['fat'] as num?)?.toDouble() ?? 0;
    final date = meal['date'] as String?;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getMealIcon(mealType),
                  color: AppTheme.exerciseColor,
                ),
                const SizedBox(width: 8),
                Text(
                  mealType[0].toUpperCase() + mealType.substring(1),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${calories.toStringAsFixed(0)} kcal',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppTheme.exerciseColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              foodItems.join(', '),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildMacroChip('P: ${protein.toStringAsFixed(0)}g'),
                const SizedBox(width: 8),
                _buildMacroChip('C: ${carbs.toStringAsFixed(0)}g'),
                const SizedBox(width: 8),
                _buildMacroChip('F: ${fat.toStringAsFixed(0)}g'),
              ],
            ),
            if (date != null) ...[
              const SizedBox(height: 8),
              Text(
                _formatTime(date),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.exerciseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.exerciseColor,
        ),
      ),
    );
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType.toLowerCase()) {
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

  String _formatTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return '';
    }
  }
}

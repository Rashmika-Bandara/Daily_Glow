import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/health_plan_data.dart';

class DayPlanDetailScreen extends StatelessWidget {
  final int dayNumber;
  final DateTime dayDate;
  final double? bmi;
  final String bmiCategory;
  final Color categoryColor;

  const DayPlanDetailScreen({
    super.key,
    required this.dayNumber,
    required this.dayDate,
    required this.bmi,
    required this.bmiCategory,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dayPlan = HealthPlanHelper.getDayPlan(bmi, dayNumber - 1);
    final calorieTarget = HealthPlanHelper.getCalorieTarget(bmi);
    final goal = HealthPlanHelper.getGoal(bmi);

    return Scaffold(
      appBar: AppBar(
        title: Text('Day $dayNumber Plan'),
      ),
      body: Container(
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day Header Card
              Card(
                color: isDark ? null : Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Day $dayNumber',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? null : Colors.black87,
                                    ),
                              ),
                              Text(
                                DateFormat('EEEE, MMMM d').format(dayDate),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: isDark ? null : Colors.black54,
                                    ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: categoryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              bmiCategory,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.flag, color: AppTheme.primaryLight),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Goal: $goal',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? null : Colors.black87,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department,
                              color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Target: $calorieTarget',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? null : Colors.black87,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Workout Section
              _buildSectionHeader(
                context,
                icon: Icons.fitness_center,
                title: 'Workout Plan',
                color: AppTheme.exerciseColor,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              Card(
                color: isDark ? null : Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        context,
                        icon: Icons.directions_run,
                        label: 'Focus',
                        value: dayPlan.workout.focus,
                        isDark: isDark,
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoRow(
                              context,
                              icon: Icons.timer,
                              label: 'Duration',
                              value: dayPlan.workout.duration,
                              isDark: isDark,
                            ),
                          ),
                          Expanded(
                            child: _buildInfoRow(
                              context,
                              icon: Icons.local_fire_department,
                              label: 'Burn',
                              value: dayPlan.workout.calories,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Meal Plan Section
              _buildSectionHeader(
                context,
                icon: Icons.restaurant,
                title: 'Meal Plan',
                color: AppTheme.mealColor,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildMealCard(
                context,
                icon: Icons.wb_sunny,
                mealTime: 'Breakfast',
                meal: dayPlan.meals.breakfast,
                color: const Color(0xFFFFD93D),
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildMealCard(
                context,
                icon: Icons.lunch_dining,
                mealTime: 'Lunch',
                meal: dayPlan.meals.lunch,
                color: const Color(0xFFF59E0B),
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildMealCard(
                context,
                icon: Icons.cookie,
                mealTime: 'Snack',
                meal: dayPlan.meals.snack,
                color: const Color(0xFFAAC4F5),
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildMealCard(
                context,
                icon: Icons.dinner_dining,
                mealTime: 'Dinner',
                meal: dayPlan.meals.dinner,
                color: const Color(0xFF8CA9FF),
                isDark: isDark,
              ),
              const SizedBox(height: 20),

              // Water Intake Section
              _buildSectionHeader(
                context,
                icon: Icons.water_drop,
                title: 'Water Intake Plan',
                color: AppTheme.waterIntake,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              Card(
                color: isDark ? null : Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_drink, color: AppTheme.waterIntake),
                          const SizedBox(width: 12),
                          Text(
                            'Daily Target: ${dayPlan.water.dailyTotal}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? null : Colors.black87,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...dayPlan.water.schedule.map((intake) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppTheme.waterIntake,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  intake.time,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: isDark ? null : Colors.black87,
                                      ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.waterIntake.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  intake.amount,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.waterIntake,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryLight),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? null : Colors.black54,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? null : Colors.black87,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMealCard(
    BuildContext context, {
    required IconData icon,
    required String mealTime,
    required Meal meal,
    required Color color,
    required bool isDark,
  }) {
    return Card(
      color: isDark ? null : Colors.white.withOpacity(0.95),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          title: Text(
            mealTime,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? null : Colors.black54,
                ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meal.summary,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? null : Colors.black87,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                '${meal.totalCalories} kcal',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  // Food items
                  ...meal.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.name} (${item.weight})',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? null : Colors.black87,
                                        ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${item.calories} kcal',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _buildMacroChip(
                                    'P: ${item.protein.toStringAsFixed(1)}g',
                                    Icons.fitness_center,
                                    isDark),
                                const SizedBox(width: 8),
                                _buildMacroChip(
                                    'C: ${item.carbs.toStringAsFixed(1)}g',
                                    Icons.restaurant,
                                    isDark),
                                const SizedBox(width: 8),
                                _buildMacroChip(
                                    'F: ${item.fat.toStringAsFixed(1)}g',
                                    Icons.water_drop,
                                    isDark),
                              ],
                            ),
                          ],
                        ),
                      )),
                  const Divider(),
                  const SizedBox(height: 8),
                  // Total macros
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Macronutrients',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? null : Colors.black54,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMacroStat(
                              context,
                              'Protein',
                              '${meal.totalProtein.toStringAsFixed(1)}g',
                              color,
                              isDark,
                            ),
                            _buildMacroStat(
                              context,
                              'Carbs',
                              '${meal.totalCarbs.toStringAsFixed(1)}g',
                              color,
                              isDark,
                            ),
                            _buildMacroStat(
                              context,
                              'Fat',
                              '${meal.totalFat.toStringAsFixed(1)}g',
                              color,
                              isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChip(String text, IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isDark ? Colors.white70 : Colors.black54),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroStat(
    BuildContext context,
    String label,
    String value,
    Color color,
    bool isDark,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? null : Colors.black54,
              ),
        ),
      ],
    );
  }
}

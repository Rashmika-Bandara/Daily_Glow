import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../providers/services_provider.dart';
import '../../models/health_plan_data.dart';
import 'day_plan_detail_screen.dart';

class HealthHabitPlanScreen extends ConsumerStatefulWidget {
  const HealthHabitPlanScreen({super.key});

  @override
  ConsumerState<HealthHabitPlanScreen> createState() =>
      _HealthHabitPlanScreenState();
}

class _HealthHabitPlanScreenState extends ConsumerState<HealthHabitPlanScreen> {
  DateTime _selectedStartDate = DateTime.now();
  int _currentDayIndex = 0;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryLight,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        // Calculate which day of the plan we're on
        final difference = DateTime.now().difference(_selectedStartDate).inDays;
        if (difference >= 0 && difference < 7) {
          _currentDayIndex = difference;
        } else if (difference < 0) {
          _currentDayIndex = 0;
        } else {
          _currentDayIndex = 6;
        }
      });
    }
  }

  DateTime _getDayDate(int dayIndex) {
    return _selectedStartDate.add(Duration(days: dayIndex));
  }

  bool _isCurrentDay(int dayIndex) {
    final dayDate = _getDayDate(dayIndex);
    final today = DateTime.now();
    return dayDate.year == today.year &&
        dayDate.month == today.month &&
        dayDate.day == today.day;
  }

  String _getBMICategory(double? bmi) {
    if (bmi == null) return 'Unknown';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color _getBMICategoryColor(double? bmi) {
    if (bmi == null) return Colors.grey;
    if (bmi < 18.5) return const Color(0xFF60A5FA);
    if (bmi < 25) return const Color(0xFF10B981);
    if (bmi < 30) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(currentUserDataProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Habit Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectStartDate(context),
            tooltip: 'Select Start Date',
          ),
        ],
      ),
      body: userData.when(
        data: (user) {
          final height = user?['height'] as double?;
          final weight = user?['weight'] as double?;

          // Calculate BMI
          double? bmi;
          if (height != null && weight != null && height > 0) {
            final heightInMeters = height / 100;
            bmi = weight / (heightInMeters * heightInMeters);
          }

          final bmiCategory = _getBMICategory(bmi);
          final categoryColor = _getBMICategoryColor(bmi);

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BMI Info Card
                  Card(
                    color: isDark ? null : Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your BMI',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? null : Colors.black87,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    bmi != null
                                        ? bmi.toStringAsFixed(1)
                                        : 'N/A',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: categoryColor,
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
                          if (bmi == null) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Please add your height and weight in profile to see personalized plans',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: isDark ? null : Colors.black54,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Start Date Card
                  Card(
                    color: isDark ? null : Colors.white.withOpacity(0.95),
                    child: InkWell(
                      onTap: () => _selectStartDate(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                color: AppTheme.primaryLight,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Plan Start Date',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: isDark ? null : Colors.black54,
                                        ),
                                  ),
                                  Text(
                                    DateFormat('EEEE, MMMM d, yyyy')
                                        .format(_selectedStartDate),
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
                            ),
                            Icon(
                              Icons.edit_calendar,
                              color: isDark ? null : Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Current Day Indicator
                  Text(
                    'Today: ${DateFormat('EEEE, MMMM d').format(DateTime.now())}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // 7-Day Plan Cards
                  ...List.generate(7, (index) {
                    final dayDate = _getDayDate(index);
                    final isToday = _isCurrentDay(index);
                    final dayName = DateFormat('EEEE').format(dayDate);
                    final dateStr = DateFormat('MMM d').format(dayDate);

                    return Column(
                      children: [
                        _buildDayCard(
                          context,
                          dayNumber: index + 1,
                          dayName: dayName,
                          date: dateStr,
                          dayDate: dayDate,
                          isToday: isToday,
                          isDark: isDark,
                          bmi: bmi,
                          bmiCategory: bmiCategory,
                          categoryColor: categoryColor,
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Error loading user data',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDayCard(
    BuildContext context, {
    required int dayNumber,
    required String dayName,
    required String date,
    required DateTime dayDate,
    required bool isToday,
    required bool isDark,
    required double? bmi,
    required String bmiCategory,
    required Color categoryColor,
  }) {
    return Card(
      color: isDark ? null : Colors.white.withOpacity(0.95),
      elevation: isToday ? 8 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isToday ? AppTheme.primaryLight : Colors.transparent,
          width: isToday ? 2 : 0,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DayPlanDetailScreen(
                dayNumber: dayNumber,
                dayDate: dayDate,
                bmi: bmi,
                bmiCategory: bmiCategory,
                categoryColor: categoryColor,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppTheme.primaryLight
                          : AppTheme.primaryLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isToday ? Colors.white : AppTheme.primaryLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Day $dayNumber - $dayName',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? null : Colors.black87,
                                  ),
                            ),
                            if (isToday) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'TODAY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          date,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark ? null : Colors.black54,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isDark ? null : Colors.black54,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPlanIndicator(
                    context,
                    icon: Icons.fitness_center,
                    label: 'Workout',
                    color: AppTheme.exerciseColor,
                    isDark: isDark,
                  ),
                  _buildPlanIndicator(
                    context,
                    icon: Icons.restaurant,
                    label: 'Meals',
                    color: AppTheme.mealColor,
                    isDark: isDark,
                  ),
                  _buildPlanIndicator(
                    context,
                    icon: Icons.water_drop,
                    label: 'Water',
                    color: AppTheme.waterIntake,
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanIndicator(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? null : Colors.black87,
              ),
        ),
      ],
    );
  }
}

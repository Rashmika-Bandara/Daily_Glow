import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/services_provider.dart';
import '../../config/theme.dart';
import 'log_meal_screen.dart';

class MealsTab extends ConsumerStatefulWidget {
  const MealsTab({super.key});

  @override
  ConsumerState<MealsTab> createState() => _MealsTabState();
}

class _MealsTabState extends ConsumerState<MealsTab> {
  bool _showHistory = false;
  int _refreshKey = 0;

  void _refresh() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dailyMealService = ref.watch(dailyMealServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(_showHistory ? Icons.today : Icons.history),
            onPressed: () {
              setState(() {
                _showHistory = !_showHistory;
              });
            },
            tooltip: _showHistory ? 'Show Today\'s Plan' : 'Show History',
          ),
        ],
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
        child: _showHistory
            ? _buildHistoryView()
            : _buildTodaysPlanView(dailyMealService, isDark),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LogMealScreen()),
          ).then((_) => _refresh());
        },
        icon: const Icon(Icons.add),
        label: Text(_showHistory ? 'Log Meal' : 'Add Custom Meal'),
        backgroundColor: AppTheme.mealColor,
      ),
    );
  }

  Widget _buildTodaysPlanView(DailyMealService service, bool isDark) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: service.getTodaysMealPlan(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red.withOpacity(0.7),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Error Loading Meal Plan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Please try again later',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final planData = snapshot.data;

        if (planData == null) {
          return _buildNoPlanView(isDark);
        }

        if (planData['status'] == 'waiting') {
          return _buildWaitingView(planData, isDark);
        }

        return _buildActivePlanView(planData, isDark);
      },
    );
  }

  Widget _buildNoPlanView(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu_outlined,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Active Meal Plan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Set up your Health Habit Plan to get personalized daily meal plans!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go to Dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryLight,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingView(Map<String, dynamic> planData, bool isDark) {
    final startDate = planData['startDate'] as DateTime;
    final daysUntilStart = startDate.difference(DateTime.now()).inDays + 1;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.schedule,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Get Ready!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              planData['message'] as String,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '$daysUntilStart',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    daysUntilStart == 1 ? 'Day to Go' : 'Days to Go',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '🍽️ Prepare your kitchen and ingredients',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.6),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlanView(Map<String, dynamic> planData, bool isDark) {
    final dayNumber = planData['dayNumber'] as int;
    final date = planData['date'] as DateTime;
    final meals = planData['meals'] as Map<String, dynamic>;
    final totalCalories = planData['totalCalories'] as int;
    final dailyMealService = ref.watch(dailyMealServiceProvider);

    return FutureBuilder<Map<String, String>>(
      key: ValueKey('meal_status_$_refreshKey'),
      future: dailyMealService.getMealStatus(),
      builder: (context, statusSnapshot) {
        final mealStatuses = statusSnapshot.data ??
            {
              'breakfast': 'not_yet',
              'lunch': 'not_yet',
              'snack': 'not_yet',
              'dinner': 'not_yet',
            };

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.mealColor.withOpacity(0.8),
                      AppTheme.mealColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.mealColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Day $dayNumber',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          DateFormat('EEEE, MMM dd').format(date),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Daily Calorie Target
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: isDark ? Colors.grey[850] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$totalCalories kcal',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                'Daily Target',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Meal Plan Cards
              Text(
                'Today\'s Meal Plan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 12),

              if (meals['breakfast'] != null)
                _buildMealCard(
                    'Breakfast',
                    'breakfast',
                    meals['breakfast']!,
                    mealStatuses['breakfast'] ?? 'not_yet',
                    Icons.wb_sunny,
                    Colors.orange,
                    isDark,
                    dailyMealService),
              if (meals['lunch'] != null)
                _buildMealCard(
                    'Lunch',
                    'lunch',
                    meals['lunch']!,
                    mealStatuses['lunch'] ?? 'not_yet',
                    Icons.wb_cloudy,
                    Colors.blue,
                    isDark,
                    dailyMealService),
              if (meals['snack'] != null)
                _buildMealCard(
                    'Snack',
                    'snack',
                    meals['snack']!,
                    mealStatuses['snack'] ?? 'not_yet',
                    Icons.cookie,
                    Colors.brown,
                    isDark,
                    dailyMealService),
              if (meals['dinner'] != null)
                _buildMealCard(
                    'Dinner',
                    'dinner',
                    meals['dinner']!,
                    mealStatuses['dinner'] ?? 'not_yet',
                    Icons.nightlight,
                    Colors.indigo,
                    isDark,
                    dailyMealService),

              const SizedBox(height: 24),

              // Today's Logged Meals
              _buildTodaysLoggedMeals(isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMealCard(
      String mealType,
      String mealKey,
      Map<String, dynamic> mealData,
      String status,
      IconData icon,
      Color color,
      bool isDark,
      DailyMealService dailyMealService) {
    final items = (mealData['items'] as List<dynamic>?) ?? [];
    final totalCalories = (mealData['totalCalories'] as int?) ?? 0;
    final totalProtein = ((mealData['totalProtein'] as num?) ?? 0).toDouble();
    final totalCarbs = ((mealData['totalCarbs'] as num?) ?? 0).toDouble();
    final totalFat = ((mealData['totalFat'] as num?) ?? 0).toDouble();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDark ? Colors.grey[850] : Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  mealType,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              _buildStatusBadge(status, isDark),
            ],
          ),
          subtitle: Text(
            '$totalCalories kcal',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  // Food Items
                  ...items.map((item) {
                    final itemMap = item as Map<String, dynamic>?;
                    if (itemMap == null) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 6, color: color),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${itemMap['name'] ?? 'Unknown'} (${itemMap['weight'] ?? '0g'})',
                              style: TextStyle(
                                color:
                                    isDark ? Colors.grey[300] : Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            '${itemMap['calories'] ?? 0} kcal',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  // Macros
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMacroItem(
                            'Protein',
                            '${totalProtein.toStringAsFixed(1)}g',
                            Colors.red,
                            isDark),
                        _buildMacroItem(
                            'Carbs',
                            '${totalCarbs.toStringAsFixed(1)}g',
                            Colors.blue,
                            isDark),
                        _buildMacroItem(
                            'Fat',
                            '${totalFat.toStringAsFixed(1)}g',
                            Colors.orange,
                            isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Status Buttons
                  Text(
                    'Meal Status',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusButtons(
                      mealKey, status, isDark, dailyMealService),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButtons(String mealKey, String currentStatus, bool isDark,
      DailyMealService dailyMealService) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildStatusButton(
          'Had it',
          'completed',
          currentStatus,
          Icons.check_circle,
          Colors.green,
          isDark,
          () async {
            await dailyMealService.saveMealStatus(mealKey, 'completed');
            _refresh();
          },
        ),
        _buildStatusButton(
          'Not Yet',
          'not_yet',
          currentStatus,
          Icons.schedule,
          Colors.orange,
          isDark,
          () async {
            await dailyMealService.saveMealStatus(mealKey, 'not_yet');
            _refresh();
          },
        ),
        _buildStatusButton(
          'Missed',
          'missed',
          currentStatus,
          Icons.close_rounded,
          Colors.red,
          isDark,
          () async {
            await dailyMealService.saveMealStatus(mealKey, 'missed');
            _refresh();
          },
        ),
      ],
    );
  }

  Widget _buildStatusButton(
    String label,
    String statusValue,
    String currentStatus,
    IconData icon,
    Color color,
    bool isDark,
    VoidCallback onPressed,
  ) {
    final isSelected = currentStatus == statusValue;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 16,
        color: isSelected ? Colors.white : color,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : (isDark ? Colors.white70 : color),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? color : (isDark ? Colors.grey[800] : Colors.grey[200]),
        foregroundColor: isSelected ? Colors.white : color,
        elevation: isSelected ? 4 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
      ),
    );
  }

  Widget _buildMacroItem(String label, String value, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status, bool isDark) {
    Color badgeColor;
    IconData badgeIcon;
    String badgeText;

    switch (status) {
      case 'completed':
        badgeColor = Colors.green;
        badgeIcon = Icons.check_circle;
        badgeText = 'Had it';
        break;
      case 'missed':
        badgeColor = Colors.red;
        badgeIcon = Icons.close_rounded;
        badgeText = 'Missed';
        break;
      case 'not_yet':
      default:
        badgeColor = Colors.orange;
        badgeIcon = Icons.schedule;
        badgeText = 'Not Yet';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            size: 14,
            color: badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            badgeText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysLoggedMeals(bool isDark) {
    final activityService = ref.watch(activityServiceProvider);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: activityService.getTodayMeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        final todayMeals = snapshot.data ?? [];

        if (todayMeals.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Logged Meals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 12),
            ...todayMeals.map((meal) => _buildLoggedMealCard(meal, isDark)),
          ],
        );
      },
    );
  }

  Widget _buildLoggedMealCard(Map<String, dynamic> meal, bool isDark) {
    final mealType = meal['mealType'] as String? ?? 'Meal';
    final calories = (meal['calories'] as num?)?.toDouble() ?? 0;
    final protein = (meal['protein'] as num?)?.toDouble();
    final carbs = (meal['carbs'] as num?)?.toDouble();
    final fat = (meal['fat'] as num?)?.toDouble();
    final dateStr = meal['mealTime'] as String?;

    String timeStr = '';
    if (dateStr != null) {
      try {
        final mealTime = DateTime.parse(dateStr);
        final hour = mealTime.hour;
        final minute = mealTime.minute.toString().padLeft(2, '0');
        final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        timeStr = '$displayHour:$minute $period';
      } catch (e) {
        timeStr = '';
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDark ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.mealColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: AppTheme.mealColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mealType,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${calories.toInt()} kcal',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      if (timeStr.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[500] : Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Logged',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (protein != null && carbs != null && fat != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.mealColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMacroItem('Protein', '${protein.toStringAsFixed(1)}g',
                        Colors.red, isDark),
                    _buildMacroItem('Carbs', '${carbs.toStringAsFixed(1)}g',
                        Colors.blue, isDark),
                    _buildMacroItem('Fat', '${fat.toStringAsFixed(1)}g',
                        Colors.orange, isDark),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryView() {
    final activityService = ref.watch(activityServiceProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: activityService.getTodayMeals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
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
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: isDark ? Colors.grey[850] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 50,
                        color: AppTheme.mealColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${totalCalories.toStringAsFixed(0)} kcal',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Today',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.mealColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMacroItem(
                              'Protein',
                              '${meals.fold<double>(0, (sum, m) => sum + (m['protein'] as num? ?? 0).toDouble()).toStringAsFixed(0)}g',
                              Colors.red,
                              isDark,
                            ),
                            _buildMacroItem(
                              'Carbs',
                              '${meals.fold<double>(0, (sum, m) => sum + (m['carbs'] as num? ?? 0).toDouble()).toStringAsFixed(0)}g',
                              Colors.blue,
                              isDark,
                            ),
                            _buildMacroItem(
                              'Fat',
                              '${meals.fold<double>(0, (sum, m) => sum + (m['fat'] as num? ?? 0).toDouble()).toStringAsFixed(0)}g',
                              Colors.orange,
                              isDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Today's Meals Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Meals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          isDark ? Colors.white : Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${meals.length} meals',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (meals.isEmpty)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: isDark ? Colors.grey[850] : Colors.white,
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to log your first meal',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[500] : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...meals.map((meal) => _buildHistoryMealCard(meal, isDark)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMacroChip(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.mealColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white : AppTheme.mealColor,
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

  Widget _buildHistoryMealCard(Map<String, dynamic> meal, bool isDark) {
    final mealType = meal['mealType'] as String? ?? 'meal';
    final foodItems = meal['foodItems'] as List<dynamic>? ?? [];
    final calories = (meal['calories'] as num?)?.toDouble() ?? 0;
    final protein = (meal['protein'] as num?)?.toDouble() ?? 0;
    final carbs = (meal['carbs'] as num?)?.toDouble() ?? 0;
    final fat = (meal['fat'] as num?)?.toDouble() ?? 0;
    final date = meal['date'] as String?;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDark ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getMealIcon(mealType),
                  color: AppTheme.mealColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  mealType[0].toUpperCase() + mealType.substring(1),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  '${calories.toStringAsFixed(0)} kcal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.mealColor,
                  ),
                ),
              ],
            ),
            if (foodItems.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                foodItems.join(', '),
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMacroChip('P: ${protein.toStringAsFixed(0)}g', isDark),
                const SizedBox(width: 8),
                _buildMacroChip('C: ${carbs.toStringAsFixed(0)}g', isDark),
                const SizedBox(width: 8),
                _buildMacroChip('F: ${fat.toStringAsFixed(0)}g', isDark),
              ],
            ),
            if (date != null) ...[
              const SizedBox(height: 8),
              Text(
                _formatTime(date),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

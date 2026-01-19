import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/services_provider.dart';
import '../../services/daily_water_service.dart';
import '../../config/theme.dart';
import 'water_intake_screen.dart';

class WaterTab extends ConsumerStatefulWidget {
  const WaterTab({super.key});

  @override
  ConsumerState<WaterTab> createState() => _WaterTabState();
}

class _WaterTabState extends ConsumerState<WaterTab> {
  bool _showHistory = false;
  int _refreshKey = 0;

  void _refresh() {
    setState(() {
      _refreshKey++;
    });
  }

  Future<void> _quickLogWater(double amount) async {
    try {
      final activityService = ref.read(activityServiceProvider);
      await activityService.logWater(amount: amount);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged ${amount}L of water!'),
            backgroundColor: AppTheme.waterIntake,
            duration: const Duration(seconds: 1),
          ),
        );
        _refresh();
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dailyWaterService = ref.watch(dailyWaterServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Intake'),
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
            : _buildTodaysPlanView(dailyWaterService, isDark),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WaterIntakeScreen()),
          ).then((_) => _refresh());
        },
        icon: const Icon(Icons.add),
        label: Text(_showHistory ? 'Log Water' : 'Add Custom Intake'),
        backgroundColor: AppTheme.waterIntake,
      ),
    );
  }

  Widget _buildTodaysPlanView(DailyWaterService service, bool isDark) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: service.getTodaysWaterPlan(),
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
                    'Error Loading Water Plan',
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
                Icons.water_drop_outlined,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Active Water Plan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Set up your Health Habit Plan to get personalized daily water intake schedules!',
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
              '💧 Keep your water bottle ready!',
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
    final schedule = planData['schedule'] as List<dynamic>;
    final totalWater = planData['totalWater'] as double;
    final dailyWaterService = ref.watch(dailyWaterServiceProvider);

    return FutureBuilder<Map<String, double>>(
      key: ValueKey('water_status_$_refreshKey'),
      future: dailyWaterService.getWaterIntakeStatus(),
      builder: (context, statusSnapshot) {
        final waterIntakes = statusSnapshot.data ?? {};

        // Calculate consumed water
        double consumedWater = 0;
        waterIntakes.forEach((key, value) {
          consumedWater += value;
        });

        final progress =
            totalWater > 0 ? (consumedWater / totalWater).clamp(0.0, 1.0) : 0.0;

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
                      AppTheme.waterIntake.withOpacity(0.8),
                      AppTheme.waterIntake,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.waterIntake.withOpacity(0.3),
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
                        Icons.water_drop,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Progress Card
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
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 160,
                            width: 160,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 12,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.waterIntake),
                            ),
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.water_drop,
                                color: AppTheme.waterIntake,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(progress * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${consumedWater.toStringAsFixed(0)} / ${totalWater.toStringAsFixed(0)} ml',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                      Text(
                        'Daily Goal',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Water Schedule
              Text(
                'Today\'s Water Schedule',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 12),

              ...schedule.map((intake) {
                final intakeMap = intake as Map<String, dynamic>;
                final time = intakeMap['time'] as String;
                final amount = intakeMap['amount'] as String;
                final amountValue = double.tryParse(
                        amount.replaceAll(RegExp(r'[^0-9.]'), '')) ??
                    0;
                final consumed = waterIntakes[time] ?? 0;

                return _buildWaterIntakeCard(
                  time,
                  amount,
                  amountValue,
                  consumed,
                  isDark,
                  dailyWaterService,
                );
              }),

              const SizedBox(height: 24),

              // Today's Logged Water
              _buildTodaysLoggedWater(isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWaterIntakeCard(
    String time,
    String amount,
    double amountValue,
    double consumed,
    bool isDark,
    DailyWaterService dailyWaterService,
  ) {
    final isCompleted = consumed >= amountValue;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDark ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.waterIntake.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : Icons.water_drop_outlined,
                color: isCompleted ? AppTheme.waterIntake : Colors.grey,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  if (consumed > 0 && consumed < amountValue) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${consumed.toStringAsFixed(0)} ml consumed',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!isCompleted)
              ElevatedButton.icon(
                onPressed: () async {
                  await dailyWaterService.saveWaterIntakeStatus(
                      time, amountValue);
                  _refresh();
                },
                icon: const Icon(Icons.add_circle, size: 16),
                label: const Text('Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.waterIntake,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Done',
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
      ),
    );
  }

  Widget _buildTodaysLoggedWater(bool isDark) {
    final activityService = ref.watch(activityServiceProvider);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: activityService.getTodayWaterEntries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        final todayWater = snapshot.data ?? [];

        if (todayWater.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Logged Water',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 12),
            ...todayWater.map((water) => _buildLoggedWaterCard(water, isDark)),
          ],
        );
      },
    );
  }

  Widget _buildLoggedWaterCard(Map<String, dynamic> water, bool isDark) {
    final amount = (water['amount'] as num?)?.toDouble() ?? 0;
    final dateStr = water['date'] as String?;

    String timeStr = '';
    if (dateStr != null) {
      try {
        final waterTime = DateTime.parse(dateStr);
        final hour = waterTime.hour;
        final minute = waterTime.minute.toString().padLeft(2, '0');
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.waterIntake.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.water_drop,
                color: AppTheme.waterIntake,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${(amount * 1000).toInt()} ml',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (timeStr.isNotEmpty) ...[
                    const SizedBox(height: 4),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
      ),
    );
  }

  Widget _buildHistoryView() {
    final activityService = ref.watch(activityServiceProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: activityService.getTodayWaterEntries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final waterEntries = snapshot.data ?? [];
        final todayTotal = waterEntries.fold<double>(
          0.0,
          (sum, entry) => sum + ((entry['amount'] as num?)?.toDouble() ?? 0.0),
        );
        const dailyGoal = 2.5; // liters
        final progress = (todayTotal / dailyGoal).clamp(0.0, 1.0);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Card
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: isDark ? Colors.grey[850] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 180,
                            width: 180,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 14,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.waterIntake),
                            ),
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.water_drop,
                                color: AppTheme.waterIntake,
                                size: 50,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${todayTotal.toStringAsFixed(1)}L',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                'of $dailyGoal L',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${(progress * 100).toStringAsFixed(0)}% Complete',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.waterIntake,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Log',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _WaterButton(
                      amount: 0.25,
                      label: '250ml',
                      onTap: () => _quickLogWater(0.25),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _WaterButton(
                      amount: 0.5,
                      label: '500ml',
                      onTap: () => _quickLogWater(0.5),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _WaterButton(
                      amount: 1.0,
                      label: '1L',
                      onTap: () => _quickLogWater(1.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WaterButton extends StatelessWidget {
  final double amount;
  final String label;
  final VoidCallback onTap;

  const _WaterButton({
    super.key,
    required this.amount,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.waterIntake,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.water_drop, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

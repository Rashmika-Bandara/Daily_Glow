import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/services_provider.dart';
import '../../services/daily_workout_service.dart';
import '../../config/theme.dart';
import '../exercise/log_exercise_screen.dart';
import '../exercise/edit_exercise_screen.dart';

class WorkoutsTab extends ConsumerStatefulWidget {
  const WorkoutsTab({super.key});

  @override
  ConsumerState<WorkoutsTab> createState() => _WorkoutsTabState();
}

class _WorkoutsTabState extends ConsumerState<WorkoutsTab> {
  bool _showHistory = false;
  int _refreshKey = 0;

  void _refresh() {
    setState(() {
      _refreshKey++;
    });
  }

  Future<void> _deleteExercise(String exerciseId, String activityType) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workout'),
        content: Text('Are you sure you want to delete "$activityType"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final activityService = ref.read(activityServiceProvider);
        await activityService.deleteExercise(exerciseId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Workout deleted successfully!'),
              backgroundColor: Colors.green,
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
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dailyWorkoutService = ref.watch(dailyWorkoutServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
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
            : _buildTodaysPlanView(dailyWorkoutService, isDark),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LogExerciseScreen()),
          ).then((_) => _refresh());
        },
        icon: const Icon(Icons.add),
        label: Text(_showHistory ? 'Log Workout' : 'Add Custom Workout'),
        backgroundColor: AppTheme.exerciseColor,
      ),
    );
  }

  Widget _buildTodaysPlanView(DailyWorkoutService service, bool isDark) {
    return FutureBuilder<Map<String, dynamic>?>(
      key: ValueKey('workout_plan_$_refreshKey'),
      future: service.getTodaysWorkoutPlan(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final planData = snapshot.data;

        if (planData == null) {
          return _buildNoPlanView(isDark);
        }

        if (planData['status'] == 'waiting') {
          return _buildWaitingView(planData, isDark);
        }

        return _buildActivePlanView(planData, service, isDark);
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
                Icons.calendar_today_outlined,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Active Plan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Set up your Health Habit Plan to get started with personalized daily workouts!',
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
                // Navigate to Dashboard where they can access Health Plan
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
              '💪 Prepare yourself mentally and physically',
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

  Widget _buildActivePlanView(
      Map<String, dynamic> planData, DailyWorkoutService service, bool isDark) {
    final dayNumber = planData['dayNumber'] as int;
    final workout = planData['workout'] as Map<String, dynamic>;
    final completionStatus = planData['completionStatus'] as String;
    final date = planData['date'] as DateTime;

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
                  AppTheme.exerciseColor.withOpacity(0.8),
                  AppTheme.exerciseColor,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.exerciseColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
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
                        Icons.fitness_center,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Workout Details Card
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: isDark ? Colors.grey[850] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.exerciseColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.sports_gymnastics,
                          color: AppTheme.exerciseColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today\'s Workout',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              workout['focus'] as String,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Duration and Calories
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoTile(
                          icon: Icons.timer_outlined,
                          label: 'Duration',
                          value: workout['duration'] as String,
                          color: Colors.blue,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoTile(
                          icon: Icons.local_fire_department,
                          label: 'Target Burn',
                          value: workout['calories'] as String,
                          color: Colors.orange,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Status Section
          Text(
            'Workout Status',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),

          // Status Buttons
          _buildStatusButtons(completionStatus, service),

          const SizedBox(height: 24),

          // Motivational Message
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getMotivationIcon(completionStatus),
                  color: Colors.white.withOpacity(0.8),
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _getMotivationalMessage(completionStatus),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Today's Logged Workouts Section
          _buildTodaysLoggedWorkouts(isDark),
        ],
      ),
    );
  }

  Widget _buildTodaysLoggedWorkouts(bool isDark) {
    final activityService = ref.watch(activityServiceProvider);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: activityService.getTodayExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        final todayWorkouts = snapshot.data ?? [];

        if (todayWorkouts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Logged Workouts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 12),
            ...todayWorkouts
                .map((workout) => _buildLoggedWorkoutCard(workout, isDark)),
          ],
        );
      },
    );
  }

  Widget _buildLoggedWorkoutCard(Map<String, dynamic> workout, bool isDark) {
    final activityType = workout['activityType'] as String? ?? 'Unknown';
    final duration = (workout['duration'] as num?)?.toDouble() ?? 0;
    final caloriesBurned = (workout['caloriesBurned'] as num?)?.toDouble() ?? 0;
    final startTimeStr = workout['startTime'] as String?;

    String timeStr = '';
    if (startTimeStr != null) {
      try {
        final startTime = DateTime.parse(startTimeStr);
        final hour = startTime.hour;
        final minute = startTime.minute.toString().padLeft(2, '0');
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
                color: AppTheme.exerciseColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.fitness_center,
                color: AppTheme.exerciseColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activityType,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${duration.toInt()} min • ${caloriesBurned.toInt()} cal',
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
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
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

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButtons(
      String currentStatus, DailyWorkoutService service) {
    final statuses = [
      {
        'value': 'completed',
        'label': 'Completed',
        'icon': Icons.check_circle,
        'color': Colors.green
      },
      {
        'value': 'in_progress',
        'label': 'In Progress',
        'icon': Icons.play_circle,
        'color': Colors.blue
      },
      {
        'value': 'not_yet',
        'label': 'Not Yet',
        'icon': Icons.schedule,
        'color': Colors.orange
      },
      {
        'value': 'skipped',
        'label': 'Skipped',
        'icon': Icons.cancel,
        'color': Colors.red
      },
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: statuses.map((status) {
        final isSelected = currentStatus == status['value'];
        final color = status['color'] as Color;

        return InkWell(
          onTap: () async {
            try {
              await service.updateWorkoutStatus(status['value'] as String);
              _refresh();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Status updated to ${status['label']}'),
                    backgroundColor: color,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
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
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  status['icon'] as IconData,
                  color:
                      isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  status['label'] as String,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getMotivationIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.emoji_events;
      case 'in_progress':
        return Icons.directions_run;
      case 'not_yet':
        return Icons.watch_later;
      case 'skipped':
        return Icons.info_outline;
      default:
        return Icons.fitness_center;
    }
  }

  String _getMotivationalMessage(String status) {
    switch (status) {
      case 'completed':
        return '🎉 Excellent work! You\'ve completed today\'s workout. Keep up the momentum!';
      case 'in_progress':
        return '💪 You\'re doing great! Keep pushing through your workout!';
      case 'not_yet':
        return '⏰ No worries! Start when you\'re ready. Your health journey awaits!';
      case 'skipped':
        return '🔄 That\'s okay! Tomorrow is a new opportunity to get back on track!';
      default:
        return '🚀 Ready to start? Let\'s make today count!';
    }
  }

  Widget _buildHistoryView() {
    final activityService = ref.watch(activityServiceProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: activityService.getAllExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final exercises = snapshot.data ?? [];

        if (exercises.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.fitness_center_outlined,
                  size: 80,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No workout history yet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start logging your exercises!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }

        // Calculate totals
        final totalDuration = exercises.fold<double>(
          0,
          (sum, exercise) =>
              sum + ((exercise['duration'] as num?)?.toDouble() ?? 0),
        );
        final totalCalories = exercises.fold<double>(
          0,
          (sum, exercise) =>
              sum + ((exercise['caloriesBurned'] as num?)?.toDouble() ?? 0),
        );

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: exercises.length + 1, // +1 for summary card
          itemBuilder: (context, index) {
            if (index == 0) {
              // Summary card at the top
              return Column(
                children: [
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
                            Icons.fitness_center,
                            size: 50,
                            color: AppTheme.exerciseColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Total Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        color: Colors.blue,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${totalDuration.toInt()} min',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        'Total Time',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.local_fire_department,
                                        color: Colors.orange,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${totalCalories.toInt()} kcal',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        'Total Burned',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(
                              color:
                                  isDark ? Colors.grey[700] : Colors.grey[300]),
                          const SizedBox(height: 8),
                          Text(
                            '${exercises.length} Workout${exercises.length != 1 ? 's' : ''} Logged',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }

            final exercise = exercises[index - 1];
            return _buildExerciseCard(context, exercise, isDark);
          },
        );
      },
    );
  }

  Widget _buildExerciseCard(
      BuildContext context, Map<String, dynamic> exercise, bool isDark) {
    final activityType = exercise['activityType'] as String? ?? 'Unknown';
    final duration = (exercise['duration'] as num?)?.toDouble() ?? 0;
    final caloriesBurned =
        (exercise['caloriesBurned'] as num?)?.toDouble() ?? 0;
    final intensity = exercise['intensity'] as String? ?? 'moderate';
    final notes = exercise['notes'] as String? ?? '';
    final dateStr = exercise['date'] as String?;
    final startTimeStr = exercise['startTime'] as String?;
    final exerciseId = exercise['id'] as String;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? Colors.grey[850] : Colors.white,
      child: InkWell(
        onTap: () {
          _showExerciseDetails(context, exercise);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.exerciseColor.withOpacity(0.1),
                    child: const Icon(
                      Icons.fitness_center,
                      color: AppTheme.exerciseColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activityType,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${duration.toInt()} min • ${caloriesBurned.toInt()} cal',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(intensity),
                    backgroundColor: _getIntensityColor(intensity),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (dateStr != null || startTimeStr != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (dateStr != null) ...[
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(dateStr),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                    if (startTimeStr != null) ...[
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(startTimeStr),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ],
                ),
              ],
              if (notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  notes,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontStyle: FontStyle.italic),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditExerciseScreen(exercise: exercise),
                        ),
                      ).then((_) => _refresh());
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit'),
                  ),
                  TextButton.icon(
                    onPressed: () => _deleteExercise(exerciseId, activityType),
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExerciseDetails(
      BuildContext context, Map<String, dynamic> exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exercise['activityType'] as String? ?? 'Workout Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Duration',
                  '${(exercise['duration'] as num?)?.toInt() ?? 0} minutes'),
              _buildDetailRow('Calories',
                  '${(exercise['caloriesBurned'] as num?)?.toInt() ?? 0} kcal'),
              _buildDetailRow(
                  'Intensity', exercise['intensity'] as String? ?? 'N/A'),
              if (exercise['date'] != null)
                _buildDetailRow(
                    'Date', _formatDate(exercise['date'] as String)),
              if (exercise['startTime'] != null)
                _buildDetailRow(
                    'Start Time', _formatTime(exercise['startTime'] as String)),
              if (exercise['notes'] != null &&
                  (exercise['notes'] as String).isNotEmpty)
                _buildDetailRow('Notes', exercise['notes'] as String),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color _getIntensityColor(String intensity) {
    switch (intensity.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'very_high':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(date).inDays;

      if (diff == 0) {
        return 'Today';
      } else if (diff == 1) {
        return 'Yesterday';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'N/A';
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
      return 'N/A';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/user_provider.dart';
import '../exercise/log_exercise_screen.dart';
import '../water/water_intake_screen.dart';
import '../meal/log_meal_screen.dart';
import '../goals/goals_screen.dart';

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    // final dashboard = ref.watch(dashboardProvider); // Unused for now
    final todayProgress = ref.watch(todayProgressProvider);
    final activeStreaks = ref.watch(activeStreaksProvider);

    if (user == null) {
      return const Center(child: Text('Please login'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Glow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            _buildWelcomeCard(context, user.username),
            const SizedBox(height: 20),

            // Progress Ring
            _buildProgressCard(context, todayProgress),
            const SizedBox(height: 20),

            // Streaks
            if (activeStreaks.isNotEmpty) ...[
              _buildStreaksCard(context, activeStreaks),
              const SizedBox(height: 20),
            ],

            // Quick Stats
            _buildQuickStats(context, user),
            const SizedBox(height: 20),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildQuickActions(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LogExerciseScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Log Activity'),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, String username) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.waving_hand,
                color: AppTheme.primaryLight,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    username,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.streakAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: AppTheme.streakAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, double progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Today\'s Progress',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: progress / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryLight,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${progress.toInt()}%',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryLight,
                          ),
                    ),
                    Text(
                      'Complete',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              progress < 30
                  ? 'Just getting started! Keep going! 💪'
                  : progress < 70
                  ? 'Great progress today! 🌟'
                  : 'Amazing work! You\'re crushing it! 🔥',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreaksCard(BuildContext context, List<String> streaks) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: AppTheme.streakAccent,
                ),
                const SizedBox(width: 8),
                Text(
                  'Active Streaks',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...streaks.map(
              (streak) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.streakAccent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(streak),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, user) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.fitness_center,
            title: 'Exercises',
            value: user.exerciseHistory.length.toString(),
            color: AppTheme.exerciseColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.water_drop,
            title: 'Water (L)',
            value: user.waterIntakeHistory.isEmpty
                ? '0'
                : user.waterIntakeHistory.last.intakeAmountLiters
                      .toStringAsFixed(1),
            color: AppTheme.waterIntake,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.restaurant,
            title: 'Meals',
            value: user.meals.length.toString(),
            color: AppTheme.mealColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        _QuickActionButton(
          icon: Icons.fitness_center,
          label: 'Log Exercise',
          color: AppTheme.exerciseColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LogExerciseScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _QuickActionButton(
          icon: Icons.water_drop,
          label: 'Log Water',
          color: AppTheme.waterIntake,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WaterIntakeScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _QuickActionButton(
          icon: Icons.restaurant,
          label: 'Log Meal',
          color: AppTheme.mealColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LogMealScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _QuickActionButton(
          icon: Icons.flag,
          label: 'View Goals',
          color: AppTheme.primaryLight,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GoalsScreen()),
            );
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

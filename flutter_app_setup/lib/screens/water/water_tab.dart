import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/services_provider.dart';
import '../../config/theme.dart';
import 'water_intake_screen.dart';

class WaterTab extends ConsumerStatefulWidget {
  const WaterTab({super.key});

  @override
  ConsumerState<WaterTab> createState() => _WaterTabState();
}

class _WaterTabState extends ConsumerState<WaterTab> {
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
        setState(() {});
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
    final activityService = ref.watch(activityServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Intake'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<double>(
        future: activityService.getTodayWaterIntake(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final todayTotal = snapshot.data ?? 0.0;
          const dailyGoal = 2.5;
          final progress = (todayTotal / dailyGoal).clamp(0.0, 1.0);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 16,
                                backgroundColor: const Color(0xFFBDBDBD),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.waterIntake,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.water_drop,
                                  size: 50,
                                  color: AppTheme.waterIntake,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${todayTotal.toStringAsFixed(1)}L',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.waterIntake,
                                      ),
                                ),
                                Text(
                                  'of ${dailyGoal.toStringAsFixed(1)}L',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          progress >= 1.0
                              ? '🎉 Goal achieved! Great hydration!'
                              : progress >= 0.7
                                  ? '💧 Almost there! Keep going!'
                                  : progress >= 0.4
                                      ? '👍 Good progress!'
                                      : '💪 Let\'s stay hydrated!',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Add Section
                Text(
                  'Quick Add',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

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
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _WaterButton(
                        amount: 0.75,
                        label: '750ml',
                        onTap: () => _quickLogWater(0.75),
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
                const SizedBox(height: 24),

                // More Options Button
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WaterIntakeScreen(),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  icon: const Icon(Icons.more_horiz),
                  label: const Text('More Options'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WaterButton extends StatelessWidget {
  final double amount;
  final String label;
  final VoidCallback onTap;

  const _WaterButton({
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

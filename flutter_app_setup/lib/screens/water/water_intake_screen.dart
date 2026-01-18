import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/services_provider.dart';
import '../../config/theme.dart';

class WaterIntakeScreen extends ConsumerStatefulWidget {
  const WaterIntakeScreen({super.key});

  @override
  ConsumerState<WaterIntakeScreen> createState() => _WaterIntakeScreenState();
}

class _WaterIntakeScreenState extends ConsumerState<WaterIntakeScreen> {
  final _customAmountController = TextEditingController();

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  Future<void> _logWater(double amount) async {
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

  void _logCustomAmount() {
    final amount = double.tryParse(_customAmountController.text);
    if (amount != null && amount > 0) {
      _logWater(amount);
      _customAmountController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // For now, using placeholder values since we're not tracking state in UI yet
    const todayTotal = 0.0;
    const dailyGoal = 2.5;
    final progress = (todayTotal / dailyGoal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Water Intake')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.waterIntake,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
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

            // Quick Add Buttons
            Text(
              'Quick Add',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _WaterButton(
                    amount: 0.25,
                    label: '250ml',
                    onTap: () => _logWater(0.25),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _WaterButton(
                    amount: 0.5,
                    label: '500ml',
                    onTap: () => _logWater(0.5),
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
                    onTap: () => _logWater(0.75),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _WaterButton(
                    amount: 1.0,
                    label: '1L',
                    onTap: () => _logWater(1.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Custom Amount
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Custom Amount',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customAmountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter liters',
                              prefixIcon: Icon(Icons.water_drop),
                              suffixText: 'L',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _logCustomAmount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.waterIntake,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Hydration Tips
            Card(
              color: AppTheme.waterIntake.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: AppTheme.waterIntake,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Hydration Tips',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.waterIntake,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('• Drink water first thing in the morning'),
                    const SizedBox(height: 4),
                    const Text('• Keep a water bottle with you'),
                    const SizedBox(height: 4),
                    const Text('• Drink before, during, and after exercise'),
                    const SizedBox(height: 4),
                    const Text('• Set reminders to drink water'),
                  ],
                ),
              ),
            ),
          ],
        ),
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
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Icon(Icons.water_drop, size: 40, color: AppTheme.waterIntake),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

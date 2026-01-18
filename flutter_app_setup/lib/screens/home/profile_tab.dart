import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/services_provider.dart';
import '../../widgets/avatar_selector.dart';
import '../auth/login_screen.dart';
import '../notifications/notifications_screen.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authStateProvider);
    final userData = ref.watch(currentUserDataProvider);

    // Check authentication and loading states
    if (authUser.isLoading || userData.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (authUser.value == null || userData.value == null) {
      return const Scaffold(
        body: Center(child: Text('Please login')),
      );
    }

    final username = userData.value?['username'] ?? 'User';
    final email = userData.value?['email'] ?? '';
    final avatar = userData.value?['avatar'] as String? ?? 'boy';
    final gender = userData.value?['gender'] as String? ?? 'Not set';
    final age = userData.value?['age'] as int?;
    final height = userData.value?['height'] as double?;
    final weight = userData.value?['weight'] as double?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AvatarDisplay(avatar: avatar, size: 100),
                    const SizedBox(height: 16),
                    Text(
                      username,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // User Stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatRow(
                      context,
                      'Gender',
                      gender[0].toUpperCase() + gender.substring(1),
                      Icons.person_outline,
                    ),
                    const Divider(height: 24),
                    _buildStatRow(
                      context,
                      'Age',
                      age != null ? '$age years' : 'Not set',
                      Icons.cake,
                    ),
                    const Divider(height: 24),
                    _buildStatRow(
                      context,
                      'Height',
                      height != null
                          ? '${height.toStringAsFixed(0)} cm'
                          : 'Not set',
                      Icons.height,
                    ),
                    const Divider(height: 24),
                    _buildStatRow(
                      context,
                      'Weight',
                      weight != null
                          ? '${weight.toStringAsFixed(1)} kg'
                          : 'Not set',
                      Icons.monitor_weight,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Settings Options
            _buildSettingsOption(context, 'Edit Profile', Icons.edit, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile coming soon!')),
              );
            }),
            _buildSettingsOption(
              context,
              'Daily Targets',
              Icons.track_changes,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Daily targets coming soon!')),
                );
              },
            ),
            _buildSettingsOption(
              context,
              'Notifications',
              Icons.notifications,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            _buildSettingsOption(context, 'Theme', Icons.palette, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme settings coming soon!')),
              );
            }),
            const SizedBox(height: 20),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(authServiceProvider).signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Logout'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryLight),
        const SizedBox(width: 16),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSettingsOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryLight),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

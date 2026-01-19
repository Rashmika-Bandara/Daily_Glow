import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/services_provider.dart';
import '../../widgets/avatar_selector.dart';
import '../auth/login_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../theme/theme_selection_screen.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authStateProvider);
    final userData = ref.watch(currentUserDataProvider);
    final unreadCount = ref.watch(unreadCountProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            children: [
              // Profile Header
              Card(
                color: isDark ? null : Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      AvatarDisplay(avatar: avatar, size: 100),
                      const SizedBox(height: 16),
                      Text(
                        username,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? null : Colors.black87,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? null : Colors.black54,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // User Stats
              Card(
                color: isDark ? null : Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? null : Colors.black87,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditProfileScreen(),
                  ),
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
                badgeCount: unreadCount.value ?? 0,
              ),
              _buildSettingsOption(context, 'Theme', Icons.palette, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ThemeSelectionScreen(),
                  ),
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
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryLight),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? null : Colors.black87,
                ),
          ),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? null : Colors.black87,
              ),
        ),
      ],
    );
  }

  Widget _buildSettingsOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    int? badgeCount,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showBadge = badgeCount != null && badgeCount > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? null : Colors.white.withOpacity(0.95),
      child: ListTile(
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: AppTheme.primaryLight),
            if (showBadge)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.grey.shade800 : Colors.white,
                      width: 2,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      badgeCount > 99 ? '99+' : badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          style: TextStyle(color: isDark ? null : Colors.black87),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? null : Colors.black54,
        ),
        onTap: onTap,
      ),
    );
  }
}

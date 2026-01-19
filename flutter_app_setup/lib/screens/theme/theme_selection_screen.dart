import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/theme_provider.dart';

class ThemeSelectionScreen extends ConsumerWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
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
              // Header
              Card(
                color: isDark ? null : Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.palette,
                        size: 64,
                        color: AppTheme.primaryLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Choose Your Theme',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? null : Colors.black87,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select the appearance that suits you best',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isDark ? null : Colors.black54,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Light Theme Option
              _buildThemeOption(
                context,
                ref,
                title: 'Light Theme',
                description: 'Bright and clean interface',
                icon: Icons.light_mode,
                themeMode: ThemeMode.light,
                currentThemeMode: currentThemeMode,
                isDark: isDark,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4158D0),
                    Color(0xFFC850C0),
                    Color(0xFFFFCC70),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Dark Theme Option
              _buildThemeOption(
                context,
                ref,
                title: 'Dark Theme',
                description: 'Easy on the eyes in low light',
                icon: Icons.dark_mode,
                themeMode: ThemeMode.dark,
                currentThemeMode: currentThemeMode,
                isDark: isDark,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F2027),
                    Color(0xFF203A43),
                    Color(0xFF2C5364),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // System Theme Option
              _buildThemeOption(
                context,
                ref,
                title: 'System Default',
                description: 'Follows your device settings',
                icon: Icons.settings_suggest,
                themeMode: ThemeMode.system,
                currentThemeMode: currentThemeMode,
                isDark: isDark,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade700,
                    Colors.grey.shade500,
                    Colors.grey.shade300,
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String description,
    required IconData icon,
    required ThemeMode themeMode,
    required ThemeMode currentThemeMode,
    required bool isDark,
    required Gradient gradient,
  }) {
    final isSelected = currentThemeMode == themeMode;

    return GestureDetector(
      onTap: () {
        ref.read(themeModeProvider.notifier).setThemeMode(themeMode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Theme changed to ${title.toLowerCase()}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Card(
        color: isDark ? null : Colors.white.withOpacity(0.95),
        elevation: isSelected ? 8 : 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? AppTheme.primaryLight : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          children: [
            // Preview Container
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? null : Colors.black87,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDark ? null : Colors.black54,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? Colors.grey : Colors.grey.shade300,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.circle,
                        color: Colors.transparent,
                        size: 24,
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
}

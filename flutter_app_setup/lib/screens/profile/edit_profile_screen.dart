import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/services_provider.dart';
import '../../widgets/avatar_selector.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  String _selectedGender = 'male';
  String _selectedAvatar = 'boy';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _loadUserData(Map<String, dynamic>? userData) {
    if (userData != null && _usernameController.text.isEmpty) {
      _usernameController.text = userData['username'] ?? '';
      _selectedGender = userData['gender'] ?? 'male';
      _selectedAvatar = userData['avatar'] ?? 'boy';

      final age = userData['age'];
      if (age != null) {
        _ageController.text = age.toString();
      }

      final height = userData['height'];
      if (height != null) {
        _heightController.text = height.toString();
      }

      final weight = userData['weight'];
      if (weight != null) {
        _weightController.text = weight.toString();
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);

      await authService.updateProfile(
        username: _usernameController.text.trim(),
        gender: _selectedGender,
        avatar: _selectedAvatar,
        age: _ageController.text.isNotEmpty
            ? int.parse(_ageController.text)
            : null,
        height: _heightController.text.isNotEmpty
            ? double.parse(_heightController.text)
            : null,
        weight: _weightController.text.isNotEmpty
            ? double.parse(_weightController.text)
            : null,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(currentUserDataProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Load user data when available
    if (userData.value != null) {
      _loadUserData(userData.value);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveProfile,
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
        child: userData.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Selection
                      Card(
                        color: isDark ? null : Colors.white.withOpacity(0.95),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Choose Avatar',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? null : Colors.black87,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: AvatarDisplay(
                                  avatar: _selectedAvatar,
                                  size: 100,
                                ),
                              ),
                              const SizedBox(height: 16),
                              AvatarSelector(
                                selectedAvatar: _selectedAvatar,
                                onAvatarSelected: (avatar) {
                                  setState(() => _selectedAvatar = avatar);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Personal Information
                      Card(
                        color: isDark ? null : Colors.white.withOpacity(0.95),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Personal Information',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? null : Colors.black87,
                                    ),
                              ),
                              const SizedBox(height: 16),

                              // Username
                              TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: const Icon(Icons.person),
                                  labelStyle: TextStyle(
                                    color: isDark ? null : Colors.black54,
                                  ),
                                ),
                                style: TextStyle(
                                  color: isDark ? null : Colors.black87,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Gender Selection
                              Text(
                                'Gender',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? null : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text(
                                        'Male',
                                        style: TextStyle(
                                          color: isDark ? null : Colors.black87,
                                        ),
                                      ),
                                      value: 'male',
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(
                                            () => _selectedGender = value!);
                                      },
                                      activeColor: AppTheme.primaryLight,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: Text(
                                        'Female',
                                        style: TextStyle(
                                          color: isDark ? null : Colors.black87,
                                        ),
                                      ),
                                      value: 'female',
                                      groupValue: _selectedGender,
                                      onChanged: (value) {
                                        setState(
                                            () => _selectedGender = value!);
                                      },
                                      activeColor: AppTheme.primaryLight,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Age
                              TextFormField(
                                controller: _ageController,
                                decoration: InputDecoration(
                                  labelText: 'Age (years)',
                                  prefixIcon: const Icon(Icons.cake),
                                  labelStyle: TextStyle(
                                    color: isDark ? null : Colors.black54,
                                  ),
                                ),
                                style: TextStyle(
                                  color: isDark ? null : Colors.black87,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    final age = int.tryParse(value);
                                    if (age == null || age < 1 || age > 120) {
                                      return 'Please enter a valid age (1-120)';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Height
                              TextFormField(
                                controller: _heightController,
                                decoration: InputDecoration(
                                  labelText: 'Height (cm)',
                                  prefixIcon: const Icon(Icons.height),
                                  labelStyle: TextStyle(
                                    color: isDark ? null : Colors.black54,
                                  ),
                                ),
                                style: TextStyle(
                                  color: isDark ? null : Colors.black87,
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}')),
                                ],
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    final height = double.tryParse(value);
                                    if (height == null ||
                                        height < 50 ||
                                        height > 300) {
                                      return 'Please enter a valid height (50-300 cm)';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Weight
                              TextFormField(
                                controller: _weightController,
                                decoration: InputDecoration(
                                  labelText: 'Weight (kg)',
                                  prefixIcon: const Icon(Icons.monitor_weight),
                                  labelStyle: TextStyle(
                                    color: isDark ? null : Colors.black54,
                                  ),
                                ),
                                style: TextStyle(
                                  color: isDark ? null : Colors.black87,
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}')),
                                ],
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    final weight = double.tryParse(value);
                                    if (weight == null ||
                                        weight < 20 ||
                                        weight > 500) {
                                      return 'Please enter a valid weight (20-500 kg)';
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

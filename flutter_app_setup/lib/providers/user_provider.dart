import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/exercise.dart';
import '../models/meal.dart';
import '../models/goal.dart';
import '../models/model_extensions.dart';

/// User State Provider
/// Manages the current authenticated user and all user-related operations
class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  /// Create a new user account
  bool createAccount({
    required String userID,
    required String username,
    required String email,
    required String password,
  }) {
    try {
      final newUser = User(
        userID: userID,
        username: username,
        email: email,
        password: password,
      );
      newUser.createAccount();
      state = newUser;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Login user
  bool login({
    required String email,
    required String password,
    required List<User> allUsers, // In real app, this would query database
  }) {
    try {
      // Find user by email
      final user = allUsers.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('User not found'),
      );

      // Verify password
      if (user.login(password)) {
        state = user;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Logout user
  void logout() {
    state = null;
  }

  /// Update user profile
  void updateProfile({
    int? age,
    double? height,
    double? weight,
    String? fitnessLevel,
    List<String>? fitnessGoals,
  }) {
    if (state != null) {
      state!.updateProfile(
        age: age,
        height: height,
        weight: weight,
        fitnessLevel: fitnessLevel,
        fitnessGoals: fitnessGoals,
      );
      state = state; // Trigger rebuild
    }
  }

  /// Update daily targets
  void updateDailyTargets({
    double? calorieTarget,
    double? waterTarget,
    double? exerciseTarget,
  }) {
    if (state != null) {
      state!.setDailyTargets(
        water: waterTarget ?? 2.0,
      );
      state = state; // Trigger rebuild
    }
  }

  /// Log exercise
  void logExercise(Exercise exercise) {
    if (state != null) {
      state!.logExercise(exercise);
      state = state; // Trigger rebuild
    }
  }

  /// Log water intake
  void logWaterIntake(double amount, {String source = 'water'}) {
    if (state != null) {
      state!.logWaterIntake(amount, source: source);
      state = state; // Trigger rebuild
    }
  }

  /// Log meal
  void logMeal(Meal meal) {
    if (state != null) {
      state!.logMeal(meal);
      state = state; // Trigger rebuild
    }
  }

  /// Add goal
  void addGoal(Goal goal) {
    if (state != null) {
      state!.addGoal(goal);
      state = state; // Trigger rebuild
    }
  }

  /// Get dashboard data
  Map<String, dynamic>? getDashboard() {
    return state?.getDashboard();
  }

  /// Get today's progress score
  double? getTodayProgressScore() {
    if (state != null) {
      return state!.progress?.overallScore;
    }
    return null;
  }

  /// Get active streaks
  List<String> getActiveStreaks() {
    if (state != null) {
      return state!.streaks
          .where((s) => s.isActive)
          .map((s) => '${s.streakType}: ${s.currentStreak} days')
          .toList();
    }
    return [];
  }
}

/// Provider for user state
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

/// Provider for checking if user is logged in
final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(userProvider);
  return user != null;
});

/// Provider for user dashboard
final dashboardProvider = Provider<Map<String, dynamic>?>((ref) {
  final userNotifier = ref.watch(userProvider.notifier);
  return userNotifier.getDashboard();
});

/// Provider for today's progress
final todayProgressProvider = Provider<double>((ref) {
  final userNotifier = ref.watch(userProvider.notifier);
  return userNotifier.getTodayProgressScore() ?? 0.0;
});

/// Provider for active streaks
final activeStreaksProvider = Provider<List<String>>((ref) {
  final userNotifier = ref.watch(userProvider.notifier);
  return userNotifier.getActiveStreaks();
});

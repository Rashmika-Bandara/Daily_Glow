import 'goal.dart';
import 'exercise.dart';
import 'water_intake.dart';
import 'meal.dart';
import 'streak.dart';
import 'progress.dart';

/// Represents a user in the Daily Glow fitness tracking app.
///
/// This is the main user class that aggregates all fitness tracking data
/// including goals, exercises, water intake, meals, streaks, and progress.
/// It provides a complete user profile and comprehensive health management.
class User {
  /// Unique identifier for the user
  String userID;

  /// User's chosen username
  String username;

  /// User's email address
  String email;

  /// Encrypted password (in production, never store plain text passwords)
  String password;

  /// List of user's water intake records
  List<WaterIntake> waterIntakeHistory;

  /// List of user's exercise history
  List<Exercise> exerciseHistory;

  /// List of user's active and completed streaks
  List<Streak> streaks;

  /// List of user's meal records
  List<Meal> meals;

  /// List of user's daily progress records
  List<Progress> progressHistory;

  /// List of user's fitness goals
  List<Goal> goals;

  /// User's personal information
  Map<String, dynamic> profile;

  /// Date when user account was created
  DateTime accountCreatedDate;

  /// Last login date
  DateTime? lastLoginDate;

  /// User's current daily targets
  Map<String, double> dailyTargets;

  /// Creates a new User with the specified information
  User({
    required this.userID,
    required this.username,
    required this.email,
    required this.password,
    List<WaterIntake>? waterIntakeHistory,
    List<Exercise>? exerciseHistory,
    List<Streak>? streaks,
    List<Meal>? meals,
    List<Progress>? progressHistory,
    List<Goal>? goals,
    Map<String, dynamic>? profile,
    DateTime? accountCreatedDate,
    this.lastLoginDate,
    Map<String, double>? dailyTargets,
  }) : waterIntakeHistory = waterIntakeHistory ?? [],
       exerciseHistory = exerciseHistory ?? [],
       streaks = streaks ?? [],
       meals = meals ?? [],
       progressHistory = progressHistory ?? [],
       goals = goals ?? [],
       profile = profile ?? {},
       accountCreatedDate = accountCreatedDate ?? DateTime.now(),
       dailyTargets =
           dailyTargets ??
           {
             'water': 2.5,
             'exercise': 30.0,
             'calories': 2000.0,
             'steps': 10000.0,
           } {
    _initializeDefaultStreaks();
    _validateUserData();
  }

  /// Initializes default streak trackers for new users
  void _initializeDefaultStreaks() {
    if (streaks.isEmpty) {
      streaks.addAll([
        Streak(
          streakID: '${userID}_exercise',
          streakType: 'exercise',
          frequency: 'daily',
        ),
        Streak(
          streakID: '${userID}_hydration',
          streakType: 'hydration',
          frequency: 'daily',
        ),
        Streak(
          streakID: '${userID}_meal_logging',
          streakType: 'meal_logging',
          frequency: 'daily',
        ),
      ]);
    }
  }

  /// Validates user data for consistency and security
  void _validateUserData() {
    if (userID.isEmpty || username.isEmpty || email.isEmpty) {
      throw ArgumentError('User ID, username, and email are required');
    }

    if (!email.contains('@') || !email.contains('.')) {
      throw ArgumentError('Invalid email format');
    }

    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters long');
    }

    // Validate daily targets
    dailyTargets.forEach((key, value) {
      if (value <= 0) {
        throw ArgumentError('Daily target for $key must be positive');
      }
    });
  }

  /// Creates a new user account
  void createAccount() {
    accountCreatedDate = DateTime.now();
    lastLoginDate = DateTime.now();

    // Set up default profile information
    profile.addAll({
      'age': null,
      'height': null,
      'weight': null,
      'fitness_level': 'beginner',
      'goals': ['general_fitness'],
      'timezone': 'UTC',
      'notifications_enabled': true,
    });

    print('✅ Account created successfully for $username!');
    print('Welcome to Daily Glow! Start your fitness journey today.');
  }

  /// Handles user login
  bool login(String inputPassword) {
    if (password == inputPassword) {
      lastLoginDate = DateTime.now();
      print('Welcome back, $username! 👋');
      _showDailyOverview();
      return true;
    } else {
      print('❌ Invalid password. Please try again.');
      return false;
    }
  }

  /// Shows daily overview upon login
  void _showDailyOverview() {
    // Check today's progress
    Progress? todayProgress = _getTodayProgress();
    if (todayProgress != null) {
      print('\n📊 Today\'s Progress:');
      Map<String, dynamic> dailyData = todayProgress.viewDailyProgress();
      print(
        'Overall Score: ${dailyData['overallScore']}/10 (${dailyData['scoreLevel']})',
      );
      print(
        'Water: ${dailyData['waterIntake']} | Exercise: ${dailyData['exerciseDuration']}',
      );
    } else {
      print('\n📊 No progress recorded today. Let\'s start tracking!');
    }

    // Check streaks
    List<Streak> activeStreaks = streaks.where((s) => s.isActive).toList();
    if (activeStreaks.isNotEmpty) {
      print('\n🔥 Active Streaks:');
      for (Streak streak in activeStreaks) {
        print('  ${streak.toBriefString()} (${streak.getStreakStatus()})');
      }
    }
  }

  /// Gets today's progress record
  Progress? _getTodayProgress() {
    DateTime today = DateTime.now();
    for (Progress progress in progressHistory) {
      if (progress.date.year == today.year &&
          progress.date.month == today.month &&
          progress.date.day == today.day) {
        return progress;
      }
    }
    return null;
  }

  /// Logs out the user
  void logout() {
    print('👋 Goodbye, $username! Keep up the great work!');
  }

  /// Updates user profile information
  void updateProfile({
    String? newUsername,
    String? newEmail,
    int? age,
    double? height,
    double? weight,
    String? fitnessLevel,
    List<String>? fitnessGoals,
  }) {
    if (newUsername != null && newUsername.isNotEmpty) {
      username = newUsername;
    }

    if (newEmail != null && newEmail.contains('@')) {
      email = newEmail;
    }

    if (age != null && age > 0 && age < 150) {
      profile['age'] = age;
    }

    if (height != null && height > 0) {
      profile['height'] = height; // in cm
    }

    if (weight != null && weight > 0) {
      profile['weight'] = weight; // in kg
    }

    if (fitnessLevel != null) {
      final validLevels = ['beginner', 'intermediate', 'advanced', 'expert'];
      if (validLevels.contains(fitnessLevel.toLowerCase())) {
        profile['fitness_level'] = fitnessLevel.toLowerCase();
      }
    }

    if (fitnessGoals != null) {
      profile['goals'] = fitnessGoals;
    }

    print('✅ Profile updated successfully!');
  }

  /// Views complete user profile
  Map<String, dynamic> viewProfile() {
    Map<String, dynamic> completeProfile = Map.from(profile);
    completeProfile.addAll({
      'userID': userID,
      'username': username,
      'email': email,
      'accountCreated': accountCreatedDate.toString().substring(0, 10),
      'lastLogin': lastLoginDate?.toString().substring(0, 16) ?? 'Never',
      'dailyTargets': dailyTargets,
      'totalExercises': exerciseHistory.length,
      'totalMeals': meals.length,
      'activeStreaks': streaks.where((s) => s.isActive).length,
      'accountAge': DateTime.now().difference(accountCreatedDate).inDays,
    });

    return completeProfile;
  }

  /// Updates daily targets
  void updateDailyTargets({
    double? waterTarget,
    double? exerciseTarget,
    double? calorieTarget,
    double? stepsTarget,
  }) {
    if (waterTarget != null && waterTarget > 0) {
      dailyTargets['water'] = waterTarget;
    }

    if (exerciseTarget != null && exerciseTarget > 0) {
      dailyTargets['exercise'] = exerciseTarget;
    }

    if (calorieTarget != null && calorieTarget > 0) {
      dailyTargets['calories'] = calorieTarget;
    }

    if (stepsTarget != null && stepsTarget > 0) {
      dailyTargets['steps'] = stepsTarget;
    }

    print('🎯 Daily targets updated successfully!');
  }

  /// Adds a new goal for the user
  void addGoal(Goal goal) {
    goals.add(goal);
    print('🎯 New goal added: ${goal.goalType} (Target: ${goal.targetValue})');
  }

  /// Removes a goal
  void removeGoal(String goalID) {
    goals.removeWhere((goal) => goal.goalID == goalID);
    print('🗑️ Goal removed successfully');
  }

  /// Logs a new exercise activity
  void logExercise(Exercise exercise) {
    exerciseHistory.add(exercise);

    // Update exercise streak
    Streak? exerciseStreak = streaks.firstWhere(
      (s) => s.streakType == 'exercise',
      orElse: () =>
          Streak(streakID: '${userID}_exercise', streakType: 'exercise'),
    );

    if (!streaks.contains(exerciseStreak)) {
      streaks.add(exerciseStreak);
    }

    exerciseStreak.updateStreak();

    // Update today's progress
    _updateTodayProgress();

    print('💪 Exercise logged: ${exercise.toBriefString()}');
  }

  /// Logs water intake
  void logWaterIntake(double amountLiters, {String source = 'water'}) {
    DateTime today = DateTime.now();

    // Find or create today's water intake record
    WaterIntake? todayWater = waterIntakeHistory.firstWhere(
      (w) =>
          w.date.year == today.year &&
          w.date.month == today.month &&
          w.date.day == today.day,
      orElse: () => WaterIntake(
        intakeAmountLiters: 0.0,
        dailyTarget: dailyTargets['water'] ?? 2.5,
      ),
    );

    if (!waterIntakeHistory.contains(todayWater)) {
      waterIntakeHistory.add(todayWater);
    }

    todayWater.logWaterIntake(amountLiters, source: source);

    // Update hydration streak
    Streak? hydrationStreak = streaks.firstWhere(
      (s) => s.streakType == 'hydration',
      orElse: () =>
          Streak(streakID: '${userID}_hydration', streakType: 'hydration'),
    );

    if (!streaks.contains(hydrationStreak)) {
      streaks.add(hydrationStreak);
    }

    if (todayWater.isGoalAchieved()) {
      hydrationStreak.updateStreak();
    }

    // Update today's progress
    _updateTodayProgress();
  }

  /// Logs a meal
  void logMeal(Meal meal) {
    meals.add(meal);

    // Update meal logging streak
    Streak? mealStreak = streaks.firstWhere(
      (s) => s.streakType == 'meal_logging',
      orElse: () => Streak(
        streakID: '${userID}_meal_logging',
        streakType: 'meal_logging',
      ),
    );

    if (!streaks.contains(mealStreak)) {
      streaks.add(mealStreak);
    }

    mealStreak.updateStreak();

    // Update today's progress
    _updateTodayProgress();

    print('🍽️ Meal logged: ${meal.toBriefString()}');
  }

  /// Updates today's progress record
  void _updateTodayProgress() {
    DateTime today = DateTime.now();

    // Get today's data
    double todayWater = _getTodayWaterIntake();
    double todayExercise = _getTodayExerciseDuration();
    double todayCaloriesConsumed = _getTodayCaloriesConsumed();
    double todayCaloriesBurned = _getTodayCaloriesBurned();
    int maxStreak = streaks.isNotEmpty
        ? streaks.map((s) => s.currentStreak).reduce((a, b) => a > b ? a : b)
        : 0;

    // Find or create today's progress
    Progress? todayProgress = _getTodayProgress();
    if (todayProgress != null) {
      // Update existing record
      progressHistory.remove(todayProgress);
    }

    // Create new progress record
    Progress newProgress = Progress(
      date: today,
      waterIntake: todayWater,
      exerciseDuration: todayExercise,
      streakCount: maxStreak,
      caloriesConsumed: todayCaloriesConsumed,
      caloriesBurned: todayCaloriesBurned,
    );

    progressHistory.add(newProgress);
  }

  /// Gets today's total water intake
  double _getTodayWaterIntake() {
    DateTime today = DateTime.now();
    for (WaterIntake intake in waterIntakeHistory) {
      if (intake.date.year == today.year &&
          intake.date.month == today.month &&
          intake.date.day == today.day) {
        return intake.intakeAmountLiters;
      }
    }
    return 0.0;
  }

  /// Gets today's total exercise duration
  double _getTodayExerciseDuration() {
    DateTime today = DateTime.now();
    return exerciseHistory
        .where(
          (ex) =>
              ex.date.year == today.year &&
              ex.date.month == today.month &&
              ex.date.day == today.day &&
              ex.status == 'completed',
        )
        .fold(0.0, (sum, ex) => sum + ex.duration);
  }

  /// Gets today's total calories consumed
  double _getTodayCaloriesConsumed() {
    DateTime today = DateTime.now();
    return meals
        .where(
          (meal) =>
              meal.date.year == today.year &&
              meal.date.month == today.month &&
              meal.date.day == today.day,
        )
        .fold(0.0, (sum, meal) => sum + meal.calories);
  }

  /// Gets today's total calories burned
  double _getTodayCaloriesBurned() {
    DateTime today = DateTime.now();
    return exerciseHistory
        .where(
          (ex) =>
              ex.date.year == today.year &&
              ex.date.month == today.month &&
              ex.date.day == today.day &&
              ex.status == 'completed',
        )
        .fold(0.0, (sum, ex) => sum + ex.caloriesBurned);
  }

  /// Gets comprehensive dashboard data
  Map<String, dynamic> getDashboard() {
    Progress? todayProgress = _getTodayProgress();
    Map<String, dynamic> dashboard = {};

    if (todayProgress != null) {
      dashboard = todayProgress.viewDailyProgress();
    }

    dashboard.addAll({
      'username': username,
      'activeGoals': goals.where((g) => !g.isAchieved()).length,
      'completedGoals': goals.where((g) => g.isAchieved()).length,
      'streaks': Streak.getWeeklyStreakSummary(streaks),
      'recentExercises': exerciseHistory
          .take(5)
          .map((e) => e.toBriefString())
          .toList(),
      'upcomingReminders': _getUpcomingReminders(),
    });

    return dashboard;
  }

  /// Gets upcoming reminders for the user
  List<String> _getUpcomingReminders() {
    List<String> reminders = [];

    // Check water intake
    double todayWater = _getTodayWaterIntake();
    double waterTarget = dailyTargets['water'] ?? 2.5;
    if (todayWater < waterTarget * 0.5) {
      reminders.add('💧 Remember to drink more water today!');
    }

    // Check exercise
    double todayExercise = _getTodayExerciseDuration();
    double exerciseTarget = dailyTargets['exercise'] ?? 30.0;
    if (todayExercise < exerciseTarget * 0.5) {
      reminders.add('🏃 Don\'t forget your workout today!');
    }

    // Check streaks at risk
    List<Streak> atRiskStreaks = streaks.where((s) => s.isAtRisk()).toList();
    if (atRiskStreaks.isNotEmpty) {
      reminders.add(
        '🔥 ${atRiskStreaks.length} streak(s) at risk! Keep them alive!',
      );
    }

    return reminders;
  }

  /// Converts user to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'username': username,
      'email': email,
      'password': password, // In production, this should be hashed
      'waterIntakeHistory': waterIntakeHistory.map((w) => w.toJson()).toList(),
      'exerciseHistory': exerciseHistory.map((e) => e.toJson()).toList(),
      'streaks': streaks.map((s) => s.toJson()).toList(),
      'meals': meals.map((m) => m.toJson()).toList(),
      'progressHistory': progressHistory.map((p) => p.toJson()).toList(),
      'goals': goals.map((g) => g.toJson()).toList(),
      'profile': profile,
      'accountCreatedDate': accountCreatedDate.toIso8601String(),
      'lastLoginDate': lastLoginDate?.toIso8601String(),
      'dailyTargets': dailyTargets,
    };
  }

  /// Creates user from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
      userID: json['userID'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      profile: Map<String, dynamic>.from(json['profile'] ?? {}),
      accountCreatedDate: DateTime.parse(json['accountCreatedDate']),
      lastLoginDate: json['lastLoginDate'] != null
          ? DateTime.parse(json['lastLoginDate'])
          : null,
      dailyTargets: Map<String, double>.from(json['dailyTargets'] ?? {}),
    );

    // Load related data
    if (json['waterIntakeHistory'] != null) {
      user.waterIntakeHistory = (json['waterIntakeHistory'] as List)
          .map((w) => WaterIntake.fromJson(w))
          .toList();
    }

    if (json['exerciseHistory'] != null) {
      user.exerciseHistory = (json['exerciseHistory'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList();
    }

    if (json['streaks'] != null) {
      user.streaks = (json['streaks'] as List)
          .map((s) => Streak.fromJson(s))
          .toList();
    }

    if (json['meals'] != null) {
      user.meals = (json['meals'] as List)
          .map((m) => Meal.fromJson(m))
          .toList();
    }

    if (json['progressHistory'] != null) {
      user.progressHistory = (json['progressHistory'] as List)
          .map((p) => Progress.fromJson(p))
          .toList();
    }

    // Note: Goals would need to be handled based on the specific Goal subclass

    return user;
  }

  @override
  String toString() {
    return 'User($username - ${exerciseHistory.length} exercises, ${meals.length} meals, ${streaks.where((s) => s.isActive).length} active streaks)';
  }
}

import 'package:daily_glow/daily_glow.dart';

/// Comprehensive examples demonstrating Daily Glow functionality
void main() {
  print('🌟 Daily Glow - Comprehensive Examples 🌟\n');

  // Run all examples
  runBasicUserSetup();
  runExerciseTrackingExample();
  runHydrationTrackingExample();
  runNutritionTrackingExample();
  runGoalSettingExample();
  runStreakManagementExample();
  runProgressAnalyticsExample();
  runAdvancedFeaturesExample();
}

/// Example 1: Basic User Setup and Profile Management
void runBasicUserSetup() {
  print('📝 Example 1: User Setup and Profile Management\n');

  // Create a new user
  User user = User(
    userID: 'example_user_001',
    username: 'fitness_tracker',
    email: 'tracker@dailyglow.com',
    password: 'securePassword123',
  );

  // Create account
  user.createAccount();

  // Update profile with personal information
  user.updateProfile(
    age: 32,
    height: 170.0, // cm
    weight: 68.0, // kg
    fitnessLevel: 'intermediate',
    fitnessGoals: ['weight_loss', 'strength_building', 'endurance'],
  );

  // Set custom daily targets
  user.updateDailyTargets(
    waterTarget: 2.8, // 2.8L daily
    exerciseTarget: 45.0, // 45 minutes daily
    calorieTarget: 1900.0, // 1900 calories daily
    stepsTarget: 10000.0, // 10,000 steps daily
  );

  // View complete profile
  Map<String, dynamic> profile = user.viewProfile();
  print('User Profile Created:');
  print('Username: ${profile['username']}');
  print('Fitness Level: ${profile['fitness_level']}');
  print('Daily Water Target: ${user.dailyTargets['water']}L');
  print('Account Age: ${profile['accountAge']} days\n');
}

/// Example 2: Comprehensive Exercise Tracking
void runExerciseTrackingExample() {
  print('💪 Example 2: Exercise Tracking and Analytics\n');

  User athlete = createSampleUser();

  // Log various types of exercises
  List<Exercise> workouts = [
    Exercise(
      activityID: 'morning_run',
      activityType: 'running',
      duration: 35.0,
      caloriesBurned: 420.0,
      intensity: 'moderate',
      distance: 6.5,
      notes: 'Great morning run in the park!',
    ),
    Exercise(
      activityID: 'strength_training',
      activityType: 'weightlifting',
      duration: 50.0,
      caloriesBurned: 380.0,
      intensity: 'high',
      notes: 'Full body strength workout',
    ),
    Exercise(
      activityID: 'yoga_session',
      activityType: 'yoga',
      duration: 25.0,
      caloriesBurned: 95.0,
      intensity: 'low',
      notes: 'Relaxing evening yoga',
    ),
  ];

  // Log each workout
  for (Exercise workout in workouts) {
    workout.logActivity();
    workout.completeActivity();
    athlete.logExercise(workout);
  }

  // View exercise analytics
  Map<String, dynamic> weeklyStats = Exercise.getWeeklySummary(
    athlete.exerciseHistory,
  );
  print('Weekly Exercise Summary:');
  print('Total Workouts: ${weeklyStats['totalExercises']}');
  print('Total Duration: ${weeklyStats['totalDuration']} minutes');
  print('Total Calories: ${weeklyStats['totalCalories']}');
  print('Workout Days: ${weeklyStats['workoutDays']}');
  print(
    'Average Session: ${weeklyStats['averageDurationPerSession'].toStringAsFixed(1)} minutes\n',
  );
}

/// Example 3: Hydration Tracking and Smart Recommendations
void runHydrationTrackingExample() {
  print('💧 Example 3: Hydration Tracking and Recommendations\n');

  User hydrationUser = createSampleUser();

  // Log water intake throughout the day
  List<Map<String, dynamic>> intakeLog = [
    {'amount': 0.4, 'source': 'water', 'time': '07:00'},
    {'amount': 0.25, 'source': 'coffee', 'time': '08:30'},
    {'amount': 0.5, 'source': 'water', 'time': '10:15'},
    {'amount': 0.3, 'source': 'tea', 'time': '14:00'},
    {'amount': 0.6, 'source': 'water', 'time': '16:30'},
    {'amount': 0.35, 'source': 'water', 'time': '19:00'},
  ];

  for (Map<String, dynamic> intake in intakeLog) {
    hydrationUser.logWaterIntake(intake['amount'], source: intake['source']);
    print(
      '${intake['time']}: Logged ${intake['amount']}L of ${intake['source']}',
    );
  }

  // Get today's water intake record
  WaterIntake? todayWater = hydrationUser.waterIntakeHistory.isNotEmpty
      ? hydrationUser.waterIntakeHistory.last
      : null;

  if (todayWater != null) {
    Map<String, dynamic> hydrationReport = todayWater.getDailyReport();
    print('\nDaily Hydration Report:');
    print('Total Intake: ${hydrationReport['totalIntake']}L');
    print('Target: ${hydrationReport['dailyTarget']}L');
    print('Progress: ${hydrationReport['progressPercentage']}%');
    print('Goal Achieved: ${hydrationReport['goalAchieved']}');
    print('Status: ${hydrationReport['status']}');
    print(
      'Remaining: ${hydrationReport['remainingIntake'].toStringAsFixed(2)}L\n',
    );
  }
}

/// Example 4: Comprehensive Nutrition Tracking
void runNutritionTrackingExample() {
  print('🍽️ Example 4: Nutrition Tracking and Analysis\n');

  User nutritionUser = createSampleUser();

  // Log meals throughout the day
  List<Meal> dailyMeals = [
    Meal(
      mealID: 'breakfast_001',
      mealType: 'breakfast',
      foodItems: ['Greek yogurt', 'granola', 'berries', 'honey'],
      calories: 385.0,
      protein: 22.0,
      carbs: 48.0,
      fat: 12.0,
      preparationTime: 5,
      rating: 5,
      notes: 'Perfect protein-rich breakfast!',
    ),
    Meal(
      mealID: 'lunch_001',
      mealType: 'lunch',
      foodItems: ['grilled chicken', 'quinoa', 'mixed vegetables', 'olive oil'],
      calories: 520.0,
      protein: 38.0,
      carbs: 42.0,
      fat: 18.0,
      preparationTime: 25,
      rating: 4,
    ),
    Meal(
      mealID: 'dinner_001',
      mealType: 'dinner',
      foodItems: ['salmon', 'sweet potato', 'asparagus', 'lemon'],
      calories: 445.0,
      protein: 32.0,
      carbs: 35.0,
      fat: 20.0,
      preparationTime: 30,
      rating: 5,
    ),
    Meal(
      mealID: 'snack_001',
      mealType: 'snack',
      foodItems: ['apple', 'almond butter'],
      calories: 190.0,
      protein: 6.0,
      carbs: 25.0,
      fat: 8.0,
      preparationTime: 2,
      rating: 4,
    ),
  ];

  // Log each meal
  for (Meal meal in dailyMeals) {
    meal.logMeal();
    nutritionUser.logMeal(meal);
  }

  // Analyze daily nutrition
  Map<String, dynamic> nutritionSummary = Meal.getDailySummary(dailyMeals);
  print('Daily Nutrition Summary:');
  print('Total Calories: ${nutritionSummary['totalCalories'].toInt()}');
  print(
    'Protein: ${nutritionSummary['totalProtein'].toStringAsFixed(1)}g (${nutritionSummary['macroPercentages']['protein'].toStringAsFixed(1)}%)',
  );
  print(
    'Carbs: ${nutritionSummary['totalCarbs'].toStringAsFixed(1)}g (${nutritionSummary['macroPercentages']['carbs'].toStringAsFixed(1)}%)',
  );
  print(
    'Fat: ${nutritionSummary['totalFat'].toStringAsFixed(1)}g (${nutritionSummary['macroPercentages']['fat'].toStringAsFixed(1)}%)',
  );
  print(
    'Average Rating: ${nutritionSummary['averageRating'].toStringAsFixed(1)}/5\n',
  );
}

/// Example 5: Goal Setting and Progress Tracking
void runGoalSettingExample() {
  print('🎯 Example 5: Goal Setting and Achievement Tracking\n');

  User goalOrientedUser = createSampleUser();

  // Create various types of goals
  GoalForPhysicalActivity weeklyRunningGoal = GoalForPhysicalActivity(
    goalID: 'weekly_running_goal',
    activityType: 'running',
    unit: 'minutes',
    targetValue: 120.0, // 2 hours per week
  );

  GoalForHydration dailyHydrationGoal = GoalForHydration(
    goalID: 'daily_hydration_goal',
    dailyTargetLiters: 3.0, // 3L per day
  );

  GoalForPhysicalActivity monthlyStrengthGoal = GoalForPhysicalActivity(
    goalID: 'monthly_strength_goal',
    activityType: 'strength_training',
    unit: 'sessions',
    targetValue: 12.0, // 12 sessions per month
  );

  // Add goals to user
  goalOrientedUser.addGoal(weeklyRunningGoal);
  goalOrientedUser.addGoal(dailyHydrationGoal);
  goalOrientedUser.addGoal(monthlyStrengthGoal);

  // Simulate progress toward goals
  weeklyRunningGoal.updateProgress(30.0); // 30 minutes of running
  weeklyRunningGoal.updateProgress(45.0); // 45 minutes of running

  dailyHydrationGoal.logWaterIntake(1.2); // 1.2L of water
  dailyHydrationGoal.logWaterIntake(0.8); // 0.8L more water

  monthlyStrengthGoal.updateProgress(3.0); // 3 strength sessions

  // Display goal progress
  print('Goal Progress Report:');
  for (Goal goal in goalOrientedUser.goals) {
    double progressPercentage = goal.viewGoalProgress() * 100;
    String status = goal.isAchieved() ? '✅ ACHIEVED' : '🔄 In Progress';
    print(
      '${goal.goalType} Goal: ${progressPercentage.toStringAsFixed(1)}% $status',
    );

    if (goal is GoalForPhysicalActivity) {
      print(
        '  Activity: ${goal.activityType} (${goal.currentValue.toStringAsFixed(1)}/${goal.targetValue.toStringAsFixed(1)} ${goal.unit})',
      );
    } else if (goal is GoalForHydration) {
      print(
        '  Hydration: ${goal.currentIntakeToday.toStringAsFixed(2)}L / ${goal.dailyTargetLiters.toStringAsFixed(1)}L',
      );
    }
  }
  print('');
}

/// Example 6: Streak Management and Gamification
void runStreakManagementExample() {
  print('🔥 Example 6: Streak Management and Motivation\n');

  User streakUser = createSampleUser();

  // Simulate daily activities for streak building
  List<String> dailyActivities = ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'];

  for (String day in dailyActivities) {
    print('$day Activities:');

    // Log exercise (builds exercise streak)
    Exercise dailyExercise = Exercise(
      activityID: '${day}_exercise',
      activityType: 'mixed_workout',
      duration: 25.0,
      caloriesBurned: 200.0,
      intensity: 'moderate',
    );
    dailyExercise.completeActivity();
    streakUser.logExercise(dailyExercise);

    // Log water intake (builds hydration streak)
    streakUser.logWaterIntake(1.2);
    streakUser.logWaterIntake(1.3); // Total 2.5L (meets goal)

    // Log meal (builds meal logging streak)
    Meal dailyMeal = Meal(
      mealID: '${day}_meal',
      mealType: 'lunch',
      foodItems: ['healthy meal'],
      calories: 400.0,
      protein: 25.0,
      carbs: 40.0,
      fat: 15.0,
    );
    streakUser.logMeal(dailyMeal);
  }

  // Display streak status
  Map<String, dynamic> streakSummary = Streak.getWeeklyStreakSummary(
    streakUser.streaks,
  );
  print('Streak Summary:');
  print('Total Streaks: ${streakSummary['totalStreaks']}');
  print('Active Streaks: ${streakSummary['activeStreaks']}');
  print('Longest Current Streak: ${streakSummary['longestCurrentStreak']}');
  print('Overall Status: ${streakSummary['overallStatus']}');

  print('\nIndividual Streak Details:');
  for (Streak streak in streakUser.streaks) {
    Map<String, dynamic> streakInfo = streak.viewStreak();
    print(
      '${streakInfo['streakType']}: ${streakInfo['currentStreak']} ${streakInfo['frequency']} (${streakInfo['streakStatus']})',
    );
    print('  Achievement Level: ${streak.getAchievementLevel()}');
    print('  ${streakInfo['motivationalMessage']}');
  }
  print('');
}

/// Example 7: Progress Analytics and Insights
void runProgressAnalyticsExample() {
  print('📊 Example 7: Progress Analytics and Insights\n');

  User analyticsUser = createSampleUser();

  // Simulate a week of varied activities
  List<Map<String, dynamic>> weeklyData = [
    {'water': 2.8, 'exercise': 45, 'calories_in': 1850, 'calories_out': 420},
    {'water': 2.2, 'exercise': 30, 'calories_in': 2100, 'calories_out': 350},
    {'water': 3.1, 'exercise': 60, 'calories_in': 1950, 'calories_out': 520},
    {'water': 2.5, 'exercise': 25, 'calories_in': 1800, 'calories_out': 280},
    {'water': 2.9, 'exercise': 55, 'calories_in': 2000, 'calories_out': 480},
    {'water': 2.4, 'exercise': 35, 'calories_in': 1900, 'calories_out': 380},
    {'water': 3.2, 'exercise': 50, 'calories_in': 1950, 'calories_out': 450},
  ];

  // Create progress records for each day
  for (int i = 0; i < weeklyData.length; i++) {
    Map<String, dynamic> dayData = weeklyData[i];
    DateTime progressDate = DateTime.now().subtract(Duration(days: 6 - i));

    Progress dailyProgress = Progress(
      date: progressDate,
      waterIntake: dayData['water'].toDouble(),
      exerciseDuration: dayData['exercise'].toDouble(),
      streakCount: i + 1, // Increasing streak
      caloriesConsumed: dayData['calories_in'].toDouble(),
      caloriesBurned: dayData['calories_out'].toDouble(),
    );

    analyticsUser.progressHistory.add(dailyProgress);
  }

  // Generate comprehensive analytics
  Map<String, dynamic> weeklyAnalytics = Progress.viewWeeklyProgress(
    analyticsUser.progressHistory,
  );
  print('Weekly Progress Analytics:');
  print('Total Days Tracked: ${weeklyAnalytics['totalDays']}');
  print('Average Daily Score: ${weeklyAnalytics['averageScore']}/10');
  print('Total Water Intake: ${weeklyAnalytics['totalWaterIntake']}');
  print('Total Exercise Time: ${weeklyAnalytics['totalExerciseDuration']}');
  print(
    'Weekly Calorie Balance: ${weeklyAnalytics['weeklyCalorieBalance']} calories',
  );
  print('Trend: ${weeklyAnalytics['weeklyTrend']}');
  print('Best Day: ${weeklyAnalytics['bestDay']}');
  print(
    'Consistency Score: ${(double.parse(weeklyAnalytics['consistency'].toString()) * 100).toStringAsFixed(1)}%\n',
  );
}

/// Example 8: Advanced Features and Integration
void runAdvancedFeaturesExample() {
  print('🚀 Example 8: Advanced Features and Data Management\n');

  User advancedUser = createSampleUser();

  // Simulate comprehensive user activity
  _simulateUserActivity(advancedUser);

  // Generate comprehensive dashboard
  Map<String, dynamic> dashboard = advancedUser.getDashboard();
  print('User Dashboard Overview:');
  print('Username: ${dashboard['username']}');
  print(
    'Overall Score: ${dashboard['overallScore']}/10 (${dashboard['scoreLevel']})',
  );
  print('Active Goals: ${dashboard['activeGoals']}');
  print('Completed Goals: ${dashboard['completedGoals']}');

  // Show reminders
  if (dashboard['upcomingReminders'] is List) {
    List<String> reminders = List<String>.from(dashboard['upcomingReminders']);
    if (reminders.isNotEmpty) {
      print('\nUpcoming Reminders:');
      for (String reminder in reminders) {
        print('  $reminder');
      }
    }
  }

  // Data persistence example
  print('\nData Persistence Example:');
  Map<String, dynamic> userData = advancedUser.toJson();
  print('User data serialized: ${userData.keys.length} main sections');
  print('Exercise history: ${userData['exerciseHistory'].length} entries');
  print('Meal records: ${userData['meals'].length} entries');
  print('Progress history: ${userData['progressHistory'].length} entries');

  print('\n✨ Advanced features demonstration completed!\n');
}

/// Helper function to simulate realistic user activity
void _simulateUserActivity(User user) {
  // Add some exercises
  List<Exercise> exercises = [
    Exercise(
      activityID: 'cardio_001',
      activityType: 'cycling',
      duration: 40.0,
      caloriesBurned: 380.0,
      intensity: 'moderate',
      distance: 15.0,
    ),
    Exercise(
      activityID: 'strength_001',
      activityType: 'weightlifting',
      duration: 35.0,
      caloriesBurned: 280.0,
      intensity: 'high',
    ),
  ];

  for (Exercise exercise in exercises) {
    exercise.completeActivity();
    user.logExercise(exercise);
  }

  // Add water intake
  user.logWaterIntake(1.5);
  user.logWaterIntake(1.0);

  // Add meals
  Meal healthyMeal = Meal(
    mealID: 'healthy_001',
    mealType: 'lunch',
    foodItems: ['quinoa salad', 'grilled chicken', 'vegetables'],
    calories: 450.0,
    protein: 35.0,
    carbs: 40.0,
    fat: 15.0,
  );
  user.logMeal(healthyMeal);

  // Add goals
  GoalForPhysicalActivity fitnessGoal = GoalForPhysicalActivity(
    goalID: 'fitness_001',
    activityType: 'general',
    unit: 'minutes',
    targetValue: 150.0,
  );
  fitnessGoal.updateProgress(75.0); // 50% progress
  user.addGoal(fitnessGoal);
}

/// Daily Glow - A comprehensive fitness tracking library
///
/// This library provides a complete fitness tracking solution with classes
/// for managing users, goals, exercises, nutrition, hydration, streaks, and progress.
///
/// Main features:
/// - User account management with comprehensive profiles
/// - Goal setting and tracking for various fitness activities
/// - Exercise logging with detailed metrics and analysis
/// - Water intake monitoring with smart reminders
/// - Meal logging with nutritional information
/// - Streak tracking for motivation and habit building
/// - Progress analytics with trends and insights
///
/// Example usage:
/// ```dart
/// import 'package:daily_glow/daily_glow.dart';
///
/// // Create a new user
/// User user = User(
///   userID: 'user123',
///   username: 'fitness_enthusiast',
///   email: 'user@example.com',
///   password: 'secure_password',
/// );
///
/// // Create an account
/// user.createAccount();
///
/// // Log an exercise
/// Exercise workout = Exercise(
///   activityID: 'ex001',
///   activityType: 'running',
///   duration: 30.0,
///   caloriesBurned: 300.0,
///   intensity: 'moderate',
/// );
/// user.logExercise(workout);
///
/// // Log water intake
/// user.logWaterIntake(0.5, source: 'water');
///
/// // View dashboard
/// Map<String, dynamic> dashboard = user.getDashboard();
/// print(dashboard);
/// ```
library;

// Import model classes needed for utility functions
import 'models/user.dart';
import 'models/goal.dart';
import 'models/exercise.dart';
import 'models/meal.dart';

// Export all model classes
export 'models/user.dart';
export 'models/goal.dart';
export 'models/exercise.dart';
export 'models/water_intake.dart';
export 'models/meal.dart';
export 'models/streak.dart';
export 'models/progress.dart';

/// Library version
const String version = '1.0.0';

/// Library description
const String description =
    'A comprehensive fitness tracking library for Dart applications';

/// Utility function to create a sample user for testing
User createSampleUser() {
  User sampleUser = User(
    userID: 'sample_user_001',
    username: 'demo_user',
    email: 'demo@dailyglow.com',
    password: 'password123',
  );

  sampleUser.createAccount();

  // Add some sample data
  sampleUser.updateProfile(
    age: 28,
    height: 175.0, // cm
    weight: 70.0, // kg
    fitnessLevel: 'intermediate',
    fitnessGoals: ['weight_loss', 'strength_building', 'general_fitness'],
  );

  return sampleUser;
}

/// Utility function to demonstrate basic functionality
void demonstrateDailyGlow() {
  print('🌟 Daily Glow Fitness Tracker Demo 🌟\n');

  // Create a sample user
  User user = createSampleUser();

  // Log some activities
  print('📝 Logging activities...');

  // Log exercise
  Exercise morningRun = Exercise(
    activityID: 'ex_001',
    activityType: 'running',
    duration: 25.0,
    caloriesBurned: 250.0,
    intensity: 'moderate',
    distance: 3.5,
  );
  user.logExercise(morningRun);

  // Log water intake
  user.logWaterIntake(0.5, source: 'water');
  user.logWaterIntake(0.3, source: 'tea');

  // Log a meal
  Meal breakfast = Meal(
    mealID: 'meal_001',
    mealType: 'breakfast',
    foodItems: ['oatmeal', 'banana', 'almonds'],
    calories: 350.0,
    protein: 15.0,
    carbs: 45.0,
    fat: 12.0,
  );
  user.logMeal(breakfast);

  // Add a fitness goal
  GoalForPhysicalActivity exerciseGoal = GoalForPhysicalActivity(
    goalID: 'goal_001',
    activityType: 'running',
    unit: 'minutes',
    targetValue: 150.0, // 150 minutes per week
  );
  user.addGoal(exerciseGoal);

  // Show dashboard
  print('\n📊 User Dashboard:');
  Map<String, dynamic> dashboard = user.getDashboard();
  dashboard.forEach((key, value) {
    if (value is! List && value is! Map) {
      print('  $key: $value');
    }
  });

  print(
    '\n✅ Demo completed! Daily Glow is ready to track your fitness journey!',
  );
}

import 'package:daily_glow/daily_glow.dart';
import 'package:test/test.dart';

void main() {
  group('Daily Glow Tests', () {
    test('User creation and basic functionality', () {
      User user = User(
        userID: 'test_user_001',
        username: 'test_user',
        email: 'test@example.com',
        password: 'test_password',
      );

      expect(user.userID, 'test_user_001');
      expect(user.username, 'test_user');
      expect(user.email, 'test@example.com');
      expect(user.exerciseHistory.length, 0);
      expect(user.meals.length, 0);
      expect(user.streaks.length, 3); // Default streaks are created
    });

    test('Exercise logging functionality', () {
      User user = createSampleUser();

      Exercise exercise = Exercise(
        activityID: 'test_ex_001',
        activityType: 'running',
        duration: 30.0,
        caloriesBurned: 300.0,
        intensity: 'moderate',
      );

      exercise.completeActivity();
      user.logExercise(exercise);

      expect(user.exerciseHistory.length, 1);
      expect(user.exerciseHistory.first.activityType, 'running');
      expect(user.exerciseHistory.first.status, 'completed');
    });

    test('Water intake tracking', () {
      User user = createSampleUser();

      user.logWaterIntake(0.5);
      user.logWaterIntake(0.3, source: 'tea');

      expect(user.waterIntakeHistory.length, 1);
      expect(user.waterIntakeHistory.first.intakeAmountLiters, 0.8);
    });

    test('Goal creation and progress tracking', () {
      GoalForPhysicalActivity goal = GoalForPhysicalActivity(
        goalID: 'test_goal',
        activityType: 'running',
        unit: 'minutes',
        targetValue: 100.0,
      );

      expect(goal.currentValue, 0.0);
      expect(goal.viewGoalProgress(), 0.0);

      goal.updateProgress(50.0);
      expect(goal.currentValue, 50.0);
      expect(goal.viewGoalProgress(), 0.5);
      expect(goal.isAchieved(), false);

      goal.updateProgress(50.0);
      expect(goal.isAchieved(), true);
    });

    test('Meal nutritional calculations', () {
      Meal meal = Meal(
        mealID: 'test_meal',
        mealType: 'breakfast',
        foodItems: ['oatmeal', 'banana'],
        calories: 400.0,
        protein: 15.0,
        carbs: 60.0,
        fat: 10.0,
      );

      Map<String, double> macros = meal.getMacronutrientPercentages();
      expect(macros['protein']! > 0, true);
      expect(macros['carbs']! > 0, true);
      expect(macros['fat']! > 0, true);

      // Macros should sum to approximately 100%
      double total = macros['protein']! + macros['carbs']! + macros['fat']!;
      expect(
        (total - 100.0).abs() < 5.0,
        true,
      ); // Allow small margin for rounding
    });
  });
}

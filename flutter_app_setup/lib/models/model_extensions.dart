import 'user.dart';
import 'goal.dart';
import 'streak.dart';
import 'progress.dart';
import 'meal.dart';

/// Extension methods to bridge differences between model properties and UI expectations

extension UserExtensions on User {
  int? get age => profile['age'] as int?;
  double? get height => profile['height'] as double?;
  double? get weight => profile['weight'] as double?;
  String? get fitnessLevel => profile['fitnessLevel'] as String?;
  double get dailyWaterTarget =>
      (profile['dailyWaterTarget'] as num?)?.toDouble() ?? 2.0;

  Progress? get progress =>
      progressHistory.isNotEmpty ? progressHistory.last : null;

  // Alias for meals to match any code expecting mealHistory
  List<Meal> get mealHistory => meals;

  void setDailyTargets({required double water}) {
    profile['dailyWaterTarget'] = water;
  }
}

extension GoalExtensions on Goal {
  String get goalName => goalType;
  String get description => 'Goal for $goalType';
  double get currentProgress => currentValue;
  String get targetUnit {
    if (this is GoalForPhysicalActivity) {
      return (this as GoalForPhysicalActivity).unit;
    } else if (this is GoalForHydration) {
      return 'L';
    }
    return 'units';
  }

  DateTime get startDate => DateTime.now().subtract(Duration(days: 7));
  DateTime get targetDate => DateTime.now().add(Duration(days: 23));
  String get status => isAchieved() ? 'completed' : 'active';
}

extension StreakExtensions on Streak {
  String get activityType => streakType;
  int get currentStreakDays => currentStreak;
}

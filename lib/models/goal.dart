/// Abstract base class for all types of goals in the Daily Glow fitness tracking app.
///
/// This class provides a common structure for different goal types including
/// physical activity goals and hydration goals. Each goal has tracking capabilities
/// for progress monitoring.
abstract class Goal {
  /// Unique identifier for the goal
  String goalID;

  /// Type of goal (e.g., "physical_activity", "hydration")
  String goalType;

  /// Target value to achieve for this goal
  double targetValue;

  /// Current progress towards the target value
  double currentValue;

  /// Creates a new Goal with the specified parameters
  Goal({
    required this.goalID,
    required this.goalType,
    required this.targetValue,
    this.currentValue = 0.0,
  });

  /// Updates the current progress towards the goal
  void setGoal() {
    // Implementation will be overridden by subclasses
  }

  /// Retrieves the current progress percentage (0.0 to 1.0)
  double viewGoalProgress() {
    if (targetValue <= 0) return 0.0;
    return (currentValue / targetValue).clamp(0.0, 1.0);
  }

  /// Updates the current value for this goal
  void updateGoal(double newValue) {
    currentValue = newValue.clamp(0.0, double.infinity);
  }

  /// Checks if the goal has been achieved
  bool isAchieved() {
    return currentValue >= targetValue;
  }

  /// Returns a string representation of the goal
  /// Converts goal to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'goalID': goalID,
      'goalType': goalType,
      'targetValue': targetValue,
      'currentValue': currentValue,
    };
  }

  /// Creates a basic Goal from JSON (for polymorphic deserialization,
  /// specific subclasses should override this)
  factory Goal.fromJson(Map<String, dynamic> json) {
    // This is a factory for the base class - in practice, you'd determine
    // the specific subclass based on goalType and create the appropriate instance
    throw UnimplementedError('Use specific Goal subclass fromJson methods');
  }

  @override
  String toString() {
    return 'Goal(id: $goalID, type: $goalType, progress: ${(viewGoalProgress() * 100).toStringAsFixed(1)}%)';
  }
}

/// Represents a physical activity goal with specific exercise targets.
///
/// This goal type tracks physical exercise completion and can be measured
/// in various units such as minutes, repetitions, or distance.
class GoalForPhysicalActivity extends Goal {
  /// The type of physical activity (e.g., "running", "cycling", "strength_training")
  String activityType;

  /// Unit of measurement for the goal (e.g., "minutes", "miles", "repetitions")
  String unit;

  /// Creates a new physical activity goal
  GoalForPhysicalActivity({
    required super.goalID,
    required this.activityType,
    required this.unit,
    required super.targetValue,
    super.currentValue,
  }) : super(
         goalType: 'physical_activity',
       );

  /// Sets up the physical activity goal with specific parameters
  @override
  void setGoal() {
    // Validate that the goal parameters are reasonable for physical activity
    if (targetValue <= 0) {
      throw ArgumentError(
        'Target value must be positive for physical activity goals',
      );
    }

    // Reset current progress when setting up a new goal
    currentValue = 0.0;
  }

  /// Updates progress for the physical activity goal
  void updateProgress(double activityAmount) {
    if (activityAmount < 0) {
      throw ArgumentError('Activity amount cannot be negative');
    }

    currentValue += activityAmount;
  }

  /// Converts physical activity goal to JSON
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({'activityType': activityType, 'unit': unit});
    return json;
  }

  /// Creates physical activity goal from JSON
  factory GoalForPhysicalActivity.fromJson(Map<String, dynamic> json) {
    return GoalForPhysicalActivity(
      goalID: json['goalID'],
      activityType: json['activityType'],
      unit: json['unit'],
      targetValue: json['targetValue'].toDouble(),
      currentValue: json['currentValue']?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'PhysicalActivityGoal(activity: $activityType, ${currentValue.toStringAsFixed(1)}/${targetValue.toStringAsFixed(1)} $unit)';
  }
}

/// Represents a hydration goal for tracking daily water intake.
///
/// This goal type specifically tracks water consumption and helps users
/// maintain proper hydration levels throughout the day.
class GoalForHydration extends Goal {
  /// Target daily water intake in liters
  double dailyTargetLiters;

  /// Current water intake for today in liters
  double currentIntakeToday;

  /// Recommended minimum water intake per hour
  double recommendedHourlyIntake;

  /// Creates a new hydration goal
  GoalForHydration({
    required super.goalID,
    required this.dailyTargetLiters,
    this.currentIntakeToday = 0.0,
  }) : recommendedHourlyIntake =
           dailyTargetLiters / 16, // Assuming 16 waking hours
       super(
         goalType: 'hydration',
         targetValue: dailyTargetLiters,
         currentValue: currentIntakeToday,
       );

  /// Sets up the hydration goal with recommended daily intake
  @override
  void setGoal() {
    if (dailyTargetLiters <= 0) {
      throw ArgumentError('Daily target must be positive');
    }

    if (dailyTargetLiters < 1.0 || dailyTargetLiters > 5.0) {
      print('Warning: Recommended daily water intake is between 1-5 liters');
    }

    // Update base class values
    targetValue = dailyTargetLiters;
    currentValue = currentIntakeToday;
  }

  /// Adds water intake to today's total
  void logWaterIntake(double liters) {
    if (liters < 0) {
      throw ArgumentError('Water intake cannot be negative');
    }

    currentIntakeToday += liters;
    currentValue = currentIntakeToday;
  }

  /// Resets daily intake (should be called at start of new day)
  void resetDailyIntake() {
    currentIntakeToday = 0.0;
    currentValue = 0.0;
  }

  /// Gets the remaining water needed to reach daily goal
  double getRemainingIntake() {
    return (dailyTargetLiters - currentIntakeToday).clamp(0.0, double.infinity);
  }

  /// Checks if user is on track with hourly intake recommendations
  bool isOnTrackForHour(int currentHour) {
    double expectedIntakeByNow = recommendedHourlyIntake * currentHour;
    return currentIntakeToday >= expectedIntakeByNow;
  }

  /// Converts hydration goal to JSON
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = super.toJson();
    json.addAll({
      'dailyTargetLiters': dailyTargetLiters,
      'currentIntakeToday': currentIntakeToday,
      'recommendedHourlyIntake': recommendedHourlyIntake,
    });
    return json;
  }

  /// Creates hydration goal from JSON
  factory GoalForHydration.fromJson(Map<String, dynamic> json) {
    return GoalForHydration(
      goalID: json['goalID'],
      dailyTargetLiters: json['dailyTargetLiters'].toDouble(),
      currentIntakeToday: json['currentIntakeToday']?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'HydrationGoal(${currentIntakeToday.toStringAsFixed(2)}L / ${dailyTargetLiters.toStringAsFixed(2)}L today)';
  }
}

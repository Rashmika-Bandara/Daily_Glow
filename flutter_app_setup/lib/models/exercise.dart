/// Represents an exercise activity in the Daily Glow fitness tracking app.
///
/// This class manages individual exercise sessions, tracking details such as
/// activity type, duration, intensity, and calories burned. It provides
/// comprehensive logging and analysis capabilities for fitness activities.
class Exercise {
  /// Unique identifier for this exercise session
  String activityID;

  /// Type of activity (e.g., "running", "cycling", "weightlifting", "yoga")
  String activityType;

  /// Duration of the exercise in minutes
  double duration;

  /// Estimated calories burned during this exercise
  double caloriesBurned;

  /// Intensity level of the exercise (e.g., "low", "moderate", "high", "very_high")
  String intensity;

  /// Distance covered during exercise (in kilometers, 0 if not applicable)
  double distance;

  /// Date when this exercise was performed
  DateTime date;

  /// Additional notes about the exercise session
  String notes;

  /// Current status of the exercise (e.g., "planned", "in_progress", "completed", "skipped")
  String status;

  /// Associated goal ID if this exercise is part of a specific goal
  String? goalID;

  /// Creates a new Exercise with the specified parameters
  Exercise({
    required this.activityID,
    required this.activityType,
    required this.duration,
    required this.caloriesBurned,
    required this.intensity,
    this.distance = 0.0,
    DateTime? date,
    this.notes = '',
    this.status = 'planned',
    this.goalID,
  }) : date = date ?? DateTime.now() {
    _validateExerciseData();
  }

  /// Validates the exercise data for consistency and reasonable values
  void _validateExerciseData() {
    if (duration < 0) {
      throw ArgumentError('Duration cannot be negative');
    }
    if (caloriesBurned < 0) {
      throw ArgumentError('Calories burned cannot be negative');
    }
    if (distance < 0) {
      throw ArgumentError('Distance cannot be negative');
    }

    final validIntensities = ['low', 'moderate', 'high', 'very_high'];
    if (!validIntensities.contains(intensity.toLowerCase())) {
      throw ArgumentError(
        'Invalid intensity level. Must be one of: ${validIntensities.join(', ')}',
      );
    }

    final validStatuses = ['planned', 'in_progress', 'completed', 'skipped'];
    if (!validStatuses.contains(status.toLowerCase())) {
      throw ArgumentError(
        'Invalid status. Must be one of: ${validStatuses.join(', ')}',
      );
    }
  }

  /// Logs the start of an exercise activity
  void logActivity() {
    status = 'in_progress';
    print(
      'Started ${activityType.toLowerCase()} exercise at ${DateTime.now().toString().substring(11, 16)}',
    );
  }

  /// Updates the details of an existing exercise
  void updateActivity({
    String? newActivityType,
    double? newDuration,
    double? newCaloriesBurned,
    String? newIntensity,
    double? newDistance,
    String? newNotes,
  }) {
    if (newActivityType != null) activityType = newActivityType;
    if (newDuration != null) duration = newDuration;
    if (newCaloriesBurned != null) caloriesBurned = newCaloriesBurned;
    if (newIntensity != null) intensity = newIntensity;
    if (newDistance != null) distance = newDistance;
    if (newNotes != null) notes = newNotes;

    _validateExerciseData();
  }

  /// Marks the exercise as completed and finalizes the session
  void completeActivity() {
    if (status == 'completed') {
      print('Exercise already completed');
      return;
    }

    status = 'completed';
    print(
      'Completed ${activityType.toLowerCase()} exercise! Burned ${caloriesBurned.toInt()} calories.',
    );
  }

  /// Views detailed information about all exercises (static method for reporting)
  static String viewActivities(List<Exercise> exercises) {
    if (exercises.isEmpty) {
      return 'No exercises recorded yet.';
    }

    StringBuffer report = StringBuffer();
    report.writeln('=== Exercise Activity Report ===');
    report.writeln('Total exercises: ${exercises.length}');

    double totalDuration = 0;
    double totalCalories = 0;
    Map<String, int> activityCounts = {};

    for (Exercise exercise in exercises) {
      if (exercise.status == 'completed') {
        totalDuration += exercise.duration;
        totalCalories += exercise.caloriesBurned;
        activityCounts[exercise.activityType] =
            (activityCounts[exercise.activityType] ?? 0) + 1;
      }
    }

    report.writeln(
      'Total workout time: ${totalDuration.toStringAsFixed(1)} minutes',
    );
    report.writeln('Total calories burned: ${totalCalories.toInt()}');
    report.writeln('\nActivity breakdown:');

    activityCounts.forEach((activity, count) {
      report.writeln('  $activity: $count sessions');
    });

    return report.toString();
  }

  /// Checks if this exercise meets the minimum requirements for a valid workout
  bool checkGoal() {
    // Basic validation for a meaningful exercise session
    if (duration >= 5.0 && caloriesBurned > 0 && status == 'completed') {
      return true;
    }
    return false;
  }

  /// Sets a specific activity goal for this exercise
  void setActivityGoal(
    String newGoalID,
    double targetDuration,
    double targetCalories,
  ) {
    goalID = newGoalID;

    // Update exercise parameters to match goal if needed
    if (duration < targetDuration) {
      print(
        'Note: Current duration (${duration}min) is less than goal (${targetDuration}min)',
      );
    }
    if (caloriesBurned < targetCalories) {
      print(
        'Note: Current calories (${caloriesBurned.toInt()}) is less than goal (${targetCalories.toInt()})',
      );
    }
  }

  /// Calculates the intensity score based on duration and calories burned
  double getIntensityScore() {
    if (duration == 0) return 0.0;

    double caloriesPerMinute = caloriesBurned / duration;

    // Intensity scoring based on calories per minute
    switch (intensity.toLowerCase()) {
      case 'low':
        return caloriesPerMinute * 0.5;
      case 'moderate':
        return caloriesPerMinute * 1.0;
      case 'high':
        return caloriesPerMinute * 1.5;
      case 'very_high':
        return caloriesPerMinute * 2.0;
      default:
        return caloriesPerMinute;
    }
  }

  /// Gets a weekly summary for a list of exercises within the past week
  static Map<String, dynamic> getWeeklySummary(List<Exercise> exercises) {
    DateTime now = DateTime.now();
    DateTime weekAgo = now.subtract(Duration(days: 7));

    List<Exercise> weeklyExercises = exercises.where((exercise) {
      return exercise.date.isAfter(weekAgo) &&
          exercise.date.isBefore(now) &&
          exercise.status == 'completed';
    }).toList();

    double totalDuration = weeklyExercises.fold(
      0,
      (sum, ex) => sum + ex.duration,
    );
    double totalCalories = weeklyExercises.fold(
      0,
      (sum, ex) => sum + ex.caloriesBurned,
    );
    int workoutDays = weeklyExercises.map((ex) => ex.date.day).toSet().length;

    return {
      'totalExercises': weeklyExercises.length,
      'totalDuration': totalDuration,
      'totalCalories': totalCalories,
      'workoutDays': workoutDays,
      'averageCaloriesPerSession': weeklyExercises.isNotEmpty
          ? totalCalories / weeklyExercises.length
          : 0,
      'averageDurationPerSession': weeklyExercises.isNotEmpty
          ? totalDuration / weeklyExercises.length
          : 0,
    };
  }

  /// Gets monthly summary for exercises in the current month
  static Map<String, dynamic> getMonthlySummary(List<Exercise> exercises) {
    DateTime now = DateTime.now();
    DateTime monthStart = DateTime(now.year, now.month, 1);

    List<Exercise> monthlyExercises = exercises.where((exercise) {
      return exercise.date.isAfter(monthStart) &&
          exercise.date.isBefore(now) &&
          exercise.status == 'completed';
    }).toList();

    double totalDuration = monthlyExercises.fold(
      0,
      (sum, ex) => sum + ex.duration,
    );
    double totalCalories = monthlyExercises.fold(
      0,
      (sum, ex) => sum + ex.caloriesBurned,
    );

    Map<String, int> activityFrequency = {};
    for (Exercise ex in monthlyExercises) {
      activityFrequency[ex.activityType] =
          (activityFrequency[ex.activityType] ?? 0) + 1;
    }

    return {
      'totalExercises': monthlyExercises.length,
      'totalDuration': totalDuration,
      'totalCalories': totalCalories,
      'activityFrequency': activityFrequency,
      'averageCaloriesPerSession': monthlyExercises.isNotEmpty
          ? totalCalories / monthlyExercises.length
          : 0,
      'mostFrequentActivity': activityFrequency.isNotEmpty
          ? activityFrequency.entries
                .reduce((a, b) => a.value > b.value ? a : b)
                .key
          : 'None',
    };
  }

  /// Deletes/cancels an exercise activity
  void deleteActivity() {
    status = 'skipped';
    notes += ' [Cancelled: ${DateTime.now().toString().substring(0, 16)}]';
    print('Exercise activity cancelled: $activityType');
  }

  /// Returns a detailed string representation of the exercise
  @override
  String toString() {
    String distanceStr = distance > 0
        ? ', Distance: ${distance.toStringAsFixed(2)}km'
        : '';
    return 'Exercise($activityType, ${duration.toStringAsFixed(1)}min, ${caloriesBurned.toInt()}cal, $intensity$distanceStr, Status: $status)';
  }

  /// Returns a brief summary string for quick display
  String toBriefString() {
    return '$activityType - ${duration.toInt()}min (${caloriesBurned.toInt()}cal)';
  }

  /// Converts the exercise to a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'activityID': activityID,
      'activityType': activityType,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'intensity': intensity,
      'distance': distance,
      'date': date.toIso8601String(),
      'notes': notes,
      'status': status,
      'goalID': goalID,
    };
  }

  /// Creates an Exercise from a Map (for JSON deserialization)
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      activityID: json['activityID'],
      activityType: json['activityType'],
      duration: json['duration'].toDouble(),
      caloriesBurned: json['caloriesBurned'].toDouble(),
      intensity: json['intensity'],
      distance: json['distance']?.toDouble() ?? 0.0,
      date: DateTime.parse(json['date']),
      notes: json['notes'] ?? '',
      status: json['status'] ?? 'planned',
      goalID: json['goalID'],
    );
  }
}

/// Represents progress tracking in the Daily Glow fitness app.
///
/// This class aggregates and analyzes user progress across multiple
/// fitness metrics including exercise, hydration, nutrition, and streaks.
/// It provides comprehensive progress monitoring and trend analysis.
class Progress {
  /// Date of this progress record
  DateTime date;

  /// Water intake for this date in liters
  double waterIntake;

  /// Total exercise duration for this date in minutes
  double exerciseDuration;

  /// Current active streak count
  int streakCount;

  /// Total calories consumed from meals
  double caloriesConsumed;

  /// Total calories burned through exercise
  double caloriesBurned;

  /// User's weight on this date (optional)
  double? weight;

  /// Overall wellness score (0.0 to 10.0)
  double overallScore;

  /// Additional progress notes
  String notes;

  /// Creates a new Progress record
  Progress({
    DateTime? date,
    required this.waterIntake,
    required this.exerciseDuration,
    required this.streakCount,
    this.caloriesConsumed = 0.0,
    this.caloriesBurned = 0.0,
    this.weight,
    this.overallScore = 0.0,
    this.notes = '',
  }) : date = date ?? DateTime.now() {
    _calculateOverallScore();
    _validateProgressData();
  }

  /// Validates progress data for reasonable values
  void _validateProgressData() {
    if (waterIntake < 0) {
      throw ArgumentError('Water intake cannot be negative');
    }
    if (exerciseDuration < 0) {
      throw ArgumentError('Exercise duration cannot be negative');
    }
    if (streakCount < 0) {
      throw ArgumentError('Streak count cannot be negative');
    }
    if (caloriesConsumed < 0 || caloriesBurned < 0) {
      throw ArgumentError('Calories cannot be negative');
    }
    if (weight != null && (weight! < 0 || weight! > 1000)) {
      throw ArgumentError('Weight must be reasonable (0-1000 kg)');
    }
    if (overallScore < 0 || overallScore > 10) {
      throw ArgumentError('Overall score must be between 0 and 10');
    }
  }

  /// Calculates overall wellness score based on various metrics
  void _calculateOverallScore() {
    double score = 0.0;
    int factors = 0;

    // Water intake scoring (0-2.5 points)
    if (waterIntake >= 2.5) {
      score += 2.5;
    } else if (waterIntake >= 2.0) {
      score += 2.0;
    } else if (waterIntake >= 1.5) {
      score += 1.5;
    } else if (waterIntake >= 1.0) {
      score += 1.0;
    } else if (waterIntake >= 0.5) {
      score += 0.5;
    }
    factors++;

    // Exercise duration scoring (0-2.5 points)
    if (exerciseDuration >= 60) {
      score += 2.5;
    } else if (exerciseDuration >= 45) {
      score += 2.0;
    } else if (exerciseDuration >= 30) {
      score += 1.5;
    } else if (exerciseDuration >= 15) {
      score += 1.0;
    } else if (exerciseDuration > 0) {
      score += 0.5;
    }
    factors++;

    // Streak scoring (0-2.5 points)
    if (streakCount >= 30) {
      score += 2.5;
    } else if (streakCount >= 14) {
      score += 2.0;
    } else if (streakCount >= 7) {
      score += 1.5;
    } else if (streakCount >= 3) {
      score += 1.0;
    } else if (streakCount > 0) {
      score += 0.5;
    }
    factors++;

    // Calorie balance scoring (0-2.5 points)
    double calorieBalance = caloriesBurned - caloriesConsumed;
    if (calorieBalance >= -200 && calorieBalance <= 200) {
      score += 2.5; // Balanced intake/burn
    } else if (calorieBalance >= -500 && calorieBalance <= 500) {
      score += 2.0;
    } else if (calorieBalance >= -800 && calorieBalance <= 800) {
      score += 1.0;
    } else if (caloriesConsumed > 0 || caloriesBurned > 0) {
      score += 0.5; // At least some tracking
    }
    factors++;

    // Calculate final score out of 10
    overallScore = factors > 0 ? (score / factors) * 4 : 0.0; // Scale to 0-10
    overallScore = overallScore.clamp(0.0, 10.0);
  }

  /// Views daily progress details
  Map<String, dynamic> viewDailyProgress() {
    return {
      'date': date.toString().substring(0, 10),
      'waterIntake': '${waterIntake.toStringAsFixed(2)}L',
      'exerciseDuration': '${exerciseDuration.toInt()} minutes',
      'streakCount': streakCount,
      'caloriesConsumed': caloriesConsumed.toInt(),
      'caloriesBurned': caloriesBurned.toInt(),
      'calorieBalance': (caloriesBurned - caloriesConsumed).toInt(),
      'weight': weight != null
          ? '${weight!.toStringAsFixed(1)} kg'
          : 'Not recorded',
      'overallScore': overallScore.toStringAsFixed(1),
      'scoreLevel': _getScoreLevel(),
      'notes': notes,
      'recommendations': _getRecommendations(),
    };
  }

  /// Gets score level description
  String _getScoreLevel() {
    if (overallScore >= 8.5) return 'Excellent';
    if (overallScore >= 7.0) return 'Very Good';
    if (overallScore >= 5.5) return 'Good';
    if (overallScore >= 4.0) return 'Fair';
    if (overallScore >= 2.5) return 'Needs Improvement';
    return 'Poor';
  }

  /// Gets personalized recommendations based on current progress
  List<String> _getRecommendations() {
    List<String> recommendations = [];

    if (waterIntake < 2.0) {
      recommendations.add(
        '💧 Increase water intake - aim for at least 2L daily',
      );
    }

    if (exerciseDuration < 30) {
      recommendations.add(
        '🏃 Try to get at least 30 minutes of exercise daily',
      );
    }

    if (streakCount < 7) {
      recommendations.add(
        '🔥 Focus on building consistent habits for streak building',
      );
    }

    double calorieBalance = caloriesBurned - caloriesConsumed;
    if (calorieBalance < -500) {
      recommendations.add(
        '⚖️ Consider increasing physical activity or reducing calorie intake',
      );
    } else if (calorieBalance > 500) {
      recommendations.add(
        '🍎 Make sure you\'re eating enough to fuel your activities',
      );
    }

    if (recommendations.isEmpty) {
      recommendations.add(
        '🌟 Great job! Keep maintaining your healthy lifestyle!',
      );
    }

    return recommendations;
  }

  /// Views weekly progress summary from a list of daily progress records
  static Map<String, dynamic> viewWeeklyProgress(
    List<Progress> weeklyProgress,
  ) {
    if (weeklyProgress.isEmpty) {
      return {
        'totalDays': 0,
        'averageScore': 0.0,
        'totalWaterIntake': 0.0,
        'totalExerciseDuration': 0.0,
        'averageStreakCount': 0.0,
        'totalCaloriesConsumed': 0.0,
        'totalCaloriesBurned': 0.0,
        'weeklyTrend': 'No data',
      };
    }

    int totalDays = weeklyProgress.length;
    double totalWater = weeklyProgress.fold(
      0.0,
      (sum, p) => sum + p.waterIntake,
    );
    double totalExercise = weeklyProgress.fold(
      0.0,
      (sum, p) => sum + p.exerciseDuration,
    );
    double totalConsumed = weeklyProgress.fold(
      0.0,
      (sum, p) => sum + p.caloriesConsumed,
    );
    double totalBurned = weeklyProgress.fold(
      0.0,
      (sum, p) => sum + p.caloriesBurned,
    );
    double averageScore =
        weeklyProgress.fold(0.0, (sum, p) => sum + p.overallScore) / totalDays;
    double averageStreak =
        weeklyProgress.fold(0.0, (sum, p) => sum + p.streakCount) / totalDays;

    // Calculate trend
    String trend = _calculateWeeklyTrend(weeklyProgress);

    return {
      'totalDays': totalDays,
      'averageScore': averageScore.toStringAsFixed(1),
      'totalWaterIntake': '${totalWater.toStringAsFixed(1)}L',
      'averageWaterPerDay': '${(totalWater / totalDays).toStringAsFixed(1)}L',
      'totalExerciseDuration': '${totalExercise.toInt()} minutes',
      'averageExercisePerDay': '${(totalExercise / totalDays).toInt()} minutes',
      'averageStreakCount': averageStreak.toStringAsFixed(1),
      'totalCaloriesConsumed': totalConsumed.toInt(),
      'totalCaloriesBurned': totalBurned.toInt(),
      'weeklyCalorieBalance': (totalBurned - totalConsumed).toInt(),
      'weeklyTrend': trend,
      'bestDay': weeklyProgress
          .reduce((a, b) => a.overallScore > b.overallScore ? a : b)
          .date
          .toString()
          .substring(0, 10),
      'consistency': _calculateConsistency(weeklyProgress),
    };
  }

  /// Calculates weekly trend direction
  static String _calculateWeeklyTrend(List<Progress> progress) {
    if (progress.length < 2) return 'Insufficient data';

    // Sort by date to ensure chronological order
    progress.sort((a, b) => a.date.compareTo(b.date));

    double firstHalf = 0.0;
    double secondHalf = 0.0;
    int midPoint = progress.length ~/ 2;

    // Calculate average scores for first and second half of the week
    for (int i = 0; i < midPoint; i++) {
      firstHalf += progress[i].overallScore;
    }
    firstHalf /= midPoint;

    for (int i = midPoint; i < progress.length; i++) {
      secondHalf += progress[i].overallScore;
    }
    secondHalf /= (progress.length - midPoint);

    double difference = secondHalf - firstHalf;

    if (difference > 1.0) {
      return '📈 Improving - Keep up the great momentum!';
    } else if (difference > 0.5) {
      return '↗️ Slightly improving - Good progress!';
    } else if (difference > -0.5) {
      return '➡️ Stable - Maintaining consistency!';
    } else if (difference > -1.0) {
      return '↘️ Slight decline - Refocus on your goals!';
    } else {
      return '📉 Declining - Time to reassess your routine!';
    }
  }

  /// Calculates consistency score based on daily score variations
  static double _calculateConsistency(List<Progress> progress) {
    if (progress.length < 2) return 1.0;

    double average =
        progress.fold(0.0, (sum, p) => sum + p.overallScore) / progress.length;
    double sumOfSquares = progress.fold(
      0.0,
      (sum, p) =>
          sum + ((p.overallScore - average) * (p.overallScore - average)),
    );
    double variance = sumOfSquares / progress.length;
    double standardDeviation = variance > 0 ? variance : 0.0;

    // Normalize to 0-1 scale (lower standard deviation = higher consistency)
    return (1.0 / (1.0 + standardDeviation)).clamp(0.0, 1.0);
  }

  /// Views monthly progress summary
  static Map<String, dynamic> viewMonthlyProgress(
    List<Progress> monthlyProgress,
  ) {
    if (monthlyProgress.isEmpty) {
      return {
        'totalDays': 0,
        'monthlyAverage': 0.0,
        'bestWeek': 'No data',
        'improvementAreas': <String>[],
      };
    }

    int totalDays = monthlyProgress.length;
    double monthlyAverage =
        monthlyProgress.fold(0.0, (sum, p) => sum + p.overallScore) / totalDays;

    // Group by weeks for weekly analysis
    Map<int, List<Progress>> weeklyGroups = {};
    for (Progress p in monthlyProgress) {
      int weekNumber = ((p.date.day - 1) ~/ 7) + 1;
      weeklyGroups[weekNumber] ??= [];
      weeklyGroups[weekNumber]!.add(p);
    }

    // Find best performing week
    int bestWeekNum = 1;
    double bestWeekAverage = 0.0;
    weeklyGroups.forEach((weekNum, weekProgress) {
      double weekAverage =
          weekProgress.fold(0.0, (sum, p) => sum + p.overallScore) /
          weekProgress.length;
      if (weekAverage > bestWeekAverage) {
        bestWeekAverage = weekAverage;
        bestWeekNum = weekNum;
      }
    });

    // Identify improvement areas
    List<String> improvementAreas = _identifyImprovementAreas(monthlyProgress);

    return {
      'totalDays': totalDays,
      'monthlyAverage': monthlyAverage.toStringAsFixed(1),
      'bestWeek':
          'Week $bestWeekNum (${bestWeekAverage.toStringAsFixed(1)} avg)',
      'totalWaterIntake':
          '${monthlyProgress.fold(0.0, (sum, p) => sum + p.waterIntake).toStringAsFixed(1)}L',
      'totalExerciseHours':
          '${(monthlyProgress.fold(0.0, (sum, p) => sum + p.exerciseDuration) / 60).toStringAsFixed(1)} hours',
      'averageScore': monthlyAverage.toStringAsFixed(1),
      'consistency': _calculateConsistency(monthlyProgress).toStringAsFixed(2),
      'improvementAreas': improvementAreas,
      'monthlyTrend': _calculateMonthlyTrend(monthlyProgress),
    };
  }

  /// Identifies areas that need improvement based on monthly data
  static List<String> _identifyImprovementAreas(List<Progress> progress) {
    List<String> areas = [];

    double avgWater =
        progress.fold(0.0, (sum, p) => sum + p.waterIntake) / progress.length;
    double avgExercise =
        progress.fold(0.0, (sum, p) => sum + p.exerciseDuration) /
        progress.length;
    double avgStreak =
        progress.fold(0.0, (sum, p) => sum + p.streakCount) / progress.length;

    if (avgWater < 2.0) {
      areas.add('Hydration - Increase daily water intake');
    }

    if (avgExercise < 30) {
      areas.add('Physical Activity - Aim for more daily exercise');
    }

    if (avgStreak < 7) {
      areas.add('Consistency - Focus on building and maintaining streaks');
    }

    // Check calorie balance
    double avgCalorieBalance =
        progress.fold(
          0.0,
          (sum, p) => sum + (p.caloriesBurned - p.caloriesConsumed),
        ) /
        progress.length;
    if (avgCalorieBalance.abs() > 300) {
      areas.add(
        'Nutrition Balance - Better align calories consumed with calories burned',
      );
    }

    return areas;
  }

  /// Calculates monthly trend
  static String _calculateMonthlyTrend(List<Progress> progress) {
    if (progress.length < 7) return 'Insufficient data for trend analysis';

    // Sort by date and compare first week to last week
    progress.sort((a, b) => a.date.compareTo(b.date));

    List<Progress> firstWeek = progress.take(7).toList();
    List<Progress> lastWeek = progress.skip(progress.length - 7).toList();

    double firstWeekAvg =
        firstWeek.fold(0.0, (sum, p) => sum + p.overallScore) /
        firstWeek.length;
    double lastWeekAvg =
        lastWeek.fold(0.0, (sum, p) => sum + p.overallScore) / lastWeek.length;

    double improvement = lastWeekAvg - firstWeekAvg;

    if (improvement > 1.5) {
      return '🚀 Significant improvement this month!';
    } else if (improvement > 0.5) {
      return '📈 Good improvement this month!';
    } else if (improvement > -0.5) {
      return '➡️ Steady performance this month.';
    } else {
      return '📉 Room for improvement next month.';
    }
  }

  /// Converts progress to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'waterIntake': waterIntake,
      'exerciseDuration': exerciseDuration,
      'streakCount': streakCount,
      'caloriesConsumed': caloriesConsumed,
      'caloriesBurned': caloriesBurned,
      'weight': weight,
      'overallScore': overallScore,
      'notes': notes,
    };
  }

  /// Creates progress from JSON
  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      date: DateTime.parse(json['date']),
      waterIntake: json['waterIntake'].toDouble(),
      exerciseDuration: json['exerciseDuration'].toDouble(),
      streakCount: json['streakCount'],
      caloriesConsumed: json['caloriesConsumed']?.toDouble() ?? 0.0,
      caloriesBurned: json['caloriesBurned']?.toDouble() ?? 0.0,
      weight: json['weight']?.toDouble(),
      overallScore: json['overallScore']?.toDouble() ?? 0.0,
      notes: json['notes'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Progress(${date.toString().substring(0, 10)}: Score ${overallScore.toStringAsFixed(1)}/10)';
  }

  /// Brief string representation for lists
  String toBriefString() {
    return '${date.toString().substring(0, 10)} - ${_getScoreLevel()} (${overallScore.toStringAsFixed(1)}/10)';
  }
}

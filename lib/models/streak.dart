/// Represents a streak tracking system for the Daily Glow fitness app.
///
/// This class manages consecutive achievement tracking for various activities
/// like exercise streaks, hydration streaks, and meal logging streaks.
/// It provides motivation through gamification and progress visualization.
class Streak {
  /// Unique identifier for this streak
  String streakID;

  /// Current consecutive count for this streak
  int currentStreak;

  /// Maximum streak achieved all-time
  int maxStreak;

  /// Date when the streak was last updated/maintained
  DateTime lastLoggedDate;

  /// Type of streak (e.g., "exercise", "hydration", "meal_logging", "sleep")
  String streakType;

  /// Target frequency for maintaining the streak (daily, weekly, etc.)
  String frequency;

  /// Whether the streak is currently active
  bool isActive;

  /// Creates a new Streak with the specified parameters
  Streak({
    required this.streakID,
    required this.streakType,
    this.currentStreak = 0,
    this.maxStreak = 0,
    DateTime? lastLoggedDate,
    this.frequency = 'daily',
    this.isActive = true,
  }) : lastLoggedDate = lastLoggedDate ?? DateTime.now() {
    _validateStreakData();
  }

  /// Validates streak data for consistency
  void _validateStreakData() {
    if (currentStreak < 0) {
      throw ArgumentError('Current streak cannot be negative');
    }
    if (maxStreak < 0) {
      throw ArgumentError('Max streak cannot be negative');
    }
    if (currentStreak > maxStreak) {
      maxStreak = currentStreak; // Auto-correct if current exceeds max
    }

    final validFrequencies = ['daily', 'weekly', 'monthly'];
    if (!validFrequencies.contains(frequency.toLowerCase())) {
      throw ArgumentError(
        'Invalid frequency. Must be one of: ${validFrequencies.join(', ')}',
      );
    }
  }

  /// Updates the streak when an activity is logged
  void updateStreak() {
    DateTime today = DateTime.now();
    DateTime todayDate = DateTime(today.year, today.month, today.day);
    DateTime lastDate = DateTime(
      lastLoggedDate.year,
      lastLoggedDate.month,
      lastLoggedDate.day,
    );

    int daysDifference = todayDate.difference(lastDate).inDays;

    switch (frequency.toLowerCase()) {
      case 'daily':
        _updateDailyStreak(daysDifference);
        break;
      case 'weekly':
        _updateWeeklyStreak(daysDifference);
        break;
      case 'monthly':
        _updateMonthlyStreak(today, lastLoggedDate);
        break;
    }

    lastLoggedDate = today;
    isActive = true;

    // Update max streak if current exceeds it
    if (currentStreak > maxStreak) {
      maxStreak = currentStreak;
      print(
        '🎉 New personal best! $streakType streak: $currentStreak $frequency!',
      );
    } else {
      print(
        '✅ $streakType streak continued! Current: $currentStreak $frequency',
      );
    }
  }

  /// Updates daily streak logic
  void _updateDailyStreak(int daysDifference) {
    if (daysDifference == 0) {
      // Same day - no change to streak
      return;
    } else if (daysDifference == 1) {
      // Consecutive day - increment streak
      currentStreak++;
    } else {
      // Missed day(s) - reset streak
      print(
        '💔 Streak broken! Missed ${daysDifference - 1} day(s). Resetting $streakType streak.',
      );
      currentStreak = 1; // Start new streak with today's activity
    }
  }

  /// Updates weekly streak logic
  void _updateWeeklyStreak(int daysDifference) {
    if (daysDifference <= 7) {
      // Within same week or next week
      if (daysDifference >= 7) {
        currentStreak++;
      }
    } else {
      // Missed week(s)
      int missedWeeks = (daysDifference / 7).floor() - 1;
      if (missedWeeks > 0) {
        print(
          '💔 Streak broken! Missed $missedWeeks week(s). Resetting $streakType streak.',
        );
        currentStreak = 1;
      }
    }
  }

  /// Updates monthly streak logic
  void _updateMonthlyStreak(DateTime current, DateTime last) {
    if (current.year == last.year && current.month == last.month) {
      // Same month - no change
      return;
    } else if ((current.year == last.year && current.month == last.month + 1) ||
        (current.year == last.year + 1 &&
            current.month == 1 &&
            last.month == 12)) {
      // Consecutive month
      currentStreak++;
    } else {
      // Missed month(s)
      print(
        '💔 Streak broken! Missed month(s). Resetting $streakType streak.',
      );
      currentStreak = 1;
    }
  }

  /// Resets the current streak to zero
  void resetStreak() {
    print(
      '🔄 Manually resetting $streakType streak from $currentStreak to 0.',
    );
    currentStreak = 0;
    isActive = false;
    lastLoggedDate = DateTime.now();
  }

  /// Views the current streak information
  Map<String, dynamic> viewStreak() {
    return {
      'streakID': streakID,
      'streakType': streakType,
      'currentStreak': currentStreak,
      'maxStreak': maxStreak,
      'frequency': frequency,
      'isActive': isActive,
      'lastLoggedDate': lastLoggedDate.toString().substring(0, 10),
      'daysSinceLastLog': DateTime.now().difference(lastLoggedDate).inDays,
      'streakStatus': getStreakStatus(),
      'motivationalMessage': getMotivationalMessage(),
    };
  }

  /// Gets the current status of the streak
  String getStreakStatus() {
    DateTime now = DateTime.now();
    int daysSinceLastLog = now.difference(lastLoggedDate).inDays;

    if (!isActive) {
      return 'Inactive';
    }

    switch (frequency.toLowerCase()) {
      case 'daily':
        if (daysSinceLastLog == 0) return 'On Track';
        if (daysSinceLastLog == 1) return 'At Risk';
        return 'Broken';
      case 'weekly':
        if (daysSinceLastLog <= 7) return 'On Track';
        if (daysSinceLastLog <= 14) return 'At Risk';
        return 'Broken';
      case 'monthly':
        DateTime lastMonth = DateTime(now.year, now.month - 1);
        if (lastLoggedDate.isAfter(lastMonth)) return 'On Track';
        return 'At Risk';
      default:
        return 'Unknown';
    }
  }

  /// Gets a motivational message based on streak status
  String getMotivationalMessage() {
    String status = getStreakStatus();

    switch (status) {
      case 'On Track':
        if (currentStreak >= 30) {
          return '🔥 You\'re on fire! $currentStreak $frequency streak is incredible!';
        } else if (currentStreak >= 7) {
          return '💪 Great momentum! Keep up the excellent work!';
        } else if (currentStreak >= 3) {
          return '✨ You\'re building a great habit! Stay consistent!';
        } else {
          return '🌟 Good start! Every journey begins with a single step.';
        }
      case 'At Risk':
        return '⚠️ Don\'t break the chain! Log your $streakType activity today!';
      case 'Broken':
        return '🔄 Every expert was once a beginner. Start your new streak today!';
      case 'Inactive':
        return '💤 Ready to get back on track? Your fitness journey awaits!';
      default:
        return '🎯 Stay focused on your $streakType goals!';
    }
  }

  /// Checks if the streak is at risk of being broken
  bool isAtRisk() {
    return getStreakStatus() == 'At Risk';
  }

  /// Checks if the streak is broken
  bool isBroken() {
    return getStreakStatus() == 'Broken';
  }

  /// Gets achievement level based on current streak
  String getAchievementLevel() {
    if (currentStreak >= 365) return 'Legendary';
    if (currentStreak >= 180) return 'Master';
    if (currentStreak >= 90) return 'Expert';
    if (currentStreak >= 30) return 'Advanced';
    if (currentStreak >= 14) return 'Intermediate';
    if (currentStreak >= 7) return 'Beginner';
    if (currentStreak >= 3) return 'Starter';
    return 'Newbie';
  }

  /// Gets streak statistics for analysis
  Map<String, dynamic> getStreakStats() {
    double consistency = maxStreak > 0 ? (currentStreak / maxStreak) : 0.0;

    return {
      'currentStreak': currentStreak,
      'maxStreak': maxStreak,
      'achievementLevel': getAchievementLevel(),
      'consistency': consistency,
      'consistencyPercentage': (consistency * 100).toStringAsFixed(1),
      'totalActiveDays': maxStreak, // Approximation
      'averageStreakLength': maxStreak > 0
          ? maxStreak / 2
          : 0, // Rough estimate
    };
  }

  /// Compares this streak with another streak
  Map<String, dynamic> compareWith(Streak otherStreak) {
    return {
      'currentStreakDifference': currentStreak - otherStreak.currentStreak,
      'maxStreakDifference': maxStreak - otherStreak.maxStreak,
      'betterCurrentStreak': currentStreak > otherStreak.currentStreak,
      'betterMaxStreak': maxStreak > otherStreak.maxStreak,
      'comparisonMessage': _getComparisonMessage(otherStreak),
    };
  }

  /// Gets a comparison message between streaks
  String _getComparisonMessage(Streak other) {
    if (currentStreak > other.currentStreak) {
      return 'Your $streakType streak ($currentStreak) is ahead of ${other.streakType} (${other.currentStreak})!';
    } else if (currentStreak < other.currentStreak) {
      return 'Your ${other.streakType} streak (${other.currentStreak}) is leading $streakType ($currentStreak).';
    } else {
      return 'Both $streakType and ${other.streakType} streaks are tied at $currentStreak!';
    }
  }

  /// Gets weekly streak summary for multiple streaks
  static Map<String, dynamic> getWeeklyStreakSummary(List<Streak> streaks) {
    if (streaks.isEmpty) {
      return {
        'totalStreaks': 0,
        'activeStreaks': 0,
        'atRiskStreaks': 0,
        'brokenStreaks': 0,
        'averageStreak': 0.0,
        'longestCurrentStreak': 0,
        'streakTypes': <String>[],
      };
    }

    int activeStreaks = streaks
        .where((s) => s.getStreakStatus() == 'On Track')
        .length;
    int atRiskStreaks = streaks.where((s) => s.isAtRisk()).length;
    int brokenStreaks = streaks.where((s) => s.isBroken()).length;

    double averageStreak =
        streaks.fold(0, (sum, s) => sum + s.currentStreak) / streaks.length;
    int longestCurrentStreak = streaks.fold(
      0,
      (max, s) => s.currentStreak > max ? s.currentStreak : max,
    );

    List<String> streakTypes = streaks.map((s) => s.streakType).toList();

    return {
      'totalStreaks': streaks.length,
      'activeStreaks': activeStreaks,
      'atRiskStreaks': atRiskStreaks,
      'brokenStreaks': brokenStreaks,
      'averageStreak': averageStreak,
      'longestCurrentStreak': longestCurrentStreak,
      'streakTypes': streakTypes,
      'overallStatus': _getOverallStreakStatus(
        activeStreaks,
        atRiskStreaks,
        brokenStreaks,
        streaks.length,
      ),
    };
  }

  /// Gets overall streak status message
  static String _getOverallStreakStatus(
    int active,
    int atRisk,
    int broken,
    int total,
  ) {
    double activePercentage = (active / total) * 100;

    if (activePercentage >= 80) {
      return '🔥 Excellent! You\'re maintaining most of your streaks!';
    } else if (activePercentage >= 60) {
      return '💪 Good job! Keep working on consistency.';
    } else if (activePercentage >= 40) {
      return '⚠️ Focus needed. Several streaks need attention.';
    } else {
      return '🔄 Time to rebuild! Start fresh with your most important habit.';
    }
  }

  /// Converts streak to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'streakID': streakID,
      'currentStreak': currentStreak,
      'maxStreak': maxStreak,
      'lastLoggedDate': lastLoggedDate.toIso8601String(),
      'streakType': streakType,
      'frequency': frequency,
      'isActive': isActive,
    };
  }

  /// Creates streak from JSON
  factory Streak.fromJson(Map<String, dynamic> json) {
    return Streak(
      streakID: json['streakID'],
      streakType: json['streakType'],
      currentStreak: json['currentStreak'] ?? 0,
      maxStreak: json['maxStreak'] ?? 0,
      lastLoggedDate: DateTime.parse(json['lastLoggedDate']),
      frequency: json['frequency'] ?? 'daily',
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  String toString() {
    return 'Streak($streakType: $currentStreak $frequency, max: $maxStreak, ${getStreakStatus()})';
  }

  /// Brief string representation
  String toBriefString() {
    return '$streakType: $currentStreak $frequency streak';
  }
}

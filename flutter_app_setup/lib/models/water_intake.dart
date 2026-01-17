/// Represents water intake tracking in the Daily Glow fitness app.
///
/// This class manages hydration logging, providing detailed tracking of
/// water consumption throughout the day with automatic reminders and
/// progress monitoring capabilities.
class WaterIntake {
  /// Date of this water intake record
  DateTime date;

  /// Amount of water consumed in liters
  double intakeAmountLiters;

  /// Target daily water intake in liters
  double dailyTarget;

  /// List of individual water intake entries throughout the day
  List<WaterIntakeEntry> _intakeEntries;

  /// Creates a new WaterIntake record for a specific date
  WaterIntake({
    DateTime? date,
    required this.intakeAmountLiters,
    this.dailyTarget = 2.5, // Default 2.5L daily target
  }) : date = date ?? DateTime.now(),
       _intakeEntries = [] {
    _validateIntake();
  }

  /// Validates water intake data for reasonable values
  void _validateIntake() {
    if (intakeAmountLiters < 0) {
      throw ArgumentError('Water intake cannot be negative');
    }
    if (dailyTarget <= 0) {
      throw ArgumentError('Daily target must be positive');
    }
    if (intakeAmountLiters > 10.0) {
      print(
        'Warning: Very high water intake detected (${intakeAmountLiters.toStringAsFixed(2)}L)',
      );
    }
  }

  /// Gets all water intake entries for this date
  List<WaterIntakeEntry> get intakeEntries => List.unmodifiable(_intakeEntries);

  /// Logs a new water intake entry
  void logWaterIntake(
    double amountLiters, {
    String source = 'water',
    String? notes,
  }) {
    if (amountLiters <= 0) {
      throw ArgumentError('Water intake amount must be positive');
    }

    WaterIntakeEntry entry = WaterIntakeEntry(
      timestamp: DateTime.now(),
      amountLiters: amountLiters,
      source: source,
      notes: notes ?? '',
    );

    _intakeEntries.add(entry);
    intakeAmountLiters += amountLiters;

    print(
      'Logged ${amountLiters.toStringAsFixed(2)}L of $source. Total today: ${intakeAmountLiters.toStringAsFixed(2)}L',
    );
  }

  /// Views the current water intake for the day
  double viewWaterIntake() {
    return intakeAmountLiters;
  }

  /// Updates a specific water intake entry (for corrections)
  void updateWaterIntake(int entryIndex, double newAmountLiters) {
    if (entryIndex < 0 || entryIndex >= _intakeEntries.length) {
      throw ArgumentError('Invalid entry index');
    }
    if (newAmountLiters <= 0) {
      throw ArgumentError('Water intake amount must be positive');
    }

    double oldAmount = _intakeEntries[entryIndex].amountLiters;
    _intakeEntries[entryIndex].amountLiters = newAmountLiters;

    // Update total intake
    intakeAmountLiters = intakeAmountLiters - oldAmount + newAmountLiters;

    print(
      'Updated entry ${entryIndex + 1}: ${oldAmount.toStringAsFixed(2)}L → ${newAmountLiters.toStringAsFixed(2)}L',
    );
  }

  /// Gets the progress towards daily hydration goal (0.0 to 1.0+)
  double getHydrationProgress() {
    return intakeAmountLiters / dailyTarget;
  }

  /// Gets the remaining water needed to reach daily goal
  double getRemainingIntake() {
    double remaining = dailyTarget - intakeAmountLiters;
    return remaining > 0 ? remaining : 0.0;
  }

  /// Checks if daily hydration goal has been achieved
  bool isGoalAchieved() {
    return intakeAmountLiters >= dailyTarget;
  }

  /// Gets recommended intake for the current hour based on daily target
  double getRecommendedHourlyIntake() {
    // Assume 16 waking hours for even distribution
    return dailyTarget / 16;
  }

  /// Checks if user is on track with hourly intake recommendations
  bool isOnTrackForCurrentTime() {
    DateTime now = DateTime.now();
    int wakeHour = 6; // Assuming 6 AM wake time
    int currentWakeHour = now.hour - wakeHour;

    if (currentWakeHour < 0 || currentWakeHour > 16) {
      return true; // Outside recommended tracking hours
    }

    double expectedIntake = getRecommendedHourlyIntake() * currentWakeHour;
    return intakeAmountLiters >= expectedIntake;
  }

  /// Gets hydration status message based on current intake
  String getHydrationStatus() {
    double progress = getHydrationProgress();

    if (progress >= 1.0) {
      return 'Excellent! You\'ve reached your daily hydration goal! 🎉';
    } else if (progress >= 0.8) {
      return 'Great job! You\'re almost at your goal. Keep it up! 💪';
    } else if (progress >= 0.6) {
      return 'Good progress! You\'re more than halfway there. 👍';
    } else if (progress >= 0.4) {
      return 'Making progress! Remember to keep drinking water. 💧';
    } else if (progress >= 0.2) {
      return 'You\'ve started, but you need more water today. 🚰';
    } else {
      return 'Don\'t forget to start hydrating! Your body needs water. 💦';
    }
  }

  /// Gets a detailed daily hydration report
  Map<String, dynamic> getDailyReport() {
    double progress = getHydrationProgress();
    int totalEntries = _intakeEntries.length;
    double averagePerEntry = totalEntries > 0
        ? intakeAmountLiters / totalEntries
        : 0.0;

    // Group entries by hour
    Map<int, double> hourlyIntake = {};
    for (WaterIntakeEntry entry in _intakeEntries) {
      int hour = entry.timestamp.hour;
      hourlyIntake[hour] = (hourlyIntake[hour] ?? 0.0) + entry.amountLiters;
    }

    return {
      'date': date.toString().substring(0, 10),
      'totalIntake': intakeAmountLiters,
      'dailyTarget': dailyTarget,
      'progress': progress,
      'progressPercentage': (progress * 100).toStringAsFixed(1),
      'remainingIntake': getRemainingIntake(),
      'totalEntries': totalEntries,
      'averagePerEntry': averagePerEntry,
      'goalAchieved': isGoalAchieved(),
      'onTrack': isOnTrackForCurrentTime(),
      'status': getHydrationStatus(),
      'hourlyBreakdown': hourlyIntake,
    };
  }

  /// Gets weekly hydration summary from a list of WaterIntake records
  static Map<String, dynamic> getWeeklySummary(
    List<WaterIntake> weeklyRecords,
  ) {
    if (weeklyRecords.isEmpty) {
      return {
        'totalDays': 0,
        'averageDailyIntake': 0.0,
        'goalsAchieved': 0,
        'goalSuccessRate': 0.0,
        'totalIntake': 0.0,
      };
    }

    double totalIntake = weeklyRecords.fold(
      0.0,
      (sum, record) => sum + record.intakeAmountLiters,
    );
    int goalsAchieved = weeklyRecords
        .where((record) => record.isGoalAchieved())
        .length;
    double averageDaily = totalIntake / weeklyRecords.length;
    double successRate = goalsAchieved / weeklyRecords.length;

    return {
      'totalDays': weeklyRecords.length,
      'averageDailyIntake': averageDaily,
      'goalsAchieved': goalsAchieved,
      'goalSuccessRate': successRate,
      'goalSuccessPercentage': (successRate * 100).toStringAsFixed(1),
      'totalIntake': totalIntake,
      'bestDay': weeklyRecords.reduce(
        (a, b) => a.intakeAmountLiters > b.intakeAmountLiters ? a : b,
      ),
      'consistency': _calculateConsistency(weeklyRecords),
    };
  }

  /// Calculates consistency score based on how close daily intakes are to each other
  static double _calculateConsistency(List<WaterIntake> records) {
    if (records.length < 2) return 1.0;

    double average =
        records.fold(0.0, (sum, record) => sum + record.intakeAmountLiters) /
        records.length;
    double sumOfSquares = records.fold(
      0.0,
      (sum, record) =>
          sum +
          ((record.intakeAmountLiters - average) *
              (record.intakeAmountLiters - average)),
    );
    double variance = sumOfSquares / records.length;
    double standardDeviation = variance > 0 ? variance : 0.0;

    // Normalize to 0-1 scale (lower standard deviation = higher consistency)
    return (1.0 / (1.0 + standardDeviation)).clamp(0.0, 1.0);
  }

  /// Removes a water intake entry
  void removeEntry(int entryIndex) {
    if (entryIndex < 0 || entryIndex >= _intakeEntries.length) {
      throw ArgumentError('Invalid entry index');
    }

    WaterIntakeEntry removedEntry = _intakeEntries.removeAt(entryIndex);
    intakeAmountLiters -= removedEntry.amountLiters;

    print(
      'Removed entry: ${removedEntry.amountLiters.toStringAsFixed(2)}L of ${removedEntry.source}',
    );
  }

  /// Resets daily water intake (for new day)
  void resetDailyIntake() {
    intakeAmountLiters = 0.0;
    _intakeEntries.clear();
    date = DateTime.now();
    print('Daily water intake reset for ${date.toString().substring(0, 10)}');
  }

  /// Converts to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'intakeAmountLiters': intakeAmountLiters,
      'dailyTarget': dailyTarget,
      'entries': _intakeEntries.map((entry) => entry.toJson()).toList(),
    };
  }

  /// Creates WaterIntake from JSON
  factory WaterIntake.fromJson(Map<String, dynamic> json) {
    WaterIntake intake = WaterIntake(
      date: DateTime.parse(json['date']),
      intakeAmountLiters: json['intakeAmountLiters'].toDouble(),
      dailyTarget: json['dailyTarget'].toDouble(),
    );

    if (json['entries'] != null) {
      intake._intakeEntries = (json['entries'] as List)
          .map((entryJson) => WaterIntakeEntry.fromJson(entryJson))
          .toList();
    }

    return intake;
  }

  @override
  String toString() {
    return 'WaterIntake(${date.toString().substring(0, 10)}: ${intakeAmountLiters.toStringAsFixed(2)}L / ${dailyTarget.toStringAsFixed(2)}L)';
  }
}

/// Represents a single water intake entry with timestamp and details
class WaterIntakeEntry {
  /// When this water was consumed
  DateTime timestamp;

  /// Amount of water in liters
  double amountLiters;

  /// Source of hydration (e.g., "water", "tea", "coffee", "juice")
  String source;

  /// Optional notes about this intake
  String notes;

  WaterIntakeEntry({
    required this.timestamp,
    required this.amountLiters,
    this.source = 'water',
    this.notes = '',
  });

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'amountLiters': amountLiters,
      'source': source,
      'notes': notes,
    };
  }

  /// Creates from JSON
  factory WaterIntakeEntry.fromJson(Map<String, dynamic> json) {
    return WaterIntakeEntry(
      timestamp: DateTime.parse(json['timestamp']),
      amountLiters: json['amountLiters'].toDouble(),
      source: json['source'] ?? 'water',
      notes: json['notes'] ?? '',
    );
  }

  @override
  String toString() {
    return '${timestamp.toString().substring(11, 16)}: ${amountLiters.toStringAsFixed(2)}L ($source)';
  }
}

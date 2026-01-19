/// Represents a meal entry in the Daily Glow app.
///
/// Manages meal logging with nutritional details including macros,
/// calories, and meal planning for comprehensive nutrition tracking.
class Meal {
  /// Unique meal identifier
  String mealID;

  /// Type of meal (e.g., "breakfast", "lunch", "dinner", "snack")
  String mealType;

  /// List of food items included in this meal
  List<String> foodItems;

  /// Total calories in this meal
  double calories;

  /// Protein content in grams
  double protein;

  /// Carbohydrates content in grams
  double carbs;

  /// Fat content in grams
  double fat;

  /// Date and time when this meal was consumed
  DateTime date;

  /// Additional notes about the meal
  String notes;

  /// Preparation time in minutes
  int preparationTime;

  /// Rating of the meal (1-5 stars)
  int rating;

  /// Creates a new Meal with the specified nutritional information
  Meal({
    required this.mealID,
    required this.mealType,
    required this.foodItems,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    DateTime? date,
    this.notes = '',
    this.preparationTime = 0,
    this.rating = 0,
  }) : date = date ?? DateTime.now() {
    _validateMealData();
  }

  /// Validates meal data for consistency
  void _validateMealData() {
    if (calories < 0) {
      throw ArgumentError('Calories cannot be negative');
    }
    if (protein < 0 || carbs < 0 || fat < 0) {
      throw ArgumentError('Macronutrients cannot be negative');
    }
    if (foodItems.isEmpty) {
      throw ArgumentError('Meal must contain at least one food item');
    }
    if (rating < 0 || rating > 5) {
      throw ArgumentError('Rating must be between 0 and 5');
    }

    final validMealTypes = [
      'breakfast',
      'lunch',
      'dinner',
      'snack',
      'pre-workout',
      'post-workout',
    ];
    if (!validMealTypes.contains(mealType.toLowerCase())) {
      print(
        'Warning: Unusual meal type "$mealType". Consider using: ${validMealTypes.join(', ')}',
      );
    }

    // Warn about unrealistic macronutrient ratios
    double totalMacroCalories = (protein * 4) + (carbs * 4) + (fat * 9);
    if ((totalMacroCalories - calories).abs() > calories * 0.2) {
      print(
        'Warning: Macronutrient calories (${totalMacroCalories.toInt()}) don\'t match total calories (${calories.toInt()})',
      );
    }
  }

  /// Logs this meal to the user's meal history
  void logMeal() {
    print(
      'Logged ${mealType.toLowerCase()}: ${foodItems.join(", ")} - ${calories.toInt()} calories',
    );
  }

  /// Returns detailed meal information
  String viewMeals() {
    StringBuffer mealDetails = StringBuffer();
    mealDetails.writeln('=== ${mealType.toUpperCase()} ===');
    mealDetails.writeln('Date: ${date.toString().substring(0, 16)}');
    mealDetails.writeln('Food Items: ${foodItems.join(", ")}');
    mealDetails.writeln('Calories: ${calories.toInt()}');
    mealDetails.writeln('Protein: ${protein.toStringAsFixed(1)}g');
    mealDetails.writeln('Carbs: ${carbs.toStringAsFixed(1)}g');
    mealDetails.writeln('Fat: ${fat.toStringAsFixed(1)}g');

    if (preparationTime > 0) {
      mealDetails.writeln('Prep Time: $preparationTime minutes');
    }

    if (rating > 0) {
      mealDetails.writeln('Rating: ${'⭐' * rating} ($rating/5)');
    }

    if (notes.isNotEmpty) {
      mealDetails.writeln('Notes: $notes');
    }

    return mealDetails.toString();
  }

  /// Updates meal information
  void updateMeal({
    String? newMealType,
    List<String>? newFoodItems,
    double? newCalories,
    double? newProtein,
    double? newCarbs,
    double? newFat,
    String? newNotes,
    int? newPreparationTime,
    int? newRating,
  }) {
    if (newMealType != null) mealType = newMealType;
    if (newFoodItems != null) foodItems = List.from(newFoodItems);
    if (newCalories != null) calories = newCalories;
    if (newProtein != null) protein = newProtein;
    if (newCarbs != null) carbs = newCarbs;
    if (newFat != null) fat = newFat;
    if (newNotes != null) notes = newNotes;
    if (newPreparationTime != null) preparationTime = newPreparationTime;
    if (newRating != null) rating = newRating;

    _validateMealData();
    print('Updated ${mealType.toLowerCase()}: ${calories.toInt()} calories');
  }

  /// Adds a food item to this meal
  void addFoodItem(
    String foodItem,
    double additionalCalories, {
    double additionalProtein = 0.0,
    double additionalCarbs = 0.0,
    double additionalFat = 0.0,
  }) {
    foodItems.add(foodItem);
    calories += additionalCalories;
    protein += additionalProtein;
    carbs += additionalCarbs;
    fat += additionalFat;

    print(
      'Added $foodItem to ${mealType.toLowerCase()} (+${additionalCalories.toInt()} cal)',
    );
  }

  /// Removes a food item from this meal
  void removeFoodItem(
    String foodItem,
    double calorieReduction, {
    double proteinReduction = 0.0,
    double carbsReduction = 0.0,
    double fatReduction = 0.0,
  }) {
    if (foodItems.remove(foodItem)) {
      calories = (calories - calorieReduction).clamp(0.0, double.infinity);
      protein = (protein - proteinReduction).clamp(0.0, double.infinity);
      carbs = (carbs - carbsReduction).clamp(0.0, double.infinity);
      fat = (fat - fatReduction).clamp(0.0, double.infinity);

      print(
        'Removed $foodItem from ${mealType.toLowerCase()} (-${calorieReduction.toInt()} cal)',
      );
    } else {
      print('Food item "$foodItem" not found in this meal');
    }
  }

  /// Deletes this meal record
  void deleteMeal() {
    print(
      'Deleted ${mealType.toLowerCase()}: ${foodItems.join(", ")} (${calories.toInt()} calories)',
    );
    // In a real app, this would remove from database/storage
  }

  /// Calculates macronutrient percentages
  Map<String, double> getMacronutrientPercentages() {
    double totalMacroCalories = (protein * 4) + (carbs * 4) + (fat * 9);

    if (totalMacroCalories == 0) {
      return {'protein': 0.0, 'carbs': 0.0, 'fat': 0.0};
    }

    return {
      'protein': ((protein * 4) / totalMacroCalories * 100),
      'carbs': ((carbs * 4) / totalMacroCalories * 100),
      'fat': ((fat * 9) / totalMacroCalories * 100),
    };
  }

  /// Returns meal summary data
  Map<String, dynamic> getMealSummary() {
    Map<String, double> macroPercentages = getMacronutrientPercentages();

    return {
      'mealID': mealID,
      'mealType': mealType,
      'foodItems': foodItems,
      'totalCalories': calories,
      'macronutrients': {
        'protein': {
          'grams': protein,
          'percentage': macroPercentages['protein']!.toStringAsFixed(1),
        },
        'carbs': {
          'grams': carbs,
          'percentage': macroPercentages['carbs']!.toStringAsFixed(1),
        },
        'fat': {
          'grams': fat,
          'percentage': macroPercentages['fat']!.toStringAsFixed(1),
        },
      },
      'date': date.toString().substring(0, 16),
      'rating': rating,
      'preparationTime': preparationTime,
    };
  }

  /// Generates daily summary from meal list
  static Map<String, dynamic> getDailySummary(List<Meal> dailyMeals) {
    if (dailyMeals.isEmpty) {
      return {
        'totalMeals': 0,
        'totalCalories': 0.0,
        'totalProtein': 0.0,
        'totalCarbs': 0.0,
        'totalFat': 0.0,
        'macroPercentages': {'protein': 0.0, 'carbs': 0.0, 'fat': 0.0},
        'mealTypes': <String>[],
        'averageRating': 0.0,
      };
    }

    double totalCalories = dailyMeals.fold(
      0.0,
      (sum, meal) => sum + meal.calories,
    );
    double totalProtein = dailyMeals.fold(
      0.0,
      (sum, meal) => sum + meal.protein,
    );
    double totalCarbs = dailyMeals.fold(0.0, (sum, meal) => sum + meal.carbs);
    double totalFat = dailyMeals.fold(0.0, (sum, meal) => sum + meal.fat);

    List<String> mealTypes = dailyMeals.map((meal) => meal.mealType).toList();
    double averageRating =
        dailyMeals
            .where((meal) => meal.rating > 0)
            .fold(0.0, (sum, meal) => sum + meal.rating) /
        dailyMeals.where((meal) => meal.rating > 0).length;

    double totalMacroCalories =
        (totalProtein * 4) + (totalCarbs * 4) + (totalFat * 9);
    Map<String, double> macroPercentages = totalMacroCalories > 0
        ? {
            'protein': (totalProtein * 4) / totalMacroCalories * 100,
            'carbs': (totalCarbs * 4) / totalMacroCalories * 100,
            'fat': (totalFat * 9) / totalMacroCalories * 100,
          }
        : {'protein': 0.0, 'carbs': 0.0, 'fat': 0.0};

    return {
      'totalMeals': dailyMeals.length,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'macroPercentages': macroPercentages,
      'mealTypes': mealTypes,
      'averageRating': averageRating.isNaN ? 0.0 : averageRating,
      'calorieDistribution': _getCalorieDistribution(dailyMeals),
    };
  }

  /// Calculates calorie distribution by type
  static Map<String, double> _getCalorieDistribution(List<Meal> meals) {
    Map<String, double> distribution = {};
    double totalCalories = meals.fold(0.0, (sum, meal) => sum + meal.calories);

    for (Meal meal in meals) {
      distribution[meal.mealType] =
          (distribution[meal.mealType] ?? 0.0) + meal.calories;
    }

    // Convert to percentages
    if (totalCalories > 0) {
      distribution.updateAll((key, value) => (value / totalCalories) * 100);
    }

    return distribution;
  }

  /// Suggests meal plan based on targets
  static List<Map<String, dynamic>> suggestMealPlan({
    required double dailyCalorieTarget,
    required double proteinTarget,
    required double carbsTarget,
    required double fatTarget,
  }) {
    // Simple meal plan template (in a real app, this would be more sophisticated)
    return [
      {
        'mealType': 'breakfast',
        'targetCalories': dailyCalorieTarget * 0.25,
        'targetProtein': proteinTarget * 0.25,
        'targetCarbs': carbsTarget * 0.30,
        'targetFat': fatTarget * 0.25,
        'suggestions': [
          'oatmeal with berries',
          'Greek yogurt with nuts',
          'whole grain toast with avocado',
        ],
      },
      {
        'mealType': 'lunch',
        'targetCalories': dailyCalorieTarget * 0.35,
        'targetProtein': proteinTarget * 0.40,
        'targetCarbs': carbsTarget * 0.35,
        'targetFat': fatTarget * 0.30,
        'suggestions': [
          'grilled chicken salad',
          'quinoa bowl with vegetables',
          'lean protein with sweet potato',
        ],
      },
      {
        'mealType': 'dinner',
        'targetCalories': dailyCalorieTarget * 0.30,
        'targetProtein': proteinTarget * 0.30,
        'targetCarbs': carbsTarget * 0.25,
        'targetFat': fatTarget * 0.35,
        'suggestions': [
          'salmon with vegetables',
          'lean beef with brown rice',
          'tofu stir-fry',
        ],
      },
      {
        'mealType': 'snack',
        'targetCalories': dailyCalorieTarget * 0.10,
        'targetProtein': proteinTarget * 0.05,
        'targetCarbs': carbsTarget * 0.10,
        'targetFat': fatTarget * 0.10,
        'suggestions': [
          'mixed nuts',
          'protein smoothie',
          'apple with almond butter',
        ],
      },
    ];
  }

  /// Converts meal to JSON
  Map<String, dynamic> toJson() {
    return {
      'mealID': mealID,
      'mealType': mealType,
      'foodItems': foodItems,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'date': date.toIso8601String(),
      'notes': notes,
      'preparationTime': preparationTime,
      'rating': rating,
    };
  }

  /// Creates meal from JSON
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealID: json['mealID'],
      mealType: json['mealType'],
      foodItems: List<String>.from(json['foodItems']),
      calories: json['calories'].toDouble(),
      protein: json['protein'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fat: json['fat'].toDouble(),
      date: DateTime.parse(json['date']),
      notes: json['notes'] ?? '',
      preparationTime: json['preparationTime'] ?? 0,
      rating: json['rating'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Meal($mealType: ${calories.toInt()}cal, P:${protein.toInt()}g C:${carbs.toInt()}g F:${fat.toInt()}g)';
  }

  /// Returns brief string for lists
  String toBriefString() {
    return '$mealType - ${calories.toInt()}cal (${foodItems.length} items)';
  }
}

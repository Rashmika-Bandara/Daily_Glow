// Health Plan Data for different BMI categories

class WorkoutPlan {
  final String focus;
  final String duration;
  final String calories;

  WorkoutPlan({
    required this.focus,
    required this.duration,
    required this.calories,
  });
}

class FoodItem {
  final String name;
  final String weight;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  FoodItem({
    required this.name,
    required this.weight,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  String get nutritionSummary =>
      '$calories kcal | P: ${protein.toStringAsFixed(1)}g | C: ${carbs.toStringAsFixed(1)}g | F: ${fat.toStringAsFixed(1)}g';
}

class Meal {
  final List<FoodItem> items;

  Meal({required this.items});

  int get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  double get totalProtein => items.fold(0.0, (sum, item) => sum + item.protein);
  double get totalCarbs => items.fold(0.0, (sum, item) => sum + item.carbs);
  double get totalFat => items.fold(0.0, (sum, item) => sum + item.fat);

  String get summary {
    if (items.isEmpty) return '';
    return items.map((item) => item.name).join(', ');
  }

  String get detailedSummary {
    if (items.isEmpty) return '';
    return items.map((item) => '${item.name} (${item.weight})').join('\n');
  }

  String get nutritionSummary =>
      '$totalCalories kcal | P: ${totalProtein.toStringAsFixed(1)}g | C: ${totalCarbs.toStringAsFixed(1)}g | F: ${totalFat.toStringAsFixed(1)}g';
}

class MealPlan {
  final Meal breakfast;
  final Meal lunch;
  final Meal snack;
  final Meal dinner;

  MealPlan({
    required this.breakfast,
    required this.lunch,
    required this.snack,
    required this.dinner,
  });

  int get totalCalories =>
      breakfast.totalCalories +
      lunch.totalCalories +
      snack.totalCalories +
      dinner.totalCalories;
}

class WaterSchedule {
  final List<WaterIntake> schedule;
  final String dailyTotal;

  WaterSchedule({
    required this.schedule,
    required this.dailyTotal,
  });
}

class WaterIntake {
  final String time;
  final String amount;

  WaterIntake({
    required this.time,
    required this.amount,
  });
}

class DayPlan {
  final WorkoutPlan workout;
  final MealPlan meals;
  final WaterSchedule water;

  DayPlan({
    required this.workout,
    required this.meals,
    required this.water,
  });
}

// UNDERWEIGHT Plans (BMI < 18.5)
class UnderweightPlans {
  static final List<WorkoutPlan> workouts = [
    WorkoutPlan(
        focus: 'Light strength + walk',
        duration: '40 min',
        calories: '250 kcal'),
    WorkoutPlan(focus: 'Yoga + core', duration: '40 min', calories: '220 kcal'),
    WorkoutPlan(
        focus: 'Strength (upper body)',
        duration: '45 min',
        calories: '280 kcal'),
    WorkoutPlan(
        focus: 'Active recovery', duration: '30 min', calories: '180 kcal'),
    WorkoutPlan(
        focus: 'Strength (lower body)',
        duration: '45 min',
        calories: '300 kcal'),
    WorkoutPlan(
        focus: 'Brisk walk + stretch',
        duration: '40 min',
        calories: '240 kcal'),
    WorkoutPlan(
        focus: 'Full body light', duration: '35 min', calories: '200 kcal'),
  ];

  static final List<MealPlan> meals = [
    // Day 1
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '60 g',
            calories: 228,
            protein: 7.8,
            carbs: 38.4,
            fat: 4.2),
        FoodItem(
            name: 'Whole Milk',
            weight: '250 ml',
            calories: 160,
            protein: 8.0,
            carbs: 12.0,
            fat: 8.0),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2 (100 g)',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'White Rice',
            weight: '180 g',
            calories: 235,
            protein: 4.5,
            carbs: 52.0,
            fat: 0.4),
        FoodItem(
            name: 'Chicken Breast',
            weight: '150 g',
            calories: 248,
            protein: 46.5,
            carbs: 0,
            fat: 5.4),
        FoodItem(
            name: 'Mixed Veggies',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Banana',
            weight: '120 g',
            calories: 105,
            protein: 1.3,
            carbs: 27.0,
            fat: 0.4),
        FoodItem(
            name: 'Peanuts',
            weight: '20 g',
            calories: 113,
            protein: 5.2,
            carbs: 4.0,
            fat: 9.8),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2 (80 g)',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Lentil Curry',
            weight: '150 g',
            calories: 170,
            protein: 12.0,
            carbs: 24.0,
            fat: 3.0),
      ]),
    ),
    // Day 2-7 use same meals (you can customize each day if needed)
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '60 g',
            calories: 228,
            protein: 7.8,
            carbs: 38.4,
            fat: 4.2),
        FoodItem(
            name: 'Whole Milk',
            weight: '250 ml',
            calories: 160,
            protein: 8.0,
            carbs: 12.0,
            fat: 8.0),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2 (100 g)',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'White Rice',
            weight: '180 g',
            calories: 235,
            protein: 4.5,
            carbs: 52.0,
            fat: 0.4),
        FoodItem(
            name: 'Chicken Breast',
            weight: '150 g',
            calories: 248,
            protein: 46.5,
            carbs: 0,
            fat: 5.4),
        FoodItem(
            name: 'Mixed Veggies',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Banana',
            weight: '120 g',
            calories: 105,
            protein: 1.3,
            carbs: 27.0,
            fat: 0.4),
        FoodItem(
            name: 'Peanuts',
            weight: '20 g',
            calories: 113,
            protein: 5.2,
            carbs: 4.0,
            fat: 9.8),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2 (80 g)',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Lentil Curry',
            weight: '150 g',
            calories: 170,
            protein: 12.0,
            carbs: 24.0,
            fat: 3.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '60 g',
            calories: 228,
            protein: 7.8,
            carbs: 38.4,
            fat: 4.2),
        FoodItem(
            name: 'Whole Milk',
            weight: '250 ml',
            calories: 160,
            protein: 8.0,
            carbs: 12.0,
            fat: 8.0),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2 (100 g)',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'White Rice',
            weight: '180 g',
            calories: 235,
            protein: 4.5,
            carbs: 52.0,
            fat: 0.4),
        FoodItem(
            name: 'Chicken Breast',
            weight: '150 g',
            calories: 248,
            protein: 46.5,
            carbs: 0,
            fat: 5.4),
        FoodItem(
            name: 'Mixed Veggies',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Banana',
            weight: '120 g',
            calories: 105,
            protein: 1.3,
            carbs: 27.0,
            fat: 0.4),
        FoodItem(
            name: 'Peanuts',
            weight: '20 g',
            calories: 113,
            protein: 5.2,
            carbs: 4.0,
            fat: 9.8),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2 (80 g)',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Lentil Curry',
            weight: '150 g',
            calories: 170,
            protein: 12.0,
            carbs: 24.0,
            fat: 3.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '60 g',
            calories: 228,
            protein: 7.8,
            carbs: 38.4,
            fat: 4.2),
        FoodItem(
            name: 'Whole Milk',
            weight: '250 ml',
            calories: 160,
            protein: 8.0,
            carbs: 12.0,
            fat: 8.0),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2 (100 g)',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'White Rice',
            weight: '180 g',
            calories: 235,
            protein: 4.5,
            carbs: 52.0,
            fat: 0.4),
        FoodItem(
            name: 'Chicken Breast',
            weight: '150 g',
            calories: 248,
            protein: 46.5,
            carbs: 0,
            fat: 5.4),
        FoodItem(
            name: 'Mixed Veggies',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Banana',
            weight: '120 g',
            calories: 105,
            protein: 1.3,
            carbs: 27.0,
            fat: 0.4),
        FoodItem(
            name: 'Peanuts',
            weight: '20 g',
            calories: 113,
            protein: 5.2,
            carbs: 4.0,
            fat: 9.8),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2 (80 g)',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Lentil Curry',
            weight: '150 g',
            calories: 170,
            protein: 12.0,
            carbs: 24.0,
            fat: 3.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '60 g',
            calories: 228,
            protein: 7.8,
            carbs: 38.4,
            fat: 4.2),
        FoodItem(
            name: 'Whole Milk',
            weight: '250 ml',
            calories: 160,
            protein: 8.0,
            carbs: 12.0,
            fat: 8.0),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2 (100 g)',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'White Rice',
            weight: '180 g',
            calories: 235,
            protein: 4.5,
            carbs: 52.0,
            fat: 0.4),
        FoodItem(
            name: 'Chicken Breast',
            weight: '150 g',
            calories: 248,
            protein: 46.5,
            carbs: 0,
            fat: 5.4),
        FoodItem(
            name: 'Mixed Veggies',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Banana',
            weight: '120 g',
            calories: 105,
            protein: 1.3,
            carbs: 27.0,
            fat: 0.4),
        FoodItem(
            name: 'Peanuts',
            weight: '20 g',
            calories: 113,
            protein: 5.2,
            carbs: 4.0,
            fat: 9.8),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2 (80 g)',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Lentil Curry',
            weight: '150 g',
            calories: 170,
            protein: 12.0,
            carbs: 24.0,
            fat: 3.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '60 g',
            calories: 228,
            protein: 7.8,
            carbs: 38.4,
            fat: 4.2),
        FoodItem(
            name: 'Whole Milk',
            weight: '250 ml',
            calories: 160,
            protein: 8.0,
            carbs: 12.0,
            fat: 8.0),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2 (100 g)',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'White Rice',
            weight: '180 g',
            calories: 235,
            protein: 4.5,
            carbs: 52.0,
            fat: 0.4),
        FoodItem(
            name: 'Chicken Breast',
            weight: '150 g',
            calories: 248,
            protein: 46.5,
            carbs: 0,
            fat: 5.4),
        FoodItem(
            name: 'Mixed Veggies',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Banana',
            weight: '120 g',
            calories: 105,
            protein: 1.3,
            carbs: 27.0,
            fat: 0.4),
        FoodItem(
            name: 'Peanuts',
            weight: '20 g',
            calories: 113,
            protein: 5.2,
            carbs: 4.0,
            fat: 9.8),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2 (80 g)',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Lentil Curry',
            weight: '150 g',
            calories: 170,
            protein: 12.0,
            carbs: 24.0,
            fat: 3.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '60 g',
            calories: 228,
            protein: 7.8,
            carbs: 38.4,
            fat: 4.2),
        FoodItem(
            name: 'Whole Milk',
            weight: '250 ml',
            calories: 160,
            protein: 8.0,
            carbs: 12.0,
            fat: 8.0),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2 (100 g)',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'White Rice',
            weight: '180 g',
            calories: 235,
            protein: 4.5,
            carbs: 52.0,
            fat: 0.4),
        FoodItem(
            name: 'Chicken Breast',
            weight: '150 g',
            calories: 248,
            protein: 46.5,
            carbs: 0,
            fat: 5.4),
        FoodItem(
            name: 'Mixed Veggies',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Banana',
            weight: '120 g',
            calories: 105,
            protein: 1.3,
            carbs: 27.0,
            fat: 0.4),
        FoodItem(
            name: 'Peanuts',
            weight: '20 g',
            calories: 113,
            protein: 5.2,
            carbs: 4.0,
            fat: 9.8),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2 (80 g)',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Lentil Curry',
            weight: '150 g',
            calories: 170,
            protein: 12.0,
            carbs: 24.0,
            fat: 3.0),
      ]),
    ),
  ];

  static final WaterSchedule water = WaterSchedule(
    dailyTotal: '~2.0 L',
    schedule: [
      WaterIntake(time: '6:30 AM', amount: '400 ml'),
      WaterIntake(time: '9:30 AM', amount: '300 ml'),
      WaterIntake(time: '12:30 PM', amount: '400 ml'),
      WaterIntake(time: '3:30 PM', amount: '300 ml'),
      WaterIntake(time: '6:30 PM', amount: '300 ml'),
      WaterIntake(time: '9:00 PM', amount: '200 ml'),
    ],
  );

  static const String calorieTarget = '2400–2600 kcal';
  static const String goal = 'Healthy weight gain, muscle, energy';
}

// NORMAL WEIGHT Plans (BMI 18.5–24.9)
class NormalWeightPlans {
  static final List<WorkoutPlan> workouts = [
    WorkoutPlan(
        focus: 'Jogging + core', duration: '45 min', calories: '400 kcal'),
    WorkoutPlan(
        focus: 'Strength training', duration: '45 min', calories: '420 kcal'),
    WorkoutPlan(focus: 'Cycling', duration: '40 min', calories: '380 kcal'),
    WorkoutPlan(
        focus: 'Yoga + stretch', duration: '35 min', calories: '220 kcal'),
    WorkoutPlan(
        focus: 'HIIT (light)', duration: '30 min', calories: '450 kcal'),
    WorkoutPlan(focus: 'Brisk walk', duration: '45 min', calories: '350 kcal'),
    WorkoutPlan(
        focus: 'Recovery yoga', duration: '30 min', calories: '200 kcal'),
  ];

  static final List<MealPlan> meals = [
    // Day 1
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '50 g',
            calories: 190,
            protein: 6.5,
            carbs: 32.0,
            fat: 3.5),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '150 g',
            calories: 170,
            protein: 4.0,
            carbs: 36.0,
            fat: 1.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 210,
            protein: 28.0,
            carbs: 0,
            fat: 10.0),
        FoodItem(
            name: 'Vegetables',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Greek Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
        FoodItem(
            name: 'Almonds',
            weight: '15 g',
            calories: 87,
            protein: 3.2,
            carbs: 3.0,
            fat: 7.5),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Vegetable Curry',
            weight: '150 g',
            calories: 140,
            protein: 4.0,
            carbs: 20.0,
            fat: 5.0),
      ]),
    ),
    // Day 2-7 use same meals
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '50 g',
            calories: 190,
            protein: 6.5,
            carbs: 32.0,
            fat: 3.5),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '150 g',
            calories: 170,
            protein: 4.0,
            carbs: 36.0,
            fat: 1.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 210,
            protein: 28.0,
            carbs: 0,
            fat: 10.0),
        FoodItem(
            name: 'Vegetables',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Greek Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
        FoodItem(
            name: 'Almonds',
            weight: '15 g',
            calories: 87,
            protein: 3.2,
            carbs: 3.0,
            fat: 7.5),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Vegetable Curry',
            weight: '150 g',
            calories: 140,
            protein: 4.0,
            carbs: 20.0,
            fat: 5.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '50 g',
            calories: 190,
            protein: 6.5,
            carbs: 32.0,
            fat: 3.5),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '150 g',
            calories: 170,
            protein: 4.0,
            carbs: 36.0,
            fat: 1.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 210,
            protein: 28.0,
            carbs: 0,
            fat: 10.0),
        FoodItem(
            name: 'Vegetables',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Greek Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
        FoodItem(
            name: 'Almonds',
            weight: '15 g',
            calories: 87,
            protein: 3.2,
            carbs: 3.0,
            fat: 7.5),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Vegetable Curry',
            weight: '150 g',
            calories: 140,
            protein: 4.0,
            carbs: 20.0,
            fat: 5.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '50 g',
            calories: 190,
            protein: 6.5,
            carbs: 32.0,
            fat: 3.5),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '150 g',
            calories: 170,
            protein: 4.0,
            carbs: 36.0,
            fat: 1.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 210,
            protein: 28.0,
            carbs: 0,
            fat: 10.0),
        FoodItem(
            name: 'Vegetables',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Greek Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
        FoodItem(
            name: 'Almonds',
            weight: '15 g',
            calories: 87,
            protein: 3.2,
            carbs: 3.0,
            fat: 7.5),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Vegetable Curry',
            weight: '150 g',
            calories: 140,
            protein: 4.0,
            carbs: 20.0,
            fat: 5.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '50 g',
            calories: 190,
            protein: 6.5,
            carbs: 32.0,
            fat: 3.5),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '150 g',
            calories: 170,
            protein: 4.0,
            carbs: 36.0,
            fat: 1.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 210,
            protein: 28.0,
            carbs: 0,
            fat: 10.0),
        FoodItem(
            name: 'Vegetables',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Greek Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
        FoodItem(
            name: 'Almonds',
            weight: '15 g',
            calories: 87,
            protein: 3.2,
            carbs: 3.0,
            fat: 7.5),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Vegetable Curry',
            weight: '150 g',
            calories: 140,
            protein: 4.0,
            carbs: 20.0,
            fat: 5.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '50 g',
            calories: 190,
            protein: 6.5,
            carbs: 32.0,
            fat: 3.5),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '150 g',
            calories: 170,
            protein: 4.0,
            carbs: 36.0,
            fat: 1.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 210,
            protein: 28.0,
            carbs: 0,
            fat: 10.0),
        FoodItem(
            name: 'Vegetables',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Greek Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
        FoodItem(
            name: 'Almonds',
            weight: '15 g',
            calories: 87,
            protein: 3.2,
            carbs: 3.0,
            fat: 7.5),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Vegetable Curry',
            weight: '150 g',
            calories: 140,
            protein: 4.0,
            carbs: 20.0,
            fat: 5.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '50 g',
            calories: 190,
            protein: 6.5,
            carbs: 32.0,
            fat: 3.5),
        FoodItem(
            name: 'Boiled Eggs',
            weight: '2',
            calories: 155,
            protein: 13.0,
            carbs: 1.0,
            fat: 11.0),
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '150 g',
            calories: 170,
            protein: 4.0,
            carbs: 36.0,
            fat: 1.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 210,
            protein: 28.0,
            carbs: 0,
            fat: 10.0),
        FoodItem(
            name: 'Vegetables',
            weight: '100 g',
            calories: 50,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Greek Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
        FoodItem(
            name: 'Almonds',
            weight: '15 g',
            calories: 87,
            protein: 3.2,
            carbs: 3.0,
            fat: 7.5),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Whole Wheat Roti',
            weight: '2',
            calories: 180,
            protein: 6.0,
            carbs: 36.0,
            fat: 4.0),
        FoodItem(
            name: 'Vegetable Curry',
            weight: '150 g',
            calories: 140,
            protein: 4.0,
            carbs: 20.0,
            fat: 5.0),
      ]),
    ),
  ];

  static final WaterSchedule water = WaterSchedule(
    dailyTotal: '~3.0 L',
    schedule: [
      WaterIntake(time: '6:30 AM', amount: '500 ml'),
      WaterIntake(time: '9:30 AM', amount: '400 ml'),
      WaterIntake(time: '12:30 PM', amount: '500 ml'),
      WaterIntake(time: '3:30 PM', amount: '400 ml'),
      WaterIntake(time: '6:30 PM', amount: '400 ml'),
      WaterIntake(time: '9:00 PM', amount: '300 ml'),
      WaterIntake(time: 'Post-workout', amount: '+300 ml'),
    ],
  );

  static const String calorieTarget = '2000–2200 kcal';
  static const String goal = 'Maintain fitness & stamina';
}

// OVERWEIGHT Plans (BMI 25–29.9)
class OverweightPlans {
  static final List<WorkoutPlan> workouts = [
    WorkoutPlan(focus: 'Brisk walk', duration: '45 min', calories: '300 kcal'),
    WorkoutPlan(focus: 'Cycling', duration: '40 min', calories: '350 kcal'),
    WorkoutPlan(
        focus: 'Strength (light)', duration: '30 min', calories: '250 kcal'),
    WorkoutPlan(focus: 'Walking', duration: '40 min', calories: '280 kcal'),
    WorkoutPlan(focus: 'Cardio mix', duration: '45 min', calories: '400 kcal'),
    WorkoutPlan(focus: 'Yoga', duration: '35 min', calories: '220 kcal'),
    WorkoutPlan(
        focus: 'Recovery walk', duration: '30 min', calories: '200 kcal'),
  ];

  static final List<MealPlan> meals = [
    // Day 1
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '40 g',
            calories: 152,
            protein: 5.2,
            carbs: 25.6,
            fat: 2.8),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Papaya',
            weight: '150 g',
            calories: 60,
            protein: 0.8,
            carbs: 15.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '120 g',
            calories: 135,
            protein: 3.2,
            carbs: 28.0,
            fat: 1.2),
        FoodItem(
            name: 'Grilled Chicken',
            weight: '120 g',
            calories: 198,
            protein: 37.0,
            carbs: 0,
            fat: 4.3),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
        FoodItem(
            name: 'Nuts',
            weight: '10 g',
            calories: 60,
            protein: 2.0,
            carbs: 2.0,
            fat: 5.0),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '250 g',
            calories: 120,
            protein: 5.0,
            carbs: 18.0,
            fat: 3.0),
        FoodItem(
            name: 'Roti',
            weight: '1',
            calories: 90,
            protein: 3.0,
            carbs: 18.0,
            fat: 2.0),
      ]),
    ),
    // Day 2-7 use same meals
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '40 g',
            calories: 152,
            protein: 5.2,
            carbs: 25.6,
            fat: 2.8),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Papaya',
            weight: '150 g',
            calories: 60,
            protein: 0.8,
            carbs: 15.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '120 g',
            calories: 135,
            protein: 3.2,
            carbs: 28.0,
            fat: 1.2),
        FoodItem(
            name: 'Grilled Chicken',
            weight: '120 g',
            calories: 198,
            protein: 37.0,
            carbs: 0,
            fat: 4.3),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
        FoodItem(
            name: 'Nuts',
            weight: '10 g',
            calories: 60,
            protein: 2.0,
            carbs: 2.0,
            fat: 5.0),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '250 g',
            calories: 120,
            protein: 5.0,
            carbs: 18.0,
            fat: 3.0),
        FoodItem(
            name: 'Roti',
            weight: '1',
            calories: 90,
            protein: 3.0,
            carbs: 18.0,
            fat: 2.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '40 g',
            calories: 152,
            protein: 5.2,
            carbs: 25.6,
            fat: 2.8),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Papaya',
            weight: '150 g',
            calories: 60,
            protein: 0.8,
            carbs: 15.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '120 g',
            calories: 135,
            protein: 3.2,
            carbs: 28.0,
            fat: 1.2),
        FoodItem(
            name: 'Grilled Chicken',
            weight: '120 g',
            calories: 198,
            protein: 37.0,
            carbs: 0,
            fat: 4.3),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
        FoodItem(
            name: 'Nuts',
            weight: '10 g',
            calories: 60,
            protein: 2.0,
            carbs: 2.0,
            fat: 5.0),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '250 g',
            calories: 120,
            protein: 5.0,
            carbs: 18.0,
            fat: 3.0),
        FoodItem(
            name: 'Roti',
            weight: '1',
            calories: 90,
            protein: 3.0,
            carbs: 18.0,
            fat: 2.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '40 g',
            calories: 152,
            protein: 5.2,
            carbs: 25.6,
            fat: 2.8),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Papaya',
            weight: '150 g',
            calories: 60,
            protein: 0.8,
            carbs: 15.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '120 g',
            calories: 135,
            protein: 3.2,
            carbs: 28.0,
            fat: 1.2),
        FoodItem(
            name: 'Grilled Chicken',
            weight: '120 g',
            calories: 198,
            protein: 37.0,
            carbs: 0,
            fat: 4.3),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
        FoodItem(
            name: 'Nuts',
            weight: '10 g',
            calories: 60,
            protein: 2.0,
            carbs: 2.0,
            fat: 5.0),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '250 g',
            calories: 120,
            protein: 5.0,
            carbs: 18.0,
            fat: 3.0),
        FoodItem(
            name: 'Roti',
            weight: '1',
            calories: 90,
            protein: 3.0,
            carbs: 18.0,
            fat: 2.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '40 g',
            calories: 152,
            protein: 5.2,
            carbs: 25.6,
            fat: 2.8),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Papaya',
            weight: '150 g',
            calories: 60,
            protein: 0.8,
            carbs: 15.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '120 g',
            calories: 135,
            protein: 3.2,
            carbs: 28.0,
            fat: 1.2),
        FoodItem(
            name: 'Grilled Chicken',
            weight: '120 g',
            calories: 198,
            protein: 37.0,
            carbs: 0,
            fat: 4.3),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
        FoodItem(
            name: 'Nuts',
            weight: '10 g',
            calories: 60,
            protein: 2.0,
            carbs: 2.0,
            fat: 5.0),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '250 g',
            calories: 120,
            protein: 5.0,
            carbs: 18.0,
            fat: 3.0),
        FoodItem(
            name: 'Roti',
            weight: '1',
            calories: 90,
            protein: 3.0,
            carbs: 18.0,
            fat: 2.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '40 g',
            calories: 152,
            protein: 5.2,
            carbs: 25.6,
            fat: 2.8),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Papaya',
            weight: '150 g',
            calories: 60,
            protein: 0.8,
            carbs: 15.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '120 g',
            calories: 135,
            protein: 3.2,
            carbs: 28.0,
            fat: 1.2),
        FoodItem(
            name: 'Grilled Chicken',
            weight: '120 g',
            calories: 198,
            protein: 37.0,
            carbs: 0,
            fat: 4.3),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
        FoodItem(
            name: 'Nuts',
            weight: '10 g',
            calories: 60,
            protein: 2.0,
            carbs: 2.0,
            fat: 5.0),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '250 g',
            calories: 120,
            protein: 5.0,
            carbs: 18.0,
            fat: 3.0),
        FoodItem(
            name: 'Roti',
            weight: '1',
            calories: 90,
            protein: 3.0,
            carbs: 18.0,
            fat: 2.0),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '40 g',
            calories: 152,
            protein: 5.2,
            carbs: 25.6,
            fat: 2.8),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Papaya',
            weight: '150 g',
            calories: 60,
            protein: 0.8,
            carbs: 15.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Brown Rice',
            weight: '120 g',
            calories: 135,
            protein: 3.2,
            carbs: 28.0,
            fat: 1.2),
        FoodItem(
            name: 'Grilled Chicken',
            weight: '120 g',
            calories: 198,
            protein: 37.0,
            carbs: 0,
            fat: 4.3),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Apple',
            weight: '150 g',
            calories: 95,
            protein: 0.5,
            carbs: 25.0,
            fat: 0.3),
        FoodItem(
            name: 'Nuts',
            weight: '10 g',
            calories: 60,
            protein: 2.0,
            carbs: 2.0,
            fat: 5.0),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '250 g',
            calories: 120,
            protein: 5.0,
            carbs: 18.0,
            fat: 3.0),
        FoodItem(
            name: 'Roti',
            weight: '1',
            calories: 90,
            protein: 3.0,
            carbs: 18.0,
            fat: 2.0),
      ]),
    ),
  ];

  static final WaterSchedule water = WaterSchedule(
    dailyTotal: '~3.2 L',
    schedule: [
      WaterIntake(time: '6:30 AM', amount: '500 ml'),
      WaterIntake(time: '9:30 AM', amount: '450 ml'),
      WaterIntake(time: '12:30 PM', amount: '550 ml'),
      WaterIntake(time: '3:30 PM', amount: '450 ml'),
      WaterIntake(time: '6:30 PM', amount: '450 ml'),
      WaterIntake(time: '9:00 PM', amount: '300 ml'),
    ],
  );

  static const String calorieTarget = '1700–1800 kcal';
  static const String goal = 'Fat loss, heart health';
}

// OBESE Plans (BMI ≥ 30)
class ObesePlans {
  static final List<WorkoutPlan> workouts = [
    WorkoutPlan(focus: 'Slow walk', duration: '40 min', calories: '200 kcal'),
    WorkoutPlan(
        focus: 'Chair exercises', duration: '30 min', calories: '150 kcal'),
    WorkoutPlan(focus: 'Walking', duration: '45 min', calories: '230 kcal'),
    WorkoutPlan(focus: 'Stretching', duration: '30 min', calories: '120 kcal'),
    WorkoutPlan(focus: 'Walking', duration: '45 min', calories: '250 kcal'),
    WorkoutPlan(focus: 'Yoga', duration: '30 min', calories: '140 kcal'),
    WorkoutPlan(focus: 'Recovery', duration: '25 min', calories: '100 kcal'),
  ];

  static final List<MealPlan> meals = [
    // Day 1
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '35 g',
            calories: 133,
            protein: 4.5,
            carbs: 22.4,
            fat: 2.4),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Orange',
            weight: '150 g',
            calories: 70,
            protein: 1.2,
            carbs: 17.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Steamed Vegetables',
            weight: '200 g',
            calories: 100,
            protein: 4.0,
            carbs: 20.0,
            fat: 0.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 180,
            protein: 26.0,
            carbs: 0,
            fat: 8.0),
        FoodItem(
            name: 'Brown Rice',
            weight: '100 g',
            calories: 110,
            protein: 2.5,
            carbs: 23.0,
            fat: 1.0),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Cucumber',
            weight: '200 g',
            calories: 30,
            protein: 1.0,
            carbs: 7.0,
            fat: 0.1),
        FoodItem(
            name: 'Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '300 g',
            calories: 140,
            protein: 6.0,
            carbs: 20.0,
            fat: 3.0),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
    ),
    // Day 2-7 use same meals
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '35 g',
            calories: 133,
            protein: 4.5,
            carbs: 22.4,
            fat: 2.4),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Orange',
            weight: '150 g',
            calories: 70,
            protein: 1.2,
            carbs: 17.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Steamed Vegetables',
            weight: '200 g',
            calories: 100,
            protein: 4.0,
            carbs: 20.0,
            fat: 0.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 180,
            protein: 26.0,
            carbs: 0,
            fat: 8.0),
        FoodItem(
            name: 'Brown Rice',
            weight: '100 g',
            calories: 110,
            protein: 2.5,
            carbs: 23.0,
            fat: 1.0),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Cucumber',
            weight: '200 g',
            calories: 30,
            protein: 1.0,
            carbs: 7.0,
            fat: 0.1),
        FoodItem(
            name: 'Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '300 g',
            calories: 140,
            protein: 6.0,
            carbs: 20.0,
            fat: 3.0),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '35 g',
            calories: 133,
            protein: 4.5,
            carbs: 22.4,
            fat: 2.4),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Orange',
            weight: '150 g',
            calories: 70,
            protein: 1.2,
            carbs: 17.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Steamed Vegetables',
            weight: '200 g',
            calories: 100,
            protein: 4.0,
            carbs: 20.0,
            fat: 0.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 180,
            protein: 26.0,
            carbs: 0,
            fat: 8.0),
        FoodItem(
            name: 'Brown Rice',
            weight: '100 g',
            calories: 110,
            protein: 2.5,
            carbs: 23.0,
            fat: 1.0),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Cucumber',
            weight: '200 g',
            calories: 30,
            protein: 1.0,
            carbs: 7.0,
            fat: 0.1),
        FoodItem(
            name: 'Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '300 g',
            calories: 140,
            protein: 6.0,
            carbs: 20.0,
            fat: 3.0),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '35 g',
            calories: 133,
            protein: 4.5,
            carbs: 22.4,
            fat: 2.4),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Orange',
            weight: '150 g',
            calories: 70,
            protein: 1.2,
            carbs: 17.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Steamed Vegetables',
            weight: '200 g',
            calories: 100,
            protein: 4.0,
            carbs: 20.0,
            fat: 0.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 180,
            protein: 26.0,
            carbs: 0,
            fat: 8.0),
        FoodItem(
            name: 'Brown Rice',
            weight: '100 g',
            calories: 110,
            protein: 2.5,
            carbs: 23.0,
            fat: 1.0),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Cucumber',
            weight: '200 g',
            calories: 30,
            protein: 1.0,
            carbs: 7.0,
            fat: 0.1),
        FoodItem(
            name: 'Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '300 g',
            calories: 140,
            protein: 6.0,
            carbs: 20.0,
            fat: 3.0),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '35 g',
            calories: 133,
            protein: 4.5,
            carbs: 22.4,
            fat: 2.4),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Orange',
            weight: '150 g',
            calories: 70,
            protein: 1.2,
            carbs: 17.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Steamed Vegetables',
            weight: '200 g',
            calories: 100,
            protein: 4.0,
            carbs: 20.0,
            fat: 0.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 180,
            protein: 26.0,
            carbs: 0,
            fat: 8.0),
        FoodItem(
            name: 'Brown Rice',
            weight: '100 g',
            calories: 110,
            protein: 2.5,
            carbs: 23.0,
            fat: 1.0),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Cucumber',
            weight: '200 g',
            calories: 30,
            protein: 1.0,
            carbs: 7.0,
            fat: 0.1),
        FoodItem(
            name: 'Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '300 g',
            calories: 140,
            protein: 6.0,
            carbs: 20.0,
            fat: 3.0),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '35 g',
            calories: 133,
            protein: 4.5,
            carbs: 22.4,
            fat: 2.4),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Orange',
            weight: '150 g',
            calories: 70,
            protein: 1.2,
            carbs: 17.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Steamed Vegetables',
            weight: '200 g',
            calories: 100,
            protein: 4.0,
            carbs: 20.0,
            fat: 0.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 180,
            protein: 26.0,
            carbs: 0,
            fat: 8.0),
        FoodItem(
            name: 'Brown Rice',
            weight: '100 g',
            calories: 110,
            protein: 2.5,
            carbs: 23.0,
            fat: 1.0),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Cucumber',
            weight: '200 g',
            calories: 30,
            protein: 1.0,
            carbs: 7.0,
            fat: 0.1),
        FoodItem(
            name: 'Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '300 g',
            calories: 140,
            protein: 6.0,
            carbs: 20.0,
            fat: 3.0),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
    ),
    MealPlan(
      breakfast: Meal(items: [
        FoodItem(
            name: 'Oats',
            weight: '35 g',
            calories: 133,
            protein: 4.5,
            carbs: 22.4,
            fat: 2.4),
        FoodItem(
            name: 'Boiled Egg',
            weight: '1',
            calories: 78,
            protein: 6.5,
            carbs: 0.5,
            fat: 5.5),
        FoodItem(
            name: 'Orange',
            weight: '150 g',
            calories: 70,
            protein: 1.2,
            carbs: 17.0,
            fat: 0.2),
      ]),
      lunch: Meal(items: [
        FoodItem(
            name: 'Steamed Vegetables',
            weight: '200 g',
            calories: 100,
            protein: 4.0,
            carbs: 20.0,
            fat: 0.5),
        FoodItem(
            name: 'Grilled Fish',
            weight: '120 g',
            calories: 180,
            protein: 26.0,
            carbs: 0,
            fat: 8.0),
        FoodItem(
            name: 'Brown Rice',
            weight: '100 g',
            calories: 110,
            protein: 2.5,
            carbs: 23.0,
            fat: 1.0),
      ]),
      snack: Meal(items: [
        FoodItem(
            name: 'Cucumber',
            weight: '200 g',
            calories: 30,
            protein: 1.0,
            carbs: 7.0,
            fat: 0.1),
        FoodItem(
            name: 'Yogurt',
            weight: '100 g',
            calories: 59,
            protein: 10.0,
            carbs: 3.6,
            fat: 0.4),
      ]),
      dinner: Meal(items: [
        FoodItem(
            name: 'Vegetable Soup',
            weight: '300 g',
            calories: 140,
            protein: 6.0,
            carbs: 20.0,
            fat: 3.0),
        FoodItem(
            name: 'Salad',
            weight: '150 g',
            calories: 60,
            protein: 2.0,
            carbs: 10.0,
            fat: 0.5),
      ]),
    ),
  ];

  static final WaterSchedule water = WaterSchedule(
    dailyTotal: '~3.0-3.2 L',
    schedule: [
      WaterIntake(time: '6:30 AM', amount: '500 ml'),
      WaterIntake(time: '9:30 AM', amount: '450 ml'),
      WaterIntake(time: '12:30 PM', amount: '500 ml'),
      WaterIntake(time: '3:30 PM', amount: '450 ml'),
      WaterIntake(time: '6:30 PM', amount: '450 ml'),
      WaterIntake(time: '8:30 PM', amount: '250 ml'),
    ],
  );

  static const String calorieTarget = '1500–1600 kcal';
  static const String goal = 'Safe fat loss & habit building';
}

// Helper class to get plans based on BMI
class HealthPlanHelper {
  static DayPlan getDayPlan(double? bmi, int dayIndex) {
    if (bmi == null) {
      return _getDefaultPlan(dayIndex);
    }

    if (bmi < 18.5) {
      return DayPlan(
        workout: UnderweightPlans.workouts[dayIndex],
        meals: UnderweightPlans.meals[dayIndex],
        water: UnderweightPlans.water,
      );
    } else if (bmi < 25) {
      return DayPlan(
        workout: NormalWeightPlans.workouts[dayIndex],
        meals: NormalWeightPlans.meals[dayIndex],
        water: NormalWeightPlans.water,
      );
    } else if (bmi < 30) {
      return DayPlan(
        workout: OverweightPlans.workouts[dayIndex],
        meals: OverweightPlans.meals[dayIndex],
        water: OverweightPlans.water,
      );
    } else {
      return DayPlan(
        workout: ObesePlans.workouts[dayIndex],
        meals: ObesePlans.meals[dayIndex],
        water: ObesePlans.water,
      );
    }
  }

  static String getCalorieTarget(double? bmi) {
    if (bmi == null) return 'N/A';
    if (bmi < 18.5) return UnderweightPlans.calorieTarget;
    if (bmi < 25) return NormalWeightPlans.calorieTarget;
    if (bmi < 30) return OverweightPlans.calorieTarget;
    return ObesePlans.calorieTarget;
  }

  static String getGoal(double? bmi) {
    if (bmi == null) return 'Please add height and weight';
    if (bmi < 18.5) return UnderweightPlans.goal;
    if (bmi < 25) return NormalWeightPlans.goal;
    if (bmi < 30) return OverweightPlans.goal;
    return ObesePlans.goal;
  }

  static DayPlan _getDefaultPlan(int dayIndex) {
    final emptyMeal = Meal(items: [
      FoodItem(
          name: 'No data',
          weight: '0 g',
          calories: 0,
          protein: 0,
          carbs: 0,
          fat: 0),
    ]);

    return DayPlan(
      workout: WorkoutPlan(
          focus: 'No plan available', duration: '0 min', calories: '0 kcal'),
      meals: MealPlan(
        breakfast: emptyMeal,
        lunch: emptyMeal,
        snack: emptyMeal,
        dinner: emptyMeal,
      ),
      water: WaterSchedule(dailyTotal: 'N/A', schedule: []),
    );
  }
}

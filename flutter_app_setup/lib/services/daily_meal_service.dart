import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/health_plan_data.dart';

/// Service for managing daily meal plans based on health plan
class DailyMealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// Save meal status for a specific meal type and date
  Future<void> saveMealStatus(String mealType, String status,
      {DateTime? date}) async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) return;

      final targetDate = date ?? DateTime.now();
      final dateKey = DateFormat('yyyy-MM-dd').format(targetDate);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyMeals')
          .doc(dateKey)
          .set({
        mealType: status,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving meal status: $e');
    }
  }

  /// Get meal status for a specific date
  Future<Map<String, String>> getMealStatus({DateTime? date}) async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) return {};

      final targetDate = date ?? DateTime.now();
      final dateKey = DateFormat('yyyy-MM-dd').format(targetDate);

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyMeals')
          .doc(dateKey)
          .get();

      if (!doc.exists) return {};

      final data = doc.data() ?? {};
      return {
        'breakfast': data['breakfast'] as String? ?? 'not_yet',
        'lunch': data['lunch'] as String? ?? 'not_yet',
        'snack': data['snack'] as String? ?? 'not_yet',
        'dinner': data['dinner'] as String? ?? 'not_yet',
      };
    } catch (e) {
      print('Error getting meal status: $e');
      return {};
    }
  }

  /// Get today's meal plan based on start date and BMI
  Future<Map<String, dynamic>?> getTodaysMealPlan() async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) return null;

      // Get user data
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();
      if (userData == null) return null;

      // Get plan start date
      final planStartDateStr = userData['planStartDate'] as String?;
      if (planStartDateStr == null) return null;

      final planStartDate = DateTime.parse(planStartDateStr);
      final today = DateTime.now();

      // Check if today is before start date
      if (today.isBefore(DateTime(
          planStartDate.year, planStartDate.month, planStartDate.day))) {
        return {
          'status': 'waiting',
          'startDate': planStartDate,
          'message':
              'Your meal plan will start on ${_formatDate(planStartDate)}',
        };
      }

      // Calculate day index (0-6 for Day 1-7)
      final difference = today.difference(planStartDate).inDays;
      final dayIndex = difference >= 0 && difference < 7
          ? difference
          : (difference < 0 ? 0 : 6);
      final dayNumber = dayIndex + 1;

      // Get BMI
      final height = userData['height'] as double?;
      final weight = userData['weight'] as double?;
      double? bmi;
      if (height != null && weight != null && height > 0) {
        final heightInMeters = height / 100;
        bmi = weight / (heightInMeters * heightInMeters);
      }

      // Get meal plan for this day
      final dayPlan = HealthPlanHelper.getDayPlan(bmi, dayIndex);
      final mealPlan = dayPlan.meals;

      return {
        'status': 'active',
        'dayNumber': dayNumber,
        'dayIndex': dayIndex,
        'date': today,
        'meals': {
          'breakfast': {
            'items': mealPlan.breakfast.items
                .map((item) => {
                      'name': item.name,
                      'weight': item.weight,
                      'calories': item.calories,
                      'protein': item.protein,
                      'carbs': item.carbs,
                      'fat': item.fat,
                    })
                .toList(),
            'totalCalories': mealPlan.breakfast.totalCalories,
            'totalProtein': mealPlan.breakfast.totalProtein,
            'totalCarbs': mealPlan.breakfast.totalCarbs,
            'totalFat': mealPlan.breakfast.totalFat,
          },
          'lunch': {
            'items': mealPlan.lunch.items
                .map((item) => {
                      'name': item.name,
                      'weight': item.weight,
                      'calories': item.calories,
                      'protein': item.protein,
                      'carbs': item.carbs,
                      'fat': item.fat,
                    })
                .toList(),
            'totalCalories': mealPlan.lunch.totalCalories,
            'totalProtein': mealPlan.lunch.totalProtein,
            'totalCarbs': mealPlan.lunch.totalCarbs,
            'totalFat': mealPlan.lunch.totalFat,
          },
          'snack': {
            'items': mealPlan.snack.items
                .map((item) => {
                      'name': item.name,
                      'weight': item.weight,
                      'calories': item.calories,
                      'protein': item.protein,
                      'carbs': item.carbs,
                      'fat': item.fat,
                    })
                .toList(),
            'totalCalories': mealPlan.snack.totalCalories,
            'totalProtein': mealPlan.snack.totalProtein,
            'totalCarbs': mealPlan.snack.totalCarbs,
            'totalFat': mealPlan.snack.totalFat,
          },
          'dinner': {
            'items': mealPlan.dinner.items
                .map((item) => {
                      'name': item.name,
                      'weight': item.weight,
                      'calories': item.calories,
                      'protein': item.protein,
                      'carbs': item.carbs,
                      'fat': item.fat,
                    })
                .toList(),
            'totalCalories': mealPlan.dinner.totalCalories,
            'totalProtein': mealPlan.dinner.totalProtein,
            'totalCarbs': mealPlan.dinner.totalCarbs,
            'totalFat': mealPlan.dinner.totalFat,
          },
        },
        'totalCalories': mealPlan.totalCalories,
        'bmi': bmi,
      };
    } catch (e) {
      print('Error getting today\'s meal plan: $e');
      return null;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

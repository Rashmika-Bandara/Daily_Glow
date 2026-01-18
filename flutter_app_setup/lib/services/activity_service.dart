import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Activity Service - Handles logging exercises, meals, and water intake
class ActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // ==================== EXERCISE LOGGING ====================

  /// Log a new exercise
  Future<void> logExercise({
    required String activityType,
    required double duration,
    required double caloriesBurned,
    required String intensity,
    DateTime? startTime,
    DateTime? date,
    String? notes,
  }) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final workoutDate = date ?? DateTime.now();
    final workoutStartTime = startTime ?? DateTime.now();

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('exercises')
        .add({
      'activityType': activityType,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'intensity': intensity,
      'startTime': workoutStartTime.toIso8601String(),
      'date': workoutDate.toIso8601String(),
      'notes': notes ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update an existing exercise
  Future<void> updateExercise({
    required String exerciseId,
    required String activityType,
    required double duration,
    required double caloriesBurned,
    required String intensity,
    DateTime? startTime,
    DateTime? date,
    String? notes,
  }) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final workoutDate = date ?? DateTime.now();
    final workoutStartTime = startTime ?? DateTime.now();

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('exercises')
        .doc(exerciseId)
        .update({
      'activityType': activityType,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'intensity': intensity,
      'startTime': workoutStartTime.toIso8601String(),
      'date': workoutDate.toIso8601String(),
      'notes': notes ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete an exercise
  Future<void> deleteExercise(String exerciseId) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('exercises')
        .doc(exerciseId)
        .delete();
  }

  /// Get all exercises
  Future<List<Map<String, dynamic>>> getAllExercises() async {
    if (currentUserId == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('exercises')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  /// Get exercises for today
  Future<List<Map<String, dynamic>>> getTodayExercises() async {
    if (currentUserId == null) return [];

    final startOfDay = DateTime.now();
    final start = DateTime(startOfDay.year, startOfDay.month, startOfDay.day);
    final end = start.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('exercises')
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThan: end.toIso8601String())
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  // ==================== MEAL LOGGING ====================

  /// Log a new meal
  Future<void> logMeal({
    required String mealType,
    required List<String> foodItems,
    required double calories,
    double? protein,
    double? carbs,
    double? fat,
    String? notes,
  }) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('meals')
        .add({
      'mealType': mealType,
      'foodItems': foodItems,
      'calories': calories,
      'protein': protein ?? 0,
      'carbs': carbs ?? 0,
      'fat': fat ?? 0,
      'notes': notes ?? '',
      'date': DateTime.now().toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get meals for today
  Future<List<Map<String, dynamic>>> getTodayMeals() async {
    if (currentUserId == null) return [];

    final startOfDay = DateTime.now();
    final start = DateTime(startOfDay.year, startOfDay.month, startOfDay.day);
    final end = start.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('meals')
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThan: end.toIso8601String())
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  // ==================== WATER INTAKE LOGGING ====================

  /// Log water intake
  Future<void> logWater({
    required double amount, // in ml
  }) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('water_intake')
        .add({
      'amount': amount,
      'date': DateTime.now().toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get total water intake for today
  Future<double> getTodayWaterIntake() async {
    if (currentUserId == null) return 0.0;

    final startOfDay = DateTime.now();
    final start = DateTime(startOfDay.year, startOfDay.month, startOfDay.day);
    final end = start.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('water_intake')
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThan: end.toIso8601String())
        .get();

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc.data()['amount'] as num?)?.toDouble() ?? 0;
    }
    return total;
  }

  /// Get water intake entries for today
  Future<List<Map<String, dynamic>>> getTodayWaterEntries() async {
    if (currentUserId == null) return [];

    final startOfDay = DateTime.now();
    final start = DateTime(startOfDay.year, startOfDay.month, startOfDay.day);
    final end = start.add(const Duration(days: 1));

    final snapshot = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('water_intake')
        .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('date', isLessThan: end.toIso8601String())
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }
}

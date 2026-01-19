import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/health_plan_data.dart';

/// Service for managing daily workout plans based on health plan
class DailyWorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// Get today's workout plan based on start date and BMI
  Future<Map<String, dynamic>?> getTodaysWorkoutPlan() async {
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
          'message': 'Your plan will start on ${_formatDate(planStartDate)}',
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

      // Get workout plan for this day
      final dayPlan = HealthPlanHelper.getDayPlan(bmi, dayIndex);
      final workout = dayPlan.workout;

      // Get completion status
      final statusDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyWorkouts')
          .doc(_getDateKey(today))
          .get();

      final completionStatus = statusDoc.exists
          ? (statusDoc.data()?['status'] ?? 'not_started')
          : 'not_started';

      return {
        'status': 'active',
        'dayNumber': dayNumber,
        'dayIndex': dayIndex,
        'date': today,
        'workout': {
          'focus': workout.focus,
          'duration': workout.duration,
          'calories': workout.calories,
        },
        'completionStatus': completionStatus,
        'bmi': bmi,
      };
    } catch (e) {
      print('Error getting today\'s workout plan: $e');
      return null;
    }
  }

  /// Update workout completion status
  Future<void> updateWorkoutStatus(String status) async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) throw Exception('No user signed in');

      final today = DateTime.now();
      final dateKey = _getDateKey(today);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyWorkouts')
          .doc(dateKey)
          .set({
        'status': status,
        'date': today.toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to update workout status: $e');
    }
  }

  /// Get workout status for a specific date
  Future<String> getWorkoutStatus(DateTime date) async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) return 'not_started';

      final dateKey = _getDateKey(date);
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyWorkouts')
          .doc(dateKey)
          .get();

      return doc.exists
          ? (doc.data()?['status'] ?? 'not_started')
          : 'not_started';
    } catch (e) {
      return 'not_started';
    }
  }

  /// Get all workout history for the current 7-day plan
  Future<List<Map<String, dynamic>>> getWeeklyWorkoutHistory() async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) return [];

      // Get plan start date
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final planStartDateStr = userDoc.data()?['planStartDate'] as String?;
      if (planStartDateStr == null) return [];

      final planStartDate = DateTime.parse(planStartDateStr);
      final List<Map<String, dynamic>> history = [];

      // Get BMI
      final height = userDoc.data()?['height'] as double?;
      final weight = userDoc.data()?['weight'] as double?;
      double? bmi;
      if (height != null && weight != null && height > 0) {
        final heightInMeters = height / 100;
        bmi = weight / (heightInMeters * heightInMeters);
      }

      // Get workout data for each day
      for (int i = 0; i < 7; i++) {
        final dayDate = planStartDate.add(Duration(days: i));
        final dayPlan = HealthPlanHelper.getDayPlan(bmi, i);
        final workout = dayPlan.workout;

        final status = await getWorkoutStatus(dayDate);

        history.add({
          'dayNumber': i + 1,
          'date': dayDate,
          'workout': {
            'focus': workout.focus,
            'duration': workout.duration,
            'calories': workout.calories,
          },
          'status': status,
        });
      }

      return history;
    } catch (e) {
      print('Error getting weekly workout history: $e');
      return [];
    }
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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

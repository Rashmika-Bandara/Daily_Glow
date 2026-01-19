import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/health_plan_data.dart';

/// Service for managing daily water intake plans based on health plan
class DailyWaterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  /// Save water intake status for a specific time slot and date
  Future<void> saveWaterIntakeStatus(String timeSlot, double amount,
      {DateTime? date}) async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) return;

      final targetDate = date ?? DateTime.now();
      final dateKey = DateFormat('yyyy-MM-dd').format(targetDate);

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyWater')
          .doc(dateKey)
          .set({
        timeSlot: amount,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving water intake status: $e');
    }
  }

  /// Get water intake status for a specific date
  Future<Map<String, double>> getWaterIntakeStatus({DateTime? date}) async {
    try {
      final userId = currentUser?.uid;
      if (userId == null) return {};

      final targetDate = date ?? DateTime.now();
      final dateKey = DateFormat('yyyy-MM-dd').format(targetDate);

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('dailyWater')
          .doc(dateKey)
          .get();

      if (!doc.exists) return {};

      final data = doc.data() ?? {};
      final Map<String, double> waterIntake = {};

      data.forEach((key, value) {
        if (key != 'lastUpdated' && value is num) {
          waterIntake[key] = value.toDouble();
        }
      });

      return waterIntake;
    } catch (e) {
      print('Error getting water intake status: $e');
      return {};
    }
  }

  /// Get today's water intake plan based on start date and BMI
  Future<Map<String, dynamic>?> getTodaysWaterPlan() async {
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
              'Your water intake plan will start on ${_formatDate(planStartDate)}',
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

      // Get water plan for this day
      final dayPlan = HealthPlanHelper.getDayPlan(bmi, dayIndex);
      final waterPlan = dayPlan.water;

      // Calculate total daily water goal
      double totalWater = 0;
      for (var intake in waterPlan.schedule) {
        final amountStr = intake.amount.replaceAll(RegExp(r'[^0-9.]'), '');
        totalWater += double.tryParse(amountStr) ?? 0;
      }

      return {
        'status': 'active',
        'dayNumber': dayNumber,
        'dayIndex': dayIndex,
        'date': today,
        'schedule': waterPlan.schedule
            .map((intake) => {
                  'time': intake.time,
                  'amount': intake.amount,
                })
            .toList(),
        'totalWater': totalWater,
        'bmi': bmi,
      };
    } catch (e) {
      print('Error getting today\'s water plan: $e');
      return null;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

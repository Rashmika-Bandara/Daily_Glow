import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  /// Send a welcome notification to the user
  Future<void> sendWelcomeNotification(String username) async {
    if (currentUserId == null) return;

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('notifications')
        .add({
      'title': 'Welcome to Health Habbit, $username! 🔥',
      'message':
          'This is DAY ONE, $username! Every sip of water and every step you take moves you closer to a stronger, healthier you. Track your habits, build unstoppable streaks, and let Health Habbit push you forward every single day. Let\'s go!',
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
      'date': DateTime.now().toIso8601String(),
    });
  }

  /// Send a motivational notification to the user
  Future<void> sendMotivationalNotification(String username) async {
    if (currentUserId == null) return;

    final motivationalMessages = [
      "🔥 $username, take a moment and breathe—this very day is a fresh page in your health story. Every glass of water, every stretch, every step you take today is quietly rebuilding your strength, your energy, and your confidence. Begin now. Your body is ready.",
      "💪 $username, inside your body, every healthy choice you make is waking up muscles, sharpening your mind, and restoring balance. Even the smallest action today—standing up, moving, breathing—creates real change. Start small. Stay strong.",
      "⚡ $username, imagine ending today knowing you showed up for yourself. The movement you do now fuels tomorrow's energy, focus, and happiness. One habit today is worth more than a hundred plans. Take action.",
      "🌱 $username, growth happens quietly, one habit at a time. With each healthy choice you make today, your body adapts, your stamina increases, and your self-belief grows stronger. Care for yourself—you are building something powerful.",
      "🚀 $username, momentum is born from action. A walk, a stretch, a mindful breath right now tells your body it matters. Stay consistent today, and future you will feel lighter, stronger, and more confident.",
      "🔥 $username, discipline isn't punishment—it's self-respect. Every time you choose movement over comfort, hydration over excuses, and care over delay, your body thanks you with strength and energy. Keep going.",
      "🏆 $username, you don't need perfection—you need presence. Show up today, complete one healthy habit, and let that single win remind you that progress is already happening. One step forward changes everything.",
      "⚡ $username, your health journey is unfolding right now, in this moment. Each mindful choice today strengthens your heart, sharpens your focus, and builds resilience. Stay present. Stay powerful.",
      "💥 $username, don't underestimate today. One healthy action right now can ignite days of motivation and weeks of progress. Move your body, fuel it wisely, and remind yourself why you started.",
      "🌟 $username, picture yourself weeks from now—stronger, more energized, more confident—because you chose consistency today. Your habits are shaping your future. Take care of your body. It's carrying you forward.",
    ];

    // Pick a random message
    final random = Random();
    final randomMessage =
        motivationalMessages[random.nextInt(motivationalMessages.length)];

    // Extract the emoji from the message for the title
    final emoji = randomMessage.substring(0, 2);
    final titleText = "Stay Motivated, $username! $emoji";

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('notifications')
        .add({
      'title': titleText,
      'message': randomMessage,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
      'date': DateTime.now().toIso8601String(),
    });
  }

  /// Get all notifications for the current user
  Stream<List<Map<String, dynamic>>> getNotifications() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    if (currentUserId == null) return;

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    if (currentUserId == null) return;

    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in notifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    if (currentUserId == null) return;

    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  /// Get unread notification count
  Stream<int> getUnreadCount() {
    if (currentUserId == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}

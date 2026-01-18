import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/activity_service.dart';
import '../services/notification_service.dart';

/// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Activity Service Provider
final activityServiceProvider = Provider<ActivityService>((ref) {
  return ActivityService();
});

/// Notification Service Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Current Auth User Stream Provider
final authStateProvider = StreamProvider((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value != null;
});

/// Current User Data Provider - Fetches user data from Firestore
final currentUserDataProvider = StreamProvider((ref) async* {
  final authState = ref.watch(authStateProvider);

  if (authState.value == null) {
    yield null;
  } else {
    final userId = authState.value!.uid;
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return {
        'id': doc.id,
        'userId': doc.data()?['userId'] ?? '',
        'username': doc.data()?['username'] ?? '',
        'email': doc.data()?['email'] ?? '',
        'avatar': doc.data()?['avatar'] ?? 'boy',
        'gender': doc.data()?['gender'] ?? 'Not set',
        'age': doc.data()?['age'],
        'height': doc.data()?['height'],
        'weight': doc.data()?['weight'],
      };
    });
  }
});

/// Notifications Stream Provider
final notificationsStreamProvider = StreamProvider.autoDispose((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.getNotifications();
});

/// Unread Notification Count Provider
final unreadCountProvider = StreamProvider.autoDispose((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.getUnreadCount();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

/// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
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
        'username': doc.data()?['username'] ?? '',
        'email': doc.data()?['email'] ?? '',
      };
    });
  }
});

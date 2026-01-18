# 🔥 Firebase Firestore Setup Guide

## ✅ What's Already Done

1. ✓ Firebase packages installed (`firebase_core`, `firebase_auth`, `cloud_firestore`)
2. ✓ Firebase initialized in `main.dart`
3. ✓ `FirestoreService` created - handles all database operations
4. ✓ `AuthService` created - handles authentication
5. ✓ Firebase configuration file exists (`firebase_options.dart`)

---

## 🚀 Step-by-Step Setup

### Step 1: Firebase Console Setup

1. **Go to Firebase Console**
   - Visit: https://console.firebase.google.com/
   - Sign in with your Google account

2. **Create/Select Project**
   - If new: Click "Add project" → Name it "Daily Glow" → Continue
   - If existing: Select your project

3. **Enable Firestore Database**
   - In left sidebar, click "Firestore Database"
   - Click "Create database"
   - Choose **"Start in test mode"** (for development)
   - Select closest location (e.g., `us-central`)
   - Click "Enable"

4. **Enable Authentication**
   - In left sidebar, click "Authentication"
   - Click "Get started"
   - Click "Email/Password" → Enable it → Save

5. **Add Web App** (if not already added)
   - Click gear icon ⚙️ → Project settings
   - Scroll to "Your apps" section
   - Click Web icon `</>`
   - Register app with nickname "Daily Glow Web"
   - Copy the config values

### Step 2: Update Firebase Config (if needed)

If your `firebase_options.dart` doesn't have the correct values, update it with your Firebase config from the console.

### Step 3: Security Rules (Important!)

1. Go to **Firestore Database** → **Rules** tab
2. Replace with these rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // User's sub-collections
      match /{collection}/{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

3. Click **Publish**

---

## 📱 Using the Services in Your App

### Authentication Example

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

// In your widget:
final authService = ref.read(authServiceProvider);

// Sign Up
try {
  final user = await authService.signUpWithEmail(
    email: 'user@example.com',
    password: 'password123',
    username: 'John Doe',
  );
  print('User created: ${user?.username}');
} catch (e) {
  print('Error: $e');
}

// Sign In
try {
  final user = await authService.signInWithEmail(
    email: 'user@example.com',
    password: 'password123',
  );
  print('Signed in: ${user?.username}');
} catch (e) {
  print('Error: $e');
}

// Sign Out
await authService.signOut();
```

### Firestore Example

```dart
import '../services/firestore_service.dart';
import '../models/exercise.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

// In your widget:
final firestoreService = ref.read(firestoreServiceProvider);

// Log Exercise
final exercise = Exercise(
  name: 'Morning Run',
  category: 'Cardio',
  duration: 30,
  caloriesBurned: 300,
  date: DateTime.now(),
);

await firestoreService.logExercise(exercise);

// Get Today's Exercises
final exercises = await firestoreService.getExercisesForDate(DateTime.now());

// Log Water
final water = WaterIntake(
  amount: 250,
  date: DateTime.now(),
);
await firestoreService.logWaterIntake(water);

// Get Total Water Today
final totalWater = await firestoreService.getTotalWaterForDate(DateTime.now());
```

---

## 🗄️ Firestore Database Structure

Your database will be organized as:

```
users (collection)
├── {userId} (document)
    ├── username: "John Doe"
    ├── email: "user@example.com"
    ├── age: 25
    ├── weight: 70.5
    ├── height: 175
    ├── dailyWaterGoal: 2000
    ├── dailyCalorieGoal: 2000
    │
    ├── exercises (sub-collection)
    │   ├── {exerciseId}
    │   │   ├── name: "Running"
    │   │   ├── duration: 30
    │   │   ├── caloriesBurned: 300
    │   │   └── date: "2026-01-18"
    │
    ├── meals (sub-collection)
    │   ├── {mealId}
    │   │   ├── name: "Chicken Salad"
    │   │   ├── calories: 450
    │   │   └── date: "2026-01-18"
    │
    ├── water_intake (sub-collection)
    │   ├── {waterId}
    │   │   ├── amount: 250
    │   │   └── date: "2026-01-18"
    │
    ├── goals (sub-collection)
    │   ├── {goalId}
    │   │   ├── title: "Lose 5kg"
    │   │   ├── targetValue: 5
    │   │   └── isCompleted: false
    │
    ├── streaks (sub-collection)
    │   ├── {activityType}
    │   │   ├── currentStreak: 7
    │   │   └── longestStreak: 15
    │
    └── daily_progress (sub-collection)
        ├── {date}
            ├── steps: 10000
            ├── caloriesBurned: 500
            └── waterIntake: 2000
```

---

## ✅ Test Your Setup

Run this test in your app:

```dart
// Test Authentication
final authService = AuthService();
final user = await authService.signUpWithEmail(
  email: 'test@example.com',
  password: 'test123',
  username: 'Test User',
);
print('✅ Auth works! User: ${user?.username}');

// Test Firestore
final firestoreService = FirestoreService();
final exercise = Exercise(
  name: 'Test Run',
  category: 'Cardio',
  duration: 10,
  caloriesBurned: 100,
  date: DateTime.now(),
);
await firestoreService.logExercise(exercise);
print('✅ Firestore works! Exercise logged');
```

---

## 🔒 Security Checklist

- [x] Firestore Security Rules configured
- [x] Authentication enabled
- [ ] Test mode → Production rules (after development)
- [ ] Enable App Check (for production)

---

## 📊 Next Steps

1. Update your `user_provider.dart` to use AuthService
2. Create providers for exercises, meals, water intake
3. Connect screens to Firestore services
4. Test authentication flow
5. Test data sync across devices

---

## 🆘 Troubleshooting

**Error: "Permission denied"**
- Check Firestore Security Rules
- Make sure user is authenticated
- Verify userId matches

**Error: "Firebase not initialized"**
- Check `main.dart` has `Firebase.initializeApp()`
- Verify `firebase_options.dart` has correct config

**Error: "Network error"**
- Check internet connection
- Verify Firebase project is active
- Check browser console for CORS issues (web)

---

## 📚 Documentation

- Firebase Console: https://console.firebase.google.com/
- Firestore Docs: https://firebase.google.com/docs/firestore
- Firebase Auth Docs: https://firebase.google.com/docs/auth

---

**You're all set! 🎉** Your Firebase Firestore database is ready to use!

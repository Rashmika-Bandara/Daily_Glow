# Daily Glow - Comprehensive Fitness Tracking Library

Daily Glow is a complete fitness tracking solution implemented in Dart, featuring user management, goal setting, exercise logging, nutrition tracking, hydration monitoring, streak building, and progress analytics.

## Features

### 🔐 User Management
- Complete user profiles with personal information
- Secure account creation and authentication  
- Customizable daily targets and preferences
- Comprehensive dashboard and analytics

### 🎯 Goal Setting & Tracking
- Physical activity goals with custom metrics
- Hydration goals with smart recommendations
- Progress monitoring and achievement tracking
- Flexible goal types and measurement units

### 💪 Exercise Tracking
- Detailed exercise logging with multiple metrics
- Activity type classification and intensity levels
- Calorie burn estimation and duration tracking
- Distance measurement for cardio activities
- Exercise history and performance analytics

### 💧 Hydration Management  
- Daily water intake tracking with multiple sources
- Smart reminders and progress notifications
- Hourly intake recommendations
- Hydration streak tracking and motivation

### 🍽️ Nutrition Logging
- Comprehensive meal tracking with macronutrients
- Calorie counting and nutritional analysis
- Meal planning suggestions and recommendations
- Food item management and portion tracking

### 🔥 Streak System
- Multi-type streak tracking (exercise, hydration, meals)
- Motivational messages and achievement levels
- Streak recovery and maintenance strategies
- Consistency scoring and trend analysis

### 📊 Progress Analytics
- Daily, weekly, and monthly progress summaries
- Trend analysis and improvement recommendations
- Comprehensive wellness scoring
- Visual progress indicators and insights

## Quick Start

```dart
import 'package:daily_glow/daily_glow.dart';

void main() {
  // Create a new user
  User user = User(
    userID: 'unique_user_id',
    username: 'fitness_enthusiast', 
    email: 'user@example.com',
    password: 'secure_password123',
  );
  
  // Set up the account
  user.createAccount();
  
  // Log activities
  user.logWaterIntake(0.5);
  user.logExercise(Exercise(...));
  user.logMeal(Meal(...));
  
  // View progress
  Map<String, dynamic> dashboard = user.getDashboard();
}
```

## Installation

Add to your `pubspec.yaml`:
```yaml
dependencies:
  daily_glow: ^1.0.0
```

## Demo

Run the demonstration:
```bash
dart run bin/daily_glow.dart demo
```

## Architecture

The library implements a comprehensive UML design with the following core classes:
- **User**: Central user management and data aggregation
- **Goal**: Abstract base class for fitness goals
- **Exercise**: Detailed workout and activity tracking
- **WaterIntake**: Hydration monitoring and recommendations
- **Meal**: Nutrition logging with macronutrient analysis
- **Streak**: Gamification and habit tracking system
- **Progress**: Analytics and trend monitoring

## License

MIT License - see LICENSE file for details.

import 'package:daily_glow/daily_glow.dart';

void main(List<String> arguments) {
  print('🌟 Welcome to Daily Glow - Your Personal Fitness Tracker! 🌟\n');

  if (arguments.isNotEmpty && arguments[0] == 'demo') {
    // Run the demonstration
    demonstrateDailyGlow();
  } else {
    // Show basic usage information
    print('Usage: dart run bin/daily_glow.dart [demo]');
    print('\nAvailable commands:');
    print('  demo  - Run a demonstration of Daily Glow features');
    print('\nDaily Glow Library v$version');
    print(description);
    print('\nTo get started, import the library in your Dart project:');
    print('import \'package:daily_glow/daily_glow.dart\';');

    // Show a quick example
    print('\n📋 Quick Example:');
    print('''
// Create a new user
User user = User(
  userID: 'user123',
  username: 'fitness_lover',
  email: 'user@example.com',
  password: 'secure_password',
);

// Create account and start tracking
user.createAccount();

// Log activities
user.logWaterIntake(0.5);
user.logExercise(Exercise(...));
user.logMeal(Meal(...));

// View progress
Map<String, dynamic> dashboard = user.getDashboard();
''');
  }
}

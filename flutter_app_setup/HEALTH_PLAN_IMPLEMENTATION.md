# Health Habit Plan Implementation

## Overview
A comprehensive 7-day health plan system with BMI-based personalization for workouts, meals, and water intake.

## Features

### 1. Health Habit Plan Screen (`health_habit_plan_screen.dart`)
- **BMI Display**: Shows user's current BMI and category
- **Date Selection**: Choose when to start the 7-day plan
- **Current Day Tracking**: Automatically highlights today's plan
- **7-Day Overview**: Cards for each day with quick indicators

### 2. Day Plan Detail Screen (`day_plan_detail_screen.dart`)
- **Workout Plan**: Focus area, duration, and calories burned
- **Meal Plan**: Breakfast, lunch, snack, and dinner details
- **Water Intake Schedule**: Timed water intake throughout the day
- **Goal Display**: BMI-specific health goals and calorie targets

### 3. Health Plan Data Model (`health_plan_data.dart`)
Comprehensive data for 4 BMI categories:

#### Underweight Plans (BMI < 18.5)
- **Goal**: Healthy Weight Gain
- **Calorie Target**: 2400-2600 kcal/day
- **Workout Focus**: Strength training (250-300 kcal burn)
- **Water Intake**: ~2.0L per day

#### Normal Weight Plans (BMI 18.5-24.9)
- **Goal**: Maintain Health
- **Calorie Target**: 2000-2200 kcal/day
- **Workout Focus**: Mixed cardio and strength (200-450 kcal burn)
- **Water Intake**: ~3.0L per day

#### Overweight Plans (BMI 25-29.9)
- **Goal**: Healthy Weight Loss
- **Calorie Target**: 1700-1800 kcal/day
- **Workout Focus**: Fat burning cardio (200-400 kcal burn)
- **Water Intake**: ~3.2L per day

#### Obese Plans (BMI ≥ 30)
- **Goal**: Sustainable Weight Loss
- **Calorie Target**: 1500-1600 kcal/day
- **Workout Focus**: Low-impact activities (100-250 kcal burn)
- **Water Intake**: ~3.0-3.2L per day

## Data Structure

### WorkoutPlan
```dart
- String focus (e.g., "Strength Training")
- String duration (e.g., "45 min")
- String calories (e.g., "250 kcal")
```

### MealPlan
```dart
- String breakfast
- String lunch
- String snack
- String dinner
```

### WaterSchedule
```dart
- String dailyTotal (e.g., "2.0L")
- List<WaterIntake> schedule
  - String time (e.g., "7:00 AM")
  - String amount (e.g., "250 ml")
```

### DayPlan
```dart
- WorkoutPlan workout
- MealPlan meals
- WaterSchedule water
```

## Navigation Flow

```
Dashboard → Health Habit Plan Button
    ↓
Health Habit Plan Screen (7-day overview)
    ↓
Tap on Day Card
    ↓
Day Plan Detail Screen (full workout, meals, water schedule)
```

## Key Features

### Automatic BMI Detection
- Reads user's height and weight from profile
- Calculates BMI automatically
- Selects appropriate plan based on category

### Date Management
- Start date selection with date picker
- Auto-calculates current day in the plan
- Highlights today's plan with special styling

### Visual Design
- Color-coded BMI categories
- Gradient backgrounds (light/dark theme support)
- Icon-based meal indicators
- Timed water intake schedule

### Personalized Content
- Different workouts for each BMI category
- Calorie targets matched to goals
- Progressive workout intensity across 7 days
- Balanced meal plans with specific calorie counts

## Example 7-Day Plan Structure

Each day includes:

1. **Workout**
   - Focus area (e.g., "Full Body", "Cardio")
   - Duration (30-60 minutes)
   - Calorie burn estimate

2. **Meals**
   - Breakfast with calorie count
   - Lunch with calorie count
   - Snack with calorie count
   - Dinner with calorie count

3. **Water Schedule**
   - 6-8 timed intakes throughout the day
   - Total daily target (2.0L - 3.2L)
   - Specific amounts per intake

## Usage Example

1. User opens Health Habit Plan from dashboard
2. System calculates BMI from profile data
3. User selects start date (defaults to today)
4. System shows 7-day overview with appropriate plan
5. User taps on any day to see detailed plan
6. Detailed screen shows:
   - Complete workout information
   - All 4 meals with descriptions
   - Water intake schedule with times

## Benefits

- **Personalization**: Plans tailored to individual BMI
- **Structure**: Clear 7-day progression
- **Comprehensive**: Covers exercise, nutrition, and hydration
- **Flexible**: Start any day with date picker
- **Visual**: Easy-to-read cards and color coding
- **Goal-Oriented**: Clear targets for each BMI category

## Future Enhancements (Optional)

- [ ] Progress tracking for completed days
- [ ] Meal substitution options
- [ ] Workout video demonstrations
- [ ] Push notifications for water reminders
- [ ] Custom plan creation
- [ ] Integration with fitness trackers
- [ ] Meal preparation tips
- [ ] Shopping list generation


# Meals Tab Implementation

## Overview
The Meals Tab has been completely redesigned to mirror the Workouts Tab functionality, displaying personalized daily meal plans based on the user's Health Habit Plan start date and BMI category.

## Features Implemented

### 1. Daily Meal Plan Display
- **Day-based System**: Shows "Day 1" through "Day 7" based on plan start date
- **Date Display**: Current date with formatted display (e.g., "Monday, Jan 20")
- **Daily Calorie Target**: Prominent display of total daily calorie goal
- **Meal Breakdown**: 
  - Breakfast (morning icon)
  - Lunch (cloud icon)
  - Snack (cookie icon)
  - Dinner (night icon)

### 2. Meal Plan Cards
Each meal card displays:
- **Food Items**: List of all food items with weights (e.g., "Brown Rice (100g)")
- **Individual Calories**: Calories per food item
- **Macronutrient Breakdown**:
  - Protein (g)
  - Carbohydrates (g)
  - Fat (g)
- **Expandable Design**: Cards collapse/expand for better space management

### 3. Logged Meals Section
- **Separate Display**: Custom meals logged by user shown separately from planned meals
- **Status Indicator**: Green "Logged" badge on each custom meal
- **Detailed Info**: Shows meal type, calories, macros, and time logged
- **Real-time Updates**: Automatically refreshes when new meals are logged

### 4. Waiting View
When plan start date is in the future:
- **Countdown Display**: Days until plan starts
- **Motivational Message**: "Get Ready!" with encouraging text
- **Preparation Tip**: "🍽️ Prepare your kitchen and ingredients"

### 5. No Plan View
When user hasn't set up a Health Habit Plan:
- **Clear Message**: "No Active Meal Plan"
- **Call-to-Action**: Button to return to dashboard
- **Guidance**: Instructions to set up Health Habit Plan

### 6. History View
Toggle between today's plan and meal history:
- **Summary Card**: Total calories and macros for the day
- **Meal List**: All logged meals with full details
- **Empty State**: Friendly message when no meals logged

### 7. FAB (Floating Action Button)
- **Always Visible**: Floating button at bottom right
- **Context-aware Label**:
  - "Add Custom Meal" in plan view
  - "Log Meal" in history view
- **Navigation**: Opens LogMealScreen
- **Color**: Matches meal theme color

## Technical Implementation

### Service Layer
**DailyMealService** (`lib/services/daily_meal_service.dart`):
- `getTodaysMealPlan()`: Fetches meal plan for current day
- Returns structured data with:
  - Status: 'active', 'waiting', or null
  - Day number (1-7)
  - Current date
  - Meals object with breakfast, lunch, snack, dinner
  - Total daily calories
  - Per-meal nutritional breakdown

### Data Flow
1. User sets plan start date in Health Habit Plan
2. AuthService stores `planStartDate` in Firebase
3. DailyMealService calculates current day index
4. Service fetches BMI-appropriate meal plan from HealthPlanHelper
5. MealsTab displays meal plan with professional UI
6. ActivityService handles custom meal logging
7. Both planned and logged meals display on same screen

### Firebase Structure
```
users/{userId}/
  - planStartDate: "2026-01-19T00:00:00.000Z"
  - height: 175
  - weight: 70
  - meals/
    - {mealId}/
      - mealType: "breakfast"
      - foodItems: ["Eggs", "Toast"]
      - calories: 350
      - protein: 20
      - carbs: 30
      - fat: 15
      - date: "2026-01-20T08:30:00.000Z"
```

### UI Components
1. **_buildTodaysPlanView()**: Main view showing today's meal plan
2. **_buildActivePlanView()**: Displays active plan with all meals
3. **_buildWaitingView()**: Countdown when start date is future
4. **_buildNoPlanView()**: Message when no plan exists
5. **_buildMealCard()**: Individual meal plan card (expandable)
6. **_buildTodaysLoggedMeals()**: Section for custom logged meals
7. **_buildLoggedMealCard()**: Individual logged meal card
8. **_buildHistoryView()**: History tab with all meals
9. **_buildMacroItem()**: Reusable macro display component

## Design Patterns

### Gradient Background
Matches login page gradient:
- **Dark Mode**: [0xFF0F2027, 0xFF203A43, 0xFF2C5364]
- **Light Mode**: [0xFF4158D0, 0xFFC850C0, 0xFFFFCC70]

### Color Scheme
- **Primary Color**: AppTheme.mealColor (green tone)
- **Card Background**: Dark mode (grey[850]), Light mode (white)
- **Icons**: 
  - Breakfast: Orange (wb_sunny)
  - Lunch: Blue (wb_cloudy)
  - Snack: Brown (cookie)
  - Dinner: Indigo (nightlight)

### Typography
- **Header Text**: 32px, bold, white
- **Date Text**: 16px, white with opacity
- **Card Titles**: 18px, bold
- **Body Text**: 14px, regular
- **Macro Labels**: 12px, semi-transparent

## User Experience

### Navigation Flow
1. User opens Meals tab
2. If no plan → Shows setup message
3. If plan future → Shows countdown
4. If plan active → Shows today's meals
5. User can toggle history view
6. User can add custom meals anytime

### Interaction Points
- **Tap meal card**: Expand/collapse to see food items
- **Tap history icon**: Switch to history view
- **Tap FAB**: Log a custom meal
- **Swipe down**: Refresh meal data

### Visual Feedback
- **Loading State**: Circular progress indicator
- **Empty State**: Friendly illustrations and messages
- **Success State**: Green badges for logged meals
- **Data Display**: Clear hierarchy with cards and sections

## Testing Scenarios

### Test Case 1: New User
- Expected: "No Active Meal Plan" message
- Action: Navigate to dashboard to set up plan

### Test Case 2: Future Start Date
- Expected: Countdown display
- Verify: Correct number of days until start

### Test Case 3: Active Plan
- Expected: Today's meal plan displayed
- Verify: Correct day number (1-7)
- Verify: Correct date
- Verify: All 4 meals shown

### Test Case 4: Log Custom Meal
- Action: Tap FAB, log a meal
- Expected: Meal appears in "Today's Logged Meals"
- Verify: Separate from planned meals

### Test Case 5: History View
- Action: Tap history icon
- Expected: Summary card + list of all meals
- Verify: Total calories calculated correctly

### Test Case 6: BMI-based Plans
- Test with different BMI categories
- Verify: Correct meal plans displayed
- Categories: Underweight, Normal, Overweight, Obese

## Files Modified

1. **lib/screens/meal/meals_tab.dart** (905 lines)
   - Complete UI redesign
   - Added plan-based meal display
   - Added history toggle
   - Added logged meals section

2. **lib/services/daily_meal_service.dart** (140 lines)
   - Created new service
   - Implemented getTodaysMealPlan()
   - Day calculation logic

3. **lib/providers/services_provider.dart**
   - Added dailyMealServiceProvider
   - Riverpod integration

## Future Enhancements

### Potential Features
1. **Meal Completion Tracking**: Mark planned meals as completed
2. **Recipe Details**: Tap food item to see cooking instructions
3. **Shopping List**: Generate list from meal plan
4. **Meal Swap**: Allow swapping between similar meals
5. **Nutrition Insights**: Weekly nutrition trends
6. **Photo Logging**: Add photos to logged meals
7. **Meal Reminders**: Notifications for meal times
8. **Calorie Progress**: Visual progress bar for daily target

### Performance Optimizations
1. Cache meal plans for offline access
2. Preload next day's meal plan
3. Optimize food item list rendering
4. Add pull-to-refresh gesture

## Consistency with Workouts Tab

Both tabs now share:
- ✅ Same gradient background
- ✅ Day-based display (Day 1-7)
- ✅ Start date dependency
- ✅ Waiting view for future dates
- ✅ Separate section for logged items
- ✅ Professional card-based UI
- ✅ FAB for adding custom items
- ✅ Motivational messaging
- ✅ BMI-appropriate plans

## Conclusion

The Meals Tab now provides a comprehensive, user-friendly interface for managing daily nutrition within the Health Habit Plan framework. It seamlessly integrates planned meals with user-logged meals, providing clear visibility into daily calorie and macro targets while maintaining design consistency with the Workouts Tab.

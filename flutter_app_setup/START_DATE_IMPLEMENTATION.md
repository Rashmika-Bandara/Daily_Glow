# Health Habit Plan Start Date Implementation

## Overview
This implementation adds a start date selection system for the Health Habit Plan feature. When users first access the plan, they are prompted to select a start date, which becomes "Day 1" of their 7-day health journey.

## Features Implemented

### 1. Start Date Dialog (`lib/widgets/start_date_dialog.dart`)
- Beautiful gradient dialog with calendar icon
- Shows welcome message: "Please select your start day to proceed. Choose and confirm."
- Date picker with editable selection
- "Start" button to confirm the selected date
- Cannot be dismissed without selecting a date (barrierDismissible: false)

### 2. Firebase Integration (`lib/services/auth_service.dart`)
Added three new methods:
- `savePlanStartDate(DateTime startDate)` - Saves the start date to Firestore
- `getPlanStartDate()` - Retrieves the saved start date from Firestore
- `hasPlanStartDate()` - Checks if a start date has been set

### 3. Dashboard Integration (`lib/screens/home/dashboard_tab.dart`)
Modified the "View Your Health Habit Plan" button to:
- Check if user has set a start date
- Show the start date dialog on first access
- Save the selected date to Firebase
- Navigate to the health plan screen after date selection

### 4. Health Plan Screen Updates (`lib/screens/health_plan/health_habit_plan_screen.dart`)
Enhanced to:
- Load the start date from Firebase on screen initialization
- Calculate current day (Day 1-7) based on the saved start date
- Allow users to update the start date via calendar icon
- Show loading indicator while fetching data
- Display dates relative to the selected start date

## User Flow

1. **First Time Access:**
   - User clicks "View Your Health Habit Plan" on Dashboard
   - Start date dialog appears with welcome message
   - User selects desired start date using the date picker
   - User clicks "Start" button
   - Date is saved to Firebase (`planStartDate` field)
   - User is navigated to Health Habit Plan screen

2. **Subsequent Access:**
   - User clicks "View Your Health Habit Plan" on Dashboard
   - System checks Firebase for existing start date
   - If found, navigates directly to Health Habit Plan screen
   - Health plan displays dates calculated from the saved start date

3. **Updating Start Date:**
   - User opens Health Habit Plan screen
   - Clicks calendar icon in app bar
   - Selects new start date
   - Date is updated in Firebase
   - Current day calculation is updated automatically

## Firebase Data Structure

```
users/{userId}/
  - planStartDate: "2026-01-19T00:00:00.000Z" (ISO 8601 string)
  - updatedAt: "2026-01-19T10:30:00.000Z"
```

## Day Calculation Logic

The system calculates which day of the plan the user is on:

```dart
final difference = DateTime.now().difference(startDate).inDays;
if (difference >= 0 && difference < 7) {
  currentDayIndex = difference; // Day 1-7
} else if (difference < 0) {
  currentDayIndex = 0; // Before start date -> Day 1
} else {
  currentDayIndex = 6; // After 7 days -> Day 7
}
```

### Examples:
- Start date = Jan 19, Today = Jan 19 → Day 1 (index 0)
- Start date = Jan 19, Today = Jan 20 → Day 2 (index 1)
- Start date = Jan 19, Today = Jan 25 → Day 7 (index 6)
- Start date = Jan 19, Today = Jan 26+ → Day 7 (capped)

## UI/UX Features

### Start Date Dialog:
- Gradient background matching app theme
- Light/dark mode support
- Large calendar icon for visual appeal
- Clear instructions for users
- Date displayed in readable format (e.g., "Sunday, January 19, 2026")
- Edit calendar icon to indicate date is changeable
- Cancel and Start buttons for user control

### Health Plan Screen:
- Calendar icon in app bar for easy date modification
- Loading indicator while fetching saved date
- Success/error messages when updating date
- Current day highlighting based on calculated day index

## Benefits

1. **Personalized Experience:** Each user has their own start date
2. **Flexible Planning:** Users can start their plan on any day they choose
3. **Data Persistence:** Start date is saved to Firebase and synced across devices
4. **Clear Progress Tracking:** Day 1-7 are calculated relative to user's chosen start date
5. **Easy Updates:** Users can change their start date at any time

## Testing Checklist

- [ ] First login shows start date dialog
- [ ] Selected date is saved to Firebase
- [ ] Health plan screen loads with correct start date
- [ ] Day calculation is accurate
- [ ] Calendar icon allows date updates
- [ ] Updated dates are saved to Firebase
- [ ] Success/error messages display correctly
- [ ] Loading indicator appears during data fetch
- [ ] Works in both light and dark mode
- [ ] Dialog cannot be dismissed accidentally

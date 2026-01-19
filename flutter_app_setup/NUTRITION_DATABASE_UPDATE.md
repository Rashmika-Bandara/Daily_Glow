# Nutrition Database Update - Daily Glow Health Plans

## Overview
Updated all meal plans with **nutrition-database level detail** including exact food items, weights, calories, and macronutrients (Protein, Carbs, Fat) for all 4 BMI categories.

## Data Model Updates

### New Classes Added

#### `FoodItem`
Individual food items with complete nutrition information:
- `name`: Food name (e.g., "Oats", "Boiled Eggs")
- `weight`: Amount in grams or ml (e.g., "60 g", "250 ml")
- `calories`: Calorie content (int)
- `protein`: Protein in grams (double)
- `carbs`: Carbohydrates in grams (double)
- `fat`: Fat in grams (double)
- `nutritionSummary`: Auto-calculated summary string

#### `Meal`
Collection of food items for a single meal:
- `items`: List of FoodItem objects
- `totalCalories`: Auto-calculated from all items
- `totalProtein`: Auto-calculated sum
- `totalCarbs`: Auto-calculated sum
- `totalFat`: Auto-calculated sum
- `summary`: Simple comma-separated list of food names
- `detailedSummary`: Food names with weights
- `nutritionSummary`: Complete macro breakdown

### Updated Classes

#### `MealPlan`
Now contains Meal objects instead of simple strings:
- `breakfast`: Meal object with detailed items
- `lunch`: Meal object with detailed items
- `snack`: Meal object with detailed items
- `dinner`: Meal object with detailed items
- `totalCalories`: Auto-calculated daily total

## Nutrition Data by BMI Category

### 1. Underweight (BMI < 18.5)

**Goal**: Healthy weight gain, muscle, energy
**Target**: 2400-2600 kcal/day

#### Breakfast (543 kcal)
| Food Item   | Weight    | Calories | Protein | Carbs | Fat  |
| ----------- | --------- | -------- | ------- | ----- | ---- |
| Oats        | 60 g      | 228      | 7.8g    | 38.4g | 4.2g |
| Whole Milk  | 250 ml    | 160      | 8.0g    | 12.0g | 8.0g |
| Boiled Eggs | 2 (100 g) | 155      | 13.0g   | 1.0g  | 11.0g|

#### Lunch (533 kcal)
| Food Item      | Weight | Calories | Protein | Carbs | Fat  |
| -------------- | ------ | -------- | ------- | ----- | ---- |
| White Rice     | 180 g  | 235      | 4.5g    | 52.0g | 0.4g |
| Chicken Breast | 150 g  | 248      | 46.5g   | 0g    | 5.4g |
| Mixed Veggies  | 100 g  | 50       | 2.0g    | 10.0g | 0.5g |

#### Snack (218 kcal)
| Food Item | Weight | Calories | Protein | Carbs | Fat  |
| --------- | ------ | -------- | ------- | ----- | ---- |
| Banana    | 120 g  | 105      | 1.3g    | 27.0g | 0.4g |
| Peanuts   | 20 g   | 113      | 5.2g    | 4.0g  | 9.8g |

#### Dinner (350 kcal)
| Food Item        | Weight   | Calories | Protein | Carbs | Fat  |
| ---------------- | -------- | -------- | ------- | ----- | ---- |
| Whole Wheat Roti | 2 (80 g) | 180      | 6.0g    | 36.0g | 4.0g |
| Lentil Curry     | 150 g    | 170      | 12.0g   | 24.0g | 3.0g |

**Daily Total**: 1,644 kcal | Protein: 106.3g | Carbs: 204.4g | Fat: 44.7g

---

### 2. Normal Weight (BMI 18.5-24.9)

**Goal**: Maintain fitness & stamina
**Target**: 2000-2200 kcal/day

#### Breakfast (440 kcal)
| Food Item   | Weight | Calories | Protein | Carbs | Fat  |
| ----------- | ------ | -------- | ------- | ----- | ---- |
| Oats        | 50 g   | 190      | 6.5g    | 32.0g | 3.5g |
| Boiled Eggs | 2      | 155      | 13.0g   | 1.0g  | 11.0g|
| Apple       | 150 g  | 95       | 0.5g    | 25.0g | 0.3g |

#### Lunch (430 kcal)
| Food Item      | Weight | Calories | Protein | Carbs | Fat  |
| -------------- | ------ | -------- | ------- | ----- | ---- |
| Brown Rice     | 150 g  | 170      | 4.0g    | 36.0g | 1.5g |
| Grilled Fish   | 120 g  | 210      | 28.0g   | 0g    | 10.0g|
| Vegetables     | 100 g  | 50       | 2.0g    | 10.0g | 0.5g |

#### Snack (146 kcal)
| Food Item    | Weight | Calories | Protein | Carbs | Fat  |
| ------------ | ------ | -------- | ------- | ----- | ---- |
| Greek Yogurt | 100 g  | 59       | 10.0g   | 3.6g  | 0.4g |
| Almonds      | 15 g   | 87       | 3.2g    | 3.0g  | 7.5g |

#### Dinner (320 kcal)
| Food Item        | Weight | Calories | Protein | Carbs | Fat  |
| ---------------- | ------ | -------- | ------- | ----- | ---- |
| Whole Wheat Roti | 2      | 180      | 6.0g    | 36.0g | 4.0g |
| Vegetable Curry  | 150 g  | 140      | 4.0g    | 20.0g | 5.0g |

**Daily Total**: 1,336 kcal | Protein: 77.2g | Carbs: 166.6g | Fat: 43.7g

---

### 3. Overweight (BMI 25-29.9)

**Goal**: Healthy weight loss
**Target**: 1700-1800 kcal/day

#### Breakfast (290 kcal)
| Food Item  | Weight | Calories | Protein | Carbs | Fat  |
| ---------- | ------ | -------- | ------- | ----- | ---- |
| Oats       | 40 g   | 152      | 5.2g    | 25.6g | 2.8g |
| Boiled Egg | 1      | 78       | 6.5g    | 0.5g  | 5.5g |
| Papaya     | 150 g  | 60       | 0.8g    | 15.0g | 0.2g |

#### Lunch (393 kcal)
| Food Item       | Weight | Calories | Protein | Carbs | Fat  |
| --------------- | ------ | -------- | ------- | ----- | ---- |
| Brown Rice      | 120 g  | 135      | 3.2g    | 28.0g | 1.2g |
| Grilled Chicken | 120 g  | 198      | 37.0g   | 0g    | 4.3g |
| Salad           | 150 g  | 60       | 2.0g    | 10.0g | 0.5g |

#### Snack (155 kcal)
| Food Item | Weight | Calories | Protein | Carbs | Fat  |
| --------- | ------ | -------- | ------- | ----- | ---- |
| Apple     | 150 g  | 95       | 0.5g    | 25.0g | 0.3g |
| Nuts      | 10 g   | 60       | 2.0g    | 2.0g  | 5.0g |

#### Dinner (210 kcal)
| Food Item      | Weight | Calories | Protein | Carbs | Fat  |
| -------------- | ------ | -------- | ------- | ----- | ---- |
| Vegetable Soup | 250 g  | 120      | 5.0g    | 18.0g | 3.0g |
| Roti           | 1      | 90       | 3.0g    | 18.0g | 2.0g |

**Daily Total**: 1,048 kcal | Protein: 65.2g | Carbs: 142.1g | Fat: 24.8g

---

### 4. Obese (BMI ≥ 30)

**Goal**: Safe fat loss & habit building
**Target**: 1500-1600 kcal/day

#### Breakfast (281 kcal)
| Food Item  | Weight | Calories | Protein | Carbs | Fat  |
| ---------- | ------ | -------- | ------- | ----- | ---- |
| Oats       | 35 g   | 133      | 4.5g    | 22.4g | 2.4g |
| Boiled Egg | 1      | 78       | 6.5g    | 0.5g  | 5.5g |
| Orange     | 150 g  | 70       | 1.2g    | 17.0g | 0.2g |

#### Lunch (390 kcal)
| Food Item          | Weight | Calories | Protein | Carbs | Fat  |
| ------------------ | ------ | -------- | ------- | ----- | ---- |
| Steamed Vegetables | 200 g  | 100      | 4.0g    | 20.0g | 0.5g |
| Grilled Fish       | 120 g  | 180      | 26.0g   | 0g    | 8.0g |
| Brown Rice         | 100 g  | 110      | 2.5g    | 23.0g | 1.0g |

#### Snack (89 kcal)
| Food Item | Weight | Calories | Protein | Carbs | Fat  |
| --------- | ------ | -------- | ------- | ----- | ---- |
| Cucumber  | 200 g  | 30       | 1.0g    | 7.0g  | 0.1g |
| Yogurt    | 100 g  | 59       | 10.0g   | 3.6g  | 0.4g |

#### Dinner (200 kcal)
| Food Item      | Weight | Calories | Protein | Carbs | Fat  |
| -------------- | ------ | -------- | ------- | ----- | ---- |
| Vegetable Soup | 300 g  | 140      | 6.0g    | 20.0g | 3.0g |
| Salad          | 150 g  | 60       | 2.0g    | 10.0g | 0.5g |

**Daily Total**: 960 kcal | Protein: 63.7g | Carbs: 123.5g | Fat: 21.6g

---

## UI Enhancements

### Day Plan Detail Screen

**New Features**:
1. **Expandable Meal Cards**: Tap to expand and view detailed nutrition
2. **Individual Food Items**: Each food item displayed with weight and calories
3. **Macronutrient Chips**: Visual chips showing P/C/F for each item
4. **Total Macros**: Summary section showing meal totals
5. **Color-Coded Calories**: Meal-specific color highlighting

### Meal Card Components

```dart
ExpansionTile
  ├── Title: Meal name (Breakfast, Lunch, etc.)
  ├── Subtitle: Food summary + total calories
  └── Children (Expanded):
      ├── Individual Food Items
      │   ├── Name + Weight
      │   ├── Calorie badge
      │   └── Macro chips (P/C/F)
      └── Total Macronutrients Section
          ├── Total Protein
          ├── Total Carbs
          └── Total Fat
```

## Macronutrient Reference

**Energy Values**:
- Protein: 4 kcal/g
- Carbohydrates: 4 kcal/g
- Fat: 9 kcal/g

## Benefits of Update

1. **Precision**: Exact portion sizes and nutrition data
2. **Education**: Users learn food nutrition values
3. **Tracking**: Easy to track macronutrient intake
4. **Flexibility**: Can substitute items while maintaining macros
5. **Transparency**: Full visibility into meal composition
6. **Science-Based**: Based on standard nutrition databases

## Future Enhancements

- [ ] Meal substitution suggestions
- [ ] Shopping list generation
- [ ] Meal preparation instructions
- [ ] Custom meal creator
- [ ] Food search and add functionality
- [ ] Barcode scanner integration
- [ ] Meal logging and tracking
- [ ] Progress photos and comparisons

## Technical Notes

- All nutrition data uses standard USDA values
- Macronutrient totals are auto-calculated
- UI updates automatically when data changes
- Supports both light and dark themes
- Expandable cards optimize screen space
- Color coding improves visual hierarchy


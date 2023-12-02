class MealPlanEntry {
  final String foodItem;
  final double calories;

  MealPlanEntry({
    required this.foodItem,
    required this.calories,
  });
}


// Define multiple databases using a Map
Map<String, List<MealPlanEntry>> databases = {
  'Food': [
    MealPlanEntry(foodItem: 'Chicken Breast', calories: 284),
    MealPlanEntry(foodItem: "Prime Rib", calories: 400),
    MealPlanEntry(foodItem: "Pork Rib", calories: 317),
    MealPlanEntry(foodItem: "Lamb Chops", calories: 305),
    MealPlanEntry(foodItem: "Ground Lamb", calories: 283),
    MealPlanEntry(foodItem: "Ground Beef", calories: 273),
    MealPlanEntry(foodItem: "Ground Turkey", calories: 258),
    MealPlanEntry(foodItem: "Chicken Thigh", calories: 208),
    MealPlanEntry(foodItem: "Chicken Wing", calories: 43),
    MealPlanEntry(foodItem: 'Salmon', calories: 300),
    MealPlanEntry(foodItem: 'Apple', calories: 89),
    MealPlanEntry(foodItem: 'Avocado', calories: 354),
    MealPlanEntry(foodItem: 'BlackBerry', calories: 53),
    MealPlanEntry(foodItem: 'Coconut', calories: 1536),
    MealPlanEntry(foodItem: 'Fresh Pineapple', calories: 23),
    MealPlanEntry(foodItem: 'Grapes', calories: 6),
    MealPlanEntry(foodItem: 'Mango', calories: 215),
    MealPlanEntry(foodItem: 'Sea Lettuce', calories: 4),
    MealPlanEntry(foodItem: 'Roma Tomato', calories: 25),
    MealPlanEntry(foodItem: 'Artichoke', calories: 56),
    MealPlanEntry(foodItem: 'Sweet Corn', calories: 141),

  ]
  // Add more databases as needed
};

class SavedMealPlan {
  final String targetCalories;
  final double totalCalories;
  final String date;
  final List<MealPlanEntry> selectedItems;

  SavedMealPlan({
    required this.targetCalories,
    required this.totalCalories,
    required this.date,
    required this.selectedItems,
  });
}

Map<String, SavedMealPlan> savedMealPlans = {};

Future<void> saveMealPlan(
    String dbName,
    String date,
    String targetCalories,
    double totalCalories,
    List<MealPlanEntry> selectedItems,
    ) async {
  savedMealPlans[date] = SavedMealPlan(
    targetCalories: targetCalories,
    totalCalories: totalCalories,
    date: date,
    selectedItems: selectedItems,
  );
}

Future<List<MealPlanEntry>> getMealPlan(String dbName, String date) async {
  if (databases.containsKey(dbName)) {
    return databases[dbName]!;
  } else {
    // Handle the case where the requested database is not found
    throw Exception("Database '$dbName' not found");
  }
}


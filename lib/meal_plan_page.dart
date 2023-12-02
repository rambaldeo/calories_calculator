import 'package:flutter/material.dart';
import 'database.dart';

class MealPlanPage extends StatefulWidget {
  final String targetCalories;
  final String date;
  final String databaseName;
  final List<MealPlanEntry> selectedItems;

  MealPlanPage({
    required this.targetCalories,
    required this.date,
    required this.databaseName,
    required this.selectedItems,
  });

  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  late Future<List<MealPlanEntry>> mealPlanFuture;
  List<MealPlanEntry> selectedEntries = [];
  double totalCalories = 0.0;

  @override
  void initState() {
    super.initState();
    mealPlanFuture = getMealPlan(widget.databaseName, widget.date);
    selectedEntries = widget.selectedItems; // Initialize selectedEntries with passed items
  }

  //Function to calculate the total calories
  double calculateTotalCalories(List<MealPlanEntry> items){
    double totalCalories = 0.0;
    for (var item in items){
      totalCalories += item.calories;
    }
    return totalCalories;
  }

  @override
  Widget build(BuildContext context) {
    // Get the maximum width and height of the screen
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan Tracker'),
        actions: [
          //Save Button
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              //Show a message to the user when saved
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Items were saved'),
                ),
              );

              saveMealPlan("savedMealPlans", widget.date, widget.targetCalories, totalCalories, selectedEntries);

              // Navigate back to the HomePage
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context);
              });

            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Target Calories: ${widget.targetCalories}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),

          // Total Calories Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Calories: ${calculateTotalCalories(selectedEntries)}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),

          // Selected Food Item Section
          Container(
            height: maxHeight * 0.2, // Set the height as a percentage of the screen height
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Food Items:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedEntries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(selectedEntries[index].foodItem),
                        subtitle: Text('Calories: ${selectedEntries[index].calories.toString()}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              selectedEntries.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // List view
          Expanded(
            child: Container(
              height: maxHeight * 0.4, // Set the height as a percentage of the screen height
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: FutureBuilder(
                future: getMealPlan('Food', widget.date),
                builder: (context, AsyncSnapshot<List<MealPlanEntry>?> snapshot) {
                  return buildListView(snapshot);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListView(AsyncSnapshot<List<MealPlanEntry>?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError || snapshot.data == null) {
      return Text('Error: ${snapshot.error}');
    } else {
      List<MealPlanEntry> mealPlanEntries = snapshot.data!;

      return ListView.builder(
        itemCount: mealPlanEntries.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10.0), // Add margin for spacing between items
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Text(mealPlanEntries[index].foodItem),
              subtitle: Text('Calories: ${mealPlanEntries[index].calories.toString()}'),
              onTap: () {
                setState(() {
                  selectedEntries.add(mealPlanEntries[index]);
                });
              },
            ),
          );
        },
      );
    }
  }
}

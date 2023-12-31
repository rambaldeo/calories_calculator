import 'package:flutter/material.dart';
import 'database.dart';
import 'meal_plan_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController targetCaloriesController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calories Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form( //Form to take in user input
              key: _formKey,
              child: Column(
                children: [
                  TextFormField( //Take in the user target calories
                    controller: targetCaloriesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Target Calories per Day'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter target calories';
                      }
                      return null;
                    },
                  ),
                  DateInputField( //Let the user select the date
                      controller: dateController,
                    onChanged: () {
                        setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(//when pressed, push the information to the next page
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealPlanPage(
                              targetCalories: targetCaloriesController.text,
                              date: dateController.text,
                              databaseName: 'Food',
                              selectedItems: [],
                            ),
                          ),
                        ).then((_) {
                          // Clear the form when returning from MealPlanPage
                          targetCaloriesController.clear();
                          dateController.clear();
                        });
                      }
                    },
                    child: const Text('Generate Meal Plan'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), //if there is an existing meal plan on the selected date, it will display the meal plan
            const Text(
              'Saved Meal Plans for ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: savedMealPlans.length,
                itemBuilder: (context, index) {
                  var savedPlan = savedMealPlans.values.elementAt(index);

                  //If an item is clicked, open it in the meal_plan_page
                  if(savedPlan.date == dateController.text){
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealPlanPage(
                                targetCalories: savedPlan.targetCalories,
                                date: savedPlan.date,
                                databaseName: 'Food',
                                selectedItems: savedPlan.selectedItems
                            ),
                          ),
                        ).then((_) {
                          // Clear the form when returning from MealPlanPage
                          targetCaloriesController.clear();
                          dateController.clear();
                        });
                      },
                      child: ListTile(
                        title: Text('Date: ${savedPlan.date}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Target Calories: ${savedPlan.targetCalories}'),
                            Text('Total Calories: ${calculateTotalCalories(savedPlan.selectedItems)}'), // Display total calories
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            removeMealPlan(savedPlan.date);
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  }else{
                    return Container();
                  }

                },
              ),

            ),
          ],
        ),
      ),
    );
  }

  //Function to calculate the total calories in the meal plan
  calculateTotalCalories(List<MealPlanEntry> selectedItems) {
    double totalCalories = 0.0;
    for (var item in selectedItems){
      totalCalories += item.calories;
    }
    return totalCalories;
  }

  //If the user wants to remove the meal plan
  void removeMealPlan(String date) {
    setState(() {
      savedMealPlans.remove(date);
    });
  }

}

class DateInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function()? onChanged;

  const DateInputField({
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: controller,
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2300),
        );

        if (selectedDate != null) {
          controller.text = selectedDate.toLocal().toString().split(' ')[0];
          onChanged?.call();
        } else {

        }
      },
      decoration: const InputDecoration(
        labelText: 'Date (YYYY-MM-DD)',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a date';
        }
        return null;
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:foodm/models/meal_plan_model.dart';
import 'package:uuid/uuid.dart';

class SetPlanScreen extends StatefulWidget {
  final MealPlan? initialPlan;

  const SetPlanScreen({super.key, this.initialPlan});

  @override
  State<SetPlanScreen> createState() => _SetPlanScreenState();
}

class _SetPlanScreenState extends State<SetPlanScreen> {
  final Map<String, Meal> _meals = {
    "Breakfast": Meal(type: "Breakfast", startTime: "08:00", endTime: "09:00", items: []),
    "Lunch": Meal(type: "Lunch", startTime: "12:00", endTime: "13:00", items: []),
    "Snacks": Meal(type: "Snacks", startTime: "16:00", endTime: "16:30", items: []),
    "Dinner": Meal(type: "Dinner", startTime: "19:00", endTime: "20:00", items: []),
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialPlan != null) {
      for (var meal in widget.initialPlan!.meals) {
        _meals[meal.type] = meal;
      }
    }
  }

  void _addItem(String mealType) {
    final TextEditingController itemController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Item to $mealType"),
          content: TextField(
            controller: itemController,
            decoration: const InputDecoration(labelText: "Item Name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _meals[mealType]?.items.add(itemController.text);
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: _meals.entries.map((entry) {
            final mealType = entry.key;
            final meal = entry.value;

            // Create controllers for start and end time
            final TextEditingController startTimeController =
                TextEditingController(text: meal.startTime);
            final TextEditingController endTimeController =
                TextEditingController(text: meal.endTime);

            return Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealType,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Start Time
                        Expanded(
                          child: TextField(
                            controller: startTimeController,
                            decoration: const InputDecoration(
                              labelText: "Start Time",
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            onChanged: (value) {
                              setState(() {
                                meal.startTime = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // End Time
                        Expanded(
                          child: TextField(
                            controller: endTimeController,
                            decoration: const InputDecoration(
                              labelText: "End Time",
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            onChanged: (value) {
                              setState(() {
                                meal.endTime = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Items List
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Items:"),
                        ...meal.items.map((item) => ListTile(
                              title: Text(item),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    meal.items.remove(item);
                                  });
                                },
                              ),
                            )),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => _addItem(mealType),
                          icon: const Icon(Icons.add),
                          label: const Text("Add Item"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            final newMealPlan = MealPlan(
              id: const Uuid().v4().toString(),
              name: "My Meal Plan",
              frequency: "Daily",
              amount: 1000,
              meals: _meals.values.toList(),
            );

            Navigator.pop(context, newMealPlan);
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text("Save"),
        ),
      ),
    );
  }
}

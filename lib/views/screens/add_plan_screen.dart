import 'package:flutter/material.dart';
import 'package:foodm/models/meal_plan_model.dart';
import 'package:foodm/mobx/meal_plan_store.dart';
import 'package:uuid/uuid.dart'; // Import UUID package

class AddPlanScreen extends StatefulWidget {
  final MealPlanStore store;

  const AddPlanScreen({super.key, required this.store});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _planNameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedFrequency = "Monthly";
  final Map<String, bool> _mealsSelected = {
    "Breakfast": false,
    "Lunch": false,
    "Snacks": false,
    "Dinner": false,
  };

  final Map<String, double> _mealPrices = {
    "Breakfast": 0.0,
    "Lunch": 0.0,
    "Snacks": 0.0,
    "Dinner": 0.0,
  };

  bool _showPriceBreakdown = false;
  final Uuid _uuid = const Uuid();

  // Build the Add Plan form
  Widget _buildAddPlanForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _planNameController,
              decoration: const InputDecoration(
                labelText: "Plan Name",
                prefixIcon: Icon(Icons.assignment),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a plan name";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Show price breakdown per meal"),
                Switch(
                  value: _showPriceBreakdown,
                  onChanged: (value) {
                    setState(() {
                      _showPriceBreakdown = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: _mealsSelected.keys.map((meal) {
                return CheckboxListTile(
                  title: _showPriceBreakdown
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(meal),
                            SizedBox(
                              width: 80,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  prefixText: "₹",
                                ),
                                enabled: _mealsSelected[meal] ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    _mealPrices[meal] =
                                        double.tryParse(value) ?? 0.0;
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      : Text(meal),
                  value: _mealsSelected[meal],
                  onChanged: (value) {
                    setState(() {
                      _mealsSelected[meal] = value!;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Amount",
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter an amount";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedFrequency,
              items: ["Daily", "Weekly", "Monthly"]
                  .map((frequency) => DropdownMenuItem<String>(
                        value: frequency,
                        child: Text(frequency),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFrequency = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Select Frequency",
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final newPlan = MealPlan(
                    id: _uuid.v4(),
                    name: _planNameController.text,
                    frequency: _selectedFrequency,
                    amount: double.parse(_amountController.text).toInt(),
                    meals: _mealsSelected.entries
                        .where((entry) => entry.value)
                        .map((entry) => Meal(
                              type: entry.key,
                              startTime: '08:00',
                              endTime: '09:00',
                              items: [],
                            ))
                        .toList(),
                  );

                  widget.store.addMealPlan(newPlan);

                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50)),
              child: const Text("Save & Continue"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Plan"),
      ),
      body: _buildAddPlanForm(),
    );
  }
}

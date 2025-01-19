import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:foodm/main.dart';
import 'package:foodm/models/meal_plan_model.dart';
// import 'package:foodm/controller/meal_plan_controller.dart';
import 'package:foodm/views/screens/add_plan_screen.dart';
import 'package:foodm/mobx/meal_plan_store.dart';
import 'package:foodm/views/screens/feedback_screen.dart';
import 'package:foodm/views/screens/meal_track_screen.dart';
import 'package:foodm/views/screens/menu_screen.dart';
// import 'package:foodm/views/screens/meal_details_screen.dart';
import 'package:foodm/views/screens/set_plan_screen.dart';


final List<Widget> _tabs = [
  const MealPlanScreen(),
  const MenuScreen(),
  const MealTrackScreen(),
  const FeedbackScreen(),
];

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final MealPlanStore store = MealPlanStore(); // Instantiate the MobX store

  @override
  void initState() {
    super.initState();
    // Load meal plans from SharedPreferences when the screen loads
    store.loadMealPlansFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SplashScreen(),
                        ),
                      );
            },
          ),
          title: const Text('Food Management'),
          bottom: TabBar(
             onTap: (index) {
                  switch (index) {
                    case 0:
                      // Navigate to Meal Plan Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MealPlanScreen(),
                        ),
                      );
                      break;
                    case 1:
                      // Navigate to Menu Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuScreen(),
                        ),
                      );
                      break;
                    case 2:
                      // Navigate to Meal Track Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MealTrackScreen(),
                        ),
                      );
                      break;
                    case 3:
                      // Navigate to Feedback Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeedbackScreen(),
                        ),
                      );
                      break;
                    default:
                      break;
                  }
                },
            tabs:const [
              Tab(icon: Icon(Icons.food_bank), text: 'Meal Plan'),
              Tab(icon: Icon(Icons.menu_open_rounded), text: 'Menu'),
              Tab(icon: Icon(Icons.menu_book), text: 'Meal Track'),
              Tab(icon: Icon(Icons.rate_review_rounded), text: 'Feedback'),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPlanScreen(store: store)), // Pass MobX store to AddPlanScreen
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Plan'),
            ),
          ],
        ),
        body: Observer(
          builder: (context) {
            if (store.mealPlans.isEmpty) {
              return const Center(child: Text('No meal plans available.'));
            }

            return  ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: store.mealPlans.length,
              itemBuilder: (context, index) {
                final plan = store.mealPlans[index];
                return MealPlanCard(
                  plan: plan,
                  onDelete: () async {
                    // Call the removeMealPlan method from the store
                    await store.removeMealPlan(plan.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${plan.name} has been deleted.')),
                    );
                  },
                );
              },
            );

          },
        ),
      ),
    );
  }
}
class MealPlanCard extends StatelessWidget {
  final MealPlan plan;
  final VoidCallback onDelete;

  const MealPlanCard({
    super.key,
    required this.plan,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SetPlanScreen(),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        plan.frequency,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: plan.meals
                    .map((meal) => Text(
                          "• ${meal.type}",
                          style: const TextStyle(fontSize: 14),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Amount: ₹${plan.amount}",
                  style:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

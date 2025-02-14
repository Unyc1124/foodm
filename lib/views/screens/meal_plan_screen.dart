import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:foodm/main.dart';
import 'package:foodm/models/meal_plan_model.dart';
import 'package:foodm/views/screens/add_plan_screen.dart';
import 'package:foodm/mobx/meal_plan_store.dart';
import 'package:foodm/views/screens/feedback_screen.dart';
import 'package:foodm/views/screens/meal_track_screen.dart';
import 'package:foodm/views/screens/menu_screen.dart';
import 'package:foodm/views/screens/set_plan_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
    store
        .loadMealPlansFromSharedPreferences(); // Ensure shared prefs loading on init
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            '😋Tastings',
            style: GoogleFonts.knewave(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.purple.withOpacity(0.65),
          bottom: const TabBar(
            labelColor: Colors.white, // Active icon and text color
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white, // Inactive icon and text color
            tabs: [
              Tab(icon: Icon(Icons.food_bank), text: 'Meal Plan'),
              Tab(icon: Icon(Icons.menu_open_rounded), text: 'Menu'),
              Tab(icon: Icon(Icons.menu_book), text: 'Meal Track'),
              Tab(icon: Icon(Icons.rate_review_rounded), text: 'Feedback'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MealPlanContent(store: store),
            const MenuScreen(),
            const MealTrackScreen(),
            const FeedbackScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPlanScreen(store: store),
              ),
            );
          },
          backgroundColor: Colors.purple.withOpacity(0.65), // Custom color
          child: const Icon(Icons.add,color: Colors.white),
        ),
      ),
    );
  }
}

class MealPlanContent extends StatelessWidget {
  final MealPlanStore store;

  const MealPlanContent({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (store.mealPlans.isEmpty) {
          return const Center(child: Text('No meal plans available.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: store.mealPlans.length,
          itemBuilder: (context, index) {
            final plan = store.mealPlans[index];
            return MealPlanCard(
              plan: plan,
              onDelete: () async {
                await store.removeMealPlan(plan.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${plan.name} has been deleted.')),
                );
              },
            );
          },
        );
      },
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
         shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(12.0), // Rounded corners
          side: BorderSide(
            color: Colors.purple.withOpacity(0.65), // Border color
            width: 2.0, // Border thickness
          ),
        ),
        margin: const EdgeInsets.only(bottom: 16.0),
        elevation: 4, // Adds shadow for better appearance
              
       
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
                    icon:Icon(Icons.delete, color: Colors.purple.withOpacity(0.65)),
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
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
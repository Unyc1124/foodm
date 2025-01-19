import 'package:flutter/material.dart';
// import 'package:foodm/views/screens/add_plan_screen.dart';
import 'package:foodm/views/screens/meal_plan_screen.dart';

void main() {
  runApp(const FoodManagementApp());
}

class FoodManagementApp extends StatelessWidget {
  const FoodManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Management App',
      // theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false, // Switch based on system setting
      home: SplashScreen(),

    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 4, 4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Icon representing a meal (adjust the icon as per your needs)
            const Icon(
              Icons.fastfood,
              size: 150.0,
              color: Color.fromARGB(255, 220, 127, 127),
            ),
            const SizedBox(height: 30),
            // Title Text
            const Text(
              'Food Management',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 218, 143, 143),
              ),
            ),
            const SizedBox(height: 50),
            // Get Started Button
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MealPlanScreen(),
                        ),
                      );
              },
              style: ElevatedButton.styleFrom(
                 // Button color
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Get Started',style:TextStyle(
                color: Color.fromARGB(255, 198, 134, 134)
              ) ,),
            ),
          ],
        ),
      ),
    );
  }
}
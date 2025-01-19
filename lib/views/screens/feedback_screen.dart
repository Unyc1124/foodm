import 'package:flutter/material.dart';
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Page'),
      ),
      body: const Center(child: Text('Give Your Feedback Here')),
    );
  }
}
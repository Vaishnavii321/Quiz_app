import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Screens/achievment_badge.dart';

import '../providers/quiz_provider.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;

  const ResultScreen({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 27,)),
        backgroundColor: Colors.blueGrey.shade600,
      ),
      body: Container(
        color: Colors.blueGrey.shade600,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Display Score with a larger, more eye-catching font
                Text(
                  'Your Score: $score',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Show Achievement Badge if score is 100
                if (score > 6)
                  const AchievementBadge(
                    text: 'Perfect Score!',
                    icon: Icons.star,
                  ),
                const SizedBox(height: 40),

                // Retry Button with rounded edges and enhanced padding
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5, // Add shadow for depth
                  ),
                  onPressed: () {
                    provider.resetScore();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: const Text(
                    'Retry Quiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Go back home button with text styling and padding
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

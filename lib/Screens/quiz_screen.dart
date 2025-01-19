import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:quiz_app/Screens/question_card.dart';
import 'package:quiz_app/models/option_model.dart';
import 'package:quiz_app/providers/quiz_provider.dart'; // Import QuizProvider
import 'package:quiz_app/services/api_services.dart';

import '../models/quiz_model.dart';
import 'result_screen.dart'; // Import the ResultScreen

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizModel> questions;
  int currentQuestionIndex = 0;
  int totalQuestions = 0;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    try {
      final fetchedQuestions = await ApiService.fetchQuizData();
      setState(() {
        questions = fetchedQuestions;
        totalQuestions = questions.length;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load quiz data: $e';
        isLoading = false;
      });
    }
  }

  void handleOptionSelected(Option selectedOption) {
    bool isCorrect = selectedOption.description ==
        questions[currentQuestionIndex].correctAnswer;

    // Access QuizProvider and update the score
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);

    if (isCorrect) {
      quizProvider.incrementScore(); // Increment score using QuizProvider
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Correct Answer! 🎉"),
          backgroundColor: Colors.green,
          duration: const Duration(milliseconds: 500),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Wrong Answer! 😢"),
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 500),
        ),
      );
    }

    // Move to the next question or end the quiz
    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestionIndex < totalQuestions - 1) {
        setState(() {
          currentQuestionIndex++;
        });
      } else {
        // Navigate to ResultScreen after the quiz ends
        final score =
            quizProvider.score; // Get the final score from QuizProvider
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              score: score,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(errorMessage)),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Question ${currentQuestionIndex + 1} / $totalQuestions",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (currentQuestionIndex < totalQuestions - 1) {
                        setState(() {
                          currentQuestionIndex++;
                        });
                      }
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: (currentQuestionIndex + 1) / totalQuestions,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Question card
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: QuestionCard(
                    question: currentQuestion,
                    onOptionSelected: handleOptionSelected,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:quiz_app/models/option_model.dart';

import '../models/quiz_model.dart';

class QuestionCard extends StatelessWidget {
  final QuizModel question;
  final Function(Option) onOptionSelected;

  const QuestionCard({
    required this.question,
    required this.onOptionSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the question
        Text(
          question.question,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),

        // Display options
        for (var option in question.options)
          OptionButton(option: option, onSelected: onOptionSelected),
      ],
    );
  }
}

class OptionButton extends StatelessWidget {
  final Option option;
  final Function(Option) onSelected;

  const OptionButton({
    required this.option,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onSelected(option),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        backgroundColor: Colors.blueGrey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        option.description,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

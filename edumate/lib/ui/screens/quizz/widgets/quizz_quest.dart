import 'package:flutter/material.dart';

class QuestionComponent extends StatelessWidget {
  final Map<String, dynamic> question;
  final String? selectedAnswer;
  final Function(String) onAnswerSelected;

  QuestionComponent({
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question['question'],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...['ans_a', 'ans_b', 'ans_c', 'ans_d'].map((key) {
            return RadioListTile<String>(
              value: question[key],
              groupValue: selectedAnswer,
              title: Text(question[key]),
              onChanged: (value) => onAnswerSelected(value!),
            );
          }).toList(),
        ],
      ),
    );
  }
}

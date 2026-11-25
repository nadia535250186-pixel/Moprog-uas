import 'package:flutter/material.dart';

class CheckAnswer extends StatelessWidget{
  final bool isChecked;
  final bool isCorrect;
  final String explanation;
  final String correctAnswer;

  const CheckAnswer({
    super.key,
    required this.isChecked,
    required this.isCorrect,
    required this.correctAnswer,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    if(!isChecked) {
      return const SizedBox.shrink();
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFDFF7D2) : const Color(0xFFFFE0E0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect ? 'Jawaban Benar' : 'Jawaban Salah',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(explanation),
          if(!isCorrect)
            Text('Jawaban benar: $correctAnswer')
        ],
      ),
    );
  }

  
}
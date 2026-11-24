import 'package:flutter/material.dart';
import '../../models/quiz_question.dart';

class WordMeaningPage extends StatefulWidget {
  const WordMeaningPage({super.key});

  @override
  State<WordMeaningPage> createState() => _WordMeaningPageState();
}

class _WordMeaningPageState extends State<WordMeaningPage> {
  final List<QuizQuestion> questions = [
    QuizQuestion(
      question: 'Beautiful',
      options: ['Cantik', 'Jelek', 'Besar', 'Kecil'],
      answer: 'Cantik',
      explanation: 'Beautiful berarti Cantik atau Indah.',
    ),
    QuizQuestion(
      question: 'Hungry',
      options: ['Haus', 'Lapar', 'Kenyang', 'Mengantuk'],
      answer: 'Lapar',
      explanation: 'Hungry berarti Lapar.',
    ),
    QuizQuestion(
      question: 'Expensive',
      options: ['Murah', 'Mudah', 'Mahal', 'Sulit'],
      answer: 'Mahal',
      explanation: 'Expensive berarti Mahal.',
    ),
  ];

  int currQuestion = 0;

  @override
  Widget build(BuildContext context) {
    final question = questions[currQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tebak Arti Kata'),
      ),
      body: Center(
        child: Text(
          question.question,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
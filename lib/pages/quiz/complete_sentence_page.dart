import 'package:flutter/material.dart';
import '../../models/quiz_question.dart';

class CompleteSentencePage extends StatefulWidget {
  const CompleteSentencePage({super.key});

  @override
  State<CompleteSentencePage> createState() => _CompleteSentencePageState();
}

class _CompleteSentencePageState extends State<CompleteSentencePage> {
  final List<QuizQuestion> questions = [
    QuizQuestion(
      question: 'I ___ a student.',
      options: ['am', 'is', 'are', 'be'],
      answer: 'am',
      explanation: 'I menggunakan to be am.',
    ),
    QuizQuestion(
      question: 'She ___ to school.',
      options: ['go', 'going', 'goes', 'gone'],
      answer: 'goes',
      explanation: 'She menggunakan kata kerja goes.',
    ),
    QuizQuestion(
      question: 'They are ___ football.',
      options: ['play', 'plays', 'playing', 'played'],
      answer: 'playing',
      explanation: 'They are menggunakan kata kerja playing.',
    ),
  ];

  int currQuestion = 0;
  String? selectedAnswer;
  bool isChecked = false;
  int score = 0;

  void checkAnswer() {
    if(selectedAnswer == null) return;
    setState(() {
      isChecked = true;
      if(questions[currQuestion].checkAnswer(selectedAnswer!)) {
        score++;
      }
    });
  }
  void nextQuestion() {
    if(currQuestion < questions.length -1) {
      setState(() {
        currQuestion++;
        selectedAnswer = null;
        isChecked = false;
      });
    } 
    else {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text('Latihan selesai'),
          content: Text('Skormu: $score/${questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currQuestion = 0;
                  selectedAnswer = null;
                  isChecked = false;
                  score = 0;
                });
              },
              child: const Text('Ulang latihan')
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Selesai'),
              ),
            ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Melengkapi Kalimat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Lengkapi kalimat berikut!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...question.options.map((option) {
              final isSelected = selectedAnswer == option;
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 12),
                child: OutlinedButton(
                  onPressed: isChecked ? null : () {
                    setState(() {
                      selectedAnswer = option;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(13),
                    backgroundColor: isSelected ? const Color(0xFFDFF7D2) : Colors.white,
                    side: BorderSide(color: isSelected ? const Color(0xFF58CC02) : Colors.grey.shade400, width: 2)
                  ),
                  child: Text(option), 
                ),
              );
            }),
            const Spacer(),
            if (isChecked)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: question.checkAnswer(selectedAnswer!)
                      ? const Color(0xFFDFF7D2)
                      : const Color(0xFFFFE0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.checkAnswer(selectedAnswer!)
                          ? 'Jawaban Benar!'
                          : 'Jawaban Salah!',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(question.explanation),
                  ],
                ),
              ),
              SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: selectedAnswer == null
                  ? null
                  : isChecked
                      ? nextQuestion
                      : checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                foregroundColor: Colors.white,
              ),
              child: Text(
                isChecked ? 'Lanjut' : 'Periksa Jawaban',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
            ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../models/quiz_question.dart';
import 'check_answer.dart';
import '../../models/quiz_result.dart';

class TranslateSentencePage extends StatefulWidget {
  const TranslateSentencePage({super.key});

  @override
  State<TranslateSentencePage> createState() => _TranslateSentencePageState();
}

class _TranslateSentencePageState extends State<TranslateSentencePage> {
  final List<QuizQuestion> questions = [
    QuizQuestion(
      question: 'I go to school every morning',
      options: [],
      answer: 'Saya pergi ke sekolah setiap pagi',
      explanation: 'I go to school every morning berarti Saya pergi ke sekolah setiap pagi.',
    ),
    QuizQuestion(
      question: 'She is reading a book',
      options: [],
      answer: 'Dia sedang membaca buku',
      explanation: 'She is reading a book berarti Dia sedang membaca buku.',
    ),
    QuizQuestion(
      question: 'They are playing football',
      options: [],
      answer: 'Mereka sedang bermain sepak bola',
      explanation: 'They are playing football berarti Mereka sedang bermain sepak bola.',
    ),
  ];
  final TextEditingController answerController = TextEditingController();
  int currQuestion = 0;
  bool isChecked = false;
  bool isCorrect = false;
  int score = 0;

  void checkAnswer() {
    if (answerController.text.trim().isEmpty) return;

    setState(() {
      isChecked = true;
      isCorrect = answerController.text.trim().toLowerCase() == questions[currQuestion].answer.toLowerCase();

      if(isCorrect) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currQuestion < questions.length - 1) {
      setState(() {
        currQuestion++;
        answerController.clear();
        isChecked = false;
        isCorrect = false;
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Latihan Selesai'),
          content: Text('Skormu: $score dari ${questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  currQuestion = 0;
                  answerController.clear();
                  isChecked = false;
                  isCorrect = false;
                  score = 0;
                });
                Navigator.pop(dialogContext);
              },
              child: const Text('Ulang Latihan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(
                    context,
                    QuizResult(
                      correctAnswers: score,
                      wrongAnswers: questions.length - score,
                      totalQuestions: questions.length
                    ),
                  );
              }, child: Text('Selesai')),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menerjemahkan Kalimat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (currQuestion + 1) / questions.length,
              backgroundColor: Colors.grey.shade400,
              color: Colors.lightGreenAccent,
            ),
            const SizedBox(height: 30),
            const Text(
              'Terjemahkan kalimat berikut!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              onChanged: (value) {
                setState(() {
                });
              },
              controller: answerController,
              enabled: !isChecked,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ketik di sini...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            if(isChecked)
              CheckAnswer(
              isChecked: isChecked,
              isCorrect: isCorrect,
              correctAnswer: questions[currQuestion].answer,
              explanation: questions[currQuestion].explanation,
            ),
            const SizedBox(height: 20,
            ),
          ],
        ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: answerController.text.trim().isEmpty && !isChecked ? null : isChecked ? nextQuestion : checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                foregroundColor: Colors.white,
              ),
              child: Text(isChecked ? 'Lanjut' : 'Periksa Jawaban'),
            ),
          ),
        ),
      );
  }
}

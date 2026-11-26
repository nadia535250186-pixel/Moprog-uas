import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import '../../models/quiz_question.dart';
import 'check_answer.dart';
import '../../services/quiz_service.dart';

class TranslateSentencePage extends StatefulWidget {
  const TranslateSentencePage({super.key});

  @override
  State<TranslateSentencePage> createState() => _TranslateSentencePageState();
}

class _TranslateSentencePageState extends State<TranslateSentencePage> {
  List<QuizQuestion> questions = [];
  bool isLoading = true;
  final TextEditingController answerController = TextEditingController();
  int currQuestion = 0;
  bool isChecked = false;
  bool isCorrect = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try {
      final data = await QuizService().getQuestions('translate_sentence');

      print('Jumlah soal: ${data.length}');
      print(data);

      if(!mounted) return;

      setState(() {
        questions = data;
        isLoading = false;
      });
    } catch(e) {
      if(!mounted) return;
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

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
                Provider.of<QuizProvider>(context, listen:false).addResult(
                    score,
                    questions.length - score,
                    questions.length,
                  );
                  Navigator.pop(context);
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
    if(isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
          ),
      );
    }
    if(questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Belum ada soal tersedia'),
        ),
      );
    }
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

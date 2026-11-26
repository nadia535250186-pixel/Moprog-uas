import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import '../../models/quiz_question.dart';
import 'check_answer.dart';
import '../../services/quiz_service.dart';

class WordMeaningPage extends StatefulWidget {
  const WordMeaningPage({super.key});

  @override
  State<WordMeaningPage> createState() => _WordMeaningPageState();
}

class _WordMeaningPageState extends State<WordMeaningPage> {
  final TextEditingController answerController = TextEditingController();
  List<QuizQuestion> questions = [];
  bool isLoading = true;
  int currQuestion = 0;
  String? selectedAnswer;
  bool isChecked = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  Future<void> loadQuestions() async {
    try {
      final data = await QuizService().getQuestions('word_meaning');

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
      selectedAnswer = answerController.text.trim();

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
        answerController.clear();
        isChecked = false;
      });
    }
    else {
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
                selectedAnswer = null;
                isChecked = false;
                score = 0;
                answerController.clear();
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Ulang Latihan')
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
        title: const Text('Tebak Arti Kata'),
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
            SizedBox(height: 30,),
            const Text('Apa arti kata berikut?', style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(
              question.question,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              onChanged: (value) {
                setState(() {});
              },
              controller: answerController,
              enabled: !isChecked,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ketik di sini...',
              ),
            ),
            const SizedBox(height: 20,),
            if(isChecked)
              CheckAnswer(
              isChecked: isChecked,
              isCorrect: questions[currQuestion].checkAnswer(selectedAnswer!),
              correctAnswer: questions[currQuestion].answer,
              explanation: questions[currQuestion].explanation,
            ),
            const SizedBox(height: 20),
          ],
        ) 
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isChecked ? nextQuestion : answerController.text.trim().isEmpty ? null : checkAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                foregroundColor: Colors.white,
              ),
            child: Text(isChecked ? 'Lanjut' : 'Periksa Jawaban')
          ),
        ),
      ),
    );
  }
}
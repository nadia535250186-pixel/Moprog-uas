import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quiz_provider.dart';
import '../../models/quiz_question.dart';
import 'check_answer.dart';
import '../../services/quiz_service.dart';
import '../../services/audio_service.dart';

class CompleteSentencePage extends StatefulWidget {
  const CompleteSentencePage({super.key});

  @override
  State<CompleteSentencePage> createState() => _CompleteSentencePageState();
}

class _CompleteSentencePageState extends State<CompleteSentencePage> {
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
    AudioService.playBackground();
  }
  
  Future<void> loadQuestions() async {
    try {
      final data = await QuizService().getQuestions('complete_sentence');

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
    if(selectedAnswer == null) return;
    setState(() {
      isChecked = true;
      if(questions[currQuestion].checkAnswer(selectedAnswer!)) {
        score++;
        AudioService.playCorrect();
      }
      else {
        AudioService.playWrong();
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
        builder: (dialogContext) => AlertDialog(
          title: const Text('Latihan selesai'),
          content: Text('Skormu: $score/${questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
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
                  Navigator.pop(dialogContext);
                  Provider.of<QuizProvider>(context, listen:false).addResult(
                    score,
                    questions.length - score,
                    questions.length,
                  );
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
  void dispose() {
    AudioService.stopBackground();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Belum ada soal tersedia')),
      );
    }
    final question = questions[currQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Melengkapi Kalimat'),
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
            const SizedBox(height: 10),
            if (isChecked)
              CheckAnswer(
                isChecked: isChecked,
                isCorrect: questions[currQuestion].checkAnswer(selectedAnswer!),
                correctAnswer: questions[currQuestion].answer,
                explanation: questions[currQuestion].explanation,
            ),
            const Spacer(),
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
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
  String? selectedAnswer;
  bool isChecked = false;
  int score = 0;

  void checkAnswer() {
    if (selectedAnswer == null) return;

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
        barrierDismissible: false,
        builder: (context) => AlertDialog(
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
              });
              Navigator.pop(context);
            },
            child: const Text('Ulang Latihan')
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              }, child: Text('Selesai')),
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
            ...question.options.map((option) {
              final IsSelected = selectedAnswer == option;
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: OutlinedButton(
                  onPressed: isChecked ? null : () {
                    setState(() {
                      selectedAnswer = option;
                    });
                    
                  },
                  child: Text(option),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    backgroundColor: IsSelected ? const Color(0xFFDFF7D2) : Colors.white,
                    side: BorderSide(color: IsSelected ? const Color(0xFF58CC02) : Colors.grey.shade400, width: 2)
                  ),
                ),
              );
            }),
            const SizedBox(height: 20,),
            if(isChecked)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: questions[currQuestion].checkAnswer(selectedAnswer!) ? const Color(0xFFDFF7D2) : const Color(0xFFFFE0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questions[currQuestion].checkAnswer(selectedAnswer!) ? 'Jawaban Benar' : 'Jawaban Salah',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(question.explanation),
                    if(!questions[currQuestion].checkAnswer(selectedAnswer!))
                      Text('Jawaban benar: ${question.answer}')
                    ],
                ),
              ),
          ],
        ) 
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: selectedAnswer == null ? null : isChecked ? nextQuestion : checkAnswer,
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
import 'package:flutter/material.dart';
import '../../models/quiz_question.dart';

class MultipleChoicePage extends StatefulWidget{
  const MultipleChoicePage({super.key});

  @override
  State<MultipleChoicePage> createState() => _MultipleChoicePageState();
}

class _MultipleChoicePageState extends State<MultipleChoicePage> {
  final List<QuizQuestion> questions = [
    QuizQuestion(
      question: 'What is the meaning of "I know"',
      options: ['Aku tahu', 'Aku tidak tahu', 'Aku sekarang', 'Aku senang'],
      answer: 'Aku tahu',
      explanation: 'I know dalam bahasa indonesia berarti Aku tahu'
    ),
    QuizQuestion(
      question: 'What is the meaning of Book', 
      options: ['Meja', 'Kursi', 'Buku', 'Gelas'], 
      answer: 'Buku', 
      explanation: 'Book berarti buku dalam bahasa indonesia'
      ),
    QuizQuestion(
      question: 'What is the meaning of "Water"?',
      options: ['Api', 'Air', 'Angin', 'Tanah'],
      answer: 'Air',
      explanation: 'Water berarti Air dalam bahasa Indonesia.',
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
        title: const Text('Pilihan Ganda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Soal ${currQuestion + 1} dari ${questions.length}',
            style: const TextStyle(fontSize:16),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: (currQuestion + 1) / questions.length,
            color: Colors.lightGreenAccent,
            backgroundColor: Colors.grey.shade300,
          ),
          const SizedBox(height: 32),
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 24),
          ...question.options.map((option) {
            final isSelected = selectedAnswer == option;

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              child: OutlinedButton(
                onPressed: isChecked ? null :() {
                  setState(() {
                    selectedAnswer = option;
                  });
                }, 
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: isSelected ? const Color(0xFFDFF7D2) : Colors.white,
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF58CC02) : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: Text(
                  option,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
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
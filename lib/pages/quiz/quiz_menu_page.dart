import 'package:flutter/material.dart';
import 'complete_sentence_page.dart';
import 'multiple_choice_page.dart';
import 'translate_sentence_page.dart';
import 'word_meaning_page.dart';

class QuizMenuPage extends StatefulWidget{
  const QuizMenuPage({super.key});


  @override
  State<StatefulWidget> createState() => QuizMenuPageState();

}

class QuizMenuPageState extends State<QuizMenuPage> {
    Future<void> openQuiz(Widget page) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }

    void returnResult() {
      Navigator.pop(context);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan/Quiz'),
        actions: [
          TextButton(
            onPressed: returnResult,
            child: const Text('Selesai', style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildMenu('Pilihan Ganda', const MultipleChoicePage()),
            buildMenu('Tebak Arti Kata', const WordMeaningPage()),
            buildMenu('Melengkapi Kalimat', const CompleteSentencePage()),
            buildMenu('Terjemahkan Kalimat', const TranslateSentencePage()),

          ],
        ),),
    );
  }

  Widget buildMenu(String title, Widget page) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        onPressed: () => openQuiz(page),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(22),
          backgroundColor: const Color.fromARGB(255, 96, 173, 36),
          foregroundColor: Colors.white,
        ),
        child: Text(title),
        ),
    );
  }
}
import 'package:flutter/material.dart';
import 'complete_sentence_page.dart';
import 'multiple_choice_page.dart';
import 'translate_sentence_page.dart';
import 'word_meaning_page.dart';

class QuizMenuPage extends StatelessWidget{
  const QuizMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan/Quiz')
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildMenu(context, 'Pilihan Ganda', const MultipleChoicePage()),
            buildMenu(context, 'Tebak Arti Kata', const WordMeaningPage()),
            buildMenu(context, 'Melengkapi Kalimat', const CompleteSentencePage()),
            buildMenu(context, 'Terjemahkan Kalimat', const TranslateSentencePage()),

          ],
        ),),
    );
  }

  
}

Widget buildMenu(BuildContext context, String title, Widget page) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 15),
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(22),
        backgroundColor: const Color.fromARGB(255, 96, 173, 36),
        foregroundColor: Colors.white,
      ),
      child: Text(title),
      ),
  );
}
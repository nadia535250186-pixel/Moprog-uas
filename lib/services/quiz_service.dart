import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_question.dart';

class QuizService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<QuizQuestion>> getQuestions(String type) async {
    final snapshot = await firestore
        .collection('quiz_questions')
        .where('type', isEqualTo: type)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return QuizQuestion(
        question: data['question'],
        options: List<String>.from(data['options']),
        answer: data['answer'],
        explanation: data['explanation'],
      );
    }).toList();
  }
}

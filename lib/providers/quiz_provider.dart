import 'package:flutter/material.dart';

class QuizProvider extends ChangeNotifier {
  int totalCorrect = 0;
  int totalWrong = 0;
  int totalQuestions = 0;

  void addResult(int correct, int wrong, int total) {
    totalCorrect += correct;
    totalWrong += wrong;
    totalQuestions += total;

    notifyListeners();
  }

  void resetResult() {
    totalCorrect = 0;
    totalWrong = 0;
    totalQuestions = 0;

    notifyListeners();
  }

  int get score {
    if (totalQuestions == 0) return 0;
    return ((totalCorrect / totalQuestions) * 100).round();
  }
}

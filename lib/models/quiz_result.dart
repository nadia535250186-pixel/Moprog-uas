
class QuizResult {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;

  QuizResult({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
  });

  int get score {
    if (totalQuestions == 0) return 0;
    return ((correctAnswers / totalQuestions) * 100).round();
  }
}

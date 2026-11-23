class QuizQuestion {
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });

  bool checkAnswer(String userAnswer) {
    return userAnswer.trim().toLowerCase() == answer.toLowerCase();
  }
}


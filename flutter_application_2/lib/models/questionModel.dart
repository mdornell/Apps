class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String difficulty;
  final String theme;

  QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.difficulty,
    required this.theme,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'difficulty': difficulty,
      'theme': theme,
    };
  }

  factory QuestionModel.fromMap(String id, Map<String, dynamic> data) {
    return QuestionModel(
      id: id,
      question: data['question'] ?? 'Pergunta indisponível',
      options: List<String>.from(data['options'] ?? []),
      correctAnswerIndex: data['correctAnswerIndex'] ?? 0,
      difficulty: data['difficulty'] ?? 'Fácil',
      theme: data['theme'] ?? 'Geral',
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/questionModel.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<QuestionModel> questions = []; // Lista para armazenar as questões
  int currentQuestionIndex = 0; // Índice da questão atual
  int? selectedOption; // Opção selecionada pelo usuário
  int score = 0; // Pontuação do usuário

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  // Carrega as questões do Firestore
  Future<void> loadQuestions() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('questions').get();

      final allQuestions = snapshot.docs
          .map((doc) => QuestionModel.fromMap(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ))
          .toList();

      allQuestions.shuffle(); // Embaralha as questões

      setState(() {
        questions =
            allQuestions.take(5).toList(); // Seleciona as 5 primeiras questões
      });
    } catch (e) {
      print('Erro ao carregar as questões: $e');
    }
  }

  // Verifica a resposta selecionada pelo usuário
  void checkAnswer() {
    final currentQuestion = questions[currentQuestionIndex];
    if (selectedOption == currentQuestion.correctAnswerIndex) {
      score++; // Incrementa a pontuação se a resposta estiver correta
    }

    // Vai para a próxima questão ou exibe o resultado final
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        selectedOption = null;
      } else {
        saveScore();
        showResult();
      }
    });
  }

  // Salva a pontuação e a quantidade de perguntas no Firestore
  Future<void> saveScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        await FirebaseFirestore.instance.collection('points').add({
          'user': FirebaseFirestore.instance.collection('users').doc(user.uid),
          'point': score,
          'totalQuestions': questions.length,
        });
      } else {
        print('Usuário não encontrado na coleção users');
      }
    }
  }

  // Exibe o resultado final em um diálogo
  void showResult() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Quiz Concluído!'),
          content: Text('Sua pontuação: $score de ${questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/home', (route) => false);
                setState(() {
                  currentQuestionIndex = 0;
                  score = 0;
                  selectedOption = null;
                });
              },
              child: Text('Voltar ao menu'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz')),
        body: Center(
          child:
              CircularProgressIndicator(), // Exibe um indicador de carregamento
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Pergunta ${currentQuestionIndex + 1} de ${questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibe a pergunta
            Text(
              currentQuestion.question,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Exibe as opções como uma lista de botões de rádio
            ...List.generate(
              currentQuestion.options.length,
              (index) => ListTile(
                title: Text(currentQuestion.options[index]),
                leading: Radio<int>(
                  value: index,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
              ),
            ),

            Spacer(), // Adiciona espaço entre as opções e o botão

            // Botão para avançar para a próxima pergunta
            ElevatedButton(
              onPressed: selectedOption != null ? checkAnswer : null,
              child: Text(
                currentQuestionIndex < questions.length - 1
                    ? 'Próxima'
                    : 'Finalizar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuestionCRUD extends StatefulWidget {
  @override
  _QuestionCRUDState createState() => _QuestionCRUDState();
}

class _QuestionCRUDState extends State<QuestionCRUD> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _optionAController = TextEditingController();
  final TextEditingController _optionBController = TextEditingController();
  final TextEditingController _optionCController = TextEditingController();
  final TextEditingController _optionDController = TextEditingController();
  final TextEditingController _correctAnswerIndexController =
      TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  final TextEditingController _themeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _documentId;

  void _saveQuestion() async {
    if (_questionController.text.isNotEmpty &&
        _optionAController.text.isNotEmpty &&
        _optionBController.text.isNotEmpty &&
        _optionCController.text.isNotEmpty &&
        _optionDController.text.isNotEmpty &&
        _correctAnswerIndexController.text.isNotEmpty &&
        _difficultyController.text.isNotEmpty &&
        _themeController.text.isNotEmpty) {
      try {
        // Salvar ou atualizar o documento no Firestore
        await _firestore.collection('questions').doc(_documentId).set({
          'question': _questionController.text,
          'options': [
            _optionAController.text,
            _optionBController.text,
            _optionCController.text,
            _optionDController.text,
          ],
          'correctAnswerIndex': int.parse(_correctAnswerIndexController.text),
          'difficulty': _difficultyController.text,
          'theme': _themeController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _clearFields();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pergunta salva com sucesso!')),
        );
      } catch (e) {
        print('Erro ao salvar: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar a pergunta.')),
        );
      }
    }
  }

  void _deleteQuestion() async {
    if (_documentId != null) {
      await _firestore.collection('questions').doc(_documentId).delete();
      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pergunta deletada com sucesso!')),
      );
    }
  }

  void _clearFields() {
    _questionController.clear();
    _optionAController.clear();
    _optionBController.clear();
    _optionCController.clear();
    _optionDController.clear();
    _correctAnswerIndexController.clear();
    _difficultyController.clear();
    _themeController.clear();
    _documentId = null;
  }

  void _loadQuestion(String documentId) async {
    DocumentSnapshot doc =
        await _firestore.collection('questions').doc(documentId).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      _questionController.text = data['question'];
      _optionAController.text = data['options'][0];
      _optionBController.text = data['options'][1];
      _optionCController.text = data['options'][2];
      _optionDController.text = data['options'][3];
      _correctAnswerIndexController.text =
          data['correctAnswerIndex'].toString();
      _difficultyController.text = data['difficulty'];
      _themeController.text = data['theme'];
      _documentId = documentId;
    }
  }

  Future<String?> _showDocumentSelectionDialog() async {
    String? selectedDocumentId;
    List<DropdownMenuItem<String>>? items;

    // Busca perguntas na coleção 'questions'
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('questions').get();
      items = querySnapshot.docs.map((doc) {
        return DropdownMenuItem<String>(
          value: doc.id,
          child: Text(doc['question']),
        );
      }).toList();
    } catch (e) {
      print('Erro ao buscar perguntas: $e');
    }

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione uma pergunta'),
          content: items != null && items.isNotEmpty
              ? DropdownButton<String>(
                  isExpanded: true,
                  value: selectedDocumentId,
                  hint: Text('Selecione uma pergunta'),
                  items: items,
                  onChanged: (String? newValue) {
                    selectedDocumentId = newValue;
                  },
                )
              : Text('Nenhuma pergunta disponível.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(selectedDocumentId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Pergunta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              TextField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Digite a pergunta',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _optionAController,
                decoration: InputDecoration(
                  labelText: 'Digite a alternativa A',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _optionBController,
                decoration: InputDecoration(
                  labelText: 'Digite a alternativa B',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _optionCController,
                decoration: InputDecoration(
                  labelText: 'Digite a alternativa C',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _optionDController,
                decoration: InputDecoration(
                  labelText: 'Digite a alternativa D',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _correctAnswerIndexController,
                decoration: InputDecoration(
                  labelText: 'Digite o índice da resposta correta',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              SizedBox(height: 10),
              TextField(
                controller: _difficultyController,
                decoration: InputDecoration(
                  labelText: 'Digite a dificuldade',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _themeController,
                decoration: InputDecoration(
                  labelText: 'Digite o tema',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveQuestion,
                    child: Text('Salvar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String? documentId = await _showDocumentSelectionDialog();
                      if (documentId != null && documentId.isNotEmpty) {
                        _loadQuestion(documentId);
                      }
                    },
                    child: Text('Carregar'),
                  ),
                  ElevatedButton(
                    onPressed: _deleteQuestion,
                    child: Text('Deletar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'pointsList.dart';
import 'quiz.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              child: Text('Iniciar Quiz'),
            ),
            SizedBox(height: 20),
            FutureBuilder<User?>(
              future: Future.value(FirebaseAuth.instance.currentUser),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData &&
                    snapshot.data?.email == 'mdornell@hotmail.com') {
                  return ElevatedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/questionCRUD');
                    },
                    child: Text('Adicionar Pergunta'),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PointsListPage()),
                );
              },
              child: Text('Listar Pontuações'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (Route<dynamic> route) => false);
              },
              child: Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}

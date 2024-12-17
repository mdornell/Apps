import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/pointsList.dart';
import 'pages/questionCRUD.dart';
import 'pages/quiz.dart';
import 'pages/register.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Garante que os widgets sejam inicializados corretamente
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/pointsList': (context) => PointsListPage(),
        '/quiz': (context) => QuizPage(),
        '/questionCRUD': (context) => QuestionCRUD(),
        '/register': (context) => RegisterPage(),
      },
      // Caso a rota não seja definida, o onUnknownRoute pode capturar o erro
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => LoginPage());
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import 'obstacle.dart';

void main() {
  runApp(FlappyBirdGame());
}

class FlappyBirdGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Variáveis do estado do jogo
  double birdY = 0;
  double birdHeight = 0.1;
  double birdWidth = 0.1;

  double gravity = -4.9;
  double velocity = 0;
  double time = 0;

  bool gameStarted = false;
  double initialPosition = 0;

  List<double> obstacleX = [2, 3.5];
  double obstacleWidth = 0.2;
  double obstacleGap = 0.4; // Espaço entre os obstáculos
  List<double> obstacleHeight = [0.3, 0.5];

  int score = 0;
  double obstacleSpeed = 0.05; // Velocidade inicial dos obstáculos

  void startGame() {
    gameStarted = true;
    time = 0;
    initialPosition = birdY;

    Timer.periodic(Duration(milliseconds: 30), (timer) {
      time += 0.03;
      double height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPosition - height;
      });

      // Verifica colisões ou se o pássaro caiu
      if (birdY > 1 || birdY < -1) {
        timer.cancel();
        resetGame();
      }

      // Atualiza posição dos obstáculos
      for (int i = 0; i < obstacleX.length; i++) {
        setState(() {
          obstacleX[i] -= obstacleSpeed;
        });

        // Reseta a posição do obstáculo quando sai da tela
        if (obstacleX[i] < -1) {
          obstacleX[i] += 3;
          obstacleHeight[i] = (0.2 + (0.4 * i)) % 0.6; // Altura aleatória
        }

        // Incrementa a pontuação quando o pássaro passa pelo obstáculo
        if (obstacleX[i] < 0 && obstacleX[i] > -0.05) {
          setState(() {
            score++;
            obstacleSpeed += 0.002; // Aumenta a velocidade dos obstáculos
          });
        }

        // Verifica colisão com obstáculos
        if (obstacleX[i] < 0.2 &&
            obstacleX[i] > -0.2 &&
            (birdY < -1 + obstacleHeight[i] ||
                birdY > 1 - obstacleHeight[i] - obstacleGap)) {
          timer.cancel();
          resetGame();
        }
      }
    });
  }

  void resetGame() {
    setState(() {
      birdY = 0;
      time = 0;
      gameStarted = false;
      obstacleX = [2, 3.5];
      score = 0;
      obstacleSpeed = 0.05; // Reseta a velocidade dos obstáculos
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPosition = birdY;
      velocity = 2.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdY),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: Container(
                      height: MediaQuery.of(context).size.height * birdHeight,
                      width: MediaQuery.of(context).size.width * birdWidth,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  for (int i = 0; i < obstacleX.length; i++)
                    Obstacle(
                      x: obstacleX[i],
                      width: obstacleWidth,
                      height: obstacleHeight[i],
                      gap: obstacleGap,
                    ),
                  if (!gameStarted)
                    Center(
                      child: Text(
                        "TAP TO START",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.green,
                child: Center(
                  child: Text(
                    "Score: $score",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

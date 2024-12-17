import 'package:flutter/material.dart';

class Obstacle extends StatelessWidget {
  final double x;
  final double width;
  final double height;
  final double gap; // Novo parâmetro para o espaço entre os obstáculos

  const Obstacle({
    Key? key,
    required this.x,
    required this.width,
    required this.height,
    required this.gap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment(x, -1),
          child: Container(
            color: Colors.green,
            width: MediaQuery.of(context).size.width * width,
            height: MediaQuery.of(context).size.height * height,
          ),
        ),
        Container(
          alignment: Alignment(x, 1),
          child: Container(
            color: Colors.green,
            width: MediaQuery.of(context).size.width * width,
            height: MediaQuery.of(context).size.height * (1 - height - gap),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class GamePageTruco extends StatefulWidget {
  final int betAmount;

  GamePageTruco({required this.betAmount});

  @override
  _GamePageTrucoState createState() => _GamePageTrucoState();
}

class _GamePageTrucoState extends State<GamePageTruco> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo Truco'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Exemplo de tabuleiro de Truco
              Container(
                width: 300,
                height: 300,
                color: Colors.white,
                child: Center(
                  child: Text(
                    'Tabuleiro de Truco',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Aposta: \$${widget.betAmount.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
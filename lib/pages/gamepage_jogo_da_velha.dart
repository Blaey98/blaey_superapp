import 'package:flutter/material.dart';

class GamePageJogoDaVelha extends StatefulWidget {
  final int betAmount;

  GamePageJogoDaVelha({required this.betAmount});

  @override
  _GamePageJogoDaVelhaState createState() => _GamePageJogoDaVelhaState();
}

class _GamePageJogoDaVelhaState extends State<GamePageJogoDaVelha> {
  List<String> _board = List.filled(9, '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Velha'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tabuleiro de Jogo da Velha
              Container(
                width: 300,
                height: 300,
                color: Colors.white,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _board[index] = 'X';
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        color: Colors.grey[700],
                        child: Center(
                          child: Text(
                            _board[index],
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 9,
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
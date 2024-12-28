import 'package:flutter/material.dart';

class GamePageXadrez extends StatefulWidget {
  final int betAmount;

  GamePageXadrez({required this.betAmount});

  @override
  _GamePageXadrezState createState() => _GamePageXadrezState();
}

class _GamePageXadrezState extends State<GamePageXadrez> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo Xadrez'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Exemplo de tabuleiro de Xadrez
              Container(
                width: 300,
                height: 300,
                color: Colors.white,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(1),
                      color: (index % 2 == 0) ? Colors.white : Colors.black,
                    );
                  },
                  itemCount: 64,
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
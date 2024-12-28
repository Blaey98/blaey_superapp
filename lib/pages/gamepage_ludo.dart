import 'package:flutter/material.dart';

class GamePageLudo extends StatefulWidget {
  final int betAmount;

  GamePageLudo({required this.betAmount});

  @override
  _GamePageLudoState createState() => _GamePageLudoState();
}

class _GamePageLudoState extends State<GamePageLudo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo Ludo'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Exemplo de tabuleiro de Ludo
              Container(
                width: 300,
                height: 300,
                color: Colors.white,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(4),
                      color: Colors.grey[700],
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
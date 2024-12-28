import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'negotiation_page.dart';

class WaitingForPlayerPage extends StatefulWidget {
  final String gameTitle;

  WaitingForPlayerPage({required this.gameTitle});

  @override
  _WaitingForPlayerPageState createState() => _WaitingForPlayerPageState();
}

class _WaitingForPlayerPageState extends State<WaitingForPlayerPage> {
  bool _isRedPlayerVisible = false;

  @override
  Widget build(BuildContext context) {
    String gameImagePath;
    switch (widget.gameTitle.toLowerCase()) {
      case 'dama':
        gameImagePath = 'assets/jogos/dama.png';
        break;
      case 'xadrez':
        gameImagePath = 'assets/jogos/xadrez.png';
        break;
      case 'ludo':
        gameImagePath = 'assets/jogos/ludo.png';
        break;
      case 'truco':
        gameImagePath = 'assets/jogos/truco.png';
        break;
      case 'jogo da velha':
        gameImagePath = 'assets/jogos/jogo_da_velha.png';
        break;
      default:
        gameImagePath = 'assets/jogos/default.png';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Aguardando Jogador'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, color: Colors.white, size: 40),
                  ),
                  SizedBox(width: 20),
                  Column(
                    children: [
                      // Adicionar o nome do jogo em negrito acima da imagem do jogo com animação
                      Text(
                        widget.gameTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(duration: 1000.ms).slide(),
                      SizedBox(height: 10),
                      Image.asset(
                        gameImagePath,
                        width: 100,
                        height: 100,
                      ).animate().fadeIn(duration: 1000.ms).slide(),
                      SizedBox(height: 20),
                      Text(
                        'Aguardando...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  AnimatedOpacity(
                    opacity: _isRedPlayerVisible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.green),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isRedPlayerVisible = true;
                  });
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NegotiationPage(gameTitle: widget.gameTitle)),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text('Encontrar Jogador'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// lib/pages/ready_screen.dart
import 'package:flutter/material.dart';
import 'gamepage_ludo.dart';
import 'gamepage_truco.dart';
import 'gamepage_jogo_da_velha.dart';
import 'gamepage_chess.dart';
import 'game_page_dama.dart';

class ReadyScreen extends StatefulWidget {
  final String gameTitle;
  final int totalBetAmount;

  ReadyScreen({required this.gameTitle, required this.totalBetAmount});

  @override
  _ReadyScreenState createState() => _ReadyScreenState();
}

class _ReadyScreenState extends State<ReadyScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();

    Future.delayed(Duration(seconds: 2), () {
      _startGame();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startGame() {
    Widget gamePage;
    switch (widget.gameTitle.toLowerCase()) {
      case 'dama':
        gamePage = GamePageDama(betAmount: widget.totalBetAmount);
        break;
      case 'xadrez':
        gamePage = GamePageChess(betAmount: widget.totalBetAmount);
        break;
      case 'ludo':
        gamePage = GamePageLudo(betAmount: widget.totalBetAmount);
        break;
      case 'truco':
        gamePage = GamePageTruco(betAmount: widget.totalBetAmount);
        break;
      case 'jogo da velha':
        gamePage = GamePageJogoDaVelha(betAmount: widget.totalBetAmount);
        break;
      default:
        gamePage = GamePageDama(betAmount: widget.totalBetAmount);
        break;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => gamePage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF16D735),
      body: Center(
        child: SlideTransition(
          position: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ready',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Blaey!',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
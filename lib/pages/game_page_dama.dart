import 'package:flutter/material.dart';
import 'dart:async';
import '../models/game_logic.dart';
import '../widgets/board_widget.dart';
import 'fun_page.dart';

class GamePageDama extends StatefulWidget {
  final int betAmount;

  const GamePageDama({Key? key, required this.betAmount}) : super(key: key);

  @override
  _GamePageDamaState createState() => _GamePageDamaState();
}

class _GamePageDamaState extends State<GamePageDama> {
  GameLogic gameLogic = GameLogic.initial();
  Timer? _playerTimer;
  Timer? _opponentTimer;
  Duration _playerTime = Duration(minutes: 5);
  Duration _opponentTime = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _startPlayerTimer();
  }

  @override
  void dispose() {
    _playerTimer?.cancel();
    _opponentTimer?.cancel();
    super.dispose();
  }

  void _startPlayerTimer() {
    _playerTimer?.cancel();
    _playerTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_playerTime > Duration(seconds: 0)) {
          _playerTime -= Duration(seconds: 1);
        } else {
          _switchPlayer();
        }
      });
    });
  }

  void _startOpponentTimer() {
    _opponentTimer?.cancel();
    _opponentTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_opponentTime > Duration(seconds: 0)) {
          _opponentTime -= Duration(seconds: 1);
        } else {
          _switchPlayer();
        }
      });
    });
  }

  void _switchPlayer() {
    setState(() {
      gameLogic.playerTurn = !gameLogic.playerTurn;
      if (gameLogic.playerTurn) {
        _startPlayerTimer();
        _opponentTimer?.cancel();
      } else {
        _startOpponentTimer();
        _playerTimer?.cancel();
      }
    });
  }

  void _handleMove() {
    _switchPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo de Damas'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Aposta: \$${widget.betAmount}',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Expanded(
              child: BoardWidget(
                gameLogic: gameLogic,
                onMove: _handleMove,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimerDisplay(_playerTime),
                  _buildTimerDisplay(_opponentTime),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerDisplay(Duration duration) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.black,
      child: Text(
        _formatDuration(duration),
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
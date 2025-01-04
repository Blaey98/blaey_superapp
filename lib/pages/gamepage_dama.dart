import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math'; // Adiciona a importação correta para Random
import '../models/game_logic.dart' as game_logic;
import 'chat_page.dart';
import 'fun_page.dart';
import 'player_won.dart'; // Importar a página de vitória
import 'player_lose.dart'; // Importar a página de derrota
import '../widgets/board_widget.dart'; // Importa o widget BoardWidget

class GamePageDama extends StatefulWidget {
  final double betAmount;

  const GamePageDama({Key? key, required this.betAmount}) : super(key: key);

  @override
  _GamePageDamaState createState() => _GamePageDamaState();
}

class _GamePageDamaState extends State<GamePageDama> {
  late game_logic.GameLogic gameLogic;
  Timer? _playerTimer;
  Timer? _opponentTimer;
  Timer? _memeTimer;
  String? _selectedMeme;
  bool _showMeme = false;
// Track the number of captured pieces
// Track the total number of captured pieces in a turn

  @override
  void initState() {
    super.initState();
    gameLogic = game_logic.GameLogic.initial();
    _startPlayerTimer();
  }

  @override
  void dispose() {
    _playerTimer?.cancel();
    _opponentTimer?.cancel();
    _memeTimer?.cancel();
    super.dispose();
  }

  void _startPlayerTimer() {
    _playerTimer?.cancel();
    _playerTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (gameLogic.playerTurn) {
          // Player's timer logic
        }
      });
    });
  }

  void _startOpponentTimer() {
    _opponentTimer?.cancel();
    _opponentTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (!gameLogic.playerTurn) {
          // Opponent's timer logic
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
        _makeBotMove();
        _playerTimer?.cancel();
      }
      // Reset total captured pieces when the turn ends
    });
  }

  void _handleMove(int startX, int startY, int endX, int endY) {
    setState(() {
      gameLogic.makeMove(startX, startY, endX, endY);
// Update captured pieces for display

      // Verifica se o jogo terminou após a jogada
      if (gameLogic.isGameOver()) {
        int? winner = gameLogic.getWinner();
        if (winner != null) {
          _endGame(winner == 1); // 1: Jogador venceu, 2: Bot venceu
        }
      }

      if (gameLogic.getPossibleCaptureMoves(endX, endY).isEmpty) {
        _switchPlayer();
      }
    });
  }

  Future<void> _makeBotMove() async {
    int delay = Random().nextInt(1000) + 1000; // Aleatório entre 1000ms (1s) e 2000ms (2s)
    await Future.delayed(Duration(milliseconds: delay));

    gameLogic.makeBotMove();
    setState(() {});

    if (gameLogic.isGameOver()) {
      int? winner = gameLogic.getWinner();
      if (winner != null) {
        _endGame(winner == 1); // 1: Jogador venceu, 2: Bot venceu
      }
    }
  }

  void _endGame(bool didPlayerWin) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => didPlayerWin ? PlayerWonPage() : PlayerLosePage(),
      ),
    );
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Confirmar Saída"),
          content: Text("Você tem certeza que deseja sair? Você perderá as moedas."),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Sair", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FunPage(userBalance: 100.0)), // Passando o userBalance
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6, // 60% da altura da tela
            child: ChatPage(
              friendName: "Amigo",
              friendPhotoUrl: "assets/icons/user.png",
              isOnline: true,
            ),
          ),
        );
      },
    );
  }


  void _goBack() {
    // Lógica para voltar e ver a jogada anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo de Damas'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: _showChatDialog,
          ),
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: _goBack,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Exibe o valor da aposta
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Aposta: \$${widget.betAmount}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Exibe o tabuleiro de damas
              Expanded(
                child: BoardWidget(
                  gameLogic: gameLogic,
                  onMove: _handleMove,
                ),
              ),
              // Botão para sair do jogo
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _confirmExit,
                  child: Text('Sair do Jogo'),
                ),
              ),
            ],
          ),
          // Exibe o meme selecionado
          if (_showMeme && _selectedMeme != null)
            Center(
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.black.withOpacity(0.7),
                child: Image.asset(_selectedMeme!),
              ),
            ),
        ],
      ),
    );
  }
}
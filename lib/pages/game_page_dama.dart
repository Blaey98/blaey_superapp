import 'dart:async';
import 'package:flutter/material.dart';
import 'package:blaey_app/models/game_logic.dart'; // Import GameLogic
import 'package:blaey_app/widgets/board_widget.dart'; // Import DamaBoardWidget
import 'package:blaey_app/pages/fun_page.dart';
import 'package:blaey_app/pages/chat_page.dart';
import 'package:blaey_app/widgets/impactcaptureoverlay.dart'; // Overlay de captura
import 'package:blaey_app/pages/player_won.dart'; // Import PlayerWonPage
import 'package:blaey_app/pages/player_lose.dart'; // Import PlayerLosePage

class GamePageDama extends StatefulWidget {
  final int betAmount;

  const GamePageDama({Key? key, required this.betAmount}) : super(key: key);

  @override
  _GamePageDamaState createState() => _GamePageDamaState();
}

class _GamePageDamaState extends State<GamePageDama> with SingleTickerProviderStateMixin {
  late GameLogic gameLogic;
  Timer? _playerTimer;
  Timer? _opponentTimer;
  Duration _playerTime = Duration(minutes: 5);
  Duration _opponentTime = Duration(minutes: 5);
  int _capturedPieces = 0; // Peças capturadas no turno atual
  String? _captureMessage;
  String? _captureImagePath;

  @override
  void initState() {
    super.initState();
    gameLogic = GameLogic.initial();
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
        if (gameLogic.playerTurn) {
          if (_playerTime > Duration(seconds: 0)) {
            _playerTime -= Duration(seconds: 1);
          }
        }
      });
    });
  }

  void _startOpponentTimer() {
    _opponentTimer?.cancel();
    _opponentTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (!gameLogic.playerTurn) {
          if (_opponentTime > Duration(seconds: 0)) {
            _opponentTime -= Duration(seconds: 1);
          }
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
      _capturedPieces = 0; // Reseta as peças capturadas no turno
    });
  }

  void _handleMove(int fromRow, int fromCol, int toRow, int toCol) {
    setState(() {
      int capturedPieces = gameLogic.makeMove(fromRow, fromCol, toRow, toCol);
      if (capturedPieces > 0) {
        _capturedPieces += capturedPieces;
        _showCaptureOverlay(_capturedPieces);
      }
      if (!gameLogic.getPossibleCaptureMoves(toRow, toCol).isNotEmpty) {
        _switchPlayer();
      }
      // Verifica se o jogo acabou
      if (gameLogic.isGameOver()) {
        int? winner = gameLogic.getWinner();
        if (winner != null) {
          _navigateToEndScreen(winner);
        }
      }
    });
  }

  void _showCaptureOverlay(int capturedPieces) {
    String assetPath;
    if (capturedPieces == 2) {
      assetPath = 'assets/jogos/double.png';
      _captureMessage = "Captura 2";
    } else if (capturedPieces == 3) {
      assetPath = 'assets/jogos/berasso.png';
      _captureMessage = "Captura 3";
    } else if (capturedPieces >= 4) {
      assetPath = 'assets/jogos/super.png';
      _captureMessage = "Captura 4+";
    } else {
      assetPath = 'assets/jogos/capture.png';
      _captureMessage = "Captura $_capturedPieces";
    }

    setState(() {
      _captureImagePath = assetPath;
    });

    OverlayEntry entry = OverlayEntry(
      builder: (context) => ImpactCaptureOverlay(assetPath: assetPath),
    );

    Overlay.of(context).insert(entry);

    Future.delayed(Duration(seconds: 1), () {
      entry.remove();
      setState(() {
        _captureMessage = null;
        _captureImagePath = null;
      });
    });
  }

  void _navigateToEndScreen(int winner) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => winner == 1 ? PlayerWonPage() : PlayerLosePage(),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _buildTimerDisplay(Duration duration, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: isActive ? Colors.black : Colors.white.withOpacity(0.6),
      child: Text(
        _formatDuration(duration),
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontSize: 14,
        ),
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
                  MaterialPageRoute(builder: (context) => FunPage(userBalance: 100.0)),
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
            height: MediaQuery.of(context).size.height * 0.6,
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

  Widget _buildPlayerInfo(String name, String imagePath, bool isActive) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive ? Colors.green : Colors.transparent,
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imagePath),
              ),
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: Colors.grey[850]), // Fundo cinza escuro
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Valendo:',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(width: 5),
                          Text(
                            '\$${widget.betAmount}',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Image.asset(
                            'assets/icons/moeda.png',
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _confirmExit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sair',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: DamaBoardWidget(
                        gameLogic: gameLogic,
                        onMove: _handleMove,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black, // Menu inferior preto
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.emoji_emotions, color: Colors.white, size: 30),
                        onPressed: () {}, // Implementar envio de emojis
                      ),
                      IconButton(
                        icon: Icon(Icons.chat, color: Colors.white, size: 26),
                        onPressed: _showChatDialog,
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        onPressed: () {}, // Implementar voltar jogada
                      ),
                      Image.asset(
                        'assets/icons/logoblaey.png',
                        width: 99,
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 60,
              left: 20,
              child: _buildPlayerInfo('Oponente', 'assets/icons/oponente.png', !gameLogic.playerTurn),
            ),
            Positioned(
              left: 20,
              bottom: 100,
              child: _buildPlayerInfo('Username', 'assets/icons/perfil.png', gameLogic.playerTurn),
            ),
            Positioned(
              top: 100,
              right: 20,
              child: Column(
                children: [
                  _buildTimerDisplay(_opponentTime, !gameLogic.playerTurn),
                  if (!gameLogic.playerTurn && _captureMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _captureMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              bottom: 140,
              child: Column(
                children: [
                  if (gameLogic.playerTurn && _captureMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _captureMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  _buildTimerDisplay(_playerTime, gameLogic.playerTurn),
                ],
              ),
            ),
            if (_captureImagePath != null)
              Positioned.fill(
                child: ImpactCaptureOverlay(assetPath: _captureImagePath!),
              ),
          ],
        ),
      ),
    );
  }
}
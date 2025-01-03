import 'dart:async';
import 'package:flutter/material.dart';
import 'package:blaey_app/models/game_logic.dart';
import 'package:blaey_app/widgets/board_widget.dart';
import 'package:blaey_app/pages/fun_page.dart';
import 'package:blaey_app/pages/chat_page.dart';
import 'package:blaey_app/widgets/impactcaptureoverlay.dart'; // Import the ImpactCaptureOverlay widget

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
  Timer? _memeTimer;
  Duration _playerTime = Duration(minutes: 5);
  Duration _opponentTime = Duration(minutes: 5);
  String? _selectedMeme;
  bool _showMeme = false;
  late AnimationController _animationController;
  int _capturedPieces = 0; // Track the number of captured pieces
  int _totalCapturedPieces = 0; // Track the total number of captured pieces in a turn
  String? _captureMessage;
  String? _captureImagePath;

  @override
  void initState() {
    super.initState();
    gameLogic = GameLogic.initial();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _startPlayerTimer();
  }

  @override
  void dispose() {
    _playerTimer?.cancel();
    _opponentTimer?.cancel();
    _memeTimer?.cancel();
    _animationController.dispose();
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
      // Reset total captured pieces when the turn ends
      _totalCapturedPieces = 0;
    });
  }

  void _handleMove(int startX, int startY, int endX, int endY) {
    setState(() {
      int capturedPieces = gameLogic.makeMove(startX, startY, endX, endY);
      _totalCapturedPieces += capturedPieces;
      _capturedPieces = _totalCapturedPieces; // Update captured pieces for display
      if (capturedPieces > 0) {
        _showCaptureOverlay(_totalCapturedPieces);
      }
      if (gameLogic.getPossibleCaptureMoves(endX, endY).isEmpty) {
        _switchPlayer();
      }
    });
  }

  void _showCaptureOverlay(int totalCapturedPieces) {
    String assetPath;
    if (totalCapturedPieces == 2) {
      assetPath = 'assets/jogos/double.png';
      _captureMessage = "captura 2";
    } else if (totalCapturedPieces == 3) {
      assetPath = 'assets/jogos/berasso.png';
      _captureMessage = "captura 3";
    } else if (totalCapturedPieces >= 4) {
      assetPath = 'assets/jogos/super.png';
      _captureMessage = "captura 4+";
    } else {
      assetPath = 'assets/jogos/capture.png'; // Default capture image for 1 capture
      _captureMessage = "captura $_totalCapturedPieces";
    }

    setState(() {
      _captureImagePath = assetPath;
    });

    OverlayEntry entry = OverlayEntry(
      builder: (context) => ImpactCaptureOverlay(assetPath: assetPath),
    );

    Overlay.of(context)?.insert(entry);

    Future.delayed(Duration(seconds: 1), () {
      entry.remove();
      setState(() {
        _captureMessage = null; // Clear capture message after 1 second
        _captureImagePath = null;
      });
    });
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

  void _showOpponentDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Detalhes do Oponente"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/icons/oponente.png'),
              ),
              SizedBox(height: 10),
              Text("Nome do Oponente"),
              ElevatedButton(
                onPressed: () {
                  // Lógica para adicionar como amigo
                },
                child: Text("Adicionar como Amigo"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  void _sendEmoji(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          color: Colors.grey[900],
          child: GridView.builder(
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMeme = 'assets/meme/meme${index + 1}.png';
                    _showMeme = true;
                  });
                  Navigator.pop(context); // Fechar o modal

                  // Mostrar o meme por 3 segundos
                  _memeTimer?.cancel();
                  _memeTimer = Timer(Duration(seconds: 3), () {
                    setState(() {
                      _showMeme = false;
                    });
                  });
                },
                child: Image.asset('assets/meme/meme${index + 1}.png'),
              );
            },
          ),
        );
      },
    );
  }

  void _goBack() {
    // Lógica para voltar e ver a jogada anterior
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
                  color: isActive ? Colors.green : Colors.transparent, // Green border if active, otherwise transparent
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
              style: TextStyle(color: Colors.white, fontSize: 14), // Smaller font size
            ),
          ],
        ),
        if (_showMeme && _selectedMeme != null)
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(left: 10), // Move the meme more to the right
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(_selectedMeme!, fit: BoxFit.cover),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // space-between for aligning items to ends
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
                if (_capturedPieces > 0 && !gameLogic.playerTurn)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: [
                        Text(
                          'Captura',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        Text(
                          '$_capturedPieces',
                          style: TextStyle(fontSize: 32, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: BoardWidget(
                        gameLogic: gameLogic,
                        onMove: _handleMove,
                      ),
                    ),
                  ),
                ),
                if (_capturedPieces > 0 && gameLogic.playerTurn)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Text(
                          'Captura',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        Text(
                          '$_capturedPieces',
                          style: TextStyle(fontSize: 32, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                Container(
                  color: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.emoji_emotions, color: Colors.white, size: 30),
                        onPressed: () => _sendEmoji(context),
                      ),
                      IconButton(
                        icon: Icon(Icons.chat, color: Colors.white, size: 26),
                        onPressed: _showChatDialog, // Abre o chat flutuante
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        onPressed: _goBack,
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
            // Oponente posicionado mais para baixo na parte superior esquerda
            Positioned(
              top: 60,
              left: 20,
              child: _buildPlayerInfo('Oponente', 'assets/icons/oponente.png', !gameLogic.playerTurn),
            ),
            // Username e temporizador do jogador posicionados logo acima da barra de menu inferior
            Positioned(
              left: 20,
              bottom: 100,
              child: _buildPlayerInfo('Username', 'assets/icons/perfil.png', gameLogic.playerTurn),
            ),
            // Temporizadores na parte direita da tela
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
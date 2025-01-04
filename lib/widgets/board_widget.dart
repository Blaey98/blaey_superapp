// lib/widgets/dama_board_widget.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/game_logic.dart' as game_logic;
import '../models/position.dart' as pos;
import '../pages/player_lose.dart';
import '../pages/player_won.dart';

class DamaBoardWidget extends StatefulWidget {
  final game_logic.GameLogic gameLogic;
  final void Function(int, int, int, int) onMove;

  const DamaBoardWidget({
    Key? key,
    required this.gameLogic,
    required this.onMove,
  }) : super(key: key);

  @override
  _DamaBoardWidgetState createState() => _DamaBoardWidgetState();
}

class _DamaBoardWidgetState extends State<DamaBoardWidget> with SingleTickerProviderStateMixin {
  pos.Position? selectedPiece;
  List<List<int>> validMoves = [];
  List<List<int>> captureMoves = [];
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioCache _audioCache = AudioCache(prefix: 'assets/som/');

  int _capturedPieces = 0;
  int _totalCapturedPieces = 0;
  Timer? _captureTimer;
  String? _captureImagePath;
  pos.Position? _kingPosition;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
    _audioCache.loadAll(['move_sound.mp3', 'moeda.mp3', 'captura.mp3']);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _captureTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _selectPiece(int x, int y) {
    int piece = widget.gameLogic.board[y][x];
    // Verifica se a peça pertence ao jogador atual
    if ((widget.gameLogic.playerTurn && (piece == 1 || piece == 3)) ||
        (!widget.gameLogic.playerTurn && (piece == 2 || piece == 4))) {
      setState(() {
        selectedPiece = pos.Position(x, y);
        captureMoves = widget.gameLogic.getPossibleCaptureMoves(x, y);
        validMoves = captureMoves.isNotEmpty ? captureMoves : widget.gameLogic.getPossibleMoves(x, y);
      });
    }
  }

  Future<void> _movePiece(pos.Position newPosition) async {
    if (selectedPiece == null) return;

    int startX = selectedPiece!.x;
    int startY = selectedPiece!.y;

    int capturedPieces = widget.gameLogic.makeMove(
      startX,
      startY,
      newPosition.x,
      newPosition.y,
    );

    await _audioCache.play('move_sound.mp3');

    setState(() async {
      selectedPiece = null;
      validMoves = [];

      if (capturedPieces > 0) {
        _totalCapturedPieces += capturedPieces;
        await _audioCache.play('captura.mp3');
        _showCaptureAnimation(_totalCapturedPieces);
      }

      // Verifica se a peça foi promovida a rei
      if ((widget.gameLogic.board[newPosition.y][newPosition.x] == 3 || widget.gameLogic.board[newPosition.y][newPosition.x] == 4) &&
          (newPosition.y == 0 || newPosition.y == 7)) {
        _showKingAnimation(newPosition);
      }

      // Verifica se há mais capturas disponíveis após a jogada
      if (widget.gameLogic.getPossibleCaptureMoves(newPosition.x, newPosition.y).isNotEmpty) {
        selectedPiece = pos.Position(newPosition.x, newPosition.y);
        captureMoves = widget.gameLogic.getPossibleCaptureMoves(newPosition.x, newPosition.y);
        validMoves = captureMoves;
      } else {
        _totalCapturedPieces = 0;
      }

      if (widget.gameLogic.isGameOver()) {
        int? winner = widget.gameLogic.getWinner();
        if (winner != null) {
          _navigateToEndScreen(winner);
        }
      } else if (!widget.gameLogic.playerTurn) {
        // Se for a vez do bot, faz o movimento do bot
        _makeBotMove();
      }
    });

    widget.onMove(startX, startY, newPosition.x, newPosition.y);
  }

  void _showCaptureAnimation(int totalCapturedPieces) {
    setState(() {
      if (totalCapturedPieces == 2) {
        _captureImagePath = 'assets/jogos/double.png';
      } else if (totalCapturedPieces == 3) {
        _captureImagePath = 'assets/jogos/berasso.png';
      } else if (totalCapturedPieces >= 4) {
        _captureImagePath = 'assets/jogos/super.png';
      } else {
        _captureImagePath = null;
      }
    });

    _animationController.forward(from: 0.0);

    _captureTimer?.cancel();
    _captureTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        _captureImagePath = null;
      });
    });
  }

  void _showKingAnimation(pos.Position position) {
    setState(() {
      _kingPosition = position;
    });

    _animationController.forward(from: 0.0).then((_) {
      setState(() {
        _kingPosition = null;
      });
    });
  }

  Future<void> _makeBotMove() async {
    int delay = Random().nextInt(1000) + 1000; // Aleatório entre 1000ms (1s) e 2000ms (2s)
    await Future.delayed(Duration(milliseconds: delay));

    widget.gameLogic.makeBotMove();
    setState(() {});

    if (widget.gameLogic.isGameOver()) {
      int? winner = widget.gameLogic.getWinner();
      if (winner != null) {
        _navigateToEndScreen(winner);
      }
    }
  }

  void _navigateToEndScreen(int winner) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => winner == 1 ? PlayerWonPage() : PlayerLosePage(),
      ),
    );
  }

  Widget _buildPiece(int piece, bool isKingAnimating) {
    Widget pieceWidget;
    if (piece == 1) {
      pieceWidget = Image.asset('assets/jogos/dama_vermelho.png', fit: BoxFit.cover);
    } else if (piece == 2) {
      pieceWidget = Image.asset('assets/jogos/dama_azul.png', fit: BoxFit.cover);
    } else if (piece == 3) {
      pieceWidget = Image.asset('assets/jogos/rei_vermelho.png', fit: BoxFit.cover);
    } else if (piece == 4) {
      pieceWidget = Image.asset('assets/jogos/rei_azul.png', fit: BoxFit.cover);
    } else {
      pieceWidget = Container();
    }

    if (isKingAnimating) {
      return AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: pieceWidget,
          );
        },
        child: pieceWidget,
      );
    } else {
      return pieceWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<pos.Position> capturingPieces = widget.gameLogic.getAllCapturingPieces();
    List<pos.Position> currentPlayerCapturingPieces = capturingPieces.where((pos) {
      int piece = widget.gameLogic.board[pos.y][pos.x];
      return (widget.gameLogic.playerTurn && (piece == 1 || piece == 3)) ||
          (!widget.gameLogic.playerTurn && (piece == 2 || piece == 4));
    }).toList();
    bool hasCaptureMoves = currentPlayerCapturingPieces.isNotEmpty;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 4.0),  // Adiciona padding na borda inferior
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.green[700],  // Define a cor verde escuro da borda
          ),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
              itemCount: 64,
              itemBuilder: (context, index) {
                int x = index % 8;
                int y = index ~/ 8;
                bool isSelected = selectedPiece != null && selectedPiece!.x == x && selectedPiece!.y == y;
                bool isValidMove = validMoves.any((move) => move[0] == x && move[1] == y);
                bool isCaptureMove = captureMoves.any((move) => move[0] == x && move[1] == y);
                bool isCapturePiece = currentPlayerCapturingPieces.any((pos) => pos.x == x && pos.y == y);
                bool isKingAnimating = _kingPosition != null && _kingPosition!.x == x && _kingPosition!.y == y;

                return GestureDetector(
                  onTap: () {
                    int piece = widget.gameLogic.board[y][x];
                    if (hasCaptureMoves && ((widget.gameLogic.playerTurn && (piece == 1 || piece == 3)) ||
                        (!widget.gameLogic.playerTurn && (piece == 2 || piece == 4)))) {
                      if (isCaptureMove) {
                        _movePiece(pos.Position(x, y));
                      } else if (isCapturePiece) {
                        _selectPiece(x, y);
                      }
                    } else {
                      if (widget.gameLogic.getAllMovablePieces().any((pos) => pos.x == x && pos.y == y)) {
                        _selectPiece(x, y);
                      } else if (isValidMove) {
                        _movePiece(pos.Position(x, y));
                      }
                    }
                  },
                  child: RepaintBoundary(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCaptureMove
                            ? Colors.redAccent.withOpacity(0.7)
                            : isSelected || isValidMove
                            ? Colors.lightGreenAccent.withOpacity(0.5)
                            : isCapturePiece
                            ? Colors.orangeAccent.withOpacity(0.7)
                            : (x + y) % 2 == 0
                            ? Colors.yellow
                            : Colors.green[700],
                        border: isSelected ? Border.all(color: Colors.blue, width: 3) : null,
                      ),
                      child: Center(
                        child: _buildPiece(widget.gameLogic.board[y][x], isKingAnimating),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Exibe a mensagem de captura no canto superior direito
        if (_capturedPieces > 0)
          Positioned(
            top: 20,
            right: 20,
            child: Text(
              _capturedPieces == -1 ? 'Rei!' : 'Captura: $_capturedPieces',
              style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        if (_captureImagePath != null)
          Positioned.fill(
            child: Center(
              child: SizedBox(
                width: 400,
                height: 400,
                child: Image.asset(_captureImagePath!, fit: BoxFit.contain),
              ),
            ),
          ),
      ],
    );
  }
}
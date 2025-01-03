import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../models/game_logic.dart' as game_logic;
import '../models/position.dart' as pos;

class BoardWidget extends StatefulWidget {
  final game_logic.GameLogic gameLogic;
  final void Function(int, int, int, int) onMove;

  const BoardWidget({
    Key? key,
    required this.gameLogic,
    required this.onMove,
  }) : super(key: key);

  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> with SingleTickerProviderStateMixin {
  pos.Position? selectedPiece;
  pos.Position? highlightedCapture;
  List<List<int>> validMoves = [];
  List<List<int>> captureMoves = [];
  List<pos.Position> capturePath = [];
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioCache _audioCache = AudioCache(prefix: 'assets/som/');

  int _capturedPieces = 0;
  int _totalCapturedPieces = 0;
  Timer? _captureTimer;
  String? _captureImagePath;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _opacityAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.repeat(reverse: true);
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
    if ((widget.gameLogic.playerTurn && (piece == 1 || piece == 3)) ||
        (!widget.gameLogic.playerTurn && (piece == 2 || piece == 4))) {
      setState(() {
        selectedPiece = pos.Position(x, y);
        captureMoves = widget.gameLogic.getPossibleCaptureMoves(x, y);
        validMoves = captureMoves.isNotEmpty ? captureMoves : widget.gameLogic.getPossibleMoves(x, y);
        capturePath = captureMoves.map((move) => pos.Position(move[0], move[1])).toList();
        highlightedCapture = null; // Reset highlighted capture
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
      capturePath = [];
      highlightedCapture = null;

      if (capturedPieces > 0) {
        _totalCapturedPieces += capturedPieces;
        await _audioCache.play('captura.mp3');
        _showCaptureAnimation(_totalCapturedPieces);
      }

      if (widget.gameLogic.getPossibleCaptureMoves(newPosition.x, newPosition.y).isNotEmpty) {
        selectedPiece = pos.Position(newPosition.x, newPosition.y);
        captureMoves = widget.gameLogic.getPossibleCaptureMoves(newPosition.x, newPosition.y);
        capturePath = captureMoves.map((move) => pos.Position(move[0], move[1])).toList();

        // Highlight the capture only if the player has captured 1 or more pieces in the same turn
        if (_totalCapturedPieces >= 1) {
          highlightedCapture = captureMoves.isNotEmpty
              ? pos.Position(captureMoves[0][0], captureMoves[0][1])
              : null;
        }
      } else {
        _totalCapturedPieces = 0;
      }
    });

    widget.onMove(startX, startY, newPosition.x, newPosition.y);
  }

  void _showCaptureAnimation(int totalCapturedPieces) {
    setState(() {
      _capturedPieces = totalCapturedPieces;

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
        _capturedPieces = 0;
        _captureImagePath = null;
      });
    });
  }

  Widget _buildPiece(int piece) {
    if (piece == 1) {
      return SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset('assets/jogos/dama_vermelho.png', fit: BoxFit.cover),
        ),
      );
    } else if (piece == 2) {
      return SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset('assets/jogos/dama_azul.png', fit: BoxFit.cover),
        ),
      );
    } else if (piece == 3) {
      return _buildKingPiece('assets/jogos/rei_vermelho.png');
    } else if (piece == 4) {
      return _buildKingPiece('assets/jogos/rei_azul.png');
    } else {
      return Container();
    }
  }

  Widget _buildKingPiece(String assetPath) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.asset(assetPath, fit: BoxFit.cover),
      ),
    );
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
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
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
                bool isHighlightedCapture = highlightedCapture != null && highlightedCapture!.x == x && highlightedCapture!.y == y;
                bool isCapturePiece = currentPlayerCapturingPieces.any((pos) => pos.x == x && pos.y == y);
                bool isCapturePath = capturePath.any((pos) => pos.x == x && pos.y == y);

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
                        color: isHighlightedCapture
                            ? Colors.red.withOpacity(0.7)
                            : isCaptureMove
                            ? Colors.redAccent.withOpacity(0.7)
                            : isSelected || isValidMove
                            ? Colors.lightGreenAccent.withOpacity(0.5)
                            : isCapturePiece || isCapturePath
                            ? Colors.orangeAccent.withOpacity(0.7)
                            : (x + y) % 2 == 0
                            ? Colors.yellow
                            : Colors.green[700],
                        border: isSelected ? Border.all(color: Colors.blue, width: 3) : null,
                      ),
                      child: Center(
                        child: _buildPiece(widget.gameLogic.board[y][x]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (_captureImagePath != null)
          Positioned.fill(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Center(
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: Image.asset(_captureImagePath!, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
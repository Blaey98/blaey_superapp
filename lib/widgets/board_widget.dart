import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../models/game_logic.dart';
import '../models/position.dart';

class BoardWidget extends StatefulWidget {
  final GameLogic gameLogic;
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
  Position? selectedPiece;
  List<List<int>> validMoves = [];
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Adiciona o AudioPlayer
  final AudioCache _audioCache = AudioCache(prefix: 'assets/som/'); // Adiciona o AudioCache

  // Variáveis para a exibição de capturas e promoções
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

    // Pré-carregar sons
    _audioCache.loadAll(['move_sound.mp3', 'moeda.mp3', 'captura.mp3']);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _captureTimer?.cancel();
    _audioPlayer.dispose(); // Dispose o AudioPlayer
    super.dispose();
  }

  void _selectPiece(int x, int y) {
    int piece = widget.gameLogic.board[y][x];
    print('Peça selecionada em ($x, $y): $piece');

    // Verifica se a peça selecionada pertence ao jogador atual
    if ((widget.gameLogic.playerTurn && (piece == 1 || piece == 3)) ||
        (!widget.gameLogic.playerTurn && (piece == 2 || piece == 4))) {
      setState(() {
        selectedPiece = Position(x, y);
        validMoves = widget.gameLogic.getPossibleMoves(x, y);
        print('Movimentos válidos para ($x, $y): $validMoves');
      });
    }
  }

  Future<void> _movePiece(Position newPosition) async {
    if (selectedPiece == null) return;

    int startX = selectedPiece!.x;
    int startY = selectedPiece!.y;

    print('Movendo peça de ($startX, $startY) para (${newPosition.x}, ${newPosition.y})');

    // Executa o movimento e captura peças, se houver
    int capturedPieces = widget.gameLogic.makeMove(
      startX,
      startY,
      newPosition.x,
      newPosition.y,
    );

    // Toca o som de mover peça
    try {
      await _audioCache.play('move_sound.mp3');
    } catch (e) {
      print('Error playing sound: $e');
    }

    setState(() async {
      selectedPiece = null;
      validMoves = [];
      print('Tabuleiro após o movimento: ${widget.gameLogic.board}');

      if (capturedPieces > 0) {
        _totalCapturedPieces += capturedPieces;
        // Toca o som de captura de peça
        try {
          await _audioCache.play('captura.mp3');
        } catch (e) {
          print('Error playing capture sound: $e');
        }
        _showCaptureAnimation(_totalCapturedPieces);
      }

      // Reseta o total de peças capturadas se não houver mais capturas possíveis
      if (widget.gameLogic.getPossibleCaptureMoves(newPosition.x, newPosition.y).isEmpty) {
        _totalCapturedPieces = 0;
      }
    });

    widget.onMove(startX, startY, newPosition.x, newPosition.y);
  }

  void _showCaptureAnimation(int totalCapturedPieces) {
    setState(() {
      _capturedPieces = totalCapturedPieces;

      // Define a imagem de captura com base no número de peças capturadas
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

  Future<void> _addReward(double reward) async {
    setState(() {
      // Adiciona a recompensa ao saldo do usuário
    });

    // Toca o som de recompensa
    try {
      await _audioCache.play('moeda.mp3');
    } catch (e) {
      print('Error playing reward sound: $e');
    }
  }

  Widget _buildPiece(int piece) {
    // Retorna o widget da peça com base no valor da peça
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
    // Retorna o widget para a peça rei
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.asset(assetPath, fit: BoxFit.cover),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

                return GestureDetector(
                  onTap: () {
                    if (isValidMove) {
                      _movePiece(Position(x, y));
                    } else {
                      _selectPiece(x, y);
                    }
                  },
                  child: RepaintBoundary(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected || isValidMove
                            ? Colors.lightGreenAccent.withOpacity(0.5)
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
        if (_capturedPieces > 0)
          Positioned(
            right: 20,
            top: 20,
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
        if (_captureImagePath != null)
          Positioned.fill(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(_captureImagePath!, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
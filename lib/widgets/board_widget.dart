import 'package:flutter/material.dart';
import '../models/game_logic.dart';

class BoardWidget extends StatefulWidget {
  final GameLogic gameLogic;
  final bool myTurn; // true se for o turno do usuário, false se for o turno do oponente
  final Function onMove;

  const BoardWidget({
    Key? key,
    required this.gameLogic,
    required this.myTurn,
    required this.onMove,
  }) : super(key: key);

  @override
  _BoardWidgetState createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  Position? selectedPiece;
  List<List<int>> validMoves = [];

  // Método para selecionar uma peça e obter seus movimentos válidos
  void _selectPiece(int x, int y) {
    int piece = widget.gameLogic.board[y][x];

    // Verificar se é o turno do jogador e se a peça pertence ao jogador
    if ((widget.myTurn && (piece == 1 || piece == 3)) || (!widget.myTurn && (piece == 2 || piece == 4))) {
      setState(() {
        selectedPiece = Position(x, y);
        validMoves = widget.gameLogic.getPossibleMoves(x, y);
      });
    }
  }

  // Método para mover a peça selecionada para uma nova posição
  void _movePiece(Position newPosition) {
    setState(() {
      widget.gameLogic.makeMove(
        selectedPiece!.x,
        selectedPiece!.y,
        newPosition.x,
        newPosition.y,
      );
      selectedPiece = null;
      validMoves = [];
    });
    widget.onMove(); // Notificar o widget pai que um movimento foi feito
  }

  // Método para construir a peça no tabuleiro
  Widget _buildPiece(int piece) {
    if (piece == 1) {
      return Image.asset('assets/jogos/dama_vermelho.png', fit: BoxFit.contain);
    } else if (piece == 2) {
      return Image.asset('assets/jogos/dama_azul.png', fit: BoxFit.contain);
    } else if (piece == 3) {
      return Icon(Icons.star, color: Colors.blue, size: 24); // Rei do jogador 1
    } else if (piece == 4) {
      return Icon(Icons.star, color: Colors.red, size: 24); // Rei do jogador 2
    } else {
      return Container(); // Casa vazia
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemCount: 64,
        itemBuilder: (context, index) {
          int x = index % 8;
          int y = index ~/ 8;
          bool isSelected = selectedPiece != null && selectedPiece!.x == x && selectedPiece!.y == y;
          bool isValidMove = validMoves.any((move) => move[0] == x && move[1] == y);

          return GestureDetector(
            onTap: widget.myTurn
                ? () {
              if (isValidMove) {
                _movePiece(Position(x, y));
              } else {
                _selectPiece(x, y);
              }
            }
                : null, // Desabilitar interação se não for o turno do jogador
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
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 8 * 0.95,
                        height: MediaQuery.of(context).size.width / 8 * 0.95,
                        child: _buildPiece(widget.gameLogic.board[y][x]), // Exibir a peça
                      ),
                    ),
                    if (isValidMove)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.5),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/chess_logic.dart';
import 'chess_logic.dart'; // Certifique-se de que o caminho está correto

class ChessBoardWidget extends StatefulWidget {
  final ChessLogic chessLogic;
  final Function(int fromRow, int fromCol, int toRow, int toCol) onMove;

  const ChessBoardWidget({
    Key? key,
    required this.chessLogic,
    required this.onMove,
  }) : super(key: key);

  @override
  _ChessBoardWidgetState createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  int? selectedRow;
  int? selectedCol;
  List<List<bool>> possibleMoves = List.generate(8, (_) => List.generate(8, (_) => false));

  // Mapeamento das peças para suas respectivas imagens
  final Map<String, String> pieceImages = {
    'P': 'assets/jogos/chess/peaobranco.png',
    'R': 'assets/jogos/chess/torrebranco.png',
    'N': 'assets/jogos/chess/cavalobranco.png',
    'B': 'assets/jogos/chess/bispobranco.png',
    'Q': 'assets/jogos/chess/damabranco.png',
    'K': 'assets/jogos/chess/reibranco.png',
    'p': 'assets/jogos/chess/peaopreto.png',
    'r': 'assets/jogos/chess/torrepreto.png',
    'n': 'assets/jogos/chess/cavalopreto.png',
    'b': 'assets/jogos/chess/bispopreto.png',
    'q': 'assets/jogos/chess/damapreto.png',
    'k': 'assets/jogos/chess/reipreto.png',
  };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double boardSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        double cellSize = boardSize / 8;

        return Center(
          child: Container(
            width: boardSize,
            height: boardSize,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/jogos/chess/tabuleirochess.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemCount: 64,
              itemBuilder: (context, index) {
                int row = index ~/ 8;
                int col = index % 8;

                return GestureDetector(
                  onTap: () => _handleTap(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getCellColor(row, col),
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: Stack(
                      children: [
                        _buildPiece(row, col, cellSize),
                        if (possibleMoves[row][col])
                          Center(
                            child: Container(
                              width: cellSize / 2,
                              height: cellSize / 2,
                              decoration: BoxDecoration(
                                color: Colors.yellow.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handleTap(int row, int col) {
    setState(() {
      if (selectedRow == null || selectedCol == null) {
        // Seleciona a peça
        selectedRow = row;
        selectedCol = col;
        possibleMoves = _getPossibleMoves(row, col);
      } else {
        // Move a peça
        widget.onMove(selectedRow!, selectedCol!, row, col);
        selectedRow = null;
        selectedCol = null;
        possibleMoves = List.generate(8, (_) => List.generate(8, (_) => false));
      }
    });
  }

  List<List<bool>> _getPossibleMoves(int row, int col) {
    List<List<bool>> moves = List.generate(8, (_) => List.generate(8, (_) => false));
    for (int toRow = 0; toRow < 8; toRow++) {
      for (int toCol = 0; toCol < 8; toCol++) {
        if (widget.chessLogic.isValidMove(row, col, toRow, toCol)) {
          moves[toRow][toCol] = true;
        }
      }
    }
    return moves;
  }

  Color _getCellColor(int row, int col) {
    if (selectedRow == row && selectedCol == col) {
      return Colors.yellow.withOpacity(0.7); // Célula selecionada em amarelo
    }
    return Colors.transparent; // Células padrão transparentes
  }

  Widget _buildPiece(int row, int col, double cellSize) {
    String piece = widget.chessLogic.getPiece(row, col);
    if (piece.isEmpty) {
      return Container();
    }

    // Obtendo o caminho da imagem da peça
    String? imagePath = pieceImages[piece];
    if (imagePath == null) {
      return Container();
    }

    return Center(
      child: Image.asset(
        imagePath,
        width: cellSize,
        height: cellSize,
      ),
    );
  }
}
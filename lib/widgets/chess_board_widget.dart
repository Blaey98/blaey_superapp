import 'package:flutter/material.dart';
import '../models/chess_logic.dart';

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
            color: Colors.white,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemCount: 64,
              itemBuilder: (context, index) {
                int row = index ~/ 8;
                int col = index % 8;
                bool isWhite = (row + col) % 2 == 0;

                return GestureDetector(
                  onTap: () => _handleTap(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getCellColor(row, col, isWhite),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: _buildPiece(row, col, cellSize),
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
        selectedRow = row;
        selectedCol = col;
      } else {
        widget.onMove(selectedRow!, selectedCol!, row, col);
        selectedRow = null;
        selectedCol = null;
      }
    });
  }

  Color _getCellColor(int row, int col, bool isWhite) {
    if (selectedRow == row && selectedCol == col) {
      return Colors.yellow;
    }
    return isWhite ? Colors.white : Colors.black;
  }

  Widget _buildPiece(int row, int col, double cellSize) {
    String piece = widget.chessLogic.getPiece(row, col);
    if (piece.isEmpty) {
      return Container();
    }

    return Center(
      child: Image.asset(
        'assets/images/$piece.png',
        width: cellSize,
        height: cellSize,
      ),
    );
  }
}
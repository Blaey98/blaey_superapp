import 'package:flutter/material.dart';
import '../models/game_logic.dart';
import '../widgets/board_widget.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameLogic gameLogic = GameLogic(
    board: [
      [0, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 0, 1, 0],
      [0, 1, 0, 1, 0, 1, 0, 1],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0],
      [2, 0, 2, 0, 2, 0, 2, 0],
      [0, 2, 0, 2, 0, 2, 0, 2],
      [2, 0, 2, 0, 2, 0, 2, 0],
    ],
    playerTurn: true,
  );

  void _onMove() {
    setState(() {
      gameLogic.playerTurn = !gameLogic.playerTurn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo de Damas'),
      ),
      body: Center(
        child: BoardWidget(
          gameLogic: gameLogic,
          myTurn: gameLogic.playerTurn,
          onMove: _onMove,
        ),
      ),
    );
  }
}
class GameLogic {
  List<List<int>> board;
  bool playerTurn; // true para jogador 1 (vermelho), false para jogador 2 (azul)

  GameLogic({
    required this.board,
    required this.playerTurn,
  });

  bool isWithinBoard(int x, int y) {
    return x >= 0 && x < 8 && y >= 0 && y < 8;
  }

  List<List<int>> getPossibleMoves(int x, int y) {
    List<List<int>> moves = [];
    int player = board[y][x];

    // Verificar se a peça pertence ao jogador atual
    if (player == 0 || (player == 1 && !playerTurn) || (player == 2 && playerTurn)) return moves;

    int direction = (player == 1 || player == 3) ? 1 : -1;
    bool isKing = player == 3 || player == 4;

    // Movimentos normais
    if (isWithinBoard(x + 1, y + direction) && board[y + direction][x + 1] == 0) moves.add([x + 1, y + direction]);
    if (isWithinBoard(x - 1, y + direction) && board[y + direction][x - 1] == 0) moves.add([x - 1, y + direction]);

    // Movimentos de captura
    if (isWithinBoard(x + 2, y + 2 * direction) && board[y + 2 * direction][x + 2] == 0 && board[y + direction][x + 1] != 0 && board[y + direction][x + 1] != player && board[y + direction][x + 1] != player + 2)
      moves.add([x + 2, y + 2 * direction]);
    if (isWithinBoard(x - 2, y + 2 * direction) && board[y + 2 * direction][x - 2] == 0 && board[y + direction][x - 1] != 0 && board[y + direction][x - 1] != player && board[y + direction][x - 1] != player + 2)
      moves.add([x - 2, y + 2 * direction]);

    // Movimentos diagonais adicionais para Reis
    if (isKing) {
      if (isWithinBoard(x + 1, y - direction) && board[y - direction][x + 1] == 0) moves.add([x + 1, y - direction]);
      if (isWithinBoard(x - 1, y - direction) && board[y - direction][x - 1] == 0) moves.add([x - 1, y - direction]);
      if (isWithinBoard(x + 2, y - 2 * direction) && board[y - 2 * direction][x + 2] == 0 && board[y - direction][x + 1] != 0 && board[y - direction][x + 1] != player && board[y - direction][x + 1] != player + 2)
        moves.add([x + 2, y - 2 * direction]);
      if (isWithinBoard(x - 2, y - 2 * direction) && board[y - 2 * direction][x - 2] == 0 && board[y - direction][x - 1] != 0 && board[y - direction][x - 1] != player && board[y - direction][x - 1] != player + 2)
        moves.add([x - 2, y - 2 * direction]);
    }

    return moves;
  }

  void makeMove(int startX, int startY, int endX, int endY) {
    int dx = endX - startX;
    int dy = endY - startY;
    int player = board[startY][startX];

    board[endY][endX] = board[startY][startX];
    board[startY][startX] = 0;

    if (dx.abs() == 2 && dy.abs() == 2) {
      int midX = startX + dx ~/ 2;
      int midY = startY + dy ~/ 2;
      board[midY][midX] = 0;
    }

    if ((player == 1 && endY == 7) || (player == 2 && endY == 0)) {
      board[endY][endX] = player + 2; // Promover para rei
    }

    playerTurn = !playerTurn; // Alternar o turno após um movimento
  }
}

class Position {
  final int x;
  final int y;

  Position(this.x, this.y);
}


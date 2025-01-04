import 'dart:async';
import 'dart:math';
import 'position.dart';

class GameLogic {
  List<List<int>> board;
  bool playerTurn;
  Function(bool)? onGameEnd;

  GameLogic({required this.board, required this.playerTurn, this.onGameEnd});

  factory GameLogic.initial() {
    List<List<int>> initialBoard = List.generate(
      8,
          (i) => List.generate(
        8,
            (j) {
          if (i < 3 && (i + j) % 2 == 1) return 2; // Blue pieces
          if (i > 4 && (i + j) % 2 == 1) return 1; // Red pieces
          return 0;
        },
      ),
    );
    return GameLogic(board: initialBoard, playerTurn: true);
  }

  bool isWithinBoard(int x, int y) {
    return x >= 0 && x < 8 && y >= 0 && y < 8;
  }

  List<Position> getAllMovablePieces() {
    List<Position> movablePieces = [];
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        if (board[y][x] != 0 && getPossibleMoves(x, y).isNotEmpty) {
          movablePieces.add(Position(x, y));
        }
      }
    }
    return movablePieces;
  }

  List<Position> getAllCapturingPieces() {
    List<Position> capturingPieces = [];
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        if (board[y][x] != 0 && getPossibleCaptureMoves(x, y).isNotEmpty) {
          capturingPieces.add(Position(x, y));
        }
      }
    }
    return capturingPieces;
  }

  List<List<int>> getPossibleMoves(int x, int y) {
    List<List<int>> moves = [];
    int piece = board[y][x];

    if ((piece == 1 && !playerTurn) || (piece == 2 && playerTurn)) {
      return moves;
    }

    int direction = (piece == 1 || piece == 3) ? -1 : 1;
    bool isKing = piece == 3 || piece == 4;

    if (isWithinBoard(x + 1, y + direction)) {
      addMoveIfValid(moves, x + 1, y + direction);
    }
    if (isWithinBoard(x - 1, y + direction)) {
      addMoveIfValid(moves, x - 1, y + direction);
    }

    if (isKing) {
      if (isWithinBoard(x + 1, y - direction)) {
        addMoveIfValid(moves, x + 1, y - direction);
      }
      if (isWithinBoard(x - 1, y - direction)) {
        addMoveIfValid(moves, x - 1, y - direction);
      }
    }

    return moves;
  }

  void addMoveIfValid(List<List<int>> moves, int x, int y) {
    if (isWithinBoard(x, y) && board[y][x] == 0) {
      moves.add([x, y]);
    }
  }

  void addCaptureMoveIfValid(List<List<int>> moves, int startX, int startY, int endX, int endY) {
    int midX = (startX + endX) ~/ 2;
    int midY = (startY + endY) ~/ 2;
    int piece = board[startY][startX];
    int opponent = board[midY][midX];

    if (isWithinBoard(endX, endY) && board[endY][endX] == 0 && opponent != 0 && opponent % 2 != piece % 2) {
      moves.add([endX, endY]);
    }
  }

  int makeMove(int startX, int startY, int endX, int endY) {
    int piece = board[startY][startX];
    int capturedPieces = 0;

    // Check if it's a capture move
    if ((endX - startX).abs() == 2 && (endY - startY).abs() == 2) {
      int midX = (startX + endX) ~/ 2;
      int midY = (startY + endY) ~/ 2;
      int opponent = board[midY][midX];

      if (opponent != 0 && opponent % 2 != piece % 2) {
        // Perform capture
        board[midY][midX] = 0;
        capturedPieces++;
      }
    }

    // Move the piece to the new position
    board[endY][endX] = piece;
    board[startY][startX] = 0;

    // Promote the piece to king if it reaches the last row
    if ((piece == 1 && endY == 0) || (piece == 2 && endY == 7)) {
      board[endY][endX] = piece + 2; // Promote to king
    }

    // Check if there are more captures available after the move
    if (capturedPieces > 0 && getPossibleCaptureMoves(endX, endY).isNotEmpty) {
      return capturedPieces; // Keep the current player's turn
    }

    playerTurn = !playerTurn; // Switch to the next player

    // Check if the game is over
    if (isGameOver()) {
      int? winner = getWinner();
      if (winner != null && onGameEnd != null) {
        onGameEnd!(winner == 1); // 1: Player wins, 2: Bot wins
      }
    } else if (!playerTurn) {
      // If it's the bot's turn, make the bot move
      makeBotMove();
    }

    return capturedPieces;
  }

  List<List<int>> getPossibleCaptureMoves(int x, int y) {
    List<List<int>> captureMoves = [];
    int piece = board[y][x];
    int direction = (piece == 1 || piece == 3) ? -1 : 1;
    bool isKing = piece == 3 || piece == 4;

    if (isWithinBoard(x + 2, y + 2 * direction)) {
      addCaptureMoveIfValid(captureMoves, x, y, x + 2, y + 2 * direction);
    }
    if (isWithinBoard(x - 2, y + 2 * direction)) {
      addCaptureMoveIfValid(captureMoves, x, y, x - 2, y + 2 * direction);
    }

    if (isKing) {
      if (isWithinBoard(x + 2, y - 2 * direction)) {
        addCaptureMoveIfValid(captureMoves, x, y, x + 2, y - 2 * direction);
      }
      if (isWithinBoard(x - 2, y - 2 * direction)) {
        addCaptureMoveIfValid(captureMoves, x, y, x - 2, y - 2 * direction);
      }
    }

    return captureMoves;
  }

  bool isGameOver() {
    bool redHasPieces = board.any((row) => row.contains(1) || row.contains(3));
    bool blueHasPieces = board.any((row) => row.contains(2) || row.contains(4));

    if (!redHasPieces || !blueHasPieces) {
      return true; // Game over if a player has no pieces
    }

    // Check if a player has no possible moves
    bool redCanMove = board.asMap().entries.any((row) =>
        row.value.asMap().entries.any((cell) =>
        (cell.value == 1 || cell.value == 3) &&
            (getPossibleMoves(cell.key, row.key).isNotEmpty ||
                getPossibleCaptureMoves(cell.key, row.key).isNotEmpty)));

    bool blueCanMove = board.asMap().entries.any((row) =>
        row.value.asMap().entries.any((cell) =>
        (cell.value == 2 || cell.value == 4) &&
            (getPossibleMoves(cell.key, row.key).isNotEmpty ||
                getPossibleCaptureMoves(cell.key, row.key).isNotEmpty)));

    return !redCanMove || !blueCanMove; // Game over if a player cannot move
  }

  int? getWinner() {
    bool redHasPieces = board.any((row) => row.contains(1) || row.contains(3));
    bool blueHasPieces = board.any((row) => row.contains(2) || row.contains(4));

    if (!redHasPieces) return 2; // Blue wins
    if (!blueHasPieces) return 1; // Red wins

    // Check if a player cannot move
    bool redCanMove = board.asMap().entries.any((row) =>
        row.value.asMap().entries.any((cell) =>
        (cell.value == 1 || cell.value == 3) &&
            (getPossibleMoves(cell.key, row.key).isNotEmpty ||
                getPossibleCaptureMoves(cell.key, row.key).isNotEmpty)));


    bool blueCanMove = board.asMap().entries.any((row) =>
        row.value.asMap().entries.any((cell) =>
        (cell.value == 2 || cell.value == 4) &&
            (getPossibleMoves(cell.key, row.key).isNotEmpty ||
                getPossibleCaptureMoves(cell.key, row.key).isNotEmpty)));

    if (!redCanMove) return 2; // Blue wins
    if (!blueCanMove) return 1; // Red wins

    return null; // Game not over
  }

  void makeBotMove() {
    int delay = Random().nextInt(1000) + 1000; // Random between 1000ms (1s) and 2000ms (2s)
    Future.delayed(Duration(milliseconds: delay), () {
      List<Position> capturingPieces = getAllCapturingPieces();
      if (capturingPieces.isNotEmpty) {
        Position piece = capturingPieces.first;
        List<List<int>> captureMoves = getPossibleCaptureMoves(piece.x, piece.y);
        if (captureMoves.isNotEmpty) {
          List<int> move = captureMoves.first;
          makeMove(piece.x, piece.y, move[0], move[1]);
          return;
        }
      }

      List<Position> movablePieces = getAllMovablePieces();
      if (movablePieces.isNotEmpty) {
        Position piece = movablePieces.first;
        List<List<int>> moves = getPossibleMoves(piece.x, piece.y);
        if (moves.isNotEmpty) {
          List<int> move = moves.first;
          makeMove(piece.x, piece.y, move[0], move[1]);
        }
      }

      // Check if the game is over
      if (isGameOver()) {
        int? winner = getWinner();
        if (onGameEnd != null && winner != null) {
          onGameEnd!(winner == 1); // 1: Player wins, 2: Bot wins
        }
      }
    });
  }
}
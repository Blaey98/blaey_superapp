import 'package:blaey_app/models/position.dart' as pos;

class GameLogic {
  List<List<int>> board;
  bool playerTurn;

  GameLogic({required this.board, required this.playerTurn});

  factory GameLogic.initial() {
    List<List<int>> initialBoard = List.generate(
      8,
          (i) => List.generate(
        8,
            (j) {
          if (i < 3 && (i + j) % 2 == 1) return 2; // Peças azuis
          if (i > 4 && (i + j) % 2 == 1) return 1; // Peças vermelhas
          return 0;
        },
      ),
    );
    return GameLogic(board: initialBoard, playerTurn: true);
  }

  bool isWithinBoard(int x, int y) {
    return x >= 0 && x < 8 && y >= 0 && y < 8;
  }

  List<pos.Position> getAllMovablePieces() {
    List<pos.Position> movablePieces = [];
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        if (board[y][x] != 0 && getPossibleMoves(x, y).isNotEmpty) {
          movablePieces.add(pos.Position(x, y));
        }
      }
    }
    return movablePieces;
  }

  List<pos.Position> getAllCapturingPieces() {
    List<pos.Position> capturingPieces = [];
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        if (board[y][x] != 0 && getPossibleCaptureMoves(x, y).isNotEmpty) {
          capturingPieces.add(pos.Position(x, y));
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

    if (isWithinBoard(x + 2, y + 2 * direction)) {
      addCaptureMoveIfValid(moves, x, y, x + 2, y + 2 * direction);
    }
    if (isWithinBoard(x - 2, y + 2 * direction)) {
      addCaptureMoveIfValid(moves, x, y, x - 2, y + 2 * direction);
    }

    if (isKing) {
      if (isWithinBoard(x + 1, y - direction)) {
        addMoveIfValid(moves, x + 1, y - direction);
      }
      if (isWithinBoard(x - 1, y - direction)) {
        addMoveIfValid(moves, x - 1, y - direction);
      }
      if (isWithinBoard(x + 2, y - 2 * direction)) {
        addCaptureMoveIfValid(moves, x, y, x + 2, y - 2 * direction);
      }
      if (isWithinBoard(x - 2, y - 2 * direction)) {
        addCaptureMoveIfValid(moves, x, y, x - 2, y - 2 * direction);
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

    board[endY][endX] = piece;
    board[startY][startX] = 0;

    if ((endX - startX).abs() == 2) {
      int midX = (startX + endX) ~/ 2;
      int midY = (startY + endY) ~/ 2;
      board[midY][midX] = 0;
      capturedPieces++;
    }

    if ((piece == 1 && endY == 0) || (piece == 2 && endY == 7)) {
      board[endY][endX] = piece + 2;
    }

    // Check for additional captures
    if ((endX - startX).abs() == 2 && getPossibleCaptureMoves(endX, endY).isNotEmpty) {
      return capturedPieces;
    }

    playerTurn = !playerTurn;
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
}
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

    // Verifica se é um movimento de captura
    if ((endX - startX).abs() == 2 && (endY - startY).abs() == 2) {
      int midX = (startX + endX) ~/ 2;
      int midY = (startY + endY) ~/ 2;
      int opponent = board[midY][midX];

      if (opponent != 0 && opponent % 2 != piece % 2) {
        // Realiza a captura
        board[midY][midX] = 0;
        capturedPieces++;
      }
    }

    // Move a peça para a nova posição
    board[endY][endX] = piece;
    board[startY][startX] = 0;

    // Promove a peça a rei se atingir a última linha
    if ((piece == 1 && endY == 0) || (piece == 2 && endY == 7)) {
      board[endY][endX] = piece + 2; // Promove a peça a dama (rei)
    }

    // Verifica se há mais capturas disponíveis após a jogada
    if (capturedPieces > 0 && getPossibleCaptureMoves(endX, endY).isNotEmpty) {
      return capturedPieces; // Mantém o turno do jogador atual
    }

    playerTurn = !playerTurn; // Passa o turno para o próximo jogador
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

    // Verifica se um dos jogadores não tem movimentos possíveis
    bool redCanMove = board.asMap().entries.any((row) =>
        row.value.asMap().entries.any((cell) =>
        (cell.value == 1 || cell.value == 3) && getPossibleMoves(cell.key, row.key).isNotEmpty));

    bool blueCanMove = board.asMap().entries.any((row) =>
        row.value.asMap().entries.any((cell) =>
        (cell.value == 2 || cell.value == 4) && getPossibleMoves(cell.key, row.key).isNotEmpty));

    return !redHasPieces || !blueHasPieces || !redCanMove || !blueCanMove;
  }
}
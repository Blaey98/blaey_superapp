class GameLogic {
  List<List<int>> board;
  bool playerTurn;

  GameLogic({required this.board, required this.playerTurn});

  // Factory method to initialize the game board
  factory GameLogic.initial() {
    return GameLogic(
      board: List.generate(8, (i) => List.generate(8, (j) {
        if (i < 3 && (i + j) % 2 == 1) return 2; // peças azuis
        if (i > 4 && (i + j) % 2 == 1) return 1; // peças vermelhas
        return 0;
      })),
      playerTurn: true,
    );
  }

  // Check if the position is within the board boundaries
  bool isWithinBoard(int x, int y) {
    return x >= 0 && x < 8 && y >= 0 && y < 8;
  }

  // Get possible moves for a piece at (x, y)
  List<List<int>> getPossibleMoves(int x, int y) {
    List<List<int>> moves = [];
    int piece = board[y][x];

    // Check if it's the player's turn for the piece
    if ((piece == 1 && !playerTurn) || (piece == 2 && playerTurn)) {
      return moves;
    }

    int direction = (piece == 1 || piece == 3) ? -1 : 1;
    bool isKing = piece == 3 || piece == 4;

    // Normal moves
    if (isWithinBoard(x + 1, y + direction)) {
      addMoveIfValid(moves, x + 1, y + direction);
    }
    if (isWithinBoard(x - 1, y + direction)) {
      addMoveIfValid(moves, x - 1, y + direction);
    }

    // Capture moves
    if (isWithinBoard(x + 2, y + 2 * direction)) {
      addCaptureMoveIfValid(moves, x, y, x + 2, y + 2 * direction);
    }
    if (isWithinBoard(x - 2, y + 2 * direction)) {
      addCaptureMoveIfValid(moves, x, y, x - 2, y + 2 * direction);
    }

    // King moves
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

  // Helper method to add a move if it's valid
  void addMoveIfValid(List<List<int>> moves, int x, int y) {
    if (isWithinBoard(x, y) && board[y][x] == 0) {
      moves.add([x, y]);
    }
  }

  // Helper method to add a capture move if it's valid
  void addCaptureMoveIfValid(List<List<int>> moves, int startX, int startY, int endX, int endY) {
    int midX = (startX + endX) ~/ 2;
    int midY = (startY + endY) ~/ 2;
    int piece = board[startY][startX];
    int opponent = board[midY][midX];

    if (isWithinBoard(endX, endY) && board[endY][endX] == 0 && opponent != 0 && opponent % 2 != piece % 2) {
      moves.add([endX, endY]);
    }
  }

  // Make a move and return the number of captured pieces
  int makeMove(int startX, int startY, int endX, int endY) {
    int piece = board[startY][startX];
    int capturedPieces = 0;

    print('Movendo peça de (${startX}, ${startY}) para (${endX}, ${endY})');
    board[endY][endX] = piece;
    board[startY][startX] = 0;

    // Capture logic
    if ((endX - startX).abs() == 2) {
      int midX = (startX + endX) ~/ 2;
      int midY = (startY + endY) ~/ 2;
      print('Capturando peça em (${midX}, ${midY})');
      board[midY][midX] = 0;
      capturedPieces++;
    }

    // King promotion
    if ((piece == 1 && endY == 0) || (piece == 2 && endY == 7)) {
      board[endY][endX] = piece + 2;
      print('Promovendo peça em (${endX}, ${endY}) para rei');
    }

    // If there are more captures possible, do not change turn
    if ((endX - startX).abs() == 2 && getPossibleCaptureMoves(endX, endY).isNotEmpty) {
      return capturedPieces;
    }

    // Toggle player turn
    playerTurn = !playerTurn;
    print('Turno do jogador: ${playerTurn ? "vermelho" : "azul"}');
    return capturedPieces;
  }

  // Get possible capture moves for a piece at (x, y)
  List<List<int>> getPossibleCaptureMoves(int x, int y) {
    List<List<int>> captureMoves = [];
    int piece = board[y][x];
    int direction = (piece == 1 || piece == 3) ? -1 : 1;
    bool isKing = piece == 3 || piece == 4;

    // Capture moves
    if (isWithinBoard(x + 2, y + 2 * direction)) {
      addCaptureMoveIfValid(captureMoves, x, y, x + 2, y + 2 * direction);
    }
    if (isWithinBoard(x - 2, y + 2 * direction)) {
      addCaptureMoveIfValid(captureMoves, x, y, x - 2, y + 2 * direction);
    }

    // King capture moves
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
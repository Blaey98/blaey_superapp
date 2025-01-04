class ChessLogic {
  List<List<String>> board;
  bool isWhiteTurn;

  ChessLogic.initial()
      : board = [
    ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'],
    ['p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
    ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'],
  ],
        isWhiteTurn = true;

  static const Map<String, String> whitePieces = {
    'P': 'pawn',
    'R': 'rook',
    'N': 'knight',
    'B': 'bishop',
    'Q': 'queen',
    'K': 'king'
  };

  static const Map<String, String> blackPieces = {
    'p': 'pawn',
    'r': 'rook',
    'n': 'knight',
    'b': 'bishop',
    'q': 'queen',
    'k': 'king'
  };

  String getPiece(int row, int col) {
    return board[row][col];
  }

  bool isValidMove(int fromRow, int fromCol, int toRow, int toCol) {
    String piece = board[fromRow][fromCol];
    if (piece.isEmpty) return false;

    switch (piece.toLowerCase()) {
      case 'p':
        return _isValidPawnMove(fromRow, fromCol, toRow, toCol, piece);
      case 'r':
        return _isValidRookMove(fromRow, fromCol, toRow, toCol);
      case 'n':
        return _isValidKnightMove(fromRow, fromCol, toRow, toCol);
      case 'b':
        return _isValidBishopMove(fromRow, fromCol, toRow, toCol);
      case 'q':
        return _isValidQueenMove(fromRow, fromCol, toRow, toCol);
      case 'k':
        return _isValidKingMove(fromRow, fromCol, toRow, toCol);
      default:
        return false;
    }
  }

  bool _isValidPawnMove(int fromRow, int fromCol, int toRow, int toCol, String piece) {
    int direction = piece == 'P' ? -1 : 1;
    if (fromCol == toCol && board[toRow][toCol].isEmpty) {
      if (toRow == fromRow + direction) {
        return true;
      }
      if ((piece == 'P' && fromRow == 6 || piece == 'p' && fromRow == 1) && toRow == fromRow + 2 * direction) {
        return true;
      }
    } else if ((toCol == fromCol + 1 || toCol == fromCol - 1) && toRow == fromRow + direction && !board[toRow][toCol].isEmpty) {
      return true;
    }
    return false;
  }

  bool _isValidRookMove(int fromRow, int fromCol, int toRow, int toCol) {
    if (fromRow != toRow && fromCol != toCol) return false;
    int rowStep = (toRow - fromRow).sign;
    int colStep = (toCol - fromCol).sign;
    int checkRow = fromRow + rowStep;
    int checkCol = fromCol + colStep;
    while (checkRow != toRow || checkCol != toCol) {
      if (board[checkRow][checkCol].isNotEmpty) return false;
      checkRow += rowStep;
      checkCol += colStep;
    }
    return true;
  }

  bool _isValidKnightMove(int fromRow, int fromCol, int toRow, int toCol) {
    int rowDiff = (toRow - fromRow).abs();
    int colDiff = (toCol - fromCol).abs();
    return (rowDiff == 2 && colDiff == 1) || (rowDiff == 1 && colDiff == 2);
  }

  bool _isValidBishopMove(int fromRow, int fromCol, int toRow, int toCol) {
    if ((toRow - fromRow).abs() != (toCol - fromCol).abs()) return false;
    int rowStep = (toRow - fromRow).sign;
    int colStep = (toCol - fromCol).sign;
    int checkRow = fromRow + rowStep;
    int checkCol = fromCol + colStep;
    while (checkRow != toRow || checkCol != toCol) {
      if (board[checkRow][checkCol].isNotEmpty) return false;
      checkRow += rowStep;
      checkCol += colStep;
    }
    return true;
  }

  bool _isValidQueenMove(int fromRow, int fromCol, int toRow, int toCol) {
    return _isValidRookMove(fromRow, fromCol, toRow, toCol) || _isValidBishopMove(fromRow, fromCol, toRow, toCol);
  }

  bool _isValidKingMove(int fromRow, int fromCol, int toRow, int toCol) {
    int rowDiff = (toRow - fromRow).abs();
    int colDiff = (toCol - fromCol).abs();
    return rowDiff <= 1 && colDiff <= 1;
  }

  bool movePiece(int fromRow, int fromCol, int toRow, int toCol) {
    if (isValidMove(fromRow, fromCol, toRow, toCol)) {
      board[toRow][toCol] = board[fromRow][fromCol];
      board[fromRow][fromCol] = '';
      isWhiteTurn = !isWhiteTurn;
      return true;
    }
    return false;
  }

  bool isCheck(bool isWhiteTurn) {
    String king = isWhiteTurn ? 'K' : 'k';
    int kingRow = -1;
    int kingCol = -1;
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (board[row][col] == king) {
          kingRow = row;
          kingCol = col;
          break;
        }
      }
    }
    if (kingRow == -1 || kingCol == -1) return false;

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (board[row][col].isNotEmpty && ((isWhiteTurn && blackPieces.containsKey(board[row][col])) || (!isWhiteTurn && whitePieces.containsKey(board[row][col])))) {
          if (isValidMove(row, col, kingRow, kingCol)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool isCheckmate(bool isWhiteTurn) {
    if (!isCheck(isWhiteTurn)) return false;

    for (int fromRow = 0; fromRow < 8; fromRow++) {
      for (int fromCol = 0; fromCol < 8; fromCol++) {
        if (board[fromRow][fromCol].isNotEmpty && ((isWhiteTurn && whitePieces.containsKey(board[fromRow][fromCol])) || (!isWhiteTurn && blackPieces.containsKey(board[fromRow][fromCol])))) {
          for (int toRow = 0; toRow < 8; toRow++) {
            for (int toCol = 0; toCol < 8; toCol++) {
              if (isValidMove(fromRow, fromCol, toRow, toCol)) {
                String temp = board[toRow][toCol];
                board[toRow][toCol] = board[fromRow][fromCol];
                board[fromRow][fromCol] = '';
                bool stillInCheck = isCheck(isWhiteTurn);
                board[fromRow][fromCol] = board[toRow][toCol];
                board[toRow][toCol] = temp;
                if (!stillInCheck) {
                  return false;
                }
              }
            }
          }
        }
      }
    }
    return true;
  }
}
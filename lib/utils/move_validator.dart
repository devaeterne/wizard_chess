import '../models/piece.dart';

bool canMove({
  required Piece piece,
  required int fromX,
  required int fromY,
  required int toX,
  required int toY,
  required List<List<Piece?>> board,
}) {
  // Tahtanın sınırları dışına çıkma
  if (toX < 0 || toX >= 8 || toY < 0 || toY >= 8) return false;

  // Aynı kareye gitme
  if (fromX == toX && fromY == toY) return false;

  // Gideceği karede kendi taşı varsa hareket geçersiz
  final destinationPiece = board[toY][toX];
  if (destinationPiece != null && destinationPiece.color == piece.color)
    return false;

  // Taş tipine göre hareket kuralları
  switch (piece.type) {
    case PieceType.pawn:
      return _canMovePawn(piece, fromX, fromY, toX, toY, board);
    case PieceType.rook:
      return _canMoveRook(fromX, fromY, toX, toY, board);
    case PieceType.knight:
      return _canMoveKnight(fromX, fromY, toX, toY);
    case PieceType.bishop:
      return _canMoveBishop(fromX, fromY, toX, toY, board);
    case PieceType.queen:
      return _canMoveQueen(fromX, fromY, toX, toY, board);
    case PieceType.king:
      return _canMoveKing(fromX, fromY, toX, toY, board);
  }
}

bool _canMovePawn(
  Piece piece,
  int fromX,
  int fromY,
  int toX,
  int toY,
  List<List<Piece?>> board,
) {
  int direction = piece.color == PieceColor.white ? -1 : 1;

  // İleri hareket (boş kare)
  if (fromX == toX && board[toY][toX] == null) {
    if (toY - fromY == direction) return true;

    // İlk hareketinde 2 kare ilerleyebilir
    bool isAtStartRow =
        (piece.color == PieceColor.white && fromY == 6) ||
        (piece.color == PieceColor.black && fromY == 1);
    if (isAtStartRow &&
        toY - fromY == 2 * direction &&
        board[fromY + direction][fromX] == null) {
      return true;
    }
  }

  // Çapraz hareket (rakip taşı varsa)
  if ((toX - fromX).abs() == 1 && toY - fromY == direction) {
    final target = board[toY][toX];
    if (target != null && target.color != piece.color) return true;
  }

  return false;
}

bool _canMoveRook(
  int fromX,
  int fromY,
  int toX,
  int toY,
  List<List<Piece?>> board,
) {
  if (fromX != toX && fromY != toY) return false;

  int stepX = (toX - fromX).sign;
  int stepY = (toY - fromY).sign;

  int x = fromX + stepX;
  int y = fromY + stepY;
  while (x != toX || y != toY) {
    if (board[y][x] != null) return false;
    x += stepX;
    y += stepY;
  }
  return true;
}

bool _canMoveKnight(int fromX, int fromY, int toX, int toY) {
  int dx = (toX - fromX).abs();
  int dy = (toY - fromY).abs();

  return (dx == 2 && dy == 1) || (dx == 1 && dy == 2);
}

bool _canMoveBishop(
  int fromX,
  int fromY,
  int toX,
  int toY,
  List<List<Piece?>> board,
) {
  if ((toX - fromX).abs() != (toY - fromY).abs()) return false;

  int stepX = (toX - fromX).sign;
  int stepY = (toY - fromY).sign;

  int x = fromX + stepX;
  int y = fromY + stepY;
  while (x != toX && y != toY) {
    if (board[y][x] != null) return false;
    x += stepX;
    y += stepY;
  }
  return true;
}

bool _canMoveQueen(
  int fromX,
  int fromY,
  int toX,
  int toY,
  List<List<Piece?>> board,
) {
  return _canMoveRook(fromX, fromY, toX, toY, board) ||
      _canMoveBishop(fromX, fromY, toX, toY, board);
}

bool _canMoveKing(
  int fromX,
  int fromY,
  int toX,
  int toY,
  List<List<Piece?>> board,
) {
  int dx = (toX - fromX).abs();
  int dy = (toY - fromY).abs();

  if (dx <= 1 && dy <= 1) {
    return true;
  }

  // Castling kuralları eklenebilir burada (şimdilik yok)
  return false;
}

// Şah çekilme kontrolü
bool isKingInCheck(PieceColor kingColor, List<List<Piece?>> board) {
  int kingX = -1;
  int kingY = -1;
  for (int y = 0; y < board.length; y++) {
    for (int x = 0; x < board[y].length; x++) {
      final piece = board[y][x];
      if (piece != null &&
          piece.type == PieceType.king &&
          piece.color == kingColor) {
        kingX = x;
        kingY = y;
        break;
      }
    }
    if (kingX != -1) break;
  }

  if (kingX == -1 || kingY == -1) return false;

  final opponentColor = kingColor == PieceColor.white
      ? PieceColor.black
      : PieceColor.white;

  for (int y = 0; y < board.length; y++) {
    for (int x = 0; x < board[y].length; x++) {
      final piece = board[y][x];
      if (piece != null && piece.color == opponentColor) {
        if (canMove(
          piece: piece,
          fromX: x,
          fromY: y,
          toX: kingX,
          toY: kingY,
          board: board,
        )) {
          return true;
        }
      }
    }
  }

  return false;
}

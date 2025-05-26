import '../models/piece.dart';

bool canMovePawn({
  required Piece piece,
  required int fromX,
  required int fromY,
  required int toX,
  required int toY,
  required List<List<Piece?>> board,
}) {
  int direction = piece.color == PieceColor.white ? -1 : 1;
  if (toX == fromX && toY == fromY + direction && board[toY][toX] == null) {
    return true;
  }
  bool isAtStartingRow =
      (piece.color == PieceColor.white && fromY == 6) ||
      (piece.color == PieceColor.black && fromY == 1);
  if (isAtStartingRow &&
      toX == fromX &&
      toY == fromY + 2 * direction &&
      board[fromY + direction][fromX] == null &&
      board[toY][toX] == null) {
    return true;
  }
  if ((toX == fromX + 1 || toX == fromX - 1) &&
      toY == fromY + direction &&
      board[toY][toX] != null &&
      board[toY][toX]?.color != piece.color) {
    return true;
  }
  return false;
}

bool canMoveRook({
  required Piece piece,
  required int fromX,
  required int fromY,
  required int toX,
  required int toY,
  required List<List<Piece?>> board,
}) {
  if (fromX != toX && fromY != toY) return false;

  int xDirection = toX == fromX ? 0 : (toX > fromX ? 1 : -1);
  int yDirection = toY == fromY ? 0 : (toY > fromY ? 1 : -1);

  int currentX = fromX + xDirection;
  int currentY = fromY + yDirection;

  while (currentX != toX || currentY != toY) {
    if (board[currentY][currentX] != null) return false;
    currentX += xDirection;
    currentY += yDirection;
  }
  return board[toY][toX] == null || board[toY][toX]?.color != piece.color;
}

bool canMoveKnight({
  required Piece piece,
  required int fromX,
  required int fromY,
  required int toX,
  required int toY,
  required List<List<Piece?>> board,
}) {
  int dx = (toX - fromX).abs();
  int dy = (toY - fromY).abs();
  if (!((dx == 2 && dy == 1) || (dx == 1 && dy == 2))) return false;

  return board[toY][toX] == null || board[toY][toX]?.color != piece.color;
}

bool canMoveBishop({
  required Piece piece,
  required int fromX,
  required int fromY,
  required int toX,
  required int toY,
  required List<List<Piece?>> board,
}) {
  int dx = (toX - fromX).abs();
  int dy = (toY - fromY).abs();
  if (dx != dy) return false;

  int xDirection = toX > fromX ? 1 : -1;
  int yDirection = toY > fromY ? 1 : -1;

  int currentX = fromX + xDirection;
  int currentY = fromY + yDirection;

  while (currentX != toX && currentY != toY) {
    if (board[currentY][currentX] != null) return false;
    currentX += xDirection;
    currentY += yDirection;
  }
  return board[toY][toX] == null || board[toY][toX]?.color != piece.color;
}

bool canMoveQueen({
  required Piece piece,
  required int fromX,
  required int fromY,
  required int toX,
  required int toY,
  required List<List<Piece?>> board,
}) {
  // Vezir, kale veya fil hareketi gibi hareket edebilir
  return canMoveRook(
        piece: piece,
        fromX: fromX,
        fromY: fromY,
        toX: toX,
        toY: toY,
        board: board,
      ) ||
      canMoveBishop(
        piece: piece,
        fromX: fromX,
        fromY: fromY,
        toX: toX,
        toY: toY,
        board: board,
      );
}

bool canMoveKing({
  required Piece piece,
  required int fromX,
  required int fromY,
  required int toX,
  required int toY,
  required List<List<Piece?>> board,
}) {
  int dx = (toX - fromX).abs();
  int dy = (toY - fromY).abs();

  if (dx > 1 || dy > 1) return false;

  return board[toY][toX] == null || board[toY][toX]?.color != piece.color;
}

bool canMove({
  required Piece piece,
  required int fromX,
  required int fromY,
  required int toX,
  required int toY,
  required List<List<Piece?>> board,
}) {
  switch (piece.type) {
    case PieceType.pawn:
      return canMovePawn(
        piece: piece,
        fromX: fromX,
        fromY: fromY,
        toX: toX,
        toY: toY,
        board: board,
      );
    case PieceType.rook:
      return canMoveRook(
        piece: piece,
        fromX: fromX,
        fromY: fromY,
        toX: toX,
        toY: toY,
        board: board,
      );
    case PieceType.knight:
      return canMoveKnight(
        piece: piece,
        fromX: fromX,
        fromY: fromY,
        toX: toX,
        toY: toY,
        board: board,
      );
    case PieceType.bishop:
      return canMoveBishop(
        piece: piece,
        fromX: fromX,
        fromY: fromY,
        toX: toX,
        toY: toY,
        board: board,
      );
    case PieceType.queen:
      return canMoveQueen(
        piece: piece,
        fromX: fromX,
        fromY: fromY,
        toX: toX,
        toY: toY,
        board: board,
      );
    case PieceType.king:
      return canMoveKing(
        piece: piece,
        fromX: fromX,
        fromY: fromY,
        toX: toX,
        toY: toY,
        board: board,
      );
  }
}

enum PieceType { pawn, rook, knight, bishop, queen, king }

enum PieceColor { white, black }

class Piece {
  final PieceType type;
  final PieceColor color;
  bool hasMoved;

  Piece({required this.type, required this.color, this.hasMoved = false});
}

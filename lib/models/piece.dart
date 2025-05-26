enum PieceColor { white, black }

enum PieceType { pawn, rook, knight, bishop, queen, king }

class Piece {
  final PieceType type;
  final PieceColor color;

  Piece({required this.type, required this.color});

  String get symbol {
    switch (type) {
      case PieceType.pawn:
        return color == PieceColor.white ? '♙' : '♟';
      case PieceType.rook:
        return color == PieceColor.white ? '♖' : '♜';
      case PieceType.knight:
        return color == PieceColor.white ? '♘' : '♞';
      case PieceType.bishop:
        return color == PieceColor.white ? '♗' : '♝';
      case PieceType.queen:
        return color == PieceColor.white ? '♕' : '♛';
      case PieceType.king:
        return color == PieceColor.white ? '♔' : '♚';
    }
  }
}

import 'package:flutter/material.dart';

enum PieceType { king, queen, rook, bishop, knight, pawn }

enum PieceColor { white, black }

class Piece {
  final PieceType type;
  final PieceColor color;

  Piece({required this.type, required this.color});

  // Taş ikonunu dönüyor (örnek olarak, istersen özel SVG veya resim koyabilirsin)
  IconData get icon {
    switch (type) {
      case PieceType.king:
        return color == PieceColor.white
            ? Icons.king_bed
            : Icons.king_bed_outlined;
      case PieceType.queen:
        return color == PieceColor.white ? Icons.crown : Icons.crown; // Mesela
      case PieceType.rook:
        return color == PieceColor.white ? Icons.castle : Icons.castle_outlined;
      case PieceType.bishop:
        return color == PieceColor.white
            ? Icons.filter_hdr
            : Icons.filter_hdr_outlined;
      case PieceType.knight:
        return color == PieceColor.white
            ? Icons.directions_bike
            : Icons.directions_bike_outlined;
      case PieceType.pawn:
        return color == PieceColor.white
            ? Icons.adjust
            : Icons.radio_button_unchecked;
    }
  }

  // Satranç notasyonundaki sembol (örn: K,Q,R,B,N,P)
  String get symbol {
    switch (type) {
      case PieceType.king:
        return 'K';
      case PieceType.queen:
        return 'Q';
      case PieceType.rook:
        return 'R';
      case PieceType.bishop:
        return 'B';
      case PieceType.knight:
        return 'N';
      case PieceType.pawn:
        return 'P';
    }
  }
}

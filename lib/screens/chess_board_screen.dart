import 'package:flutter/material.dart';
import '../models/piece.dart';
import '../utils/move_validator.dart';
import '../widgets/chess_tile.dart';

class ChessBoardScreen extends StatefulWidget {
  @override
  State<ChessBoardScreen> createState() => _ChessBoardScreenState();
}

class _ChessBoardScreenState extends State<ChessBoardScreen> {
  static const int boardSize = 8;
  late List<List<Piece?>> board;
  int? selectedX;
  int? selectedY;
  PieceColor currentTurn = PieceColor.white;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    board = List.generate(
      boardSize,
      (_) => List.generate(boardSize, (_) => null),
    );

    // Siyah taşlar (0. ve 1. satırlar)
    board[0] = [
      Piece(type: PieceType.rook, color: PieceColor.black),
      Piece(type: PieceType.knight, color: PieceColor.black),
      Piece(type: PieceType.bishop, color: PieceColor.black),
      Piece(type: PieceType.queen, color: PieceColor.black),
      Piece(type: PieceType.king, color: PieceColor.black),
      Piece(type: PieceType.bishop, color: PieceColor.black),
      Piece(type: PieceType.knight, color: PieceColor.black),
      Piece(type: PieceType.rook, color: PieceColor.black),
    ];
    for (int i = 0; i < boardSize; i++) {
      board[1][i] = Piece(type: PieceType.pawn, color: PieceColor.black);
    }

    // Beyaz taşlar (6. ve 7. satırlar)
    board[7] = [
      Piece(type: PieceType.rook, color: PieceColor.white),
      Piece(type: PieceType.knight, color: PieceColor.white),
      Piece(type: PieceType.bishop, color: PieceColor.white),
      Piece(type: PieceType.queen, color: PieceColor.white),
      Piece(type: PieceType.king, color: PieceColor.white),
      Piece(type: PieceType.bishop, color: PieceColor.white),
      Piece(type: PieceType.knight, color: PieceColor.white),
      Piece(type: PieceType.rook, color: PieceColor.white),
    ];
    for (int i = 0; i < boardSize; i++) {
      board[6][i] = Piece(type: PieceType.pawn, color: PieceColor.white);
    }
  }

  void _onTileTap(int x, int y) {
    setState(() {
      final tappedPiece = board[y][x];

      if (selectedX == null || selectedY == null) {
        // Henüz taş seçilmedi, seç
        if (tappedPiece != null && tappedPiece.color == currentTurn) {
          selectedX = x;
          selectedY = y;
        }
      } else {
        // Taş seçili, şimdi hareket kontrolü
        final selectedPiece = board[selectedY!][selectedX!];

        if (selectedPiece != null &&
            canMove(
              piece: selectedPiece,
              fromX: selectedX!,
              fromY: selectedY!,
              toX: x,
              toY: y,
              board: board,
            )) {
          // Hamle geçerli, taşı hareket ettir
          board[y][x] = selectedPiece;
          board[selectedY!][selectedX!] = null;

          // Sıra değiştir
          currentTurn = currentTurn == PieceColor.white
              ? PieceColor.black
              : PieceColor.white;
        }

        // Seçimi kaldır
        selectedX = null;
        selectedY = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wizard Chess')),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            itemCount: boardSize * boardSize,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: boardSize,
            ),
            itemBuilder: (context, index) {
              final x = index % boardSize;
              final y = index ~/ boardSize;
              final isDarkSquare = (x + y) % 2 == 1;

              final isSelected = (selectedX == x && selectedY == y);
              final piece = board[y][x];
              final symbol = piece?.symbol;

              return ChessTile(
                isDark: isDarkSquare,
                isSelected: isSelected,
                symbol: symbol,
                onTap: () => _onTileTap(x, y),
              );
            },
          ),
        ),
      ),
    );
  }
}

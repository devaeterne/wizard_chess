import 'package:flutter/material.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import '../models/piece.dart';
import '../utils/move_validator.dart';
import '../widgets/chess_tile.dart';

class ChessBoardScreen extends StatefulWidget {
  const ChessBoardScreen({Key? key}) : super(key: key);

  @override
  State<ChessBoardScreen> createState() => _ChessBoardScreenState();
}

class _ChessBoardScreenState extends State<ChessBoardScreen> {
  late List<List<Piece?>> board;
  PieceColor currentTurn = PieceColor.white;
  List<String> moveLog = [];
  List<Piece> capturedWhite = [];
  List<Piece> capturedBlack = [];

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {
    board = List.generate(8, (_) => List.filled(8, null));

    List<PieceType> backRow = [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook,
    ];

    // Siyah taşlar
    for (int x = 0; x < 8; x++) {
      board[1][x] = Piece(type: PieceType.pawn, color: PieceColor.black);
      board[0][x] = Piece(type: backRow[x], color: PieceColor.black);
    }

    // Beyaz taşlar
    for (int x = 0; x < 8; x++) {
      board[6][x] = Piece(type: PieceType.pawn, color: PieceColor.white);
      board[7][x] = Piece(type: backRow[x], color: PieceColor.white);
    }
  }

  Widget _getPieceIcon(Piece? piece) {
    if (piece == null) return const SizedBox.shrink();

    final isWhite = piece.color == PieceColor.white;

    Widget icon;

    switch (piece.type) {
      case PieceType.pawn:
        icon = isWhite ? WhitePawn() : BlackPawn();
        break;
      case PieceType.rook:
        icon = isWhite ? WhiteRook() : BlackRook();
        break;
      case PieceType.knight:
        icon = isWhite ? WhiteKnight() : BlackKnight();
        break;
      case PieceType.bishop:
        icon = isWhite ? WhiteBishop() : BlackBishop();
        break;
      case PieceType.queen:
        icon = isWhite ? WhiteQueen() : BlackQueen();
        break;
      case PieceType.king:
        icon = isWhite ? WhiteKing() : BlackKing();
        break;
    }

    return SizedBox(width: 48, height: 48, child: icon);
  }

  int? selectedX;
  int? selectedY;

  void _onTileTap(int x, int y) {
    final piece = board[y][x];
    setState(() {
      if (selectedX == null || selectedY == null) {
        if (piece != null && piece.color == currentTurn) {
          selectedX = x;
          selectedY = y;
        }
      } else {
        if (selectedX == x && selectedY == y) {
          selectedX = null;
          selectedY = null;
          return;
        }

        final selectedPiece = board[selectedY!][selectedX!];
        if (selectedPiece == null) {
          selectedX = null;
          selectedY = null;
          return;
        }

        if (canMove(
          piece: selectedPiece,
          fromX: selectedX!,
          fromY: selectedY!,
          toX: x,
          toY: y,
          board: board,
        )) {
          final capturedPiece = board[y][x];
          if (capturedPiece != null) {
            if (capturedPiece.color == PieceColor.white) {
              capturedWhite.add(capturedPiece);
            } else {
              capturedBlack.add(capturedPiece);
            }
          }

          board[y][x] = selectedPiece;
          board[selectedY!][selectedX!] = null;

          moveLog.add(
            "${_pieceName(selectedPiece.type)} ${_posToString(selectedX!, selectedY!)} -> ${_posToString(x, y)}",
          );

          currentTurn = currentTurn == PieceColor.white
              ? PieceColor.black
              : PieceColor.white;

          selectedX = null;
          selectedY = null;
        } else {
          if (piece != null && piece.color == currentTurn) {
            selectedX = x;
            selectedY = y;
          } else {
            selectedX = null;
            selectedY = null;
          }
        }
      }
    });
  }

  String _pieceName(PieceType type) {
    switch (type) {
      case PieceType.pawn:
        return "P";
      case PieceType.rook:
        return "R";
      case PieceType.knight:
        return "N";
      case PieceType.bishop:
        return "B";
      case PieceType.queen:
        return "Q";
      case PieceType.king:
        return "K";
    }
  }

  String _posToString(int x, int y) {
    const files = "abcdefgh";
    return "${files[x]}${8 - y}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wizard Chess"),
        backgroundColor: Colors.brown[700],
      ),
      backgroundColor: Colors.brown[300],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Satranç tahtası
            Expanded(
              flex: 4,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown.shade900, width: 4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                        ),
                    itemCount: 64,
                    itemBuilder: (context, index) {
                      final x = index % 8;
                      final y = index ~/ 8;
                      final isDark = (x + y) % 2 == 1;
                      final isSelected = (selectedX == x && selectedY == y);
                      final piece = board[y][x];

                      return ChessTile(
                        isDark: isDark,
                        isSelected: isSelected,
                        pieceWidget: _getPieceIcon(piece),
                        onTap: () => _onTileTap(x, y),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Sağdaki log ve yakalanan taşlar bölümü
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  // Hareket logu
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.brown[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.brown),
                      ),
                      child: ListView.builder(
                        itemCount: moveLog.length,
                        itemBuilder: (context, index) {
                          return Text(
                            moveLog[index],
                            style: const TextStyle(fontSize: 14),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Yenilen taşlar beyaz
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.brown[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.brown),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Captured White",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: capturedWhite
                                  .map(
                                    (p) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                      ),
                                      child: SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: _getPieceIcon(p),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Yenilen taşlar siyah
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.brown[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.brown),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Captured Black",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: capturedBlack
                                  .map(
                                    (p) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0,
                                      ),
                                      child: SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: _getPieceIcon(p),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

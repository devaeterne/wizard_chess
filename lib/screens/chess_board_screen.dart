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

  // Yenilen taşlar için listeler
  List<Piece> whiteCaptured = [];
  List<Piece> blackCaptured = [];

  // Hareket logları
  List<String> moveLog = [];

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

    // Siyah taşlar
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

    // Beyaz taşlar
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
        if (tappedPiece != null && tappedPiece.color == currentTurn) {
          selectedX = x;
          selectedY = y;
        }
      } else {
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
          // Taş yeme durumu kontrolü
          if (board[y][x] != null) {
            final capturedPiece = board[y][x]!;
            if (capturedPiece.color == PieceColor.white) {
              whiteCaptured.add(capturedPiece);
            } else {
              blackCaptured.add(capturedPiece);
            }
          }

          // Hamleyi gerçekleştir
          board[y][x] = selectedPiece;
          board[selectedY!][selectedX!] = null;

          // Log kaydı
          String move =
              '${selectedPiece.symbol} ${String.fromCharCode(97 + selectedX!)}${8 - selectedY!} → ${String.fromCharCode(97 + x)}${8 - y}';
          moveLog.add(move);

          // Sıra değiştir
          currentTurn = currentTurn == PieceColor.white
              ? PieceColor.black
              : PieceColor.white;
        }

        selectedX = null;
        selectedY = null;
      }
    });
  }

  Widget _buildCapturedPiecesRow(List<Piece> capturedPieces) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: capturedPieces
            .map(
              (p) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(p.symbol, style: TextStyle(fontSize: 24)),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wizard Chess')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Tahta boyutu ekranın yüksekliğinin %90'ı veya genişliğinin %60'ı kadar olsun (örnek)
          final boardSizePx =
              constraints.maxHeight * 0.9 < constraints.maxWidth * 0.6
              ? constraints.maxHeight * 0.9
              : constraints.maxWidth * 0.6;

          return Row(
            children: [
              // Tahta
              Container(
                width: boardSizePx,
                height: boardSizePx,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
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
                    final icon = piece?.icon;

                    return ChessTile(
                      isDark: isDarkSquare,
                      isSelected: isSelected,
                      icon: icon,
                      onTap: () => _onTileTap(x, y),
                    );
                  },
                ),
              ),

              // Spacer
              SizedBox(width: 12),

              // Sağ panel: Yenilen taşlar ve loglar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Captured Pieces:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'White Captured:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    _buildCapturedPiecesRow(whiteCaptured),
                    SizedBox(height: 12),
                    Text(
                      'Black Captured:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    _buildCapturedPiecesRow(blackCaptured),
                    SizedBox(height: 20),
                    Text(
                      'Move Log:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: moveLog.length,
                          itemBuilder: (context, index) {
                            return Text(moveLog[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

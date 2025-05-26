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

  final List<String> columns = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  final List<String> rows = ['8', '7', '6', '5', '4', '3', '2', '1'];

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
          board[y][x] = selectedPiece;
          board[selectedY!][selectedX!] = null;

          currentTurn = currentTurn == PieceColor.white
              ? PieceColor.black
              : PieceColor.white;
        }
        selectedX = null;
        selectedY = null;
      }
    });
  }

  Widget _buildCoordinateLabels() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: columns
            .map(
              (col) => Text(col, style: TextStyle(fontWeight: FontWeight.bold)),
            )
            .toList(),
      ),
    );
  }

  Widget _buildBoard() {
    return AspectRatio(
      aspectRatio: 1,
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
          final symbol = piece?.symbol;

          return ChessTile(
            isDark: isDarkSquare,
            isSelected: isSelected,
            symbol: symbol,
            onTap: () => _onTileTap(x, y),
          );
        },
      ),
    );
  }

  Widget _buildRowLabels() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: rows
          .map(
            (row) => Text(row, style: TextStyle(fontWeight: FontWeight.bold)),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double boardSizePixels = MediaQuery.of(context).size.width * 0.9;
    if (boardSizePixels > 400) boardSizePixels = 400;

    return Scaffold(
      appBar: AppBar(title: Text('Wizard Chess')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCoordinateLabels(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    height: boardSizePixels,
                    child: _buildRowLabels(),
                  ),
                ),
                SizedBox(
                  width: boardSizePixels,
                  height: boardSizePixels,
                  child: _buildBoard(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

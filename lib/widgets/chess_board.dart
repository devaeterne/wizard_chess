import 'package:flutter/material.dart';
import '../models/piece.dart';
import '../utils/move_validator.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({Key? key}) : super(key: key);

  @override
  _ChessBoardState createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  static const int boardSize = 8;
  late List<List<Piece?>> board;

  Piece? selectedPiece;
  int? selectedX;
  int? selectedY;

  // Yenilen taşlar
  List<Piece> capturedWhitePieces = [];
  List<Piece> capturedBlackPieces = [];

  // Hamle logları
  List<String> moveLogs = [];

  @override
  void initState() {
    super.initState();
    board = initializeBoard();
  }

  List<List<Piece?>> initializeBoard() {
    List<List<Piece?>> newBoard = List.generate(
      boardSize,
      (_) => List.filled(boardSize, null),
    );

    // ... (Taş dizilimi aynı, kısaca burayı atlıyorum, sen önceki koddan kopyala) ...

    return newBoard;
  }

  String pieceToShortName(Piece piece) {
    switch (piece.type) {
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
        return '';
    }
  }

  String posToChessNotation(int x, int y) {
    // x: 0-7 => a-h, y:0-7 => 8-1
    String file = String.fromCharCode('a'.codeUnitAt(0) + x);
    String rank = (8 - y).toString();
    return '$file$rank';
  }

  void onSquareTapped(int x, int y) {
    setState(() {
      if (selectedPiece != null) {
        if (canMove(
          piece: selectedPiece!,
          fromX: selectedX!,
          fromY: selectedY!,
          toX: x,
          toY: y,
          board: board,
        )) {
          // Eğer hedef karede taş varsa yakalanacak
          if (board[y][x] != null) {
            Piece captured = board[y][x]!;
            if (captured.color == PieceColor.white) {
              capturedWhitePieces.add(captured);
            } else {
              capturedBlackPieces.add(captured);
            }
          }

          // Taşı hareket ettir
          board[y][x] = selectedPiece;
          board[selectedY!][selectedX!] = null;

          // Hamle loguna ekle
          String moveString =
              '${pieceToShortName(selectedPiece!)}${posToChessNotation(selectedX!, selectedY!)} → ${posToChessNotation(x, y)}';
          moveLogs.add(moveString);

          // Seçimi temizle
          selectedPiece = null;
          selectedX = null;
          selectedY = null;
        } else {
          // Geçersiz hamlede seçimi iptal et
          selectedPiece = null;
          selectedX = null;
          selectedY = null;
        }
      } else {
        if (board[y][x] != null) {
          selectedPiece = board[y][x];
          selectedX = x;
          selectedY = y;
        }
      }
    });
  }

  Widget buildCapturedPieces(List<Piece> pieces) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: pieces
          .map((piece) => Text(piece.symbol, style: TextStyle(fontSize: 24)))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Beyazın yediği taşlar (sol taraf)
        Container(
          width: 40,
          color: Colors.grey[200],
          child: SingleChildScrollView(
            child: buildCapturedPieces(capturedWhitePieces),
          ),
        ),

        // Satranç tahtası
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: boardSize,
              ),
              itemCount: boardSize * boardSize,
              itemBuilder: (context, index) {
                final int x = index % boardSize;
                final int y = index ~/ boardSize;
                final bool isDarkSquare = (x + y) % 2 == 1;
                final Piece? piece = board[y][x];
                final bool isSelected = selectedX == x && selectedY == y;

                return GestureDetector(
                  onTap: () => onSquareTapped(x, y),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkSquare
                          ? Colors.brown[700]
                          : Colors.brown[300],
                      border: isSelected
                          ? Border.all(color: Colors.red, width: 3)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        piece?.symbol ?? '',
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Siyahın yediği taşlar (sağ taraf)
        Container(
          width: 40,
          color: Colors.grey[300],
          child: SingleChildScrollView(
            child: buildCapturedPieces(capturedBlackPieces),
          ),
        ),

        // Hareket logları (altta küçük ekran istedin, burayı Row yerine Column içine almalıyız)
      ],
    );
  }
}

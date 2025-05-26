import 'package:flutter/material.dart';

class ChessTile extends StatelessWidget {
  final bool isDark;
  final bool isSelected;
  final String? symbol;
  final VoidCallback? onTap;

  const ChessTile({
    super.key,
    required this.isDark,
    this.isSelected = false,
    this.symbol,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.greenAccent
              : (isDark ? Colors.brown[700] : Colors.brown[300]),
          border: isSelected
              ? Border.all(color: Colors.yellowAccent, width: 3)
              : null,
        ),
        child: Center(
          child: Text(
            symbol ?? '',
            style: TextStyle(
              fontSize: 32,
              color: symbol != null && '♙♖♘♗♕♔'.contains(symbol!)
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

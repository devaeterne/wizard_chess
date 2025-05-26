import 'package:flutter/material.dart';

class ChessTile extends StatelessWidget {
  final bool isDark;
  final bool isSelected;
  final String? symbol;
  final VoidCallback onTap;

  const ChessTile({
    Key? key,
    required this.isDark,
    required this.isSelected,
    this.symbol,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color baseColor = isDark ? Colors.brown[700]! : Colors.brown[300]!;
    Color selectedColor = Colors.orange.withOpacity(0.5);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : baseColor,
          border: Border.all(color: Colors.black54),
        ),
        child: Center(
          child: Text(
            symbol ?? '',
            style: TextStyle(fontSize: 32, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

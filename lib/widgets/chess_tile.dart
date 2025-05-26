import 'package:flutter/material.dart';

class ChessTile extends StatelessWidget {
  final bool isDark;
  final bool isSelected;
  final Widget? pieceWidget;
  final VoidCallback onTap;

  const ChessTile({
    Key? key,
    required this.isDark,
    this.isSelected = false,
    this.pieceWidget,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark ? Colors.brown[700] : Colors.brown[300];
    final borderColor = isSelected ? Colors.yellow : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 3),
        ),
        child: Center(child: pieceWidget ?? const SizedBox.shrink()),
      ),
    );
  }
}

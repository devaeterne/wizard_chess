import 'package:flutter/material.dart';
import 'screens/chess_board_screen.dart';

void main() {
  runApp(WizardChessApp());
}

class WizardChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wizard Chess',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: ChessBoardScreen(),
    );
  }
}

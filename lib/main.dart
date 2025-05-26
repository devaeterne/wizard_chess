import 'package:flutter/material.dart';
import 'widgets/chess_board.dart';

void main() {
  runApp(const WizardChessApp());
}

class WizardChessApp extends StatelessWidget {
  const WizardChessApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wizard Chess',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Scaffold(
        appBar: AppBar(title: const Text('Wizard Chess')),
        body: const Center(child: ChessBoard()),
      ),
    );
  }
}

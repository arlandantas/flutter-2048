import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  final List<List<int>> boardData;
  GameBoard({super.key, int boardWidth = 4, int boardHeight = 4}) : boardData = List<List<int>>.filled(boardHeight, List.filled(boardWidth, 0));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: boardData
          .map((e) => Row(
                children: e.map((e) => const BoardPosition()).toList(),
              ))
          .toList(),
    );
  }
}

class BoardPosition extends StatelessWidget {
  const BoardPosition({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.red,
      margin: const EdgeInsets.all(5),
    );
  }
}

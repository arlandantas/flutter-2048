import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  final List<List<int>> boardData;
  GameBoard({super.key, int boardWidth = 4, int boardHeight = 4}) : boardData = List<List<int>>.filled(boardHeight, List.filled(boardWidth, 0));

  @override
  State<GameBoard> createState() => _GameBoardsState();
}

const double cellsMargin = 5;
const double cellsRadius = 5;

class _GameBoardsState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(cellsMargin),
      child: Column(
        children: widget.boardData
            .map(
              (e) => Expanded(
                  child: Row(
                children: e
                    .map((e) => const Expanded(
                          child: BoardPosition(),
                        ))
                    .toList(),
              )),
            )
            .toList(),
      ),
    );
  }
}

class BoardPosition extends StatelessWidget {
  const BoardPosition({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(cellsMargin),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(cellsRadius)),
          border: Border.all(color: Colors.black26),
        ),
      ),
    );
  }
}

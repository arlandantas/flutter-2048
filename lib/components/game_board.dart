import 'package:flutter/material.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:provider/provider.dart';

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
    Game game = Provider.of<Game>(context);
    return Stack(
      children: [
        BoardGrid(boardData: widget.boardData),
        Positioned.fromRect(
          rect: Rect.fromPoints(const Offset(20, 20), const Offset(50, 50)),
          child: Container(
            height: 50,
            width: 50,
            color: Colors.blueAccent,
            child: const Text("Aloouu"),
          ),
        )
      ],
    );
  }
}

class BoardGrid extends StatelessWidget {
  const BoardGrid({super.key, required this.boardData});

  final List<List<int>> boardData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(cellsMargin),
      child: Column(
        children: boardData
            .map(
              (e) => Expanded(
                  child: Row(
                children: e
                    .map((e) => const Expanded(
                          child: BoardCell(),
                        ))
                    .toList(),
              )),
            )
            .toList(),
      ),
    );
  }
}

class BoardCell extends StatelessWidget {
  const BoardCell({super.key});

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

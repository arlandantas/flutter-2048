import 'package:flutter/material.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatefulWidget {
  final int boardWidth;
  final int boardHeight;
  const GameBoard({super.key, this.boardWidth = 4, this.boardHeight = 4});

  @override
  State<GameBoard> createState() => _GameBoardsState();
}

const double cellsMargin = 5;
const double cellsRadius = 5;

class _GameBoardsState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BoardGrid(
          boardHeight: widget.boardHeight,
          boardWidth: widget.boardWidth,
        ),
        // Positioned.fromRect(
        //   rect: Rect.fromPoints(const Offset(20, 20), const Offset(50, 50)),
        //   child: Container(
        //     height: 50,
        //     width: 50,
        //     color: Colors.blueAccent,
        //     child: const Text("Aloouu"),
        //   ),
        // )
      ],
    );
  }
}

class BoardGrid extends StatelessWidget {
  final int boardWidth;
  final int boardHeight;
  const BoardGrid({super.key, this.boardWidth = 4, this.boardHeight = 4});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(cellsMargin),
      child: Column(
        children: List<Widget>.generate(
          boardHeight,
          (y) => Expanded(
              child: Row(
            children: List<Widget>.generate(
              boardWidth,
              (x) => BoardCell(x: x, y: y),
            ),
          )),
        ),
      ),
    );
  }
}

class BoardCell extends StatelessWidget {
  final int x;
  final int y;
  const BoardCell({super.key, required this.x, required this.y});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      key: Key('Cell$y$x'),
      child: Container(
        margin: const EdgeInsets.all(cellsMargin),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(cellsRadius)),
          border: Border.all(color: Colors.black26),
        ),
        alignment: Alignment.center,
        child: Consumer<Game>(
          builder: (c, game, h) => Text(
            game.getCellText(x: x, y: y),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

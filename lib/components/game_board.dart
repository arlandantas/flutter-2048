import 'package:flutter/material.dart';
import 'package:flutter2048/components/game_bricks.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:provider/provider.dart';

const double cellsMargin = 5;
const double cellsRadius = 10;

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    print("Re-rendering Board");

    return Stack(
      children: const [
        BoardGrid(),
        GameBricks(),
      ],
    );
  }
}

class BoardGrid extends StatelessWidget {
  const BoardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    print("Re-rendering Grid");

    Game game = Provider.of<Game>(context);

    return Container(
      margin: const EdgeInsets.all(cellsMargin),
      child: Column(
        children: List<Widget>.generate(
          game.boardHeight,
          (y) => Expanded(
              child: Row(
            children: List<Widget>.generate(
              game.boardWidth,
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
          border: Border.all(color: Colors.black12),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}

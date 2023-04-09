import 'package:flutter/material.dart';
import 'package:flutter2048/components/game_bricks.dart';
import 'package:flutter2048/helpers/board_mixin.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:provider/provider.dart';

const double cellsRadius = 10;

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
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
    Game game = Provider.of<Game>(context);

    return LayoutBuilder(
      builder: (ctx, constraints) {
        List<Widget> children = [];
        for (var y = 0; y < game.boardHeight; y++) {
          for (var x = 0; x < game.boardWidth; x++) {
            children.add(BoardCell(
              x: x,
              y: y,
              size: constraints.biggest,
              boardHeight: game.boardHeight,
              boardWidth: game.boardWidth,
            ));
          }
        }
        return Stack(children: children);
      },
    );
  }
}

class BoardCell extends StatelessWidget {
  final int x;
  final int y;
  final Size size;
  final int boardWidth;
  final int boardHeight;

  const BoardCell({
    super.key,
    required this.x,
    required this.y,
    required this.size,
    required this.boardHeight,
    required this.boardWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: BoardMixin.getBrickRect(
        x: x.toDouble(),
        y: y.toDouble(),
        parentSize: size,
        boardWidth: boardWidth,
        boardHeight: boardHeight,
      ),
      key: Key('Cell$y$x'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(cellsRadius)),
          border: Border.all(color: Colors.black12),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter2048/components/brick_widget.dart';
import 'package:flutter2048/components/moving_brick.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:flutter2048/types/brick.dart';
import 'package:flutter2048/types/brick_move.dart';
import 'package:provider/provider.dart';

class GameBricks extends StatefulWidget {
  const GameBricks({super.key});

  @override
  State<GameBricks> createState() => _GameBricksState();
}

class _GameBricksState extends State<GameBricks> {
  List<Brick> bricks = [];
  List<BrickMove> currentMoves = [];
  int boardWidth = 0;
  int boardHeight = 0;

  @override
  void initState() {
    super.initState();

    Provider.of<Game>(context, listen: false).addListener(
      () => gameUpdated(context),
    );
    gameUpdated(context);
  }

  gameUpdated(BuildContext context) {
    Game game = context.read<Game>();
    setState(() {
      bricks = game.bricks.toList();
      boardWidth = game.boardWidth;
      boardHeight = game.boardHeight;
    });

    if (game.pendingMoves.isEmpty) return;

    setState(() {
      currentMoves = game.pendingMoves.toList();
    });

    print("Updated: ${game.pendingMoves}");
    Timer(movingDelay, game.resetPendingMoves);
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild game bricks $boardWidth x $boardHeight");

    return LayoutBuilder(
      builder: (ctx, constraints) {
        Size size = constraints.biggest;

        List<Widget> children = [];
        for (Brick brick in bricks) {
          try {
            BrickMove move = currentMoves.firstWhere(
              (move) => move.target.x == brick.x && move.target.y == brick.y,
            );
            print("$brick -> $move");
            children.add(MovingBrick(
              brickMove: move,
              size: size,
            ));
          } catch (e) {
            children.insert(
              0,
              BrickWidget(
                boardHeight: boardHeight,
                boardWidth: boardWidth,
                x: brick.x,
                y: brick.y,
                value: brick.value,
                size: size,
              ),
            );
          }
        }

        return Stack(children: children.toList());
      },
    );
  }
}

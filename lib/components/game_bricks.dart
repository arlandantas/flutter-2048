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

enum BrickBoardStates {
  moving,
  static,
}

const Duration brickMoveDuration = Duration(milliseconds: 500);

class _GameBricksState extends State<GameBricks> {
  List<Brick> bricks = [];
  List<BrickMove> currentMoves = [];
  int boardWidth = 0;
  int boardHeight = 0;
  BrickBoardStates currentStatus = BrickBoardStates.static;

  @override
  void initState() {
    super.initState();

    Provider.of<Game>(context, listen: false).addListener(
      () => gameUpdated(context),
    );
    gameUpdated(context);
  }

  @override
  void dispose() {
    Provider.of<Game>(context, listen: false).removeListener(
      () => gameUpdated(context),
    );
    super.dispose();
  }

  gameUpdated(BuildContext context) {
    Game game = context.read<Game>();
    setState(() {
      boardWidth = game.boardWidth;
      boardHeight = game.boardHeight;

      if (game.pendingMoves.isNotEmpty) {
        currentMoves = game.pendingMoves.toList();
        currentStatus = BrickBoardStates.moving;
        Timer(
          Duration(milliseconds: brickMoveDuration.inMilliseconds + 100),
          () {
            Provider.of<Game>(context, listen: false).resetPendingMoves();
          },
        );
      } else {
        currentMoves = [];
        currentStatus = BrickBoardStates.static;
        bricks = game.bricks.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        Size size = constraints.biggest;

        renderBrick(Brick brick) {
          return BrickWidget(
            boardHeight: boardHeight,
            boardWidth: boardWidth,
            x: brick.x,
            y: brick.y,
            value: brick.value,
            size: size,
          );
        }

        if (currentStatus == BrickBoardStates.static) {
          return Stack(
            children: bricks.map(renderBrick).toList(),
          );
        }

        List<Widget> children = [];
        for (Brick brick in bricks) {
          try {
            BrickMove move = currentMoves.firstWhere(
              (move) => move.origin.x == brick.x && move.origin.y == brick.y,
            );
            children.add(
              MovingBrick(
                brickMove: move,
                size: size,
                moveDuration: brickMoveDuration,
              ),
            );
          } catch (e) {
            children.insert(
              0,
              renderBrick(brick),
            );
          }
        }

        return Stack(children: children.toList());
      },
    );
  }
}

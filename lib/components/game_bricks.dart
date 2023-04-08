import 'package:flutter/material.dart';
import 'package:flutter2048/components/brick_widget.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:flutter2048/types/brick.dart';
import 'package:provider/provider.dart';

class GameBricks extends StatefulWidget {
  final int boardWidth;
  final int boardHeight;
  const GameBricks({super.key, this.boardWidth = 4, this.boardHeight = 4});

  @override
  State<GameBricks> createState() => _GameBricksState();
}

class _GameBricksState extends State<GameBricks> {
  Set<Brick> bricks = {};

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
      bricks = game.bricks;
    });

    if (game.pendingMoves.isEmpty) return;

    print("Updated: ${game.pendingMoves}");
    game.resetPendingMoves();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild game bricks");
    return LayoutBuilder(
      builder: (ctx, constraints) {
        Size size = constraints.biggest;
        return Stack(
          children: bricks
              .map(
                (brick) => BrickWidget(
                  boardHeight: widget.boardHeight,
                  boardWidth: widget.boardWidth,
                  brick: brick,
                  size: size,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter2048/components/brick_widget.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:flutter2048/types/brick.dart';
import 'package:flutter2048/types/cell_move.dart';
import 'package:provider/provider.dart';

class MovingBrick extends StatefulWidget {
  final CellMove cellMove;
  final Size size;
  const MovingBrick({super.key, required this.cellMove, required this.size});

  static const brickMoveDelay = 2000;

  @override
  State<MovingBrick> createState() => _MovingBricksState();
}

class _MovingBricksState extends State<MovingBrick> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  late Brick brick;

  @override
  void initState() {
    super.initState();

    brick = Brick(
      x: widget.cellMove.origin.x.toDouble(),
      y: widget.cellMove.origin.y.toDouble(),
      value: 0,
    );
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: MovingBrick.brickMoveDelay),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    );
    animation.addListener(animationListener);
  }

  animationListener() {}

  @override
  void dispose() {
    animation.removeListener(animationListener);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Game game = Provider.of<Game>(context);
    print("Rebuilding moving brick");
    return BrickWidget(
      boardHeight: game.boardHeight,
      boardWidth: game.boardWidth,
      brick: brick,
      size: widget.size,
    );
  }
}

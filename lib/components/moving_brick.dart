import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter2048/components/brick_widget.dart';
import 'package:flutter2048/helpers/board_mixin.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:flutter2048/types/brick_move.dart';
import 'package:provider/provider.dart';

class MovingBrick extends StatelessWidget {
  final BrickMove brickMove;
  final Size size;
  final Duration moveDuration;
  const MovingBrick({
    super.key,
    required this.brickMove,
    required this.size,
    this.moveDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    Game game = Provider.of<Game>(context);

    animator<T>({
      required T start,
      required T end,
      required Widget Function(T currentValue) builder,
    }) {
      return TweenAnimationBuilder(
        tween: Tween<T>(
          begin: start,
          end: end,
        ),
        curve: Curves.easeOutQuart,
        duration: moveDuration,
        builder: (_, currentValue, __) => builder(currentValue),
      );
    }

    return animator(
      start: brickMove.origin.y.toDouble(),
      end: brickMove.target.y.toDouble(),
      builder: (y) => animator(
        start: brickMove.origin.x.toDouble(),
        end: brickMove.target.x.toDouble(),
        builder: (x) => animator(
          start: brickMove.startValue.toDouble(),
          end: brickMove.finalValue.toDouble(),
          builder: (value) => TweenAnimationBuilder(
            tween: ColorTween(
              begin: BoardMixin.getColor(brickMove.startValue),
              end: BoardMixin.getColor(brickMove.finalValue),
            ),
            duration: moveDuration,
            builder: (_, color, __) => BrickWidget(
              boardHeight: game.boardHeight,
              boardWidth: game.boardWidth,
              y: y,
              x: x,
              value: value.toInt(),
              size: size,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

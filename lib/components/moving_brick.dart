import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter2048/components/brick_widget.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:flutter2048/types/brick_move.dart';
import 'package:provider/provider.dart';

class MovingBrick extends StatefulWidget {
  final BrickMove brickMove;
  final Size size;
  const MovingBrick({
    super.key,
    required this.brickMove,
    required this.size,
  });

  static const brickMoveDelay = 500;

  @override
  State<MovingBrick> createState() => _MovingBricksState();
}

class _MovingBricksState extends State<MovingBrick> {
  late int value;
  List<Timer> timers = [];
  int moveDuration = 500;
  Color color = Colors.blue;
  bool moving = true;
  int boardWidth = 4, boardHeight = 4;

  @override
  void initState() {
    super.initState();
    setState(() {
      value = widget.brickMove.startValue;
      moving = true;
      timers.add(Timer(
        Duration(milliseconds: moveDuration),
        () {
          print("Timer finished");
          setState(() {
            moving = false;
            value = widget.brickMove.finalValue;
            color = Colors.amber;
          });
        },
      ));
    });
  }

  @override
  void dispose() {
    print("disposing...");
    setState(() {
      for (Timer timer in timers) {
        timer.cancel();
      }
      timers = [];
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding moving brick $value $color");

    if (moving) {
      if (widget.brickMove.origin.x == widget.brickMove.target.x) {
        return TweenAnimationBuilder(
          tween: Tween<double>(
            begin: widget.brickMove.origin.y.toDouble(),
            end: widget.brickMove.target.y.toDouble(),
          ),
          duration: Duration(milliseconds: moveDuration),
          builder: (_, y, __) => BrickWidget(
            boardHeight: boardHeight,
            boardWidth: boardWidth,
            x: widget.brickMove.target.x.toDouble(),
            y: y,
            value: value,
            size: widget.size,
            animationDuration: moveDuration,
            color: color,
          ),
        );
      }
      return TweenAnimationBuilder(
        tween: Tween<double>(
          begin: widget.brickMove.origin.x.toDouble(),
          end: widget.brickMove.target.x.toDouble(),
        ),
        duration: Duration(milliseconds: moveDuration),
        builder: (_, x, __) => BrickWidget(
          boardHeight: boardHeight,
          boardWidth: boardWidth,
          y: widget.brickMove.target.y.toDouble(),
          x: x,
          value: value,
          size: widget.size,
          animationDuration: moveDuration,
          color: color,
        ),
      );
    }

    print("Move finished");

    return BrickWidget(
      boardHeight: boardHeight,
      boardWidth: boardWidth,
      x: widget.brickMove.target.x.toDouble(),
      y: widget.brickMove.target.y.toDouble(),
      value: value,
      size: widget.size,
      animationDuration: 0,
      color: color,
    );
  }
}

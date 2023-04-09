import 'package:flutter/material.dart';
import 'package:flutter2048/components/game_board.dart';
import 'package:flutter2048/helpers/position_helper.dart';

class BrickWidget extends StatelessWidget {
  final int boardWidth;
  final int boardHeight;
  final double x;
  final double y;
  final int value;
  final Size size;
  final int animationDuration;
  final Color color;
  const BrickWidget({
    super.key,
    required this.boardHeight,
    required this.boardWidth,
    required this.x,
    required this.y,
    required this.value,
    required this.size,
    this.animationDuration = 0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    Rect positionRect = PositionHelper.getBrickRect(
      x: x,
      y: y,
      boardHeight: boardHeight,
      boardWidth: boardWidth,
      parentSize: size,
    );
    return Positioned.fromRect(
      rect: positionRect,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: Colors.black12,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(cellsRadius),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 2,
                offset: Offset(0, 4),
                spreadRadius: -2,
              )
            ]),
        alignment: Alignment.center,
        child: Text(
          '$value',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

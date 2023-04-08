import 'package:flutter/material.dart';
import 'package:flutter2048/helpers/position_helper.dart';
import 'package:flutter2048/types/brick.dart';

class BrickWidget extends StatelessWidget {
  final int boardWidth;
  final int boardHeight;
  final Brick brick;
  final Size size;
  const BrickWidget({
    super.key,
    required this.boardHeight,
    required this.boardWidth,
    required this.brick,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    Rect positionRect = PositionHelper.getBrickRect(
      brick: brick,
      boardHeight: boardHeight,
      boardWidth: boardWidth,
      parentSize: size,
    );
    return Positioned.fromRect(
      rect: positionRect,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black12,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
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
          '${brick.value}',
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

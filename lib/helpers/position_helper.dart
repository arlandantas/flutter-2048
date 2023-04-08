import 'dart:ui';

import 'package:flutter2048/types/brick.dart';

const boardMargin = 5;
const brickMargin = 5;

class PositionHelper {
  static Rect getBrickRect({
    required Brick brick,
    required Size parentSize,
    required int boardWidth,
    required int boardHeight,
  }) {
    double brickW = (parentSize.width - (boardMargin * 2)) / boardWidth;
    double brickH = (parentSize.height - (boardMargin * 2)) / boardHeight;
    double brickX = (brick.x * brickW) + brickMargin;
    double brickY = brick.y * brickH + brickMargin;
    return Rect.fromPoints(
      Offset(brickX + boardMargin, brickY + boardMargin),
      Offset(brickX + brickW - brickMargin, brickY + brickH - brickMargin),
    );
  }
}

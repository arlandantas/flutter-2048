import 'dart:ui';

import 'package:flutter/material.dart';

const boardMargin = 5;
const brickMargin = 5;

mixin BoardMixin {
  static Rect getBrickRect({
    required double x,
    required double y,
    required Size parentSize,
    required int boardWidth,
    required int boardHeight,
  }) {
    bool isLandscape = parentSize.width > parentSize.height;
    double canvasSide = isLandscape ? parentSize.height : parentSize.width;
    canvasSide -= (boardMargin * 2);
    double yPadding = isLandscape ? 0 : (parentSize.height - canvasSide) / 2;
    double xPadding = isLandscape ? (parentSize.height - canvasSide) / 2 : 0;

    double brickW = canvasSide / boardWidth;
    double brickH = canvasSide / boardHeight;
    double brickX = (x * brickW) + brickMargin;
    double brickY = (y * brickH) + brickMargin;
    return Rect.fromPoints(
      Offset(
        brickX + xPadding,
        brickY + yPadding,
      ),
      Offset(
        brickX + brickW - brickMargin + xPadding - boardMargin,
        brickY + brickH - brickMargin + yPadding - boardMargin,
      ),
    );
  }

  static Color getColor(int value) {
    MaterialColor baseColor = Colors.yellow;
    MaterialColor greaterColor = Colors.orange;
    switch (value) {
      case 2:
        return baseColor.shade100;
      case 4:
        return baseColor.shade200;
      case 8:
        return baseColor.shade300;
      case 16:
        return baseColor.shade400;
      case 32:
        return baseColor.shade500;
      case 64:
        return baseColor.shade600;
      case 128:
        return baseColor.shade800;
      case 256:
        return baseColor.shade900;
      case 512:
        return greaterColor.shade400;
      case 1024:
        return greaterColor.shade500;
      case 2048:
        return greaterColor.shade600;
      default:
        return Colors.black;
    }
  }
}

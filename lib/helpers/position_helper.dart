import 'dart:ui';

const boardMargin = 5;
const brickMargin = 5;

class PositionHelper {
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
}

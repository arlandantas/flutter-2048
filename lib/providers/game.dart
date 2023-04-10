import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter2048/types/brick.dart';
import 'package:flutter2048/types/brick_move.dart';
import 'package:flutter2048/types/directions.dart';
import 'package:flutter2048/types/position.dart';

const Duration movingDelay = Duration(milliseconds: 300);

class Game extends ChangeNotifier {
  final Random random = Random();
  int maxExponent = 1;
  int minExponent = 1;
  int filledNumbers = 0;
  int maxValue = 2;
  bool moving = false;
  Set<BrickMove> pendingMoves = {};
  Set<Brick> bricks = {};
  final int boardWidth;
  final int boardHeight;
  late List<List<int>> boardData;
  late int cellsQty;
  Game({this.boardWidth = 4, this.boardHeight = 4}) {
    boardData = List<List<int>>.generate(
      boardHeight,
      (_) => List<int>.generate(
        boardWidth,
        (_) => 0,
      ),
    );
    cellsQty = boardHeight * boardWidth;
    start();
  }

  start() {
    walkToBoard((y, x) {
      boardData[y][x] = 0;
    });
    for (var i = 0; i < 3; i++) {
      addNumber();
    }
    moving = false;
    updateBricks();
    notifyListeners();
  }

  getCellValue({required int x, required int y}) {
    return boardData[y][x];
  }

  String getCellText({required int x, required int y}) {
    int value = getCellValue(x: x, y: y);
    if (value == 0) return '';
    return '$value';
  }

  addNumber() {
    filledNumbers = 0;
    walkToBoard((y, x) {
      if (getCellValue(x: x, y: y) != 0) {
        ++filledNumbers;
      }
    });
    if (filledNumbers >= cellsQty) {
      return;
    }
    int x = -1;
    int y = -1;
    do {
      x = random.nextInt(boardWidth);
      y = random.nextInt(boardHeight);
    } while (getCellValue(x: x, y: y) != 0);
    int value = maxExponent != minExponent ? (minExponent + random.nextInt(maxExponent - minExponent)) : minExponent;
    boardData[y][x] = pow(2, value).toInt();
    ++filledNumbers;
  }

  List<List<int>> getUnrotatedBoard(List<List<int>> board, Directions direction) {
    Directions unrotateDirection = Directions.left;
    switch (direction) {
      case Directions.up:
        unrotateDirection = Directions.down;
        break;
      case Directions.down:
        unrotateDirection = Directions.up;
        break;
      case Directions.right:
        unrotateDirection = Directions.right;
        break;
      default:
    }
    return getRotatedBoard(board, unrotateDirection);
  }

  Position getRotatedPosition(Position origin, Directions direction) {
    switch (direction) {
      case Directions.up:
        return Position(x: boardHeight - origin.y - 1, y: origin.x);
      case Directions.down:
        return Position(x: origin.y, y: boardWidth - 1 - origin.x);
      case Directions.right:
        return Position(x: boardHeight - origin.x - 1, y: boardWidth - 1 - origin.y);
      default:
        return origin;
    }
  }

  List<List<int>> getRotatedBoard(List<List<int>> board, Directions direction) {
    return List<List<int>>.generate(
      boardHeight,
      (y) => List.generate(
        boardWidth,
        (x) {
          Position rotatedPosition = getRotatedPosition(
            Position(x: x, y: y),
            direction,
          );
          return board[rotatedPosition.y][rotatedPosition.x];
        },
      ),
    );
  }

  walkToBoard(Function(int i, int j) callback, {int minX = 0}) {
    for (var i = 0; i < boardData.length; i++) {
      for (var j = minX; j < boardData[i].length; j++) {
        callback(i, j);
      }
    }
  }

  resetPendingMoves() {
    pendingMoves = {};
    moving = false;
    notifyListeners();
  }

  move(Directions direction) {
    if (moving) return;

    moving = true;
    var rotatedBoard = getRotatedBoard(boardData, direction);
    Set<Position> blockedCells = {};
    bool anyMove = false;
    Set<BrickMove> rotatedPendingMoves = {};

    registryMove(Position origin, Position target) {
      if (origin.isSame(target)) return;
      int targetValue = rotatedBoard[target.y][target.x];
      int originValue = rotatedBoard[origin.y][origin.x];
      int finalValue = originValue + targetValue;

      if (finalValue > maxValue) {
        maxValue = finalValue;
      }
      if (targetValue > 0) {
        blockedCells.add(target);
      }

      rotatedBoard[origin.y][origin.x] = 0;
      rotatedBoard[target.y][target.x] = finalValue;
      rotatedPendingMoves.add(BrickMove(
        origin: origin,
        target: target,
        startValue: originValue,
        finalValue: finalValue,
      ));
      anyMove = true;
    }

    isBlocked(Position position) {
      return blockedCells.any((element) => element.x == position.x && element.y == position.y);
    }

    walkToBoard((i, j) {
      final int originValue = rotatedBoard[i][j] + 0;
      if (originValue == 0) return;

      Position originPosition = Position(x: j, y: i);
      checkCell(int y, int x) {
        int targetValue = rotatedBoard[y][x];
        if (targetValue != 0 || x == 0) {
          Position targetPosition = Position(x: x, y: y);
          bool differentValue = targetValue != 0 && targetValue != originValue;
          if (isBlocked(targetPosition) || differentValue) {
            registryMove(originPosition, Position(x: x + 1, y: y));
            return;
          }
          registryMove(originPosition, Position(x: x, y: y));
          return;
        }
        checkCell(y, x - 1);
      }

      checkCell(i, j - 1);
    }, minX: 1);
    boardData = getUnrotatedBoard(rotatedBoard, direction);
    pendingMoves = rotatedPendingMoves
        .map(
          (e) => BrickMove(
            origin: getRotatedPosition(e.origin, direction),
            target: getRotatedPosition(e.target, direction),
            startValue: e.startValue,
            finalValue: e.finalValue,
          ),
        )
        .toSet();
    if (anyMove) addNumber();
    updateBricks();
    notifyListeners();
  }

  updateBricks() {
    bricks = {};
    walkToBoard((x, y) {
      int value = boardData[y][x];
      if (value != 0) {
        bricks.add(Brick(
          x: x.toDouble(),
          y: y.toDouble(),
          value: value,
        ));
      }
    });
  }
}

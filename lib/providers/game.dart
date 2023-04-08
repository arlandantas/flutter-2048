import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter2048/types/brick.dart';
import 'package:flutter2048/types/cell_move.dart';
import 'package:flutter2048/types/directions.dart';
import 'package:flutter2048/types/position.dart';

const Duration movingDelay = Duration(milliseconds: 200);

class Game extends ChangeNotifier {
  final Random random = Random();
  int maxExponent = 1;
  int minExponent = 1;
  int filledNumbers = 0;
  bool moving = false;
  Set<CellMove> pendingMoves = {};
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
    for (var i = 0; i < 5; i++) {
      addNumber();
    }
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

  setCellValue({required int x, required int y, required int value}) {
    boardData[y][x] = value;
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
    notifyListeners();
  }

  move(Directions direction) {
    if (moving) return;

    print("Moving to $direction");
    moving = true;
    var rotatedBoard = getRotatedBoard(boardData, direction);
    Set<Position> blockedCells = {};
    bool anyMove = false;
    Set<CellMove> rotatedPendingMoves = {};
    walkToBoard((i, j) {
      final int originValue = rotatedBoard[i][j] + 0;
      if (originValue == 0) return;

      registryMove(Position origin, Position target) {
        if (origin.isSame(target)) return;
        int finalValue = rotatedBoard[origin.y][origin.x] + rotatedBoard[target.y][target.x];

        rotatedBoard[origin.y][origin.x] = 0;
        rotatedBoard[target.y][target.x] = finalValue;
        rotatedPendingMoves.add(CellMove(
          origin: origin,
          target: target,
          finalValue: finalValue,
        ));
        anyMove = true;
      }

      Position originPosition = Position(x: j, y: i);
      checkCell(int y, int x) {
        int targetValue = rotatedBoard[y][x];
        if (targetValue != 0 || x == 0) {
          Position targetPosition = Position(x: x, y: y);
          if (blockedCells.contains(targetPosition) || (targetValue != 0 && targetValue != originValue)) {
            registryMove(originPosition, Position(x: x + 1, y: y));
            return;
          }
          registryMove(originPosition, Position(x: x, y: y));
          if (targetValue != 0) {
            blockedCells.add(targetPosition);
          }
          return;
        }
        checkCell(y, x - 1);
      }

      checkCell(i, j - 1);
    }, minX: 1);
    boardData = getUnrotatedBoard(rotatedBoard, direction);
    pendingMoves = rotatedPendingMoves
        .map(
          (e) => CellMove(
            origin: getRotatedPosition(e.origin, direction),
            target: getRotatedPosition(e.target, direction),
            finalValue: e.finalValue,
          ),
        )
        .toSet();
    if (anyMove) addNumber();
    updateBricks();
    notifyListeners();
    Timer(movingDelay, () {
      moving = false;
    });
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

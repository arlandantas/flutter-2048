import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter2048/helpers/directions.dart';

class Game extends ChangeNotifier {
  final Random random = Random();
  int maxExponent = 1;
  int minExponent = 1;
  int filledNumbers = 0;
  final int boardWidth;
  final int boardHeight;
  late List<List<int>> boardData;
  late int cellsQty;
  Game({this.boardWidth = 4, this.boardHeight = 4}) {
    boardData = List<List<int>>.generate(
      boardHeight,
      (_) => List<int>.generate(boardWidth, (_) => 0),
    );
    cellsQty = boardHeight * boardWidth;
    for (var i = 0; i < 5; i++) {
      addNumber();
    }
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
    boardData[y][x] = value;
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

  List<List<int>> getRotatedBoard(List<List<int>> board, Directions direction) {
    return List<List<int>>.generate(
      boardHeight,
      (i) => List.generate(boardWidth, (j) {
        switch (direction) {
          case Directions.up:
            return board[j][boardHeight - 1 - i];
          case Directions.down:
            return board[boardWidth - 1 - j][i];
          case Directions.right:
            return board[boardHeight - 1 - i][boardWidth - 1 - j];
          default:
            return board[i][j];
        }
      }),
    );
  }

  walkToBoard(Function(int i, int j) callback, {int minX = 0}) {
    for (var i = 0; i < boardData.length; i++) {
      for (var j = minX; j < boardData[i].length; j++) {
        callback(i, j);
      }
    }
  }

  move(Directions direction) {
    print("Moving to $direction");
    var rotatedBoard = getRotatedBoard(boardData, direction);
    Set<String> blockedCells = {};
    walkToBoard((i, j) {
      final int originValue = rotatedBoard[i][j] + 0;
      if (originValue == 0) return;

      rotatedBoard[i][j] = 0;
      checkCell(int y, int x) {
        int targetValue = rotatedBoard[y][x];
        if (targetValue != 0 || x == 0) {
          String cellKey = '$y$x';
          if (blockedCells.contains(cellKey) || (targetValue != 0 && targetValue != originValue)) {
            rotatedBoard[y][x + 1] += originValue;
            return;
          }
          rotatedBoard[y][x] += originValue;
          if (targetValue != 0) {
            blockedCells.add(cellKey);
          }
          return;
        }
        checkCell(y, x - 1);
      }

      checkCell(i, j - 1);
    }, minX: 1);
    boardData = getUnrotatedBoard(rotatedBoard, direction);
    addNumber();
    notifyListeners();
  }
}

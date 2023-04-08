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
    printBoard(boardData);
  }

  getCellValue({required int x, required int y}) {
    return boardData[y][x];
  }

  setCellValue({required int x, required int y, required int value}) {
    boardData[y][x] = value;
  }

  addNumber() {
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
    setCellValue(x: x, y: y, value: value);
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

  printBoard(List<List<int>> board) {
    String ret = '';
    walkToBoard((i, j) {
      int v = board[i][j];
      // ret += '${v < 10 ? '0' : ''}$v ';
      ret += '$v ';
      if (j == boardWidth - 1) {
        ret += '\n';
      }
    });
    print('\n$ret');
  }

  move(Directions direction) {
    print("Moving to $direction");
    var rotatedBoard = getRotatedBoard(boardData, direction);
    walkToBoard((i, j) {
      final int curValue = rotatedBoard[i][j] + 0;
      if (curValue == 0) return;

      if (rotatedBoard[i][j - 1] != 0) {
        rotatedBoard[i][j - 1] += curValue;
        rotatedBoard[i][j] = 0;
        return;
      }

      rotatedBoard[i][j] = 0;
      for (var k = j - 1; k > 0; k--) {
        if (rotatedBoard[i][k] != 0) {
          rotatedBoard[i][k + 1] = curValue;
          return;
        }
      }
      rotatedBoard[i][0] += curValue;
    }, minX: 1);
    boardData = getUnrotatedBoard(rotatedBoard, direction);
    printBoard(boardData);
    notifyListeners();
  }
}

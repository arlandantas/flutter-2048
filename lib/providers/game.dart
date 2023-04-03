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
    boardData = List<List<int>>.filled(boardHeight, List.filled(boardWidth, 0));
    cellsQty = boardHeight * boardWidth;
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
    } while (getCellValue(x: x, y: y));
    int value = maxExponent != minExponent ? (minExponent + random.nextInt(maxExponent - minExponent)) : minExponent;
    setCellValue(x: x, y: y, value: value);
    ++filledNumbers;
  }

  move(Directions direction) {
    print("Moving to $direction");
  }
}

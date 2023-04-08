import 'package:flutter2048/types/position.dart';

class CellMove {
  final Position origin;
  final Position target;
  final int finalValue;
  CellMove({
    required this.origin,
    required this.target,
    required this.finalValue,
  });
}

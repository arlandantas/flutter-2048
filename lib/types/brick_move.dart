import 'package:flutter2048/types/position.dart';

class BrickMove {
  final Position origin;
  final Position target;
  final int startValue;
  final int finalValue;
  BrickMove({
    required this.origin,
    required this.target,
    required this.startValue,
    required this.finalValue,
  });
}

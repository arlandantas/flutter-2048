import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter2048/components/game_board.dart';
import 'package:flutter2048/components/game_move_buttons.dart';
import 'package:flutter2048/types/directions.dart';

class ArrowDetect extends StatefulWidget {
  const ArrowDetect({
    super.key,
    required this.child,
    this.autofocus = true,
    this.onDirection = ignoreDirection,
    this.onArrowDown = ignoreKey,
    this.onArrowUp = ignoreKey,
    this.onArrowLeft = ignoreKey,
    this.onArrowRight = ignoreKey,
  });

  final Widget child;
  final bool autofocus;
  final Function(Directions direction) onDirection;
  final Function() onArrowDown;
  final Function() onArrowUp;
  final Function() onArrowLeft;
  final Function() onArrowRight;
  void callArrowFunction(String key) {
    if (!handleableKeys.contains(key)) {
      return;
    }

    Directions direction = keyDirection.entries.firstWhere((element) => element.key == key).value;
    switch (direction) {
      case Directions.up:
        onArrowUp();
        break;
      case Directions.down:
        onArrowDown();
        break;
      case Directions.right:
        onArrowRight();
        break;
      case Directions.left:
        onArrowLeft();
        break;
      default:
    }
    onDirection(direction);
  }

  @override
  State<ArrowDetect> createState() => _ArrowDetectState();
}

void ignoreDirection(Directions d) {}
void ignoreKey() {}
const keyResetDelay = Duration(milliseconds: 100);
const List<String> handleableKeys = [
  'Arrow Up',
  'Arrow Down',
  'Arrow Left',
  'Arrow Right',
  'A',
  'S',
  'D',
  'W',
];
const Map<String, Directions> keyDirection = {
  'Arrow Up': Directions.up,
  'Arrow Down': Directions.down,
  'Arrow Left': Directions.left,
  'Arrow Right': Directions.right,
  'A': Directions.left,
  'S': Directions.down,
  'D': Directions.right,
  'W': Directions.up,
};

class _ArrowDetectState extends State<ArrowDetect> {
  Map<String, Timer> rowsFuture = {};

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
      onKeyEvent: (node, event) {
        String keyLabel = event.logicalKey.keyLabel;

        if (!handleableKeys.contains(keyLabel)) {
          return KeyEventResult.ignored;
        }

        if (rowsFuture.containsKey(keyLabel)) {
          rowsFuture.entries
              .firstWhere(
                (element) => element.key == keyLabel,
              )
              .value
              .cancel();
          rowsFuture.remove(keyLabel);
        }
        setState(() {
          rowsFuture.addAll({
            keyLabel: Timer(
              keyResetDelay,
              () => widget.callArrowFunction(keyLabel),
            ),
          });
        });
        return KeyEventResult.handled;
      },
      child: widget.child,
    );
  }
}

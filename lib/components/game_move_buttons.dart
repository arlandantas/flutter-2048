import 'package:flutter/material.dart';
import 'package:flutter2048/helpers/directions.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:provider/provider.dart';

class GameMoveButtons extends StatelessWidget {
  const GameMoveButtons({super.key});

  moveBoard(BuildContext context, Directions direction) {
    return Provider.of<Game>(context, listen: false).move(direction);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: MaterialButton(
            onPressed: () => moveBoard(context, Directions.down),
            height: 80,
            child: const Icon(Icons.keyboard_arrow_down),
          ),
        ),
        Expanded(
          child: MaterialButton(
            onPressed: () => moveBoard(context, Directions.up),
            height: 80,
            child: const Icon(Icons.keyboard_arrow_up),
          ),
        ),
        Expanded(
          child: MaterialButton(
            onPressed: () => moveBoard(context, Directions.left),
            height: 80,
            child: const Icon(Icons.keyboard_arrow_left),
          ),
        ),
        Expanded(
          child: MaterialButton(
            onPressed: () => moveBoard(context, Directions.right),
            height: 80,
            child: const Icon(Icons.keyboard_arrow_right),
          ),
        ),
      ],
    );
  }
}
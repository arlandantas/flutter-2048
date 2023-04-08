import 'package:flutter/material.dart';
import 'package:flutter2048/components/arrow_detect.dart';
import 'package:flutter2048/components/game_board.dart';
import 'package:flutter2048/components/game_move_buttons.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, this.title = '2048 Game'});

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game game = Game();

  @override
  Widget build(BuildContext context) {
    print("Rebuild game page");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ChangeNotifierProvider(
        create: (context) => game,
        child: ArrowDetect(
          autofocus: true,
          onDirection: game.move,
          child: Column(
            children: const [
              Expanded(
                child: GameBoard(
                  boardWidth: 4,
                  boardHeight: 4,
                ),
              ),
              GameMoveButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

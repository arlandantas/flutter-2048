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
    Size size = MediaQuery.of(context).size;
    bool isLandscape = size.width > size.height;
    double width = isLandscape ? (size.height - 80) : size.width;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SizedBox.fromSize(
          size: Size(width, size.height),
          child: ChangeNotifierProvider(
            create: (context) => game,
            child: ArrowDetect(
              autofocus: true,
              onDirection: game.move,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: game.start,
                          height: 80,
                          child: const Text('NEW GAME'),
                        ),
                      ),
                    ],
                  ),
                  const Expanded(
                    child: GameBoard(),
                  ),
                  const GameMoveButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

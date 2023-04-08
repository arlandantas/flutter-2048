import 'package:flutter/material.dart';
import 'package:flutter2048/providers/game.dart';
import 'package:provider/provider.dart';

class GameBricks extends StatefulWidget {
  const GameBricks({super.key});

  @override
  State<GameBricks> createState() => _GameBricksState();
}

class _GameBricksState extends State<GameBricks> {
  @override
  void initState() {
    super.initState();

    Provider.of<Game>(context, listen: false).addListener(() => gameUpdated(context));
  }

  gameUpdated(BuildContext context) {
    Game game = context.read<Game>();
    if (game.pendingMoves.isEmpty) return;

    print("Updated: ${game.pendingMoves}");
    game.resetPendingMoves();
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuild game page");

    return const Text('BRICKS');
    // Positioned.fromRect(
    //   rect: Rect.fromPoints(const Offset(20, 20), const Offset(50, 50)),
    //   child: Container(
    //     height: 50,
    //     width: 50,
    //     color: Colors.blueAccent,
    //     child: const Text("Aloouu"),
    //   ),
    // )
  }
}

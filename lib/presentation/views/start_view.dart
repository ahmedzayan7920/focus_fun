import 'package:flutter/material.dart';
import 'package:piano_tiles_2/presentation/views/choose_game_view.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center.add(const Alignment(0, 0.1)),
        children: [
          Image.asset(
            "assets/bg.gif",
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChooseGameView(),
                ),
              );
            },
            child: Container(
              height: 100,
              width: 280,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

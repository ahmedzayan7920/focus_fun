import 'package:flutter/material.dart';

import '../../provider/game_state.dart';

class Tile extends StatelessWidget {
  final NoteState state;
  final double height;
  final VoidCallback onTapDown;
  final int index;

  const Tile({
    super.key,
    required this.state,
    required this.height,
    required this.onTapDown,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: GestureDetector(
          onTapDown: (_) {
            onTapDown();
          },
          // onTapUp: (_) async{
          //  await  audioPlayer.setVolume(0.5);
          //  await Future.delayed(const Duration(milliseconds: 500));
          //   audioPlayer.pause();
          // },
          child: Container(
            color: color,
            child: index == 0
                ? SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset(
                      'assets/tip.gif',
                      color: Colors.blue,
                      width: 50,
                      height: 50,
                    ))
                : const Text(""),
          )),
    );
  }

  Color get color {
    switch (state) {
      case NoteState.ready:
        return Colors.black;
      case NoteState.missed:
        return Colors.red;
      case NoteState.tapped:
        return Colors.blue.withOpacity(.2);
      default:
        return Colors.black;
    }
  }
}

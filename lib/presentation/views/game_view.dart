import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../model/song_model.dart';

import '../../model/node_model.dart';
import '../../provider/game_state.dart';
import '../../provider/mission_provider.dart';
import '../widgets/custom_progress_stars.dart';
import '../widgets/custom_restart_dialog.dart';
import '../widgets/line.dart';
import '../widgets/line_divider.dart';

class GameView extends StatefulWidget {
  const GameView({
    super.key,
    required this.song,
  });

  final SongModel song;

  @override
  State<StatefulWidget> createState() => _GameViewState();
}

class _GameViewState extends State<GameView>
    with SingleTickerProviderStateMixin {
  late List<Note> notes = mission();
  AudioPlayer tapPlayer = AudioPlayer();
  AudioPlayer losePlayer = AudioPlayer();
  AudioPlayer audioPlayer = AudioPlayer();
  late AnimationController animationController;
  int currentNoteIndex = 0;
  int points = 0;
  bool hasStarted = false;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    tapPlayer.setVolume(0.02);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 0),
    );
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isPlaying) {
        if (notes[currentNoteIndex].state != NoteState.tapped) {
          int previousPoints = widget.song.points;
          if (points > previousPoints) {
            sharedPreferences.setInt(widget.song.path, points);
          }
          audioPlayer.stop();
          setState(() {
            isPlaying = false;
            notes[currentNoteIndex].state = NoteState.missed;
          });
          if (notes[currentNoteIndex].orderNumber != 0) {
            losePlayer.play(AssetSource('a.wav'));
          }
          animationController.reverse().then((_) {
            if (notes[currentNoteIndex].orderNumber != 0) {
              _showFinishDialog();
            } else {
              _restart();
            }
          });
        } else if (currentNoteIndex == notes.length - 5) {
          //song finished
          _showFinishDialog();
          audioPlayer.stop();
        } else if (points == 150) {
          int previousPoints = widget.song.points;
          if (points > previousPoints) {
            sharedPreferences.setInt(widget.song.path, points);
          }
          _showFinishDialog();
          audioPlayer.stop();
        } else {
          setState(() => ++currentNoteIndex);
          animationController.forward(from: 0);
        }
      }
    });
    animationController.forward(from: -1);
  }

  void _onTap(Note note) {
    bool areAllPreviousTapped = notes
        .sublist(0, note.orderNumber)
        .every((n) => n.state == NoteState.tapped);

    if (areAllPreviousTapped) {
      if (!hasStarted) {
        audioPlayer.play(
          AssetSource(widget.song.path),
          position: const Duration(seconds: 1),
        );
        setState(() => hasStarted = true);
        animationController.forward();
      }
      _playNote(note);
      setState(() {
        if (note.state != NoteState.tapped) {
          ++points;
        }
        note.state = NoteState.tapped;

        if (points == 50) {
          animationController.duration = const Duration(milliseconds: 400);
        } else if (points == 100) {
          animationController.duration = const Duration(milliseconds: 300);
        } else if (points == 150) {
          animationController.duration = const Duration(milliseconds: 200);
        }
      });
    }
  }

  _drawLine(int lineNumber) {
    return Expanded(
      child: Line(
        lineNumber: lineNumber,
        currentNotes: notes.sublist(currentNoteIndex, currentNoteIndex + 5),
        animation: animationController,
        onTileTap: _onTap,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    tapPlayer.dispose();
    audioPlayer.dispose();
    losePlayer.dispose();
  }

  void _restart() {
    setState(() {
      hasStarted = false;
      isPlaying = true;
      notes = mission();
      points = 0;
      currentNoteIndex = 0;
      animationController.duration = const Duration(milliseconds: 700);
    });
    animationController.reset();
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomRestartDialog(points: points, restart: _restart);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              child: Image.asset(
                "assets/background.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: <Widget>[
                _drawLine(0),
                const LineDivider(),
                _drawLine(1),
                const LineDivider(),
                _drawLine(2),
                const LineDivider(),
                _drawLine(3)
              ],
            ),
            CustomProgressStars(points: points),
          ],
        ),
      ),
    );
  }

  _playNote(Note note) {
    tapPlayer.play(AssetSource('a.wav'));
  }
}

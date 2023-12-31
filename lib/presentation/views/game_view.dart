import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:piano_tiles_2/main.dart';
import 'package:piano_tiles_2/model/song_model.dart';

import '../../model/node_model.dart';
import '../../provider/game_state.dart';
import '../../provider/mission_provider.dart';
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
        }
        else {
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
          animationController.duration = const Duration(milliseconds: 600);
        } else if (points == 100) {
          animationController.duration = const Duration(milliseconds: 500);
        } else if (points == 150) {
          animationController.duration = const Duration(milliseconds: 400);
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

class CustomRestartDialog extends StatelessWidget {
  const CustomRestartDialog({
    super.key,
    required this.points,
    required this.restart,
  });

  final int points;
  final dynamic restart;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: Colors.grey,
          ),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                restart();
              },
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(150)),
                ),
                child: const Icon(Icons.play_arrow, size: 50),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(150)),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  "مجموع النقاط: $points",
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomScoreStars(points: points),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(),
              child: const Text("رجوع", style: TextStyle(fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomProgressStars extends StatelessWidget {
  const CustomProgressStars({super.key, required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 50,
      left: 50,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    49,
                    (index) => Container(
                      height: 4,
                      width: 1.2,
                      color: index < points ? Colors.yellow : Colors.blueGrey,
                    ),
                  ),
                  Icon(
                    Icons.star,
                    color: points >= 50 ? Colors.yellow : Colors.blueGrey,
                  ),
                  ...List.generate(
                    49,
                    (index) => Container(
                      height: 4,
                      width: 1.2,
                      color: (index + 50) < points
                          ? Colors.yellow
                          : Colors.blueGrey,
                    ),
                  ),
                  Icon(
                    Icons.star,
                    color: points >= 100 ? Colors.yellow : Colors.blueGrey,
                  ),
                  ...List.generate(
                    49,
                    (index) => Container(
                      height: 4,
                      width: 1.2,
                      color: (index + 100) < points
                          ? Colors.yellow
                          : Colors.blueGrey,
                    ),
                  ),
                  Icon(
                    Icons.star,
                    color: points >= 150 ? Colors.yellow : Colors.blueGrey,
                  ),
                ],
              ),
            ),
            CustomPointsText(points: points),
          ],
        ),
      ),
    );
  }
}

class CustomScoreStars extends StatelessWidget {
  const CustomScoreStars({super.key, required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          points >= 50 ? Icons.star : Icons.star_border_outlined,
          color: points >= 50 ? Colors.yellow : Colors.grey,
        ),
        Icon(
          points >= 100 ? Icons.star : Icons.star_border_outlined,
          color: points >= 100 ? Colors.yellow : Colors.grey,
        ),
        Icon(
          points >= 150 ? Icons.star : Icons.star_border_outlined,
          color: points >= 150 ? Colors.yellow : Colors.grey,
        ),
      ],
    );
  }
}

class CustomPointsText extends StatelessWidget {
  const CustomPointsText({super.key, required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Text(
          "$points",
          style: const TextStyle(color: Colors.red, fontSize: 60),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../main.dart';
import '../../model/song_model.dart';
import 'game_view.dart';

import '../widgets/custom_score_stars.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<SongModel> songs = [];
  int stars = 0;

  @override
  void initState() {
    initSongs();
    super.initState();
  }

  void initSongs() {
    songs = [
      SongModel(
        name: "Für Elise",
        actor: "Beethoven",
        path: "1.wav",
        points: sharedPreferences.getInt("1.wav") ?? 0,
      ),
      SongModel(
        name: "Symphony No. 40 in G Minor",
        actor: "Wolfgang Amadeus Mozart",
        path: "2.wav",
        points: sharedPreferences.getInt("2.wav") ?? 0,
      ),
      SongModel(
        name: "Brandenburg Concertos",
        actor: "Johann Sebastian Bach",
        path: "3.wav",
        points: sharedPreferences.getInt("3.wav") ?? 0,
      ),
      SongModel(
        name: "Water Music",
        actor: "George Frideric Handel",
        path: "4.wav",
        points: sharedPreferences.getInt("4.wav") ?? 0,
      ),
      SongModel(
        name: "The Four Seasons",
        actor: "Antonio Vivaldi",
        path: "6.wav",
        points: sharedPreferences.getInt("6.wav") ?? 0,
      ),
    ];
    initStars();
    setState(() {});
  }

  void initStars() {
    stars = 0;
    for (int i = 0; i < songs.length; i++) {
      songs[i].points >= 150
          ? stars = stars + 3
          : songs[i].points >= 100
              ? stars = stars + 2
              : songs[i].points >= 50
                  ? stars = stars + 1
                  : stars;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFE2F0),
      body: Stack(
        children: [

          SafeArea(
            child: IconButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 60,
                color: Colors.black,
              ),
            ),
          ),
          Column(
            children: [
              const SafeArea(
                child: Text(
                  "Piano Tiles",
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Text(
                      "$stars",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 20,
                      margin: const EdgeInsets.all(8),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 70,
                                    height: double.infinity,
                                    color: Colors.yellow,
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      "${index + 1}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    right: -20,
                                    bottom: -20,
                                    child: Icon(
                                      Icons.star,
                                      size: 70,
                                      color: Colors.yellowAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    songs[index].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    songs[index].actor,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  CustomScoreStars(points: songs[index].points),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GameView(
                                          song: songs[index],
                                        ),
                                      ),
                                    ).then((value) {
                                      initSongs();
                                    });
                                  },
                                  child: const Text("ابدأ", style: TextStyle(fontSize: 18),),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

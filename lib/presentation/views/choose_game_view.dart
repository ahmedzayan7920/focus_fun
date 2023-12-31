import 'package:flutter/material.dart';
import 'package:piano_tiles_2/presentation/views/home_view.dart';

class ChooseGameView extends StatelessWidget {
  const ChooseGameView({super.key});

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
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: double.infinity),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeView(),
                        ),
                      );
                    },
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/piano.png",
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 50,
                          width: 300,
                          color: const Color(0xFF14C1FD),
                          child: const Center(
                            child: Text(
                              "Piano Tiles",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const HomeView(),
                      //   ),
                      // );
                    },
                    overlayColor:
                        const MaterialStatePropertyAll(Colors.transparent),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Image.asset(
                          "assets/icy.png",
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 50,
                          width: 300,
                          color: const Color(0xFF14C1FD),
                          child: const Center(
                            child: Text(
                              "Icy Tower",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

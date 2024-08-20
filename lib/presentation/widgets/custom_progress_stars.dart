import 'package:flutter/material.dart';

import 'custom_points_text.dart';

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
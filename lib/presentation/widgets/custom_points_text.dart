import 'package:flutter/material.dart';

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

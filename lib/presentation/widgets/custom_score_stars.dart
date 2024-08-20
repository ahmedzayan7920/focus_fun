import 'package:flutter/material.dart';

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


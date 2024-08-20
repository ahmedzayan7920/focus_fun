import 'package:flutter/material.dart';

import 'custom_score_stars.dart';

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

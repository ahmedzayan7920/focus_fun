import 'dart:math';

import '../model/node_model.dart';

List<Note> mission() {
  final random = Random();

  int nextUnique(int min, int max, int previous) {
    num nextValue = -1;
    do {
      nextValue = min + random.nextInt(max - min);
    } while (nextValue == previous);
    return nextValue.toInt();
  }

  List<Note> notes = [];
  int previousValue = -1;
  for (int i = 0; i < 1000; i++) {
    int newValue = nextUnique(0, 4, previousValue);
    notes.add(Note(i, newValue));
    previousValue = newValue;
  }
  return notes;
}

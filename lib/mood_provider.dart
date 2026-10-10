
import 'package:flutter/material.dart';

class MoodEntry {
  final int mood;
  final String note;
  final DateTime time;

  MoodEntry({
    required this.mood,
    required this.note,
    required this.time,
  });
}

class MoodProvider extends ChangeNotifier {
  final List<MoodEntry> _entries = [];

  List<MoodEntry> get entries => List.unmodifiable(_entries);

  void addMood(int mood, String note) {
    _entries.insert(
      0,
      MoodEntry(
        mood: mood,
        note: note,
        time: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void deleteMood(MoodEntry entry) {
    _entries.remove(entry);
    notifyListeners();
  }
}

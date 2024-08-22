import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class StreakProvider extends ChangeNotifier {
  int streak = 0;
  int highestStreak = 0;
  late SharedPreferences _prefs;

  StreakProvider() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    highestStreak = _prefs.getInt('highestStreak') ?? 0;

    notifyListeners();
  }

  void updateHighStreak() {
    if (streak > highestStreak) {
      highestStreak = streak;
      _prefs.setInt('highestStreak', highestStreak);

      notifyListeners();
    }
  }

  void resetStreak() {
    if (streak != 0) {
      streak = 0;
      notifyListeners();
    }
  }

  void incrementStreak() {
    streak++;
    updateHighStreak();

    notifyListeners();
  }
}

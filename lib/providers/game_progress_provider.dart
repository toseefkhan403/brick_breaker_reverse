import 'package:flutter/material.dart';

import 'package:brick_breaker_reverse/components/level_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameProgressProvider extends ChangeNotifier {
  int score = 0;
  LevelConfig currentLevel = level1;
  bool shouldApplyRedColor = false;
  late SharedPreferences _prefs;
  int highScore = 0;

  GameProgressProvider() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    highScore = _prefs.getInt('highScore') ?? 0;

    notifyListeners();
  }

  void updateHighScore(int score) {
    if (score > highScore) {
      highScore = score;
      _prefs.setInt('highScore', highScore);

      notifyListeners();
    }
  }

  void switchRevengeMode() {
    shouldApplyRedColor = !shouldApplyRedColor;
    notifyListeners();
  }

  void resetProgress() {
    score = 0;
    currentLevel = level1;
    shouldApplyRedColor = false;
    notifyListeners();
  }

  void incrementScore() {
    score++;
    if (score == 5) {
      currentLevel = level2;
    }
    if (score == 15) {
      currentLevel = level3;
    }
    if (score == 30) {
      currentLevel = level4;
    }
    if (score == 50) {
      currentLevel = level5;
    }
    notifyListeners();
  }
}

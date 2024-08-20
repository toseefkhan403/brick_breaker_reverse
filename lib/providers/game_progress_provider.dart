import 'package:flutter/material.dart';

import 'package:brick_breaker_reverse/components/level_config.dart';

class GameProgressProvider extends ChangeNotifier {
  int score = 0;
  LevelConfig currentLevel = level1;
  bool shouldApplyRedColor = false;

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

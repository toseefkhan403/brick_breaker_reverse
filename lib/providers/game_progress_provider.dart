import 'package:brick_breaker_reverse/components/level_config.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'package:brick_breaker_reverse/widgets/utils/colors.dart';

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
      showToast();
    }
    if (score == 10) {
      currentLevel = level3;
      showToast();
    }
    if (score == 20) {
      currentLevel = level4;
      showToast();
    }
    if (score == 30) {
      currentLevel = level5;
      showToast();
    }
    notifyListeners();
  }

  void showToast() {
    toastification.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: const Text(
        'Level Up!!!\nBall speed and frequency increased!',
        style: TextStyle(color: red),
      ),
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: red,
      ),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      showProgressBar: false,
    );
  }
}

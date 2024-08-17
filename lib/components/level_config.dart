class LevelConfig {
  final double moveSpeed;
  final int intervalMilliseconds;

  LevelConfig({required this.moveSpeed, required this.intervalMilliseconds});
}

final level1 = LevelConfig(moveSpeed: 300, intervalMilliseconds: 2000);
final level2 = LevelConfig(moveSpeed: 350, intervalMilliseconds: 1500);
final level3 = LevelConfig(moveSpeed: 400, intervalMilliseconds: 1000);
final level4 = LevelConfig(moveSpeed: 450, intervalMilliseconds: 1000);
final level5 = LevelConfig(moveSpeed: 500, intervalMilliseconds: 500);

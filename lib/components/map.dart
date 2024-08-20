import 'dart:async';
import 'dart:math';

import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/components/ball.dart';
import 'package:brick_breaker_reverse/components/border_block.dart';
import 'package:brick_breaker_reverse/components/colored_brick.dart';
import 'package:brick_breaker_reverse/components/level_config.dart';
import 'package:brick_breaker_reverse/components/player.dart';
import 'package:brick_breaker_reverse/providers/game_progress_provider.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:provider/provider.dart';

class Map extends World with HasGameRef<BrickBreakerReverse>, HasDecorator {
  Map({required this.name});

  final String name;
  late TiledComponent level;
  final double scrollSpeed = 40;
  bool spawnBalls = true;

  @override
  FutureOr<void> onLoad() async {
    await _loadLevel();
    _addSpawnPoints();
    _addBorders();
    addBalls();
    return super.onLoad();
  }

  Future<void> _loadLevel() async {
    level = await TiledComponent.load('$name.tmx', Vector2.all(16));
    add(level);
  }

  void _addSpawnPoints() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('spawnPoints');
    if (spawnPointsLayer == null) return;

    final random = Random();
    for (final spawnPoint in spawnPointsLayer.objects) {
      switch (spawnPoint.class_) {
        case 'player':
          final player = Player(
            position: Vector2(spawnPoint.x - 108, spawnPoint.y + 200),
            size: Vector2(spawnPoint.width * 4, spawnPoint.height * 4),
          );
          game.player = player;
          break;
        case 'colored_brick':
          if (!game.addColoredBricks) break;
          final cb = ColoredBrick(
            brick: 'colored_brick_${random.nextInt(5) + 1}',
            position: Vector2(spawnPoint.x - 86, spawnPoint.y),
            size: Vector2(spawnPoint.width * 4, spawnPoint.height * 4),
          );
          add(cb);
          break;
      }
    }
  }

  void _addBorders() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('borders');

    if (collisionsLayer == null) return;

    for (final collision in collisionsLayer.objects) {
      switch (collision.class_) {
        case 'ground':
          BorderBlock block = BorderBlock(
            borderType: BorderType.ground,
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          add(block);
          game.borders.ground = block.y;
          break;

        case 'ceiling':
          BorderBlock block = BorderBlock(
            borderType: BorderType.ceiling,
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          add(block);
          game.borders.ceiling = block.y;
          break;

        case 'leftBorder':
          BorderBlock block = BorderBlock(
            borderType: BorderType.leftBorder,
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          add(block);
          game.borders.left = block.x;
          break;

        case 'rightBorder':
          BorderBlock block = BorderBlock(
            borderType: BorderType.rightBorder,
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          add(block);
          game.borders.right = block.x;
          break;
      }
    }
  }

  void addBalls() {
    final currentLevel =
        gameRef.buildContext?.read<GameProgressProvider>().currentLevel;

    final leftPoint = game.borders.left + 64 * 2;
    final rightPoint = game.borders.right - 64 * 2;
    final spawnXPoint =
        leftPoint + (Random().nextDouble() * (rightPoint - leftPoint));

    final ball = Ball(
        position: Vector2(spawnXPoint, game.borders.ceiling - 64 * 1),
        size: Vector2.all(64 * 2),
        horizontalDirection: DateTime.now().millisecond % 2 == 0 ? 1 : -1,
        moveSpeed: currentLevel?.moveSpeed ?? level1.moveSpeed);
    add(ball);
    Future.delayed(
        Duration(
            milliseconds: currentLevel?.intervalMilliseconds ??
                level1.intervalMilliseconds), () {
      if (spawnBalls) {
        addBalls();
      }
    });
  }
}

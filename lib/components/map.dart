import 'dart:async';

import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Map extends World with HasGameRef<BrickBreakerReverse>, HasDecorator {
  Map({required this.name});

  final String name;
  late TiledComponent level;
  final double scrollSpeed = 40;

  @override
  FutureOr<void> onLoad() async {
    await _loadLevel();
    _addSpawnPoints();
    return super.onLoad();
  }

  Future<void> _loadLevel() async {
    level = await TiledComponent.load('$name.tmx', Vector2.all(16));
    add(level);
  }

  void _addSpawnPoints() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('spawnPoints');
    if (spawnPointsLayer == null) return;
    for (final spawnPoint in spawnPointsLayer.objects) {
      switch (spawnPoint.class_) {
        case 'player':
          final player = Player(
            position: Vector2(spawnPoint.x, spawnPoint.y),
            size: Vector2(spawnPoint.width * 4, spawnPoint.height * 4),
          );
          add(player);
          break;
      }
    }
  }
}

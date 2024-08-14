import 'dart:async';

import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Map extends World with HasGameRef<BrickBreakerReverse>, HasDecorator {
  Map({required this.name});

  final String name;
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$name.tmx', Vector2.all(16));
    add(level);
    return super.onLoad();
  }
}

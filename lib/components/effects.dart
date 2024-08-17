import 'dart:async';

import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:flame/components.dart';

class Effects extends SpriteAnimationComponent
    with HasGameRef<BrickBreakerReverse> {
  Effects({required this.effect, super.position, super.size});

  final String effect;
  final double stepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(effect),
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: stepTime,
          textureSize: Vector2.all(64),
          loop: false,
        ));
    removeOnFinish = true;
    return super.onLoad();
  }
}

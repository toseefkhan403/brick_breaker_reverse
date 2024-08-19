import 'dart:async';

import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class ColoredBrick extends SpriteAnimationComponent
    with HasGameRef<BrickBreakerReverse> {
  ColoredBrick({this.brick = 'colored_brick_1', super.position, super.size});

  final String brick;

  final hitBox =
      RectangleHitbox(position: Vector2(80, 110), size: Vector2(72, 52));

  @override
  FutureOr<void> onLoad() {
    add(hitBox);
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('colored_bricks/$brick.png'),
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 0.10, textureSize: Vector2.all(64)));
    return super.onLoad();
  }

  void brickExplode() {
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('colored_bricks/colored_vfx_explosion.png'),
        SpriteAnimationData.sequenced(
          amount: 9,
          stepTime: 0.10,
          textureSize: Vector2.all(64),
          loop: false,
        ));
    animationTicker?.completed.then((_) {
      removeFromParent();
    });
  }
}

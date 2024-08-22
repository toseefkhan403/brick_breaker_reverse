import 'dart:async';

import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Paddleboard extends SpriteAnimationComponent
    with HasGameRef<BrickBreakerReverse>, KeyboardHandler {
  Paddleboard({super.position, super.size});
  final hitBox =
      RectangleHitbox(position: Vector2(69, 110), size: Vector2(120, 52));
  final double moveSpeed = 500;
  Vector2 velocity = Vector2.zero();
  double horizontalMovement = 0;
  final horizontalOffset = 26 * 4;

  @override
  FutureOr<void> onLoad() {
    add(hitBox);
    debugMode = kDebugMode;
    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('paddleboard/Paddle_shaking.png'),
        SpriteAnimationData.sequenced(
            amount: 5, stepTime: 0.10, textureSize: Vector2.all(64)));
    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    if (game.playState == PlayState.intro) {
      horizontalMovement += isLeftKeyPressed ? 1 : 0;
      horizontalMovement += isRightKeyPressed ? -1 : 0;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    _updatePaddleboardMovement(dt);
    super.update(dt);
  }

  void _updatePaddleboardMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;

    double newX = position.x + velocity.x * dt;

    if (!_isInNoGoZone(newX)) {
      position.x = newX;
    }
  }

  bool _isInNoGoZone(double newX) {
    double leftBorder = game.borders.left - 72;
    double rightBorder = game.borders.right - horizontalOffset - 82;

    if (newX < leftBorder || newX > rightBorder) {
      return true;
    }

    return false;
  }
}

import 'dart:async';

import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum PlayerDirection { left, right, up, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<BrickBreakerReverse>, KeyboardHandler {
  Player({super.position, super.size});

  final double stepTime = 0.10;
  final double moveSpeed = 150;
  // final double headSpaceOffset = 18;

  PlayerDirection playerDirection = PlayerDirection.none;
  bool isRunning = false;
  // List<CollisionBlock> collisionBlocks = [];
  Vector2 velocity = Vector2.zero();
  double horizontalMovement = 0;
  double verticalMovement = 0;
  bool showControls = false;

  @override
  FutureOr<void> onLoad() {
    priority = 1;
    add(RectangleHitbox(position: Vector2(100, 94), size: Vector2(52, 72)));
    debugMode = kDebugMode;
    _loadAnims();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    verticalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);

    if (game.playState == PlayState.playing) {
      horizontalMovement += isLeftKeyPressed ? -1 : 0;
      horizontalMovement += isRightKeyPressed ? 1 : 0;
      verticalMovement += isUpKeyPressed ? -1 : 0;

      if (horizontalMovement == -1) {
        playerDirection = PlayerDirection.left;
      } else if (horizontalMovement == 1) {
        playerDirection = PlayerDirection.right;
      } else if (verticalMovement == -1) {
        playerDirection = PlayerDirection.up;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    velocity.y = verticalMovement * moveSpeed;

    double newX = position.x + velocity.x * dt;
    double newY = position.y + velocity.y * dt;

    // if (_isWithinBoundaries(newX, newY) && !_isInNoGoZone(newX, newY)) {
    position.x = newX;
    position.y = newY;
    // }

    if (velocity.x != 0 || velocity.y != 0) {
      isRunning = true;
    } else {
      isRunning = false;
    }
    current = isRunning ? 'running' : 'idle';
  }

  void _loadAnims() {
    animations = {
      'idle': _getPlayerAnim(false),
      'running': _getPlayerAnim(true),
    };

    // current animation
    current = 'idle';
  }

  _getPlayerAnim(bool isRunning) {
    return SpriteAnimation.fromFrameData(
        game.images
            .fromCache('brick/brick_alive_${isRunning ? 'walk' : 'idle'}.png'),
        SpriteAnimationData.sequenced(
            amount: isRunning ? 4 : 5,
            textureSize: Vector2.all(64),
            stepTime: stepTime));
  }
}

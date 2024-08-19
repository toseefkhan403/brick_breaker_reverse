import 'dart:async';
import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum PlayerState { anticipation, alive, running, jumping, doubleJumping, dead }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<BrickBreakerReverse>, KeyboardHandler {
  Player({super.position, super.size});

  final double stepTime = 0.10;
  final double moveSpeed = 500;
  final double _gravity = 2000;
  final double jumpForce = 1000;
  final double terminalVelocity = 2000;
  final verticalOffset = 22 * 4;
  final horizontalOffset = 26 * 4;

  bool jump = false;
  bool doubleJump = false;
  bool isOnGround = true;

  final playerHitBox =
      RectangleHitbox(position: Vector2(100, 94), size: Vector2(52, 72));

  Vector2 velocity = Vector2.zero();
  double horizontalMovement = 0;

  @override
  FutureOr<void> onLoad() {
    priority = 1;
    add(playerHitBox);
    debugMode = kDebugMode;
    _loadAnims();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    _applyGravity(dt);
    _checkGround();
    _updatePlayerState(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isJumpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.enter) ||
        keysPressed.contains(LogicalKeyboardKey.space);

    if (game.playState == PlayState.playing) {
      horizontalMovement += isLeftKeyPressed ? -1 : 0;
      horizontalMovement += isRightKeyPressed ? 1 : 0;

      if (isJumpKeyPressed) {
        startJump();
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void playerJump() {
    velocity.y = -jumpForce;
    jump = true;
    isOnGround = false;
  }

  void playerDead() {
    // todo
    // current = PlayerState.dead;
    // removeFromParent();
    // game.playState = PlayState.gameOver;
  }

  void _playerDoubleJump() {
    velocity.y = -jumpForce * 0.8; // Reduced force for double jump
    doubleJump = true;
  }

  void _applyGravity(double dt) {
    if (!isOnGround) {
      velocity.y += _gravity * dt;
      velocity.y = velocity.y.clamp(-jumpForce, terminalVelocity);
      position.y += velocity.y * dt;
    }
  }

  void _checkGround() {
    double ground = game.borders.ground + verticalOffset;

    if (position.y >= ground - size.y) {
      position.y = ground - size.y;
      velocity.y = 0;
      isOnGround = true;
      jump = false;
      doubleJump = false;
    }
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;

    double newX = position.x + velocity.x * dt;

    if (!_isInNoGoZone(newX)) {
      position.x = newX;
    }
  }

  void _updatePlayerState(double dt) {
    PlayerState playerState = current;

    if (velocity.x > 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x < 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Determine the jumping and double jumping states
    if (velocity.y < 0) {
      if (doubleJump) {
        playerState = PlayerState.doubleJumping;
      } else {
        playerState = PlayerState.jumping;
      }
    }

    if (isOnGround) {
      if (current == PlayerState.jumping ||
          current == PlayerState.doubleJumping) {
        current = PlayerState.alive;
      } else if (current == PlayerState.alive) {
        animationTicker?.completed.then((_) {
          current = PlayerState.running;
        });
      }
      return;
    }

    // Update the current animation based on the player state
    current = playerState;
  }

  void _loadAnims() {
    animations = {
      PlayerState.anticipation: getPlayerAnim(PlayerState.anticipation),
      PlayerState.alive: getPlayerAnim(PlayerState.alive),
      PlayerState.running: getPlayerAnim(PlayerState.running),
      PlayerState.jumping: getPlayerAnim(PlayerState.jumping),
      PlayerState.doubleJumping: getPlayerAnim(PlayerState.doubleJumping),
      PlayerState.dead: getPlayerAnim(PlayerState.dead),
    };

    current = PlayerState.anticipation;
    Future.delayed(const Duration(seconds: 3), () {
      current = PlayerState.alive;
    });
  }

  getPlayerAnim(PlayerState state) {
    switch (state) {
      case PlayerState.anticipation:
        return SpriteAnimation.fromFrameData(
            game.images.fromCache('brick/brick_alive_antecipation.png'),
            SpriteAnimationData.sequenced(
              amount: 9,
              textureSize: Vector2.all(64),
              stepTime: stepTime,
            ));
      case PlayerState.alive:
        return SpriteAnimation.fromFrameData(
            game.images.fromCache('brick/brick_alive_turn_vertical.png'),
            SpriteAnimationData.sequenced(
                amount: 7,
                textureSize: Vector2.all(64),
                stepTime: stepTime,
                loop: false));
      case PlayerState.running:
        return SpriteAnimation.fromFrameData(
            game.images.fromCache('brick/brick_alive_walk.png'),
            SpriteAnimationData.sequenced(
                amount: 4, textureSize: Vector2.all(64), stepTime: stepTime));
      case PlayerState.jumping:
        return SpriteAnimation.fromFrameData(
            game.images.fromCache('brick/brick_alive_jump_b.png'),
            SpriteAnimationData.sequenced(
                amount: 21, textureSize: Vector2.all(64), stepTime: stepTime));
      case PlayerState.doubleJumping:
        return SpriteAnimation.fromFrameData(
            game.images.fromCache('brick/brick_glitch.png'),
            SpriteAnimationData.sequenced(
                amount: 22, textureSize: Vector2.all(64), stepTime: stepTime));
      case PlayerState.dead:
        return SpriteAnimation.fromFrameData(
            game.images.fromCache('brick/brick_dead.png'),
            SpriteAnimationData.sequenced(
                amount: 13, textureSize: Vector2.all(64), stepTime: stepTime));
    }
  }

  bool _isInNoGoZone(double newX) {
    double leftBorder = game.borders.left - horizontalOffset;
    double rightBorder = game.borders.right + horizontalOffset;

    if (newX < leftBorder || newX > rightBorder) {
      return true;
    }

    return false;
  }

  void startJump() {
    if (isOnGround) {
      playerJump();
    } else if (!doubleJump) {
      _playerDoubleJump();
    }
  }
}

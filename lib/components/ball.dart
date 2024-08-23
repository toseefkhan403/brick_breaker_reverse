import 'dart:async';

import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/components/border_block.dart';
import 'package:brick_breaker_reverse/components/colored_brick.dart';
import 'package:brick_breaker_reverse/components/paddleboard.dart';
import 'package:brick_breaker_reverse/components/player.dart';
import 'package:brick_breaker_reverse/providers/game_progress_provider.dart';
import 'package:brick_breaker_reverse/providers/streak_provider.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

enum BallStates { red, green, explode }

class Ball extends SpriteAnimationGroupComponent
    with HasGameRef<BrickBreakerReverse>, CollisionCallbacks {
  Ball({
    this.moveSpeed = 50,
    this.horizontalDirection = 1,
    super.position,
    super.size,
  });

  final double ballSpeed = 0.07;
  final double moveSpeed;
  int horizontalDirection = 1;
  int verticalDirection = 1;
  final verticalOffset = 22 * 2;
  final horizontalOffset = 22 * 2;

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      final provider = gameRef.buildContext?.read<GameProgressProvider>();
      final streakProvider = gameRef.buildContext?.read<StreakProvider>();
      final playerTop = other.position.y + other.verticalOffset;

      if ((playerTop - intersectionPoints.first.y).abs() < 18) {
        other.playerDead();
      } else {
        current = BallStates.explode;
        // playSound(game, 'powerUp');
        streakProvider?.incrementStreak();
        other.playerJump();
        provider?.incrementScore();
        animationTicker?.completed.then((_) {
          removeFromParent();
        });
      }
    }

    if (other is ColoredBrick) {
      verticalDirection *= -1;
      other.brickExplode();
    }
    if (other is Paddleboard) {
      verticalDirection *= -1;
    }

    if (other is BorderBlock) {
      final borders = game.borders;
      final ground = borders.ground;
      final ceiling = borders.ceiling + 5;

      final yPoint = intersectionPoints.first.y;

      if (yPoint < ceiling) {
        removeFromParent();
      }

      if (yPoint < ground && yPoint > ceiling) {
        horizontalDirection *= -1;
      } else {
        verticalDirection *= -1;
      }
    }

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(CircleHitbox(position: Vector2.all(40), radius: 24));
    debugMode = kDebugMode;
    animations = {
      BallStates.red: _getBallAnims(BallStates.red),
      BallStates.green: _getBallAnims(BallStates.green),
      BallStates.explode: _getBallAnims(BallStates.explode),
    };

    current = BallStates.red;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _launch(dt);
    super.update(dt);
  }

  void _launch(double dt) {
    position.y += verticalDirection * moveSpeed * dt;
    position.x += horizontalDirection * moveSpeed * dt;

    if (position.y + 64 > game.borders.ground) {
      removeFromParent();
    }
  }

  _getBallAnims(BallStates state) {
    if (state == BallStates.explode) {
      return SpriteAnimation.fromFrameData(
          game.images.fromCache('ball/Ball_explosion_final.png'),
          SpriteAnimationData.sequenced(
            amount: 7,
            stepTime: ballSpeed,
            textureSize: Vector2.all(64),
            loop: false,
          ));
    }

    return SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'ball/Ball_${state == BallStates.red ? 'red' : 'green'}_idle.png'),
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: ballSpeed,
          textureSize: Vector2.all(64),
        ));
  }
}

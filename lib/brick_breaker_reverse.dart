import 'dart:async';

import 'package:brick_breaker_reverse/components/borders.dart';
import 'package:brick_breaker_reverse/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/map.dart';
import 'package:flame_audio/flame_audio.dart';

enum PlayState {
  startScreen,
  startMenu,
  transition,
  intro,
  intro2,
  playing,
  pauseMenu,
  about,
  gameOver
}

class BrickBreakerReverse extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection, TapCallbacks {
  late CameraComponent cam;
  late Map currentMap;

  PlayState playState = PlayState.startScreen;
  Player player = Player();
  bool playSounds = true;
  double volume = 1.0;
  final borders = Borders(left: 0, right: 0, ground: 0, ceiling: 0);

  @override
  Color backgroundColor() => const Color(0xFFb18266);

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    startBgmMusic();

    // startGame();
    overlays.add(PlayState.startScreen.name);

    return super.onLoad();
  }

  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.audioCache.loadAll(['click.wav', 'typing.mp3']);
    if (playSounds) {
      FlameAudio.bgm
          .play('Three-Red-Hearts-Pixel-War-2.mp3', volume: volume * 0.5);
    }
  }

  void loadMap({required String mapName}) {
    removeWhere(
        (component) => component is Map || component is CameraComponent);

    currentMap = Map(name: mapName);

    // this line makes it responsive! aspect ratio 16:9
    cam = CameraComponent.withFixedResolution(
        world: currentMap, width: 1920, height: 1080);
    cam.viewfinder.anchor = Anchor.center;
    cam.viewfinder.angle = 3.14;
    cam.moveBy(Vector2(1920 / 2, 1080 / 2));

    addAll([
      cam,
      currentMap,
    ]);
  }

  void startGame() {
    playState = PlayState.intro;

    Future.delayed(const Duration(milliseconds: 800), () {
      loadMap(
        mapName: 'gameMap',
      );
      Future.delayed(const Duration(milliseconds: 800), () {
        overlays.add(PlayState.intro.name);
      });
    });
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.startJump();
    super.onTapDown(event);
  }
}

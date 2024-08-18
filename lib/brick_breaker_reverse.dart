import 'dart:async';

import 'package:brick_breaker_reverse/components/borders.dart';
import 'package:brick_breaker_reverse/components/player.dart';
import 'package:brick_breaker_reverse/widgets/utils/colors.dart';
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
  bool playSounds = false;
  double volume = 1.0;
  final borders = Borders(left: 0, right: 0, ground: 0, ceiling: 0);

  @override
  Color backgroundColor() => green;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    startBgmMusic();
    overlays.add(PlayState.startScreen.name);

    return super.onLoad();
  }

  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    FlameAudio.audioCache.loadAll(['click.wav']);
    if (playSounds) {
      FlameAudio.bgm
          .play('Three-Red-Hearts-Pixel-War-2.mp3', volume: volume * 0.5);
    }
  }

  void loadMap({required String mapName}) {
    removeWhere(
        (component) => component is Map || component is CameraComponent);

    currentMap = Map(name: mapName);

    // this line makes it responsive! aspect ratio 16:9 - 32x32 in 640x360
    cam = CameraComponent.withFixedResolution(
        world: currentMap, width: 1920, height: 1080);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([
      cam,
      currentMap,
    ]);
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.startJump();
    super.onTapDown(event);
  }

  void startGame() {
    playState = PlayState.playing;
    loadMap(
      mapName: 'gameMap',
    );
    if (playSounds) {
      FlameAudio.bgm
          .play('Three Red Hearts - Box Jump.ogg', volume: volume * 0.5);
    }
  }
}

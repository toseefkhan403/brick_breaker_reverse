import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'components/map.dart';

enum PlayState {
  startScreen,
  startMenu,
  transition,
  playing,
  pauseMenu,
  gameOver
}

class BrickBreakerReverse extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  late CameraComponent cam;
  late Map currentMap;

  PlayState playState = PlayState.startScreen;

  // @override
  // Color backgroundColor() => Colors.black;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    loadMap(
      mapName: 'game_map',
    );

    return super.onLoad();
  }

  void loadMap({required String mapName}) {
    removeWhere(
        (component) => component is Map || component is CameraComponent);

    currentMap = Map(name: mapName);

    // this line makes it responsive! aspect ratio 16:9 - 32x32 in 640x360
    cam = CameraComponent.withFixedResolution(
        world: currentMap,
        width: 640,
        height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, currentMap]);
  }
}

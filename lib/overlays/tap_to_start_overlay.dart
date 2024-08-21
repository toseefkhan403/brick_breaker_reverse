import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/widgets/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class TapToStartOverlay extends StatelessWidget {
  final BrickBreakerReverse game;

  const TapToStartOverlay({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Semantics(
      label: 'Tap to start area',
      child: Container(
        width: width,
        height: height,
        color: bgColor,
        child: InkWell(
          onTap: () async {
            game.overlays.remove("tapToStart");
            game.overlays.add(PlayState.startScreen.name);
            game.startBgmMusic();
          },
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: AnimatedTextKit(
                animatedTexts: [
                  FadeAnimatedText("[Tap anywhere to start]",
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        fontSize: height > 500 ? 34 : 26,
                        color: Colors.white,
                      ),
                      duration: const Duration(milliseconds: 2000)),
                ],
                onTap: () async {
                  game.overlays.remove("tapToStart");
                  game.overlays.add(PlayState.startScreen.name);
                  game.startBgmMusic();
                },
                pause: const Duration(milliseconds: 10),
                repeatForever: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

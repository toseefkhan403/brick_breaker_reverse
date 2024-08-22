import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/components/ball.dart';
import 'package:brick_breaker_reverse/components/colored_brick.dart';
import 'package:brick_breaker_reverse/components/paddleboard.dart';
import 'package:brick_breaker_reverse/widgets/dialog_typewriter_animated_text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';

class IntroDialogOverlay extends StatefulWidget {
  final BrickBreakerReverse game;

  const IntroDialogOverlay({super.key, required this.game});

  @override
  State<IntroDialogOverlay> createState() => _IntroDialogOverlayState();
}

class _IntroDialogOverlayState extends State<IntroDialogOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    if (widget.game.playSounds) {
      FlameAudio.bgm.play('typing.mp3', volume: widget.game.volume);
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameWidth = MediaQuery.of(context).size.width;
    final gameHeight = MediaQuery.of(context).size.height;

    return FadeTransition(
      opacity: _opacityAnimation,
      child: Center(
        child: SizedBox(
          width: gameWidth / 2,
          height: gameHeight,
          child: Semantics(
            label: 'Dialogue box',
            child: AnimatedTextKit(
              animatedTexts: getAnimatedTextBasedOnEcoMeter(),
              displayFullTextOnTap: true,
              pause: const Duration(seconds: 3),
              isRepeatingAnimation: false,
              stopPauseOnTap: true,
              onNextBeforePause: (i, isLast) {
                if (widget.game.playSounds) {
                  FlameAudio.bgm.stop();
                }
              },
              onNext: (i, isLast) {
                if (widget.game.playSounds) {
                  if (isLast) {
                    FlameAudio.bgm.stop();
                  } else {
                    FlameAudio.bgm
                        .play('typing.mp3', volume: widget.game.volume);
                  }
                }
              },
              onFinished: () {
                widget.game.overlays.add(PlayState.transition.name);
                widget.game.overlays.remove(PlayState.intro.name);

                Future.delayed(const Duration(milliseconds: 800), () {
                  widget.game.cam.viewfinder.angle = 0;
                  widget.game.currentMap.removeWhere((component) =>
                      component is ColoredBrick ||
                      component is Ball ||
                      component is Paddleboard);
                  widget.game.currentMap.spawnBalls = false;

                  widget.game.currentMap.add(widget.game.player);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    widget.game.overlays.add(PlayState.intro2.name);
                    widget.game.playState = PlayState.playing;
                  });
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  List<AnimatedText> getAnimatedTextBasedOnEcoMeter() {
    final local = context.watch<LocaleProvider>().currentLocalization();

    List<AnimatedText> result = [];
    final msgs = <String>[
      local.introMessage1,
      local.introMessage2,
      local.introMessage3,
    ];

    for (var msg in msgs) {
      result.add(
        DialogTypewriterAnimatedText(
          msg,
          textStyle: const TextStyle(
            fontSize: 20.0,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          speed: const Duration(milliseconds: 35),
        ),
      );
    }

    return result;
  }
}

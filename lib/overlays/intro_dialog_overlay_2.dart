import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/providers/game_progress_provider.dart';
import 'package:brick_breaker_reverse/widgets/dialog_typewriter_animated_text.dart';
import 'package:brick_breaker_reverse/widgets/utils/colors.dart';
import 'package:brick_breaker_reverse/widgets/utils/utils.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../providers/locale_provider.dart';

class IntroDialogOverlay2 extends StatefulWidget {
  final BrickBreakerReverse game;

  const IntroDialogOverlay2({super.key, required this.game});

  @override
  State<IntroDialogOverlay2> createState() => _IntroDialogOverlay2State();
}

class _IntroDialogOverlay2State extends State<IntroDialogOverlay2>
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
              pause: const Duration(seconds: 2),
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
                context.read<GameProgressProvider>().switchRevengeMode();
                playClickSound(widget.game);
                widget.game.overlays.remove(PlayState.intro2.name);
                widget.game.currentMap.spawnBalls = true;
                widget.game.currentMap.addBalls();
                showJumpInfoToast();

                if (widget.game.playSounds) {
                  FlameAudio.bgm.play('Three-Red-Hearts-Out-of-Time.mp3',
                      volume: widget.game.volume * 0.5);
                }
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
      local.introMessage4,
      local.introMessage5,
      local.introMessage6,
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

  void showJumpInfoToast() {
    final local = context.read<LocaleProvider>().currentLocalization();

    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      title: Text(
        local.tutorialMsg,
        style: const TextStyle(color: Colors.white),
      ),
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: Colors.white,
      ),
      backgroundColor: red.withOpacity(0.8),
      autoCloseDuration: const Duration(seconds: 4),
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
    );
  }
}

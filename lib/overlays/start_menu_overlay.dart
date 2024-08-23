import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/providers/locale_provider.dart';
import 'package:brick_breaker_reverse/widgets/game_title_widget.dart';
import 'package:brick_breaker_reverse/widgets/slide_transition_widget.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:brick_breaker_reverse/widgets/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartMenuOverlay extends StatefulWidget {
  const StartMenuOverlay({super.key, required this.game});

  final BrickBreakerReverse game;

  @override
  State<StartMenuOverlay> createState() => _StartMenuOverlayState();
}

class _StartMenuOverlayState extends State<StartMenuOverlay> {
  @override
  Widget build(BuildContext context) {
    final local = context.watch<LocaleProvider>().currentLocalization();

    return SlideTransitionWidget(
        child: Center(
      child: Column(
        children: [
          const Spacer(),
          const Expanded(flex: 2, child: GameTitleWidget()),
          textButton(local.play, context, () {
            /// start the game
            widget.game.overlays.remove(PlayState.startMenu.name);
            widget.game.overlays.add(PlayState.transition.name);
            widget.game.addColoredBricks = true;
            widget.game.startGame();
            playClickSound(widget.game);
          }),
          textButton(widget.game.playSounds ? local.soundsOn : local.soundsOff,
              context, () {
            playClickSound(widget.game);
            widget.game.playSounds = !widget.game.playSounds;
            if (widget.game.playSounds) {
              FlameAudio.bgm.play('Three-Red-Hearts-Pixel-War-2.mp3',
                  volume: widget.game.volume * 0.5);
            } else {
              FlameAudio.bgm.stop();
            }
            setState(() {});
          }),
          textButton(
              widget.game.isMouseControl
                  ? local.controlsMouse
                  : local.controlsKeyboard,
              context, () {
            playClickSound(widget.game);
            widget.game.isMouseControl = !widget.game.isMouseControl;
            setState(() {});
          }),
          textButton(local.language, context, () {
            context.read<LocaleProvider>().switchLocale();
            playClickSound(widget.game);
          }),
          textButton(local.about, context, () {
            widget.game.overlays.remove(PlayState.startMenu.name);
            widget.game.overlays.add(PlayState.transition.name);
            widget.game.overlays.add(PlayState.about.name);
            playClickSound(widget.game);
          }),
          const Spacer(),
        ],
      ),
    ));
  }
}

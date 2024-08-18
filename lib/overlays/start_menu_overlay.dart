import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/providers/locale_provider.dart';
import 'package:brick_breaker_reverse/widgets/game_title_widget.dart';
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

class _StartMenuOverlayState extends State<StartMenuOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticInOut),
    );
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
    final local = context.watch<LocaleProvider>().currentLocalization();

    return SlideTransition(
        position: _animation,
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              const Expanded(flex: 2, child: GameTitleWidget()),
              textButton(local.play, context, () async {
                /// start the game
                widget.game.overlays.remove(PlayState.startMenu.name);
                widget.game.overlays.add(PlayState.transition.name);
                widget.game.startGame();
                await playClickSound(widget.game);
              }),
              textButton(
                  widget.game.playSounds ? local.soundsOn : local.soundsOff,
                  context, () async {
                await playClickSound(widget.game);
                widget.game.playSounds = !widget.game.playSounds;
                if (widget.game.playSounds) {
                  FlameAudio.bgm.play('Three-Red-Hearts-Pixel-War-2.mp3',
                      volume: widget.game.volume * 0.5);
                } else {
                  FlameAudio.bgm.stop();
                }
                setState(() {});
              }),
              textButton(local.language, context, () async {
                context.read<LocaleProvider>().switchLocale();
                await playClickSound(widget.game);
              }),
              textButton(local.about, context, () async {
                widget.game.overlays.remove(PlayState.startMenu.name);
                widget.game.overlays.add(PlayState.transition.name);
                widget.game.overlays.add(PlayState.about.name);
                await playClickSound(widget.game);
              }),
              const Spacer(),
            ],
          ),
        ));
  }
}

import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/widgets/game_title_widget.dart';
import 'package:brick_breaker_reverse/widgets/utils/utils.dart';
import 'package:flutter/material.dart';

class StartScreenOverlay extends StatefulWidget {
  const StartScreenOverlay({super.key, required this.game});

  final BrickBreakerReverse game;

  @override
  State<StartScreenOverlay> createState() => _StartScreenOverlayState();
}

class _StartScreenOverlayState extends State<StartScreenOverlay>
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
    return SlideTransition(
      position: _animation,
      child: GestureDetector(
        onTap: () {
          widget.game.overlays.remove(PlayState.startScreen.name);
          widget.game.overlays.add(PlayState.transition.name);
          widget.game.overlays.add(PlayState.startMenu.name);
          playClickSound(widget.game);
        },
        child: const ColoredBox(
          color: Colors.transparent,
          child: Center(
            child: GameTitleWidget(),
          ),
        ),
      ),
    );
  }
}

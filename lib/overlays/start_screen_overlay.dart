import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/providers/game_progress_provider.dart';
import 'package:brick_breaker_reverse/widgets/game_title_widget.dart';
import 'package:brick_breaker_reverse/widgets/slide_transition_widget.dart';
import 'package:brick_breaker_reverse/widgets/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartScreenOverlay extends StatefulWidget {
  const StartScreenOverlay({super.key, required this.game});

  final BrickBreakerReverse game;

  @override
  State<StartScreenOverlay> createState() => _StartScreenOverlayState();
}

class _StartScreenOverlayState extends State<StartScreenOverlay> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProgressProvider>().resetProgress();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransitionWidget(
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

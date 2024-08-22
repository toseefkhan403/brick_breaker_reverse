import 'package:auto_size_text/auto_size_text.dart';
import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/providers/game_progress_provider.dart';
import 'package:brick_breaker_reverse/providers/locale_provider.dart';
import 'package:brick_breaker_reverse/providers/streak_provider.dart';
import 'package:brick_breaker_reverse/widgets/dancing_text.dart';
import 'package:brick_breaker_reverse/widgets/slide_transition_widget.dart';
import 'package:brick_breaker_reverse/widgets/utils/colors.dart';
import 'package:brick_breaker_reverse/widgets/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameOverOverlay extends StatefulWidget {
  const GameOverOverlay({super.key, required this.game});

  final BrickBreakerReverse game;

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  int score = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<GameProgressProvider>();
      score = provider.score;
      provider.updateHighScore(score);
      provider.resetProgress();
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final local = context.watch<LocaleProvider>().currentLocalization();
    final highScore = context.watch<GameProgressProvider>().highScore;
    final highestStreak = context.watch<StreakProvider>().highestStreak;

    return SlideTransitionWidget(
      child: Semantics(
        label: 'game over overlay',
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: DancingText(
                        child: gradientText(
                          local.gameOver.toUpperCase(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              '${local.highScore}: $highScore',
                              style: const TextStyle(
                                  fontSize: 40, fontFamily: 'Sabo-Regular'),
                            ),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              '${local.highestStreak}: $highestStreak',
                              style: const TextStyle(
                                  fontSize: 40, fontFamily: 'Sabo-Regular'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AutoSizeText(
                  '${local.score}: $score',
                  style: const TextStyle(fontSize: 50, color: red),
                ),
              ),
              textButton(local.restart, context, () => restartTheGame(context)),
              textButton(local.language, context, () async {
                context.read<LocaleProvider>().switchLocale();
                await playClickSound(widget.game);
              }),
              textButton(
                local.exit,
                context,
                () async {
                  widget.game.overlays.remove(PlayState.gameOver.name);
                  widget.game.overlays.add(PlayState.transition.name);
                  widget.game.overlays.add(PlayState.startMenu.name);
                  await playClickSound(widget.game);
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void restartTheGame(BuildContext context) {
    /// restart the game
    playClickSound(widget.game);
    widget.game.overlays.remove(PlayState.gameOver.name);
    widget.game.overlays.add(PlayState.transition.name);

    widget.game.loadMap(
      mapName: 'gameMap',
    );
    widget.game.cam.viewfinder.angle = 0;
    widget.game.addColoredBricks = false;

    widget.game.currentMap.add(widget.game.player);
    widget.game.playState = PlayState.playing;
    widget.game.currentMap.spawnBalls = true;
    widget.game.currentMap.addBalls();
    context.read<GameProgressProvider>().switchRevengeMode();
  }
}

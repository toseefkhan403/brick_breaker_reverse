import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/widgets/scrolling_background.dart';
import 'package:brick_breaker_reverse/widgets/start_screen_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flame/game.dart';

// brick breaker reverse - deadline 26 Aug - 11 days left - lead with linux
// 12-13 - music, setting up the canvas
// 14-15-16 - add assets, actual gameplay - brick movements, ball randomizer, hitboxes, dodging and score
// 17-18 - intro animation and bg graphics
// 19-20 - starting menu(stats, credits, settings), pause menu, animations, lose condition and restart screen
// 21-22 - skins, finishing touches, responsiveness, rush mode(with a timer) and release
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(const MainApp());
}

// music choices - intro: penguins vs rabbits, pixel war 2
// gameplay: out of time, box jump, go(no vocal), pixel war 1
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, fontFamily: 'Sabo-Filled'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GameWidget(
              game: BrickBreakerReverse(),
              loadingBuilder: (_) => const Center(
                      child: Text(
                    "Loading...",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
              backgroundBuilder: (_) => const ScrollingBackground(),
              overlayBuilderMap: {
                PlayState.startScreen.name:
                    (context, BrickBreakerReverse game) =>
                        StartScreenOverlay(game: game),
                PlayState.startMenu.name: (context, BrickBreakerReverse game) =>
                    StartScreenOverlay(game: game),
                PlayState.transition.name:
                    (context, BrickBreakerReverse game) =>
                        StartScreenOverlay(game: game),
                PlayState.playing.name: (context, BrickBreakerReverse game) =>
                    StartScreenOverlay(game: game),
                PlayState.pauseMenu.name: (context, BrickBreakerReverse game) =>
                    StartScreenOverlay(game: game),
                PlayState.gameOver.name: (context, BrickBreakerReverse game) =>
                    StartScreenOverlay(game: game),
              }),
        ));
  }
}

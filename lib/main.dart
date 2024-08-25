import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/overlays/about_overlay.dart';
import 'package:brick_breaker_reverse/overlays/game_over_overlay.dart';
import 'package:brick_breaker_reverse/overlays/intro_dialog_overlay.dart';
import 'package:brick_breaker_reverse/overlays/intro_dialog_overlay_2.dart';
import 'package:brick_breaker_reverse/overlays/start_menu_overlay.dart';
import 'package:brick_breaker_reverse/overlays/tap_to_start_overlay.dart';
import 'package:brick_breaker_reverse/overlays/transition_overlay.dart';
import 'package:brick_breaker_reverse/providers/game_progress_provider.dart';
import 'package:brick_breaker_reverse/providers/locale_provider.dart';
import 'package:brick_breaker_reverse/providers/streak_provider.dart';
import 'package:brick_breaker_reverse/widgets/scrolling_background.dart';
import 'package:brick_breaker_reverse/overlays/start_screen_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProgressProvider()),
        ChangeNotifierProvider(create: (_) => StreakProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: ToastificationWrapper(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true, fontFamily: 'Sabo-Filled'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: GameWidget(
              game: BrickBreakerReverse(),
              loadingBuilder: (_) => Builder(builder: (context) {
                final local =
                    context.read<LocaleProvider>().currentLocalization();

                return Center(
                    child: Text(
                  local.loading,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ));
              }),
              backgroundBuilder: (_) => const ScrollingBackground(),
              overlayBuilderMap: {
                PlayState.startScreen.name:
                    (context, BrickBreakerReverse game) =>
                        StartScreenOverlay(game: game),
                PlayState.startMenu.name: (context, BrickBreakerReverse game) =>
                    StartMenuOverlay(game: game),
                PlayState.transition.name:
                    (context, BrickBreakerReverse game) =>
                        TransitionOverlay(game: game),
                PlayState.intro.name: (context, BrickBreakerReverse game) =>
                    IntroDialogOverlay(game: game),
                PlayState.intro2.name: (context, BrickBreakerReverse game) =>
                    IntroDialogOverlay2(game: game),
                PlayState.about.name: (context, BrickBreakerReverse game) =>
                    AboutOverlay(game: game),
                PlayState.gameOver.name: (context, BrickBreakerReverse game) =>
                    GameOverOverlay(game: game),
                'tapToStart': (context, BrickBreakerReverse game) =>
                    TapToStartOverlay(game: game),
              },
            ),
          ),
        ),
      ),
    );
  }
}

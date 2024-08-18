import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/providers/locale_provider.dart';
import 'package:brick_breaker_reverse/widgets/game_title_widget.dart';
import 'package:brick_breaker_reverse/widgets/hyperlink_typewriter_animated_text.dart';
import 'package:brick_breaker_reverse/widgets/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AboutOverlay extends StatefulWidget {
  final BrickBreakerReverse game;

  const AboutOverlay({super.key, required this.game});

  @override
  State<AboutOverlay> createState() => _AboutOverlayState();
}

class _AboutOverlayState extends State<AboutOverlay>
    with SingleTickerProviderStateMixin {
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
      child: Semantics(
        label: 'game credits overlay',
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              const Expanded(flex: 2, child: GameTitleWidget()),
              typerWidget(
                  text: local.developedBy,
                  linkText: 'Toseef Ali Khan',
                  link: 'https://x.com/toseefkhan_',
                  pause: 1200),
              typerWidget(
                  text: local.musicCredits,
                  linkText: 'Abstraction',
                  link: 'https://abstractionmusic.com/',
                  pause: 3000),
              textButton(
                local.exit,
                context,
                () async {
                  widget.game.overlays.remove(PlayState.about.name);
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

  typerWidget(
      {required String text,
      required String link,
      required String linkText,
      required int pause}) {
    return Expanded(
      child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(''),
          HyperlinkTypewriterAnimatedText(
            text,
            link: link,
            linkText: linkText,
            textStyle: const TextStyle(
              fontSize: 50,
            ),
          ),
        ],
        pause: Duration(milliseconds: pause),
        isRepeatingAnimation: false,
      ),
    );
  }
}

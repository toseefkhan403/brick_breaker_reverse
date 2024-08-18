import 'package:brick_breaker_reverse/providers/locale_provider.dart';
import 'package:brick_breaker_reverse/widgets/dancing_text.dart';
import 'package:brick_breaker_reverse/widgets/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameTitleWidget extends StatefulWidget {
  const GameTitleWidget({super.key});

  @override
  State<GameTitleWidget> createState() => _GameTitleWidgetState();
}

class _GameTitleWidgetState extends State<GameTitleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<double> _flashAnimation;

  @override
  void initState() {
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _flashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
    );

    super.initState();
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = context.watch<LocaleProvider>().currentLocalization();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DancingText(
          child: gradientText(
            local.gameTitle.toUpperCase(),
          ),
        ),
        FadeTransition(
          opacity: _flashAnimation,
          child: DancingText(
            child: Text(
              local.gameSubTitle.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Sabo-Regular',
                fontSize: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

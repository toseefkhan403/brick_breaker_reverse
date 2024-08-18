import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/widgets/utils/colors.dart';
import 'package:flutter/material.dart';

class TransitionOverlay extends StatefulWidget {
  const TransitionOverlay({super.key, required this.game});
  final BrickBreakerReverse game;

  @override
  State createState() => _TransitionOverlayState();
}

class _TransitionOverlayState extends State<TransitionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _animation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 1))
            .animate(
      CurvedAnimation(parent: _controller, curve: Curves.slowMiddle),
    );

    // handles remove automatically
    _controller
        .forward()
        .then((_) => widget.game.overlays.remove(PlayState.transition.name));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxHeight: double.infinity,
      child: SlideTransition(
        position: _animation,
        child: Container(
          color: red,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1.5,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

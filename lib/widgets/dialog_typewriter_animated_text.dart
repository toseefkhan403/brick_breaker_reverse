import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DialogTypewriterAnimatedText extends AnimatedText {
  final Duration speed;

  /// The [Curve] of the rate of change of animation over time.
  ///
  /// By default it is set to Curves.linear.
  final Curve curve;

  DialogTypewriterAnimatedText(
    String text, {
    TextAlign textAlign = TextAlign.center,
    TextStyle? textStyle,
    this.speed = const Duration(milliseconds: 30),
    this.curve = Curves.linear,
  }) : super(
          text: text,
          textAlign: textAlign,
          textStyle: textStyle,
          duration: speed * text.characters.length,
        );

  late Animation<double> _typewriterText;

  @override
  Duration get remaining =>
      speed * (textCharacters.length - _typewriterText.value);

  @override
  void initAnimation(AnimationController controller) {
    _typewriterText = CurveTween(
      curve: curve,
    ).animate(controller);
  }

  @override
  Widget completeText(BuildContext context) {
    final dialogBoxHeight = MediaQuery.of(context).size.height / 5;

    return Center(
      child: AutoSizeText(
        text,
        // maxLines: 2,
        textAlign: textAlign,
        style: DefaultTextStyle.of(context)
            .style
            .merge(textStyle)
            .copyWith(fontSize: dialogBoxHeight * 0.15),
      ),
    );
  }

  /// Widget showing partial text
  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    /// Output of CurveTween is in the range [0, 1] for majority of the curves.
    /// It is converted to [0, textCharacters.length + extraLengthForBlinks].
    final typewriterValue =
        (_typewriterText.value.clamp(0, 1) * (textCharacters.length)).round();

    var visibleString = text;
    if (typewriterValue == 0) {
      visibleString = '';
    } else {
      visibleString = textCharacters.take(typewriterValue).toString();
    }

    final dialogBoxHeight = MediaQuery.of(context).size.height / 5;

    return Center(
      child: AutoSizeText(
        visibleString,
        // maxLines: 2,
        textAlign: textAlign,
        style: DefaultTextStyle.of(context)
            .style
            .merge(textStyle)
            .copyWith(fontSize: dialogBoxHeight * 0.15),
      ),
    );
  }
}

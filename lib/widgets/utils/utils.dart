import 'package:auto_size_text/auto_size_text.dart';
import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/widgets/utils/colors.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

textButton(String title, BuildContext context, Function() onPressed,
    {Color color = Colors.black}) {
  return Expanded(
    child: Semantics(
      label: '$title button',
      child: InkWell(
        onTap: onPressed,
        child: AutoSizeText(
          title,
          textAlign: TextAlign.center,
          minFontSize: 20,
          style: TextStyle(fontSize: 50, color: color.withOpacity(0.8)),
        ),
      ),
    ),
  );
}

playClickSound(BrickBreakerReverse game) async {
  if (game.playSounds) await FlameAudio.play('click.wav', volume: game.volume);
}

Widget gradientText(String text) => ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [red, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      child: AutoSizeText(
        text,
        textAlign: TextAlign.center,
        minFontSize: 30,
        style: const TextStyle(
            height: 0.74,
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );

openLink(String url) async {
  if (url == '') return;

  try {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

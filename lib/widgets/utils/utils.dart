import 'package:auto_size_text/auto_size_text.dart';
import 'package:brick_breaker_reverse/brick_breaker_reverse.dart';
import 'package:brick_breaker_reverse/widgets/utils/colors.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:url_launcher/url_launcher.dart';

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

playSound(BrickBreakerReverse game, String sound) async {
  if (game.playSounds) await FlameAudio.play('$sound.wav', volume: game.volume);
}

Widget gradientText(String text) => ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [red, darkRed],
          stops: [0, 0.9],
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
            fontSize: 100,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      ),
    );

openLink(String url) async {
  // if (url == '') return;

  // try {
  //   Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   }
  // } catch (e) {
  //   debugPrint(e.toString());
  // }
}

void showLevelUpToast(int score, AppLocalizations local) {
  if (score == 5 || score == 15 || score == 30 || score == 50) {
    toastification.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: Text(
        local.levelUpMsg,
        style: const TextStyle(color: red),
      ),
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: red,
      ),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      showProgressBar: false,
    );
  }
}

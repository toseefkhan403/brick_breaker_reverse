import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class ScrollingBackground extends StatefulWidget {
  const ScrollingBackground({super.key});

  @override
  State createState() => _ScrollingBackgroundState();
}

class _ScrollingBackgroundState extends State<ScrollingBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _loadImage();
  }

  Future<void> _loadImage() async {
    final ByteData data =
        await rootBundle.load('assets/images/background/green.png');
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    setState(() {
      _image = frameInfo.image;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? const SizedBox.shrink()
        : AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _ScrollingBackgroundPainter(
                  _controller.value,
                  _image!,
                ),
                child: Container(),
              );
            },
          );
  }
}

class _ScrollingBackgroundPainter extends CustomPainter {
  final double animationValue;
  final ui.Image image;

  _ScrollingBackgroundPainter(this.animationValue, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    const imageSize = 64.0;
    final imageRepeatOffset = imageSize * animationValue;

    for (double y = -imageSize + imageRepeatOffset;
        y < size.height;
        y += imageSize) {
      for (double x = 0; x < size.width; x += imageSize) {
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTWH(x, y, imageSize, imageSize),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

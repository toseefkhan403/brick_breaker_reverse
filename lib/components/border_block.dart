import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

enum BorderType { ground, ceiling, leftBorder, rightBorder }

class BorderBlock extends PositionComponent {
  BorderBlock(
      {required this.borderType,
      required super.position,
      required super.size}) {
    debugMode = kDebugMode;
  }

  final BorderType borderType;
}

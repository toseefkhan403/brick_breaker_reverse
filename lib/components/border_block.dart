import 'dart:async';

import 'package:flame/collisions.dart';
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

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());
    return super.onLoad();
  }
}

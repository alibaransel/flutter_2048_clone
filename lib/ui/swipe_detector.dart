import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048_clone/enums/swipe_direction.dart';

class SwipeDetector extends StatefulWidget {
  const SwipeDetector({
    required this.onSwipe,
    this.child,
    super.key,
  });

  final void Function(SwipeDirection swipeDirection) onSwipe;
  final Widget? child;

  @override
  State<SwipeDetector> createState() => _SwipeDetectorState();
}

class _SwipeDetectorState extends State<SwipeDetector> {
  static const double _halfQuarter = 22.5;

  Offset? startOffset;

  SwipeDirection? _angleToSwipeDirection(int angle) {
    if ((angle <= _halfQuarter) || (360 - angle <= _halfQuarter)) return SwipeDirection.right;
    if ((angle - 90).abs() <= _halfQuarter) return SwipeDirection.up;
    if ((angle - 180).abs() <= _halfQuarter) return SwipeDirection.left;
    if ((angle - 270).abs() <= _halfQuarter) return SwipeDirection.down;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (pointerDownDetails) {
        startOffset = pointerDownDetails.localPosition;
      },
      onPointerUp: (pointerUpDetails) {
        if (startOffset == null) return;
        final Offset differenceOffset = pointerUpDetails.localPosition - startOffset!;
        if (differenceOffset.distance < 50) return;
        int angle = -differenceOffset.direction * 180 ~/ pi;
        if (angle < 0) angle += 360;
        final SwipeDirection? swipeDirection = _angleToSwipeDirection(angle);
        if (swipeDirection != null) widget.onSwipe(swipeDirection);
        startOffset = null;
      },
      child: widget.child,
    );
  }
}

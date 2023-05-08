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
  Offset? startOffset;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (topDownDetails) {
        startOffset = topDownDetails.localPosition;
      },
      onPointerUp: (tapUpDetails) {
        if (startOffset == null) return;
        final Offset differenceOffset = tapUpDetails.localPosition - startOffset!;
        if (differenceOffset.distance < 50) return;
        int angle = -differenceOffset.direction * 180 ~/ pi;
        if (angle < 0) angle += 360;
        if ((angle <= 22) || (360 - angle <= 22)) {
          widget.onSwipe(SwipeDirection.right);
        } else if ((angle - 90).abs() <= 22) {
          widget.onSwipe(SwipeDirection.up);
        } else if ((angle - 180).abs() <= 22) {
          widget.onSwipe(SwipeDirection.left);
        } else if ((angle - 270).abs() <= 22) {
          widget.onSwipe(SwipeDirection.down);
        }
        startOffset = null;
      },
      child: widget.child,
    );
  }
}

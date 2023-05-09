import 'package:flutter/material.dart';

enum SwipeDirection {
  up(Axis.vertical),
  down(Axis.vertical),
  right(Axis.horizontal),
  left(Axis.horizontal);

  const SwipeDirection(
    this.axis,
  );

  final Axis axis;
}

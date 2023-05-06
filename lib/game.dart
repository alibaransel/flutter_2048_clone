import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048_clone/matrix.dart';

class Game extends ChangeNotifier {
  Game({
    required this.height,
    required this.width,
  }) {
    tileCount = height * width;
    _grid = Matrix(
      height: height,
      width: width,
      fillValue: 0,
    );
  }

  final int height;
  final int width;

  late final int tileCount;
  late final Matrix<int> _grid;

  int getValueWithIndex(int index) => _grid.getValueWithIndex(index);

  void swipe(AxisDirection direction) {}

  void _spawnNewTile() {
    final List<int> emptyIndexes = _grid.findValueIndexes(0);
    final int index = emptyIndexes[Random().nextInt(emptyIndexes.length)];
    _grid.setValueWithIndex(index, 2);
  }
}

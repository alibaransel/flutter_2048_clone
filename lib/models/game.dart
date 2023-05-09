import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048_clone/enums/game_status.dart';
import 'package:flutter_2048_clone/enums/swipe_direction.dart';
import 'package:flutter_2048_clone/models/matrix.dart';

class Game extends ChangeNotifier {
  Game({
    required this.height,
    required this.width,
  }) {
    tileCount = height * width;
    _grid = Matrix.filled(
      height: height,
      width: width,
      fillValue: 0,
    );
    _status = GameStatus.playing;
  }

  final int height;
  final int width;

  late final int tileCount;

  GameStatus _status = GameStatus.notStarted;

  late Matrix<int> _grid;

  GameStatus get status => _status;

  int getValueWithIndex(int index) => _grid.getValueWithIndex(index);

  void swipe(SwipeDirection direction) {
    _checkStatusIsPlaying();
    final Matrix<int> newGrid = Matrix.filled(
      height: height,
      width: width,
      fillValue: 0,
    );
    if (direction == SwipeDirection.left) {
      for (int y = 0; y < height; y++) {
        final List<int> values = [];
        final List<int> counts = [];
        int? lastValue;
        for (int x = 0; x < width; x++) {
          final int value = _grid.getValue(Point(x, y));
          if (value == 0) continue;
          if (value != lastValue) {
            values.add(value);
            counts.add(1);
            lastValue = value;
          } else {
            counts.last += 1;
          }
        }
        int currentX = 0;
        for (int i = 0; i < values.length; i++) {
          final int value = values[i];
          final int count = counts[i];
          for (int i2 = 0; i2 < (count ~/ 2); i2++) {
            newGrid.setValue(Point(currentX, y), value * 2);
            currentX += 1;
          }
          if (count.isOdd) {
            newGrid.setValue(Point(currentX, y), value);
            currentX += 1;
          }
        }
      }
    }
    _grid = newGrid;
    final List<int> emptyIndexes = _grid.findAll(0);
    if (emptyIndexes.isNotEmpty) {
      _spawnNewTile(emptyIndexes);
    } else {
      _finish();
    }
    notifyListeners();
  }

  void restart() {
    _checkStatusIsOver();
    _grid = Matrix.filled(
      height: height,
      width: width,
      fillValue: 0,
    );
    _status = GameStatus.playing;
    notifyListeners();
  }

  void _checkStatusIsOver() {
    if (_status != GameStatus.over) throw Exception("Game status isn't over");
  }

  void _checkStatusIsPlaying() {
    if (_status != GameStatus.playing) throw Exception("Game status isn't playing");
  }

  void _spawnNewTile(List<int> emptyIndexes) {
    final int index = emptyIndexes[Random().nextInt(emptyIndexes.length)];
    _grid.setValueWithIndex(index, 2);
  }

  void _finish() {
    _status = GameStatus.over;
  }
}

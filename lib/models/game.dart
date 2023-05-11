import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048_clone/enums/game_status.dart';
import 'package:flutter_2048_clone/enums/swipe_direction.dart';
import 'package:flutter_2048_clone/models/matrix.dart';

typedef TileValue = int;

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
    _spawnNewTile(List.generate(tileCount, (i) => i));
    _spawnNewTile(_grid.findAll(0));
    _status = GameStatus.playing;
  }

  final int height;
  final int width;

  late final int tileCount;

  GameStatus _status = GameStatus.notStarted;

  late Matrix<TileValue> _grid;

  GameStatus get status => _status;

  TileValue getValueWithIndex(int index) => _grid.getValueWithIndex(index);

  void swipe(SwipeDirection direction) {
    _checkStatusIsPlaying();
    final List<List<TileValue>> lines =
        direction.axis == Axis.vertical ? _grid.getColumns() : _grid.getRows();
    final List<List<TileValue>> groupedLines =
        direction == SwipeDirection.up || direction == SwipeDirection.left
            ? List.generate(lines.length, (i) => _groupTilesToStart(lines[i]))
            : List.generate(lines.length, (i) => _groupTilesToEnd(lines[i]));
    _grid = direction.axis == Axis.vertical
        ? Matrix.fromColumns(height: height, width: width, columns: groupedLines)
        : Matrix.fromRows(height: height, width: width, rows: groupedLines);
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

  List<TileValue> _groupTilesToStart(List<TileValue> tiles) {
    final List<TileValue> values = [];
    final List<int> counts = [];
    TileValue? lastValue;
    for (final TileValue tile in tiles) {
      if (tile == 0) continue;
      if (tile != lastValue) {
        values.add(tile);
        counts.add(1);
        lastValue = tile;
      } else {
        counts.last += 1;
      }
    }
    final List<TileValue> newRow = [];
    for (int i = 0; i < values.length; i++) {
      final TileValue value = values[i];
      final int count = counts[i];
      newRow.addAll(List.filled(count ~/ 2, value * 2));
      if (count.isOdd) newRow.add(value);
    }
    newRow.addAll(List.filled(tiles.length - newRow.length, 0));
    return newRow;
  }

  List<TileValue> _groupTilesToEnd(List<TileValue> tiles) {
    return _groupTilesToStart(tiles.reversed.toList()).reversed.toList();
  }
}

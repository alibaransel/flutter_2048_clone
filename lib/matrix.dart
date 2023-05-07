import 'dart:math';

class Matrix<T> {
  Matrix({
    required this.height,
    required this.width,
    required this.fillValue,
  }) {
    _data = List.generate(
      height,
      (i) => List.generate(
        width,
        (i2) => fillValue,
      ),
    );
  }

  final int height;
  final int width;
  final T fillValue;

  late List<List<T>> _data;

  Matrix<T> copy() {
    Matrix<T> copyMatrix = Matrix(
      height: height,
      width: width,
      fillValue: fillValue,
    );
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        copyMatrix.setValue(Point(x, y), _data[y][x]);
      }
    }
    return copyMatrix;
  }

  T getValue(Point<int> point) {
    _checkPoint(point);
    return _data[point.y][point.x];
  }

  T getValueWithIndex(int index) {
    _checkIndex(index);
    final Point<int> point = _indexToPoint(index);
    return _data[point.y][point.x];
  }

  List<int> findValueIndexes(T value) {
    final List<int> indexes = [];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (_data[y][x] == value) {
          final int index = y * width + x;
          indexes.add(index);
        }
      }
    }
    return indexes;
  }

  void setValue(Point<int> point, T value) {
    //TODO
    _checkPoint(point);
    _data[point.y][point.x] = value;
  }

  void setValueWithIndex(int index, T value) {
    _checkIndex(index);
    final Point<int> point = _indexToPoint(index);
    _data[point.y][point.x] = value;
  }

  void _checkPoint(Point<int> point) {
    if (point.x < 0 || width <= point.x) throw Exception('X out of range');
    if (point.y < 0 || height <= point.y) throw Exception('Y out of range');
  }

  void _checkIndex(int index) {
    if (index < 0 || height * width <= index) throw Exception('Index out of range');
  }

  Point<int> _indexToPoint(int index) {
    final int x = index % width;
    final int y = index ~/ width;
    return Point(x, y);
  }
}

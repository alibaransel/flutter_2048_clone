import 'dart:math';

typedef Matrix2DData<T> = List<List<T>>;

class Matrix<T> {
  Matrix({
    required this.height,
    required this.width,
    required this.filler,
  }) {
    _data = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) => filler(x, y),
      ),
    );
  }

  factory Matrix.filled({
    required int height,
    required int width,
    required T fillValue,
  }) =>
      Matrix(
        height: height,
        width: width,
        filler: (x, y) => fillValue,
      );

  factory Matrix.fromData({
    required int height,
    required int width,
    required Matrix2DData<T> data,
  }) =>
      Matrix(
        height: height,
        width: width,
        filler: (x, y) => data[y][x],
      );

  factory Matrix.fromRows({
    required int height,
    required int width,
    required List<List<T>> rows,
  }) =>
      Matrix.fromData(
        height: height,
        width: width,
        data: rows,
      );

  factory Matrix.fromColumns({
    required int height,
    required int width,
    required List<List<T>> columns,
  }) =>
      Matrix(
        height: height,
        width: width,
        filler: (x, y) => columns[x][y],
      );

  final int height;
  final int width;
  final T Function(int x, int y) filler;

  late Matrix2DData<T> _data;

  Matrix<T> copy() => Matrix(
        height: height,
        width: width,
        filler: (x, y) => _data[y][x],
      );

  T getValue(Point<int> point) {
    _checkPoint(point);
    return _data[point.y][point.x];
  }

  T getValueWithIndex(int index) {
    _checkIndex(index);
    final Point<int> point = _indexToPoint(index);
    return _data[point.y][point.x];
  }

  List<List<T>> getRows() {
    return List.generate(
      height,
      (y) => List.generate(
        width,
        (x) => _data[y][x],
      ),
    );
  }

  List<List<T>> getColumns() {
    return List.generate(
      width,
      (x) => List.generate(
        height,
        (y) => _data[y][x],
      ),
    );
  }

  void goAll(dynamic Function(int x, int y, T value) goer) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        goer(x, y, _data[y][x]);
      }
    }
  }

  List<int> findAll(T searchValue) {
    final List<int> indexes = [];
    this.goAll((x, y, value) {
      if (value == searchValue) indexes.add(_pointToIndex(Point(x, y)));
    });
    return indexes;
  }

  void applyAll(T Function(int x, int y, T value) applier) {
    goAll((x, y, value) {
      _data[y][x] = applier(x, y, value);
    });
  }

  void setValue(Point<int> point, T value) {
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

  int _pointToIndex(Point<int> point) {
    return point.y * width + point.x;
  }
}

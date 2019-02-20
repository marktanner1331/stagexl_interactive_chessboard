import 'package:stagexl/stagexl.dart';

import './Chessboard.dart';

class Square extends Sprite {
  Chessboard _chessboard;

  num _size = 10;

  String _squareName;
  get squareName => _squareName;

  bool _isBlack;

  int _backgroundColor;
  int get backgroundColor => _backgroundColor;
  void set backgroundColor(int value) {
    _backgroundColor = value;
    redraw();
  }

  Square(Chessboard chessboard, String squareName, bool isBlack) {
    _chessboard = chessboard;

    this._squareName = squareName;
    this._isBlack = isBlack;
  }

  set piece(Sprite value) {
    removeChildren();

    if (value != null) {
      value
        ..x = 0
        ..y = 0
        ..width = _size
        ..height = _size;

      addChild(value);
    }
  }

  @override
  set height(num value) {
    throw Exception("use setSize() instead");
  }

  void setSize(num width, num height) {
    if (width != height) {
      throw Exception("width must be equal to height");
    }

    _size = width;
    redraw();
  }

  void redraw() {
    graphics.clear();

    graphics.beginPath();
    graphics.rect(0, 0, _size, _size);

    if (_isBlack) {
      graphics.fillColor(_chessboard.SQUARE_BLACK_COLOR);
    } else {
      graphics.fillColor(_chessboard.SQUARE_WHITE_COLOR);
    }

    if (_backgroundColor != null) {
      graphics.fillColor(_backgroundColor);
    }

    graphics.closePath();

    if (this.numChildren == 1) {
      getChildAt(0)
        ..x = 0
        ..y = 0
        ..width = _size
        ..height = _size;
    }
  }
}

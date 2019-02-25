import 'package:stagexl/stagexl.dart';

///a class that represents a single square on a chess board
class Square extends Sprite {
  num _size = 10;

  String _squareName;

  ///returns the name of the square (e.g. "a1")
  get squareName => _squareName;

  int _defaultBackgroundColor = 0xffffffff;

  ///returns the default background color used when not overrided by a custom color
  int get defaultBackgroundColor => _defaultBackgroundColor;

  ///sets the default background color used when not overrided by a custom color
  set defaultBackgroundColor(int value) {
    _defaultBackgroundColor = value;
    redraw();
  }

  int _backgroundColor;

  ///gets the custom background color set for this square
  int get backgroundColor => _backgroundColor;

  ///overrides the default background color with a custom one
  set backgroundColor(int value) {
    _backgroundColor = value;
    redraw();
  }

  ///initializes the square with a given square name (e.g. "a1")
  Square(String squareName) {
    this._squareName = squareName;
  }

  ///sets the child (usually a chess piece) of the square. setting its width and height to the size of the square
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

  ///sets the size of the square. width and height must be the same
  void setSize(num width, num height) {
    if (width != height) {
      throw Exception("width must be equal to height");
    }

    _size = width;
    redraw();
  }

  ///redraws the square, there is no normal case for calling this manually
  void redraw() {
    graphics.clear();

    graphics.beginPath();
    graphics.rect(0, 0, _size, _size);

    graphics.fillColor(defaultBackgroundColor);

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

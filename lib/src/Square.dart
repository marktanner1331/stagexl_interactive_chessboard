import 'package:stagexl/stagexl.dart';

import './HasSizeMixin.dart';
import './RedrawableSprite.dart';
import './Settings.dart';

class Square extends RedrawableSprite with SizeMixin {
  String _squareName;
  get squareName => _squareName;

  bool _isBlack;

  Square(String squareName, bool isBlack) {
    this._squareName = squareName;
    this._isBlack = isBlack;
  }

  @override
  void redraw() {
    graphics.clear();

    graphics.rect(0, 0, size, size);
    
    if(_isBlack) {
      graphics.fillColor(Settings.SQUARE_BLACK_COLOR);
    } else {
      graphics.fillColor(Settings.SQUARE_WHITE_COLOR);
    }
  }
}
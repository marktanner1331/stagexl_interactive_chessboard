import 'package:stagexl/stagexl.dart';

import './Square.dart';
import './HasSizeMixin.dart';
import './RedrawableSprite.dart';

class Chessboard extends RedrawableSprite with SizeMixin {
  Map<String, Square> _squares;

  //an array of letters, from a-h
  List<String> letters;

  Chessboard() {
    letters = List();
    int start = "a".codeUnitAt(0);
    int end = "z".codeUnitAt(0);
    for (int c = start; c < end; c++) {
      letters.add(String.fromCharCode(c));
    }

    _squares = Map();
    bool isBlack = true;
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        String squareName = letters[i] + (j + 1).toString();
        Square square = Square(squareName, isBlack);

        addChild(square);
        _squares[squareName] = square;
        
        isBlack = !isBlack;
      }
    }

    redraw();
  }

  @override
  void redraw() {
    num delta = size / 8;
    
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        String squareName = letters[i] + (j + 1).toString();

        Square square = _squares[squareName];

        square
          ..x = i * delta
          ..y = j * delta
          ..size = delta;
      }
    }
  }
}

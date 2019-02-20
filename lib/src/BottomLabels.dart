import 'package:stagexl/stagexl.dart';

class BottomLabels extends Sprite {
  List<DisplayObject> _labels;

  bool _blackAtTop = true;
  bool get blackAtTop => _blackAtTop;
  void set blackAtTop(bool value) {
    _blackAtTop = value;
    width = width;
  }

  BottomLabels() {
    _labels = List();

    for(String s in "abcdefgh".split("")) {
      DisplayObject label = _getStyledLabel(s);
      label.y = 2;
      _labels.add(label);
      addChild(label);
    }
  }

  TextField _getStyledLabel(String text) {
    TextField textField = TextField()
      ..text = text
      ..textColor = 0xff000000
      ..defaultTextFormat = new TextFormat("Arial", 22, 0xff000000);

    textField.width = textField.textWidth;
    textField.height = textField.textHeight;

    return textField;
  }

  num get height {
    return _labels.last.height + 4;
  }

  @override
  set height(num value) {
    throw Exception("height cannot be set");
  }

  @override
  set width(num value) {
    num delta = value / 8;

    num deltaX = delta / 2;

    Iterable<DisplayObject> temp;
    if(_blackAtTop) {
      temp =_labels;
    } else {
      temp =_labels.reversed;
    }

    for(DisplayObject label in temp) {
      label.x = deltaX - label.width / 2;
      deltaX += delta;
    }
  }
}

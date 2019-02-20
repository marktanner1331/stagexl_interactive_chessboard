import 'package:stagexl/stagexl.dart';

class LeftLabels extends Sprite {
  List<DisplayObject> _labels;

  bool _blackAtTop = true;
  bool get blackAtTop => _blackAtTop;
  void set blackAtTop(bool value) {
    _blackAtTop = value;
    height = height;
  }

  LeftLabels() {
    _labels = List();

    for (var i = 8; i > 0; i--) {
      DisplayObject label = _getStyledLabel(i.toString());
      label.x = 5;
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

  num get width {
    return _labels.last.width + 10;
  }

  @override
  set width(num value) {
    throw Exception("width cannot be set");
  }

  @override
  set height(num value) {
    num delta = value / 8;

    num deltaY = delta / 2;

    Iterable<DisplayObject> temp;
    if(_blackAtTop) {
      temp =_labels;
    } else {
      temp =_labels.reversed;
    }

    for(DisplayObject label in temp) {
      label.y = deltaY - label.height / 2;
      deltaY += delta;
    }
  }
}

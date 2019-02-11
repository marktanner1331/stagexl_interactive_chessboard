import 'package:stagexl/stagexl.dart';
import './IRedraw.dart';

mixin SizeMixin on DisplayObject, IRedraw {
  num _size = 0;

  get size => _size;
  set size(num value) {
    _size = value;
    redraw();
  }

  @override
  get width => _size;

  @override
  set width(num value) {
    throw Exception("try setting 'size' instead");
  }

  @override
  get height => _size;

  @override
  set height(num value) {
    throw Exception("try setting 'size' instead");
  }
}
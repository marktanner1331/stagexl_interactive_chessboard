import 'package:stagexl/stagexl.dart';

///A custom event class for handling chess specific events
class ChessEvent extends Event {
  ///raised when a square is clicked by the user
  static const String SQUARE_CLICKED = "SQUARE_CLICKED";

  ///the name of the square, e.g. a1
  String squareName;

  ///constructs a new ChessEvent with the given event type and squareName
  ChessEvent(String type, this.squareName) : super(type);
}
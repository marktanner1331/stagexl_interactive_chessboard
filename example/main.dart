import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_interactive_chessboard/stagexl_interactive_chessboard.dart';
import 'dart:math';
import 'package:chess/chess.dart' as Chess;

Stage stage;

Future<Null> main() async {
  StageOptions options = StageOptions()
    ..backgroundColor = Color.White
    ..stageScaleMode =StageScaleMode.NO_SCALE
    ..stageAlign =StageAlign.TOP_LEFT
    ..renderEngine = RenderEngine.WebGL;

  var canvas = html.querySelector('#stage');
  stage = Stage(canvas, width: 1280, height: 800, options: options);

  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);

  Chessboard board = Chessboard();
  stage.addChild(board);
  board.blackAtTop = false;
  num size = min(stage.stageWidth, stage.stageHeight);
  size -= 20;
  board.setSize(size, size);

  board.x = (stage.stageWidth - board.width) / 2;
  board.y = (stage.stageHeight - board.height) / 2;
  
  Chess.Chess chess = Chess.Chess()
    ..move("e3")
    ..move("e5")
    ..move("Qe2")
    ..move("d5");
  board.loadFromChessObject(chess);

  board.onSquareClicked.listen((ChessEvent event) {
    board.resetAllSquareColors();
    board.setSquareBackgroundColor(event.squareName, 0xaa27b243);

    List<Chess.Move> moves = chess.generate_moves({"square": event.squareName});
    for (Chess.Move move in moves) {
      board.setSquareBackgroundColor(move.to, 0xaaffffb2);
    }
  });
}

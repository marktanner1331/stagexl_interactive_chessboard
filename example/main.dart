import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_interactive_chessboard/interactive_chessboard.dart';
import "package:chess/chess.dart" as chess;
import 'dart:math';

Stage stage;

Future<Null> main() async {
  StageOptions options = StageOptions()
    ..backgroundColor =  Color.White
    ..renderEngine = RenderEngine.WebGL;

  var canvas = html.querySelector('#stage');
  stage = Stage(canvas, width: 1280, height: 800, options: options);

  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);

  Chessboard board = Chessboard();
  stage.addChild(board);

  num size = min(stage.stageWidth, stage.stageHeight);
  size -= 20;
  board.size = size;

  board.x = (stage.stageWidth - board.width) / 2;
  board.y = (stage.stageHeight - board.height) / 2;
}

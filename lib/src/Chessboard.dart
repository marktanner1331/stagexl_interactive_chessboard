import 'package:stagexl/stagexl.dart';
import 'package:chess/chess.dart';
import 'package:chess/chess.dart' as c;
import 'dart:math';

import './Square.dart';
import './PieceFactory.dart';
import './ChessEvent.dart';
import './LeftLabels.dart';
import './BottomLabels.dart';

class Chessboard extends Sprite {
  Chess _chess;

  num _size = 100;

  ///the background color of black squares
  int _squareBlackColor = 0xffB58862;
  int get squareBlackColor => _squareBlackColor;
  set squareBlackColor(int value) {
    _squareBlackColor = value;
    _refreshSquareDefaultBackgroundColors();
  }

  ///the background color of white squares
  int _squareWhiteColor = 0xffF0D8B5;
  int get squareWhiteColor => _squareWhiteColor;
  set squareWhiteColor(int value) {
    _squareWhiteColor = value;
    _refreshSquareDefaultBackgroundColors();
  }

  static const EventStreamProvider<ChessEvent> _onSquareClicked =
      const EventStreamProvider<ChessEvent>(ChessEvent.SQUARE_CLICKED);

  ///raised when the user clicks on a square
  EventStream<ChessEvent> get onSquareClicked =>
      _onSquareClicked.forTarget(this);

  //we store double what we need to
  //in line with what happens in the chess package
  //first 4 bits are rank
  //last 4 are file
  List<Square> _board = new List(128);

  bool _blackAtTop = true;
  bool get blackAtTop => _blackAtTop;
  void set blackAtTop(bool value) {
    _blackAtTop = value;
    _leftLabels.blackAtTop = value;
    _bottomLabels.blackAtTop = value;
    redraw();
  }

  bool _showLabels = true;
  bool get showLabels => _showLabels;
  void set showLabels(bool value) {
    _showLabels = value;

    if (value) {
      addChild(_leftLabels);
      addChild(_bottomLabels);
    } else if (_leftLabels.stage != null) {
      removeChild(_leftLabels);
      removeChild(_bottomLabels);
    }

    redraw();
  }

  LeftLabels _leftLabels;
  BottomLabels _bottomLabels;

  ///initializes an empty chess board
  Chessboard() {
    Map<int, String> reverseSquares =
        Chess.SQUARES.map((name, value) => MapEntry(value, name));

    bool isBlack = false;
    for (int i = Chess.SQUARES_A8; i <= Chess.SQUARES_H1; i++) {
      /* did we run off the end of the board */
      if ((i & 0x88) != 0) {
        i += 7;
        isBlack = !isBlack;
        continue;
      }

      Square square = Square(reverseSquares[i]);
      square.onMouseClick.listen(_onSquareClick);
      _board[i] = square;
      square.defaultBackgroundColor =
          isBlack ? squareBlackColor : squareWhiteColor;
      addChild(square);

      isBlack = !isBlack;
    }

    _leftLabels = LeftLabels();
    _leftLabels.blackAtTop = blackAtTop;

    _bottomLabels = BottomLabels();
    _bottomLabels.blackAtTop = blackAtTop;

    if (showLabels) {
      addChild(_leftLabels);
      addChild(_bottomLabels);
    }

    loadFromChessObject(Chess());
  }

  c.Color get turn => _chess.turn;

  void set turn(c.Color value) => _chess.turn = value;

  void _refreshSquareDefaultBackgroundColors() {
    bool isBlack = false;
    for (int i = Chess.SQUARES_A8; i <= Chess.SQUARES_H1; i++) {
      /* did we run off the end of the board */
      if ((i & 0x88) != 0) {
        i += 7;
        isBlack = !isBlack;
        continue;
      }

      Square square = _board[i];
      square.defaultBackgroundColor =
          isBlack ? squareBlackColor : squareWhiteColor;

      isBlack = !isBlack;
    }
  }

  void _onSquareClick(MouseEvent event) {
    Square square = event.currentTarget;
    dispatchEvent(new ChessEvent(ChessEvent.SQUARE_CLICKED, square.squareName));
  }

  ///loads chess pieces onto the board from the given chess object
  void loadFromChessObject(Chess chess) {
    _chess = chess;
    _refreshPieces();
  }

  void _refreshPieces() {
    for (int i = Chess.SQUARES_A8; i <= Chess.SQUARES_H1; i++) {
      /* did we run off the end of the board */
      if ((i & 0x88) != 0) {
        i += 7;
        continue;
      }

      Piece piece = _chess.board[i];
      if (piece == null) {
        _board[i].piece = null;
      } else {
        Sprite pieceSprite = PieceFactory.getSpriteForPiece(piece);
        _board[i].piece = pieceSprite;
      }
    }
  }

  void clear() {
    _chess.clear();
    _refreshPieces();
    resetAllSquareColors();
  }

  void reset() {
    _chess.reset();
    _refreshPieces();
    resetAllSquareColors();
  }

  ///resets the background colors of all squares back to their original checkered pattern
  void resetAllSquareColors() {
    for (int i = Chess.SQUARES_A8; i <= Chess.SQUARES_H1; i++) {
      /* did we run off the end of the board */
      if ((i & 0x88) != 0) {
        i += 7;
        continue;
      }

      Square square = _board[i];
      square.backgroundColor = null;
    }
  }

  bool isValidMove(String san) {
    return move_from_san(san) != null;
  }

  bool performMove(String san) {
    _chess.move(move_from_san(san));
    _refreshPieces();
  }

  Move move_from_san(String san) {
    var moves = _chess.generate_moves();
    for (var i = 0, len = moves.length; i < len; i++) {
      /* strip off any trailing move decorations: e.g Nf3+?! */
      if (san.replaceAll(new RegExp(r"[+#?!=]+$"), '') ==
          _chess
              .move_to_san(moves[i])
              .replaceAll(new RegExp(r"[+#?!=]+$"), '')) {
        return moves[i];
      }
    }
    return null;
  }

  ///gets the backgroundColor of the given square
  ///if the backgroundColor is not customized (i.e. it is the normal white/black then this method returns null)
  ///square can either be an int stored in the same format used in chess.dart (used in Move.from and Move.to)
  ///or it can be a string e.g. 'a3'
  int getSquareBackgroundColor(dynamic square) {
    if (square is int) {
      return _board[square].backgroundColor;
    } else {
      return _board[Chess.SQUARES[square]].backgroundColor;
    }
  }

  ///sets the background color of the given square
  ///if null is passed then the square is reset back to its original white/black color
  ///square can either be an int stored in the same format used in chess.dart (used in Move.from and Move.to)
  ///or it can be a string e.g. 'a3'
  void setSquareBackgroundColor(dynamic square, int backgroundColor) {
    if (square is int) {
      _board[square].backgroundColor = backgroundColor;
    } else {
      _board[Chess.SQUARES[square]].backgroundColor = backgroundColor;
    }
  }

  ///returns a list of squares which have the given custom background color
  ///returns a list of strings which are the names of the squares, e.g. 'a4'
  Iterable<String> getAllSquaresWithState(int backgroundColor) {
    List<String> squares = List();

    for (int i = Chess.SQUARES_A8; i <= Chess.SQUARES_H1; i++) {
      /* did we run off the end of the board */
      if ((i & 0x88) != 0) {
        i += 7;
        continue;
      }

      Square square = _board[i];
      if (square.backgroundColor == backgroundColor) {
        squares.add(square.squareName);
      }
    }

    return squares;
  }

  ///removes the piece from the given square
  ///square can either be an int stored in the same format used in chess.dart (used in Move.from and Move.to)
  ///or it can be a string e.g. 'a3'
  void remove(dynamic square) {
    if (square is int) {
      String squareName = Chess.algebraic(square);
      _chess.remove(squareName);
      _board[square].piece = null;
    } else {
      _chess.remove(square);
      _board[Chess.SQUARES[square]].piece = null;
    }
  }

  List<Move> getPossibleMovesForSquare(String square) {
    return _chess.generate_moves({"square": square});
  }

  ///puts a piece on the given square
  ///square can either be an int stored in the same format used in chess.dart (used in Move.from and Move.to)
  ///or it can be a string e.g. 'a3'
  void put(Piece piece, dynamic square) {
    Sprite pieceSprite = PieceFactory.getSpriteForPiece(piece);

    if (square is int) {
      String squareName = Chess.algebraic(square);
      _chess.put(piece, squareName);
      _board[square].piece = pieceSprite;
    } else {
      _chess.put(piece, square);
      _board[Chess.SQUARES[square]].piece = pieceSprite;
    }
  }

  ///get a piece on the given square
  ///square can either be an int stored in the same format used in chess.dart (used in Move.from and Move.to)
  ///or it can be a string e.g. 'a3'
  Piece get(dynamic square) {
    if (square is int) {
      String squareName = Chess.algebraic(square);
      return _chess.get(squareName);
    } else {
      return _chess.get(square);
    }
  }

  ///redraws and resizes the board, it may be necessary to call this manually
  ///if one of the colors has been updated after the size has been set
  void redraw() {
    graphics.clear();
    graphics.rect(0, 0, _size, _size);
    graphics.strokeColor(0xff000000, 1);
    graphics.closePath();

    num innerX = 0;
    num innerSize = _size - 1;

    if (showLabels) {
      num temp = max(_leftLabels.width, _bottomLabels.height);

      innerX = temp;
      innerSize -= temp;

      _leftLabels.x = (temp - _leftLabels.width) / 2;
      _leftLabels.height = innerSize;

      _bottomLabels.x = innerX;
      _bottomLabels.y = innerSize;
      _bottomLabels.width = innerSize;
    }

    num delta = innerSize / 8;

    num deltaX = 0;
    num deltaY = 0;
    for (int i = Chess.SQUARES_A8; i <= Chess.SQUARES_H1; i++) {
      /* did we run off the end of the board */
      if ((i & 0x88) != 0) {
        i += 7;

        deltaX = 0;
        deltaY++;
        continue;
      }

      Square square = _board[i];
      square.setSize(delta, delta);

      if (_blackAtTop) {
        square.x = 0.5 + innerX + deltaX * delta;
        square.y = 0.5 + deltaY * delta;
      } else {
        square.x = innerX + innerSize - (deltaX + 1) * delta;
        square.y = 0.5 + innerSize - (deltaY + 1) * delta;
      }

      deltaX++;
    }
  }

  @override
  set width(num value) {
    throw Exception("use setSize() instead");
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
}

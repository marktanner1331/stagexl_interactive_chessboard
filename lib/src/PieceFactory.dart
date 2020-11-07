import 'package:stagexl/stagexl.dart' as StageXL;
import 'package:chess/chess.dart';
import 'package:stagexl_chess_pieces/stagexl_chess_pieces.dart';

///A wrapper for stagexl_chess_pieces.dart
class PieceFactory {
  ///returns the correct sprite for the given piece
  static StageXL.Sprite getSpriteForPiece(Piece piece) {
    switch(piece.type) {
      case PieceType.BISHOP:
        return piece.color == Color.WHITE ? WhiteBishop() : BlackBishop();
      case PieceType.KING:
        return piece.color == Color.WHITE ? WhiteKing() : BlackKing();
      case PieceType.KNIGHT:
        return piece.color == Color.WHITE ? WhiteKnight() : BlackKnight();
      case PieceType.PAWN:
        return piece.color == Color.WHITE ? WhitePawn() : BlackPawn();
      case PieceType.QUEEN:
        return piece.color == Color.WHITE ? WhiteQueen() : BlackQueen();
      case PieceType.ROOK:
        return piece.color == Color.WHITE ? WhiteRook() : BlackRook();
      default:
        throw Exception("unknown piece: ${piece.type}");
    }
  }

  static Piece getPieceForSprite(StageXL.Sprite sprite) {
    if(sprite is WhiteBishop) {
      return Piece(PieceType.BISHOP, Color.WHITE);
    } else if(sprite is BlackBishop) {
      return Piece(PieceType.BISHOP, Color.BLACK);
    } else if(sprite is WhiteKing) {
      return Piece(PieceType.KING, Color.WHITE);
    } else if(sprite is BlackKing) {
      return Piece(PieceType.KING, Color.BLACK);
    } else if(sprite is WhiteKnight) {
      return Piece(PieceType.KNIGHT, Color.WHITE);
    } else if(sprite is BlackKnight) {
      return Piece(PieceType.KNIGHT, Color.BLACK);
    } else if(sprite is WhitePawn) {
      return Piece(PieceType.PAWN, Color.WHITE);
    } else if(sprite is BlackPawn) {
      return Piece(PieceType.PAWN, Color.BLACK);
    } else if(sprite is WhiteQueen) {
      return Piece(PieceType.QUEEN, Color.WHITE);
    } else if(sprite is BlackQueen) {
      return Piece(PieceType.QUEEN, Color.BLACK);
    } else if(sprite is WhiteRook) {
      return Piece(PieceType.ROOK, Color.WHITE);
    } else if(sprite is BlackRook) {
      return Piece(PieceType.ROOK, Color.BLACK);
    } else {
      throw Exception("Unknown piece ${sprite}");
    }
  }
}
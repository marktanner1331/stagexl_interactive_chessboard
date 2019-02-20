import 'package:stagexl/stagexl.dart' as StageXL;
import 'package:chess/chess.dart';
import 'package:stagexl_chess_pieces/stagexl_chess_pieces.dart';

class PieceFactory {
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
}
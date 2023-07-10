import 'package:flutter/painting.dart';
import '../ayah_glyph.dart';

class GlyphCoords {
  final AyahGlyph glyph;
  final int line;
  final Rect bounds;

  GlyphCoords(this.glyph, this.line, double minX, double minY, double maxX, double maxY)
      : bounds = Rect.fromLTRB(minX, minY, maxX, maxY);

  GlyphCoords.withRect(this.glyph, this.line, this.bounds);

  GlyphCoords copyWithBounds(Rect expandedBounds) {
    return GlyphCoords.withRect(glyph, line, expandedBounds);
  }
}

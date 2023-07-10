import 'dart:math';
import 'package:flutter/material.dart';
import '../sura_ayah.dart';
import 'glyph_coords.dart';

class PageGlyphsCoords {
  final int page;
  final List<GlyphCoords> glyphCoords;
  late final Map<SuraAyah, List<GlyphCoords>> glyphsByAyah;
  late final Map<int, List<GlyphCoords>> glyphsByLine;
  late final Map<int, Rect> lineBounds;
  late final Rect pageBounds;
  late final Map<int, Rect> expandedLineBounds;
  late final Map<int, List<GlyphCoords>> expandedGlyphsByLine;
  late final List<GlyphCoords> expandedGlyphs;

  PageGlyphsCoords(this.page, this.glyphCoords) {
    glyphsByAyah = groupGlyphsByAyah(glyphCoords);
    glyphsByLine = groupGlyphsByLine(glyphCoords);
    lineBounds = calculateLineBounds(glyphsByLine);
    pageBounds = calculatePageBounds(lineBounds);
    expandedLineBounds = calculateExpandedLineBounds(lineBounds, pageBounds);
    expandedGlyphsByLine =
        calculateExpandedGlyphsByLine(glyphsByLine, expandedLineBounds);
    expandedGlyphs =
        expandedGlyphsByLine.values.expand((glyphs) => glyphs).toList();
  }

  Map<SuraAyah, List<GlyphCoords>> groupGlyphsByAyah(List<GlyphCoords> glyphs) {
    return glyphs.fold<Map<SuraAyah, List<GlyphCoords>>>({}, (result, glyph) {
      final ayahKey = glyph.glyph.ayah;
      result[ayahKey] = [...(result[ayahKey] ?? []), glyph];
      return result;
    });
  }

  Map<int, List<GlyphCoords>> groupGlyphsByLine(List<GlyphCoords> glyphs) {
    return glyphs.fold<Map<int, List<GlyphCoords>>>({}, (result, glyph) {
      final lineKey = glyph.line;
      result[lineKey] = [...(result[lineKey] ?? []), glyph];
      return result;
    });
  }

  Map<int, Rect> calculateLineBounds(Map<int, List<GlyphCoords>> glyphsByLine) {
    final lineBounds = <int, Rect>{};

    glyphsByLine.forEach((line, glyphs) {
      Rect currentBounds = Rect.fromPoints(
        glyphs.first.bounds.topLeft,
        glyphs.last.bounds.bottomRight,
      );

      // Adjust the top and bottom values to include adjacent lines
      if (lineBounds.containsKey(line - 1)) {
        final prevLineBounds = lineBounds[line - 1]!;
        currentBounds = Rect.fromLTRB(
          currentBounds.left,
          min(currentBounds.top, prevLineBounds.top),
          currentBounds.right,
          currentBounds.bottom,
        );
      }

      if (lineBounds.containsKey(line + 1)) {
        final nextLineBounds = lineBounds[line + 1]!;
        final newBottom = max(currentBounds.bottom, nextLineBounds.bottom);
        currentBounds = Rect.fromLTRB(
          currentBounds.left,
          currentBounds.top,
          currentBounds.right,
          newBottom,
        );
      }

      lineBounds[line] = currentBounds;
    });

    return lineBounds;
  }

  Rect calculatePageBounds(Map<int, Rect> lineBounds) {
    double left = double.infinity;
    double top = double.infinity;
    double right = double.negativeInfinity;
    double bottom = double.negativeInfinity;

    for (var bounds in lineBounds.values) {
      left = min(left, bounds.left);
      top = min(top, bounds.top);
      right = max(right, bounds.right);
      bottom = max(bottom, bounds.bottom);
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  Map<int, Rect> calculateExpandedLineBounds(
      Map<int, Rect> lineBounds, Rect pageBounds) {
    return lineBounds.map((line, bounds) {
      final sura = suraOfLine(line);
      final prev = suraOfLine(line - 1) == sura ? lineBounds[line - 1] : null;
      final next = suraOfLine(line + 1) == sura ? lineBounds[line + 1] : null;

      final expandedBounds = Rect.fromLTWH(
        pageBounds.left,
        line == lineBounds.keys.first
            ? pageBounds.top
            : midpointY(prev!, bounds),
        pageBounds.width,
        line == lineBounds.keys.last
            ? pageBounds.bottom - bounds.top
            : midpointY(bounds, next!),
      );

      return MapEntry(line, expandedBounds);
    });
  }

  int? suraOfLine(int line) {
    final glyphCoords = glyphsByLine[line];
    // ignore: prefer_null_aware_operators
    return glyphCoords != null ? glyphCoords.first.glyph.ayah.sura : null;
  }

  double midpointY(Rect topBounds, Rect bottomBounds) {
    return topBounds.bottom + (bottomBounds.top - topBounds.bottom) / 2;
  }

  Map<int, List<GlyphCoords>> calculateExpandedGlyphsByLine(
      Map<int, List<GlyphCoords>> glyphsByLine,
      Map<int, Rect> expandedLineBounds) {
    return glyphsByLine.map((line, glyphs) {
      final expandedBounds = expandedLineBounds[line];
      final expandedGlyphs =
          glyphs.map((glyph) => glyph.copyWithBounds(expandedBounds!)).toList();
      return MapEntry(line, expandedGlyphs);
    });
  }
}

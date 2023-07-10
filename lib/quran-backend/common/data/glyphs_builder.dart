// import 'dart:ui';

// /// Helper to convert the ordered glyph rows in the database to structured [GlyphCoords] classes.
// ///
// /// Usage: add glyphs to the builder in sequence so that word positions can be calculated correctly.
// ///
// /// Note: It is important that the glyphs are appended in sequence with no gaps,
// ///       otherwise the `wordPosition` for [WordGlyph] may be incorrect.
// class GlyphsBuilder {
//   final List<GlyphCoords> glyphs = [];

//   SuraAyah? curAyah;
//   int nextWordPos = 1;

//   void append(int sura, int ayah, int glyphPosition, int line, String type, Rect bounds) {
//     final suraAyah = SuraAyah(sura, ayah);

//     // If we're on a different ayah, reset word position to 1
//     if (curAyah == null || curAyah != suraAyah) {
//       curAyah = suraAyah;
//       nextWordPos = 1;
//     }

//     final glyph = type == HIZB
//         ? HizbGlyph(suraAyah, glyphPosition)
//         : type == SAJDAH
//             ? SajdahGlyph(suraAyah, glyphPosition)
//             : type == PAUSE
//                 ? PauseGlyph(suraAyah, glyphPosition)
//                 : type == END
//                     ? AyahEndGlyph(suraAyah, glyphPosition)
//                     : type == WORD
//                         ? WordGlyph(suraAyah, glyphPosition, nextWordPos++)
//                         : throw ArgumentError('Unknown glyph type $type');

//     glyphs.add(GlyphCoords(glyph, line, bounds));
//   }

//   List<GlyphCoords> build() => List.from(glyphs);

//   // Glyph Type keys
//   // Note: it's important these types match what is defined in the ayahinfo db
//   static const String HIZB = 'hizb';
//   static const String SAJDAH = 'sajdah';
//   static const String PAUSE = 'pause';
//   static const String END = 'end';
//   static const String WORD = 'word';
// }

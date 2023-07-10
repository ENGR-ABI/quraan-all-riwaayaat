import 'highlight_type.dart';

class HighlightInfo {
  final int sura;
  final int ayah;
  final int word;
  final HighlightType highlightType;
  final bool scrollToAyah;

  HighlightInfo(
      this.sura, this.ayah, this.word, this.highlightType, this.scrollToAyah);
}

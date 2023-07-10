class HighlightType implements Comparable<HighlightType> {
  final int id;
  final int colorResId;
  final Mode mode;
  final bool isSingle;
  final bool isTransitionAnimated;

  HighlightType(this.id, this.colorResId, this.mode,
      {this.isSingle = false, this.isTransitionAnimated = false});

  @override
  int compareTo(HighlightType other) {
    return id.compareTo(other.id);
  }
}

enum Mode {
  highlights, // Highlights the text of the ayah (rectangular overlay on the text)
  background, // Applies a background color to the entire line (full height/width, even ayahs that are centered like first 2 pages)
  underline, // Draw an underline below the text of the ayah
  color, // Change the text color of the ayah/word (apply a color filter)
  hide, // Hide the ayah/word (i.e. won't be rendered)
}

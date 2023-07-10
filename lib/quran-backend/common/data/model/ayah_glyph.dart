import 'package:flutter/material.dart';
import 'sura_ayah.dart';

abstract class AyahGlyph implements Comparable<AyahGlyph>, Serializable {
  SuraAyah get ayah;
  int get position;

  const AyahGlyph();

  @override
  int compareTo(AyahGlyph other) {
    if (this == other) {
      return 0;
    } else if (ayah != other.ayah) {
      return ayah.compareTo(other.ayah);
    } else {
      return position.compareTo(other.position);
    }
  }
}

@immutable
class HizbGlyph extends AyahGlyph {
  @override
  final SuraAyah ayah;
  @override
  final int position;

  const HizbGlyph(this.ayah, this.position);

  @override
  int compareTo(AyahGlyph other) {
    if (other is HizbGlyph) {
      return super.compareTo(other);
    }
    return 1;
  }
}

@immutable
class SajdahGlyph extends AyahGlyph {
  @override
  final SuraAyah ayah;
  @override
  final int position;

  const SajdahGlyph(this.ayah, this.position);

  @override
  int compareTo(AyahGlyph other) {
    if (other is SajdahGlyph) {
      return super.compareTo(other);
    }
    return -1;
  }
}

@immutable
class PauseGlyph extends AyahGlyph {
  @override
  final SuraAyah ayah;
  @override
  final int position;

  const PauseGlyph(this.ayah, this.position);

  @override
  int compareTo(AyahGlyph other) {
    if (other is PauseGlyph) {
      return super.compareTo(other);
    }
    return -1;
  }
}

@immutable
class AyahEndGlyph extends AyahGlyph {
  @override
  final SuraAyah ayah;
  @override
  final int position;

  const AyahEndGlyph(this.ayah, this.position);

  @override
  int compareTo(AyahGlyph other) {
    if (other is AyahEndGlyph) {
      return super.compareTo(other);
    }
    return -1;
  }
}

@immutable
class WordGlyph extends AyahGlyph {
  @override
  final SuraAyah ayah;
  @override
  final int position;
  final int wordPosition;

  const WordGlyph(this.ayah, this.position, this.wordPosition);

  AyahWord toAyahWord() => AyahWord(ayah, wordPosition);

  @override
  int compareTo(AyahGlyph other) {
    if (other is WordGlyph) {
      return super.compareTo(other);
    }
    return -1;
  }
}



@immutable
class AyahWord {
  final SuraAyah ayah;
  final int wordPosition;

  const AyahWord(this.ayah, this.wordPosition);
}

abstract class Serializable {}

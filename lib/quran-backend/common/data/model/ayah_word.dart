import 'package:flutter/foundation.dart';
import 'quran_ref.dart';
import 'sura_ayah.dart';

@immutable
class AyahWord implements Comparable<AyahWord>, Serializable, QuranId {
  final SuraAyah ayah;
  final int wordPosition;

  const AyahWord(this.ayah, this.wordPosition);

  @override
  int compareTo(AyahWord other) {
    if (this == other) {
      return 0;
    } else if (ayah != other.ayah) {
      return ayah.compareTo(other.ayah);
    } else {
      return wordPosition.compareTo(other.wordPosition);
    }
  }

  @override
  String toString() {
    return "(${ayah.sura}:${ayah.ayah}:$wordPosition)";
  }
}

abstract class Serializable {}

import '../core/quran_constants.dart';
import '../core/quran_info.dart';
import 'quran_ref.dart';

class SuraAyah implements Comparable<SuraAyah>, QuranId {
  final int sura;
  final int ayah;

  SuraAyah(this.sura, this.ayah);

  @override
  int compareTo(SuraAyah other) {
    if (this == other) {
      return 0;
    } else if (sura != other.sura) {
      return sura.compareTo(other.sura);
    } else {
      return ayah.compareTo(other.ayah);
    }
  }

  @override
  String toString() {
    return "($sura:$ayah)";
  }

  bool after(SuraAyah next) {
    return compareTo(next) > next.compareTo(this);
  }

  SuraAyah? next(QuranInfo quranInfo) {
    if (ayah < quranInfo.getNumberOfAyahs(sura)) {
      return SuraAyah(sura, ayah + 1);
    } else if (sura < QuranConstants.NUMBER_OF_SURAS) {
      return SuraAyah(sura + 1, 1);
    } else {
      return null;
    }
  }

  SuraAyah? prev(QuranInfo quranInfo) {
    if (ayah > 1) {
      return SuraAyah(sura, ayah - 1);
    } else if (sura > 1) {
      return SuraAyah(sura - 1, quranInfo.getNumberOfAyahs(sura - 1));
    } else {
      return null;
    }
  }

  int id(QuranInfo quranInfo) {
    return quranInfo.getAyahId(sura, ayah);
  }

  ///NOTE - I should debug this, comparison may be on the ayah and not the SurahAyah
  static SuraAyah min(SuraAyah a, SuraAyah b) {
    return (a.compareTo(b) <= b.compareTo(a)) ? a : b;
  }

  ///NOTE - I should debug this, comparison may be on the ayah and not the SurahAyah
  static SuraAyah max(SuraAyah a, SuraAyah b) {
    return (a.compareTo(b) >= b.compareTo(a)) ? a : b;
  }

  String toTags() => '$sura:$ayah';
}

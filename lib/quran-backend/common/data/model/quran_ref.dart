class QuranRef {}

// Reference to no Quran identifier
class None extends QuranRef {}

// Reference to a single Quran identifier
abstract class QuranId extends QuranRef {}

// Reference to a single word
class Word extends QuranId implements Comparable<Word> {
  final Ayah ayah; // Reference to the Ayah containing the word
  final int word; // Word index within the Ayah

  Word(this.ayah, this.word);

  @override
  int compareTo(Word other) {
    if (this == other) {
      return 0;
    } else if (ayah != other.ayah) {
      return ayah.compareTo(other.ayah);
    } else {
      return word.compareTo(other.word);
    }
  }
}

// Reference to a single Ayah
class Ayah extends QuranId implements Comparable<Ayah> {
  final int sura; // Surah number
  final int ayah; // Ayah number within the Surah

  Ayah(this.sura, this.ayah);

  @override
  int compareTo(Ayah other) {
    if (this == other) {
      return 0;
    } else if (sura != other.sura) {
      return sura.compareTo(other.sura);
    } else {
      return ayah.compareTo(other.ayah);
    }
  }
}

// Reference to a single Surah
class Sura extends QuranId implements Comparable<Sura> {
  final int sura; // Surah number

  Sura(this.sura);

  @override
  int compareTo(Sura other) {
    return sura.compareTo(other.sura);
  }
}

// Reference to a single page
class Page extends QuranId implements Comparable<Page> {
  final int page; // Page number

  Page(this.page);

  @override
  int compareTo(Page other) {
    return page.compareTo(other.page);
  }
}

// Reference to a single Rub' al-Hizb
class Rub3 extends QuranId implements Comparable<Rub3> {
  final int rub3; // Rub' al-Hizb number

  Rub3(this.rub3);

  @override
  int compareTo(Rub3 other) {
    return rub3.compareTo(other.rub3);
  }
}

// Reference to a single Hizb
class Hizb extends QuranId implements Comparable<Hizb> {
  final int hizb; // Hizb number

  Hizb(this.hizb);

  @override
  int compareTo(Hizb other) {
    return hizb.compareTo(other.hizb);
  }
}

// Reference to a single Juz'
class Juz2 extends QuranId implements Comparable<Juz2> {
  final int juz2; // Juz' number

  Juz2(this.juz2);

  @override
  int compareTo(Juz2 other) {
    return juz2.compareTo(other.juz2);
  }
}

// Reference to the entire Quran
class TheQuran extends QuranId implements Comparable<TheQuran> {
  @override
  int compareTo(TheQuran other) {
    return 0;
  }
}

// Reference to a range of Quran identifiers
abstract class Range<T extends QuranId> extends QuranRef {
  final T start; // Start identifier of the range
  final T endInclusive; // End identifier of the range

  Range(this.start, this.endInclusive);
}

// Reference to a range of Quran identifiers
class QuranRange<T extends QuranId> extends Range<T> {
  QuranRange(T start, T endInclusive) : super(start, endInclusive);
}

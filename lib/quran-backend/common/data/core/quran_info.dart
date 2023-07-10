import '../core/quran_constants.dart';
import '../model/sura_ayah.dart';
import '../model/verse_range.dart';
import '../source/quran_data_source.dart';

class QuranInfo {
  final List<int> suraPageStart;
  final List<int> pageSuraStart;
  final List<int> pageAyahStart;
  final List<int> juzPageStart;
  final Map<int, int> juzPageOverride;
  final List<int> pageRub3Start;
  final List<int> suraNumAyahs;
  final List<bool> suraIsMakki;
  final List<SuraAyah> quarters;
  final int numberOfPages;
  final int numberOfPagesDual;

  QuranInfo(QuranDataSource quranDataSource)
      : suraPageStart = quranDataSource.pageForSuraArray,
        pageSuraStart = quranDataSource.suraForPageArray,
        pageAyahStart = quranDataSource.ayahForPageArray,
        juzPageStart = quranDataSource.pageForJuzArray,
        juzPageOverride = quranDataSource.juzDisplayPageArrayOverride,
        pageRub3Start = quranDataSource.quarterStartByPage,
        suraNumAyahs = quranDataSource.numberOfAyahsForSuraArray,
        suraIsMakki = quranDataSource.isMakkiBySuraArray,
        quarters = quranDataSource.quartersArray,
        numberOfPages = quranDataSource.numberOfPages,
        numberOfPagesDual = (quranDataSource.numberOfPages / 2 +
                quranDataSource.numberOfPages % 2)
            .toInt();

  int getStartingPageForJuz(int juz) {
    return juzPageStart[juz - 1];
  }

  int getPageNumberForSura(int sura) {
    return suraPageStart[sura - 1];
  }

  int getSuraNumberFromPage(int page) {
    var sura = -1;
    for (var i = 0; i < QuranConstants.NUMBER_OF_SURAS; i++) {
      if (suraPageStart[i] == page) {
        sura = i + 1;
        break;
      } else if (suraPageStart[i] > page) {
        sura = i;
        break;
      }
    }
    return sura;
  }

  List<int> getListOfSurahWithStartingOnPage(int page) {
    var startIndex = pageSuraStart[page - 1] - 1;
    var result = <int>[];
    for (var i = startIndex; i < QuranConstants.NUMBER_OF_SURAS; i++) {
      if (suraPageStart[i] == page) {
        result.add(i + 1);
      } else if (suraPageStart[i] > page) {
        break;
      }
    }
    return result;
  }

  VerseRange getVerseRangeForPage(int page) {
    var result = getPageBounds(page);
    var versesInRange = 1 +
        (getAyahId(result[0], result[1]) - getAyahId(result[2], result[3]))
            .abs();
    return VerseRange(
      result[0],
      result[1],
      result[2],
      result[3],
      versesInRange,
    );
  }

  int getFirstAyahOnPage(int page) {
    return pageAyahStart[page - 1];
  }

  List<int> getPageBounds(int inputPage) {
    var page = inputPage;
    if (page > numberOfPages) {
      page = numberOfPages;
    } else if (page < 1) {
      page = 1;
    }

    var bounds = List<int>.filled(4, 0);
    bounds[0] = pageSuraStart[page - 1];
    bounds[1] = pageAyahStart[page - 1];
    if (page == numberOfPages) {
      bounds[2] = QuranConstants.LAST_SURA;
      bounds[3] = 6;
    } else {
      var nextPageSura = pageSuraStart[page];
      var nextPageAyah = pageAyahStart[page];
      if (nextPageSura == bounds[0]) {
        bounds[2] = bounds[0];
        bounds[3] = nextPageAyah - 1;
      } else {
        if (nextPageAyah > 1) {
          bounds[2] = nextPageSura;
          bounds[3] = nextPageAyah - 1;
        } else {
          bounds[2] = nextPageSura - 1;
          bounds[3] = suraNumAyahs[bounds[2] - 1];
        }
      }
    }
    return bounds;
  }

  int getSuraOnPage(int page) => pageSuraStart[page - 1];

  int getJuzFromPage(int page) {
    for (var i = 0; i < juzPageStart.length; i++) {
      if (juzPageStart[i] > page) {
        return i;
      } else if (juzPageStart[i] == page) {
        return i + 1;
      }
    }
    return 30;
  }

  int getRub3FromPage(int page) {
    return (page > numberOfPages || page < 1) ? -1 : pageRub3Start[page - 1];
  }

  int getPageFromSuraAyah(int sura, int ayah) {
    var currentAyah = (ayah == 0) ? 1 : ayah;
    if (sura < 1 ||
        sura > QuranConstants.NUMBER_OF_SURAS ||
        currentAyah < QuranConstants.MIN_AYAH ||
        currentAyah > QuranConstants.MAX_AYAH) {
      return -1;
    }

    var index = suraPageStart[sura - 1] - 1;
    while (index < numberOfPages) {
      var ss = pageSuraStart[index];
      if (ss > sura || (ss == sura && pageAyahStart[index] > currentAyah)) {
        break;
      }
      index++;
    }
    return index;
  }

  int getAyahId(int sura, int ayah) {
    var ayahId = 0;
    for (var i = 0; i < sura - 1; i++) {
      ayahId += suraNumAyahs[i];
    }
    ayahId += ayah;
    return ayahId;
  }

  int diff(SuraAyah start, SuraAyah end) {
    return getAyahId(end.sura, end.ayah) - getAyahId(start.sura, start.ayah);
  }

  int getNumberOfAyahs(int sura) {
    return (sura < 1 || sura > QuranConstants.NUMBER_OF_SURAS)
        ? -1
        : suraNumAyahs[sura - 1];
  }

  int getNumberOfAyahsInQuran() {
    return suraNumAyahs.reduce((sum, count) => sum + count);
  }

  int getPageFromPosition(int position, bool isDualPagesVisible) {
    if (isDualPagesVisible) {
      return (numberOfPagesDual - position) * 2;
    } else {
      return numberOfPages - position;
    }
  }

  int getPositionFromPage(int page, bool isDualPagesVisible) {
    if (isDualPagesVisible) {
      int pageToUse = (page % 2 != 0) ? page + 1 : page;
      return numberOfPagesDual - pageToUse ~/ 2;
    } else {
      return numberOfPages - page;
    }
  }

  int getJuzForDisplayFromPage(int page) {
    int actualJuz = getJuzFromPage(page);
    int? overriddenJuz = juzPageOverride[page];
    return overriddenJuz ?? actualJuz;
  }

  SuraAyah getSuraAyahFromAyahId(int ayahId) {
    int sura = 0;
    int ayahIdentifier = ayahId;
    while (ayahIdentifier > suraNumAyahs[sura]) {
      ayahIdentifier -= suraNumAyahs[sura++];
    }
    return SuraAyah(sura + 1, ayahIdentifier);
  }

  SuraAyah getQuarterByIndex(int quarter) {
    return quarters[quarter];
  }

  int getJuzFromSuraAyah(int sura, int ayah, int juz) {
    if (juz == 30) {
      return juz;
    }

    // get the starting point of the next juz
    var lastQuarter = quarters[juz * 8];
    // if we're after that starting point, return juz + 1
    if (sura > lastQuarter.sura ||
        (lastQuarter.sura == sura && ayah >= lastQuarter.ayah)) {
      return juz + 1;
    } else {
      // otherwise just return this juz
      return juz;
    }
  }

  bool isMakki(int sura) {
    return suraIsMakki[sura - 1];
  }
}

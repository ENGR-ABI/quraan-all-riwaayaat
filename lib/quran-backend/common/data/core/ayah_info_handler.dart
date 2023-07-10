import 'dart:collection';

import 'package:path_provider/path_provider.dart';
import 'package:quranallriwayat/quran-backend/common/data/core/cache_manager.dart';
import 'package:quranallriwayat/quran-backend/common/data/core/db_manager.dart';
import 'package:quranallriwayat/quran-backend/common/data/model/ayah_bounds.dart';
import 'package:quranallriwayat/quran-backend/common/data/model/sura_ayah.dart';
import 'package:quranallriwayat/quran-backend/common/model/ayah_coordinates.dart';

class AyahInfoHandler {
  Future<Map<int, AyahCoordinates>> getVersesBoundsForPage(
    List<int> pages,
    String quranType,
    String width,
  ) async {
    final cacheManager = CacheManager<dynamic>(quranType);
    final appDirectory = await getApplicationDocumentsDirectory();

    final dbManager = DBManager(
      '${appDirectory.path}/quraan/$quranType/databases/ayahinfo_$width.db',
    );

    final Map<int, AyahCoordinates> pagesVersesBounds = HashMap();

    try {
      for (final page in pages) {
        final boundsFromCache =
            await cacheManager.fetchData(page.toString()) as List<dynamic>?;
        if (boundsFromCache != null) {
          final bounds =
              boundsFromCache.map((e) => e as Map<String, dynamic>).toList();
          pagesVersesBounds[page] = _processVersesBounds(bounds);
        } else {
          final resulRows = dbManager.fetchRecord(
            'SELECT * FROM glyphs WHERE page_number = ? ',
            [page],
          );
          pagesVersesBounds[page] = _processVersesBounds(resulRows);
          await cacheManager.cacheData(page.toString(), resulRows);
        }
      }
    } finally {
      ///DatabaseUtils.closeCursor(cursor);
    }
    return pagesVersesBounds;
  }

  AyahCoordinates _processVersesBounds(List<Map<String, dynamic>> bounds) {
    const colLine = 'line_number';
    const colSura = 'sura_number';
    const colAyah = 'ayah_number';
    const colPosition = 'position';
    const minX = 'min_x';
    const minY = 'min_y';
    const maxX = 'max_x';
    const maxY = 'max_y';

    final Map<String, List<AyahBounds>> ayahBounds = HashMap();
    final page = bounds.first['page_number'] as int;
    final suraAyah = SuraAyah(
      bounds.first['sura_number'] as int,
      bounds.first['ayah_number'] as int,
    );
    final lastSuraAyah = SuraAyah(
      bounds.last['sura_number'] as int,
      bounds.last['ayah_number'] as int,
    );

    for (final versBound in bounds) {
      final line = versBound[colLine] as int;
      final sura = versBound[colSura] as int;
      final ayah = versBound[colAyah] as int;
      final position = versBound[colPosition] as int;
      final minimumX = (versBound[minX] as int).toDouble();
      final minimumY = (versBound[minY] as int).toDouble();
      final maximumX = (versBound[maxX] as int).toDouble();
      final maximumY = (versBound[maxY] as int).toDouble();
      final key = '$sura:$ayah';
      var bounds = ayahBounds[key];
      bounds ??= [];

      AyahBounds? last;
      if (bounds.isNotEmpty) {
        last = bounds[bounds.length - 1];
      }

      final left = minimumX;
      final top = minimumY;
      final rigth = maximumX; //> width
      //? width
      //: (maximumX - widthReduced);
      final bottom = maximumY;

      final bound = AyahBounds(
        ayah,
        line,
        position,
        left,
        top,
        rigth, // < 0 ? -1 * rigth : rigth,
        bottom,
      );
      if (last != null && last.line == bound.line) {
        last.engulf(bound);
      } else {
        bounds.add(bound);
      }
      ayahBounds[key] = bounds;
    }
    return AyahCoordinates(
      page: page,
      suraAyah: suraAyah,
      lastSuraAyah: lastSuraAyah,
      ayahCoordinates: ayahBounds,
    );
  }
}

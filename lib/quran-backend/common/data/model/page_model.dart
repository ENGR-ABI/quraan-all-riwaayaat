import 'package:quranallriwayat/quran-backend/common/data/model/sura_ayah.dart';

import 'package:quranallriwayat/quran-backend/common/data/model/ayah_bounds.dart';

class PageModel {
  PageModel({
    required this.pageNumber,
    required this.suraAyah,
    required this.lastSuraAyah,
    required this.pageImage,
    required this.ayahCoordinates,
  });
  final int pageNumber;
  final SuraAyah suraAyah;
  final SuraAyah lastSuraAyah;
  final String pageImage;
  Map<String, List<AyahBounds>> ayahCoordinates;
}

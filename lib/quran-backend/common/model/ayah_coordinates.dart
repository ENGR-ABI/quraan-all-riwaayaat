import 'package:quranallriwayat/quran-backend/common/data/model/sura_ayah.dart';

import 'package:quranallriwayat/quran-backend/common/data/model/ayah_bounds.dart';

class AyahCoordinates {
  AyahCoordinates({
    required this.page,
    required this.suraAyah,
    required this.lastSuraAyah,
    required this.ayahCoordinates,
  });
  final int page;
  final Map<String, List<AyahBounds>> ayahCoordinates;
  final SuraAyah suraAyah;
  final SuraAyah lastSuraAyah;
}

class QuranSurahMeta {
  final int surahNumber;
  final String name;
  final String revelationPlace;
  final int numberOfVerses;
  final String translatedName;
  QuranSurahMeta({
    required this.surahNumber,
    required this.name,
    required this.translatedName,
    required this.revelationPlace,
    required this.numberOfVerses,
  });

  factory QuranSurahMeta.fromJson(Map<String, dynamic> json) => QuranSurahMeta(
        surahNumber: json['surahNumber'] as int,
        name: json['name'].toString(),
        translatedName: json['translatedName'] as String,
        revelationPlace: json['revelationPlace'] as String,
        numberOfVerses: json['numberOfVerses'] as int,
      );
}

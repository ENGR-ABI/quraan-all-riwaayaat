import '../model/quran_text.dart';

abstract class TranslationsDao {
  Future<List<QuranText>> allAyahs();
}

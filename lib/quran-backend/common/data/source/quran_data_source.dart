import '../model/sura_ayah.dart';

abstract class QuranDataSource {
  int get numberOfPages;
  List<int> get pageForSuraArray;
  List<int> get suraForPageArray;
  List<int> get ayahForPageArray;
  List<int> get pageForJuzArray;
  Map<int, int> get juzDisplayPageArrayOverride;
  List<int> get numberOfAyahsForSuraArray;
  List<bool> get isMakkiBySuraArray;
  List<int> get quarterStartByPage;
  List<SuraAyah> get quartersArray;
}

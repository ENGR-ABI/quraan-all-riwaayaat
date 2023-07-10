import 'constants.dart';

Map<String, Object> initialPreferences = <String, Object>{
  DEFAULT_QURAN_TYPE: '',
  THEME_MODE: 'light',
  ALWAYS_CHOOSE_QURAN_TYPE: true,
  ALWAYS_STREAM: false,
  LAST_RECITED_PAGE: 0,
  LAST_PLAYED_VERSE: 0,
};

List<Map<String, dynamic>> defaultQuranTypes = [
  {
    'title': 'Madani Mush\'af',
    'description':
        'The 1405 classic Madani script mus\'haf from the King Fahd Quuran Complex',
    'images': 'madani-cover.gif,madani-first.gif',
    'downlaodURL':
        'https://firebasestorage.googleapis.com/v0/b/recitemaan.appspot.com/o/quran%2Ftajweed%2Ftajweed.zip?alt=media&token=8b641f2e-5ba7-4717-a499-0d4d47d88c3c',
    'isDownloaded': false,
  },
  {
    'title': 'Tajweed Mush\'af',
    'description':
        'The Tajweed script mus\'haf from the King Fahd Quuran Complex',
    'images': 'tajweed-cover.gif,tajweed-first.gif',
    'downlaodURL':
        'https://firebasestorage.googleapis.com/v0/b/recitemaan.appspot.com/o/quran%2Ftajweed%2Ftajweed.zip?alt=media&token=8b641f2e-5ba7-4717-a499-0d4d47d88c3c',
    'isDownloaded': false,
  },
];


// ignore_for_file: constant_identifier_names

import '../index.dart';
import 'display_size.dart';
import 'page_size_calculator.dart';
import 'quran_data_source.dart';

abstract class PageProvider {
  QuranDataSource getDataSource();
  PageSizeCalculator getPageSizeCalculator(DisplaySize displaySize);

  int getImageVersion();

  String getImagesBaseUrl();
  String getImagesZipBaseUrl();
  String getPatchBaseUrl();
  String getAyahInfoBaseUrl();
  String getDatabasesBaseUrl();
  String getAudioDatabasesBaseUrl();

  String getAudioDirectoryName();
  String getDatabaseDirectoryName();
  String getAyahInfoDirectoryName();
  String getImagesDirectoryName();

  bool ayahInfoDbHasGlyphData() => false;

  int getPreviewTitle();
  int getPreviewDescription();

  PageContentType getPageContentType() => PageContentType.IMAGE;
  String? getFallbackPageType();
  List<Qari> getQaris();
  String pageType() => '';
}

enum PageContentType {
  IMAGE,
  // Add other content types as needed
}



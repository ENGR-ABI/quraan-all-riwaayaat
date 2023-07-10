import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class Settings {
  Future<void> setVersion(int version);
  Future<void> removeDidDownloadPages();
  Future<void> setShouldOverlayPageInfo(bool shouldOverlay);
  Future<int> lastPage();
  Future<bool> isNightMode();
  Future<int> nightModeTextBrightness();
  Future<int> nightModeBackgroundBrightness();
  Future<bool> shouldShowHeaderFooter();
  Future<bool> shouldShowBookmarks();
  Future<String> pageType();

  ValueNotifier<String> preferencesValueNotifier();
}

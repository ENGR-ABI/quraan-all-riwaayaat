import 'package:adwaita/adwaita.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'color_schemes.g.dart';

class ThemeController extends GetxController {
  static ThemeController get inst => Get.find();

  late Rx<ThemeData> activeTheme;
  late ThemeData _lightTheme;
  ThemeData get lightTheme => _lightTheme;
  late ThemeData _darkTheme;
  ThemeData get darkTheme => _darkTheme;
  final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  Future<ThemeController> loadThemeData() async {
    _lightTheme = AdwaitaThemeData.light().copyWith(
      colorScheme: lightColorScheme,
      primaryColor: lightColorScheme.primary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
        ),
      ),
    );
    _darkTheme = AdwaitaThemeData.dark().copyWith(
      colorScheme: darkColorScheme,
      primaryColor: darkColorScheme.primary,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
        ),
      ),
    );
    activeTheme = Rx(lightTheme);
    themeNotifier.addListener(() {
      activeTheme.value =
          themeNotifier.value == ThemeMode.light ? lightTheme : darkTheme;
    });
    return this;
  }
}

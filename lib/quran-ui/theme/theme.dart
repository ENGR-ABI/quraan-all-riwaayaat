// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'theme_model.dart';


class IqraaTheme {
  static ThemeData initTheme(ThemeModel themeColors) {
    ColorScheme colorScheme = _generateColorScheme(themeColors);
    return ThemeData.from(
      colorScheme: colorScheme,
      textTheme: Typography.englishLike2021.apply(
        fontFamily: 'Nunito',
        bodyColor: themeColors.onBackground,
        displayColor: themeColors.primary,
      ),
    ).copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          )),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(themeColors.radius),
              ),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(88, 36),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          )),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(themeColors.radius),
              ),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(88, 36),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          )),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(themeColors.radius),
              ),
            ),
          ),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(
              style: BorderStyle.solid,
              width: 2,
              color: themeColors.primary,
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          minimumSize: MaterialStateProperty.all<Size>(
            const Size(88, 36),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(14, 10, 14, 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(themeColors.radius),
          ),
        ),
      ),
    );
  }

  static ColorScheme _generateColorScheme(ThemeModel themeColors) =>
      ColorScheme(
        brightness: themeColors.brightness,
        primary: themeColors.primary,
        onPrimary: themeColors.onPrimary,
        secondary: themeColors.secondary,
        onSecondary: themeColors.onSecondary,
        tertiary: themeColors.tertiary,
        onTertiary: themeColors.onTertiary,
        tertiaryContainer: Color(0xFFD1FFF2),
        onTertiaryContainer: Color(0xFF00174B),
        error: themeColors.error,
        errorContainer: themeColors.errorContainer,
        onError: themeColors.onError,
        onErrorContainer: themeColors.onErrorContainer,
        background: themeColors.background,
        onBackground: themeColors.onBackground,
        surface: themeColors.surface,
        onSurface: themeColors.onSurface,
        outline: themeColors.outline,
        onInverseSurface: const Color(0xFFF1F0F4),
        inverseSurface: const Color(0xFF2F3033),
        inversePrimary: const Color(0xFF6E7E8D),
        shadow: const Color(0xFF000000),
        surfaceTint: const Color(
          0xFF1D5FA6,
        ),
        primaryContainer: themeColors.primaryContainer,
        onPrimaryContainer: themeColors.onPrimaryContainer,
        secondaryContainer: themeColors.secondaryContainer,
        onSecondaryContainer: themeColors.onSecondaryContainer,
        surfaceVariant: Color(0xFFE7E0EC),
        onSurfaceVariant: Color(0xFF49454F),
      );
}

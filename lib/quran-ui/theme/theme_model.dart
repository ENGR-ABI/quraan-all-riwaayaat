import 'dart:ui';

import 'constants.dart';

class ThemeModel {
  ThemeModel({
    required this.brightness,
    required this.theme,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.onBackground,
    required this.outline,
    required this.layoutStyle,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.onTertiary,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.onError,
    this.radius = 4,
    this.success = ThemeConstants.success,
    this.info = ThemeConstants.info,
    this.warning = ThemeConstants.warning,
    this.danger = ThemeConstants.danger,
    this.tertiary = const Color(0xFF70ca81),
    this.error = const Color(0xFFBA1A1A),
  });
  final String theme;
  final Brightness brightness;
  Color primary,
      onPrimary,
      secondary,
      onSecondary,
      surface,
      onSurface,
      background,
      onBackground,
      outline,
      success,
      info,
      warning,
      danger,
      tertiary,
      primaryContainer,
      onPrimaryContainer,
      secondaryContainer,
      onSecondaryContainer,
      onTertiary,
      errorContainer,
      onErrorContainer,
      error,
      onError;
  final String layoutStyle;
  final double radius;
}

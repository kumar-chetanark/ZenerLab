import 'package:flutter/material.dart';

/// App-wide theme mode controller using ValueNotifier for instantaneous reactive switching
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController._() : super(ThemeMode.system);

  static final ThemeController instance = ThemeController._();

  bool isDarkMode(BuildContext context) {
    if (value == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return value == ThemeMode.dark;
  }

  void toggleTheme(BuildContext context) {
    if (isDarkMode(context)) {
      value = ThemeMode.light;
    } else {
      value = ThemeMode.dark;
    }
  }

  void setThemeMode(ThemeMode mode) {
    value = mode;
  }
}

import 'package:flutter/material.dart';
class AppTheme {
  // Define your brand's core seed color once
  static const Color _brandSeedColor = Colors.deepOrange;

  // ☀️ Auto-Generated Light Theme Layout Colors
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // Automatically creates light backgrounds with dark text contrast layers
      colorScheme: ColorScheme.fromSeed(
        seedColor: _brandSeedColor,
        brightness: Brightness.light,
      ),
    );
  }

  // 🌙 Auto-Generated Dark Theme Layout Colors
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      // Automatically creates dark backgrounds with white text contrast layers
      colorScheme: ColorScheme.fromSeed(
        seedColor: _brandSeedColor,
        brightness: Brightness.dark,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryCyan = Color(0xFF00a0bd);
  static const Color industrialOrange = Color(0xFFf97316);
  static const Color cementGray = Color(0xFF64748b);
  static const Color darkBackground = Color(0xFF121212);
  static const Color lightBackground = Color(0xFFF9FAFB);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryCyan,
      primary: primaryCyan,
      secondary: industrialOrange,
      brightness: Brightness.light,
      background: lightBackground,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: lightBackground,
    textTheme: GoogleFonts.spaceGroteskTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: const Color(0xFF0c1a1d),
      displayColor: const Color(0xFF0c1a1d),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: Color(0xFF0c1a1d),
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFF3F4F6), width: 1), // Gray-100 equivalent
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryCyan,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
      ),
    ),
  );
}

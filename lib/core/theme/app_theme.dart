import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Violet
  static const Color scaffoldLight = Color(0xFFF8FAFC);
  static const Color scaffoldDark = Color(0xFF0F172A); // Slate 900
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B); // Slate 800

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldLight,
    textTheme: GoogleFonts.outfitTextTheme(),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      surface: cardLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scaffoldLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        color: const Color(0xFF1E293B),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cardLight,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: scaffoldDark,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      surface: cardDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scaffoldDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.outfit(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cardDark,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // "Pristine Studio" Masterpiece Palette - Minimalist & Elegant
  static const Color studioBackground = Color(0xFFF9FAFB);
  static const Color studioSurface = Color(0xFFFFFFFF);
  static const Color studioText = Color(0xFF111827); // Deep Charcoal
  static const Color studioTextSecondary = Color(0xFF6B7280); // Cool Gray
  static const Color studioAccent = Color(0xFF2563EB); // Royal Blue
  static const Color studioBorder = Color(0xFFE5E7EB);
  
  // Refined Status Colors
  static const Color todoColor = Color(0xFFF59E0B); // Amber
  static const Color doingColor = Color(0xFF3B82F6); // Blue
  static const Color doneColor = Color(0xFF10B981); // Emerald

  static ThemeData get lightMasterpiece => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: studioBackground,
    primaryColor: studioAccent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: studioAccent,
      brightness: Brightness.light,
      surface: studioSurface,
      onSurface: studioText,
    ),
    
    textTheme: TextTheme(
      displayLarge: GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: studioText,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: studioText,
        letterSpacing: -0.5,
      ),
      titleLarge: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: studioText,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 15,
        color: studioText,
        height: 1.5,
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: studioBackground,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: studioText),
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: studioText,
      ),
    ),

    cardTheme: CardThemeData(
      color: studioSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: studioBorder, width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: studioSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: studioBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: studioBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: studioAccent, width: 2),
      ),
    ),
  );
}

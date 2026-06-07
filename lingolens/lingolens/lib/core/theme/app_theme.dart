import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color background    = Color(0xFFC1D5FF);
  static const Color surface       = Color(0xFF16213E);
  static const Color surfaceAlt    = Color(0xFF0F3460);
  static const Color accent        = Color(0xFF7B6CF6);
  static const Color accentLight   = Color(0xFFAB9FF2);
  static const Color accentSoft    = Color(0x267B6CF6);
  static const Color textPrimary   = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color divider       = Color(0xFF2A2A4A);
  static const Color success       = Color(0xFF4CAF86);
  static const Color error         = Color(0xFFFF6B6B);

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary:   accent,
        secondary: accentLight,
        surface:   surface,
        error:     error,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme().copyWith(
        displayLarge: GoogleFonts.dmSerifDisplay(
          color: textPrimary, fontSize: 32, fontWeight: FontWeight.w400,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        titleMedium: GoogleFonts.spaceGrotesk(
          color: textPrimary, fontSize: 17, fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.spaceGrotesk(
          color: textPrimary, fontSize: 15, fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.spaceGrotesk(
          color: textSecondary, fontSize: 13, fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.spaceGrotesk(
          color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        hintStyle: GoogleFonts.spaceGrotesk(color: textSecondary, fontSize: 14),
        labelStyle: GoogleFonts.spaceGrotesk(color: textSecondary, fontSize: 14),
        errorStyle: GoogleFonts.spaceGrotesk(color: error, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.2,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.dmSerifDisplay(
          color: textPrimary, fontSize: 26,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
    );
  }
}

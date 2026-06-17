import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Pantanal-inspired palette
  static const Color primary = Color(0xFF0F7263); // deep teal-green (lagoa)
  static const Color primaryDark = Color(0xFF064D42);
  static const Color primaryLight = Color(0xFF3DA38F);

  static const Color accent = Color(0xFFE8A23F); // sunset over wetland
  static const Color accentDark = Color(0xFFC97E1B);

  static const Color sand = Color(0xFFF4ECD8);
  static const Color cream = Color(0xFFFAF6EC);
  static const Color ink = Color(0xFF0F1B1A);
  static const Color slate = Color(0xFF536362);

  // Dark mode
  static const Color darkBg = Color(0xFF0A1413);
  static const Color darkSurface = Color(0xFF13201E);
  static const Color darkSurfaceAlt = Color(0xFF1A2A28);
}

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.cream,
    );
    return _build(scheme, Brightness.light);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      secondary: AppColors.accent,
      surface: AppColors.darkSurface,
    );
    return _build(scheme, Brightness.dark);
  }

  static ThemeData _build(ColorScheme scheme, Brightness b) {
    final isDark = b == Brightness.dark;
    final base = ThemeData(
      colorScheme: scheme,
      brightness: b,
      useMaterial3: true,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBg : AppColors.cream,
    );
    final textBase = isDark
        ? base.textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white)
        : base.textTheme;
    return base.copyWith(
      textTheme: GoogleFonts.interTextTheme(textBase).copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
          color: isDark ? Colors.white : AppColors.ink,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: isDark ? Colors.white : AppColors.ink,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: isDark ? Colors.white : AppColors.ink,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : AppColors.ink,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : AppColors.ink,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.ink,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          height: 1.55,
          color: isDark ? Colors.white.withOpacity(0.92) : AppColors.ink,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          height: 1.5,
          color: isDark ? Colors.white.withOpacity(0.85) : AppColors.ink,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : AppColors.ink,
        ),
      ),
      cardTheme: CardThemeData(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.darkSurfaceAlt
            : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white12
                : AppColors.slate.withOpacity(0.18),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white12
                : AppColors.slate.withOpacity(0.18),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          color: isDark ? Colors.white70 : AppColors.slate,
          fontWeight: FontWeight.w500,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        side: BorderSide.none,
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white12 : AppColors.slate.withOpacity(0.12),
        thickness: 1,
        space: 1,
      ),
    );
  }
}

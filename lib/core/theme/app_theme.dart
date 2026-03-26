import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Extended colors not covered by Material 3's ColorScheme.
class ExtendedColors {
  const ExtendedColors({
    required this.calorieGradient,
    required this.waterGradient,
    required this.primaryGradient,
    required this.purpleGradient,
    required this.accentAmber,
    required this.accentOrange,
    required this.waterBlue,
    required this.waterBlueLight,
    required this.accentPurple,
    required this.accentRose,
    required this.breakfastColor,
    required this.lunchColor,
    required this.dinnerColor,
    required this.snackColor,
    required this.successGreen,
  });

  final LinearGradient calorieGradient;
  final LinearGradient waterGradient;
  final LinearGradient primaryGradient;
  final LinearGradient purpleGradient;
  final Color accentAmber;
  final Color accentOrange;
  final Color waterBlue;
  final Color waterBlueLight;
  final Color accentPurple;
  final Color accentRose;
  final Color breakfastColor;
  final Color lunchColor;
  final Color dinnerColor;
  final Color snackColor;
  final Color successGreen;
}

/// InheritedWidget to provide [ExtendedColors] down the tree.
class ExtendedColorsProvider extends InheritedWidget {
  const ExtendedColorsProvider({
    required this.colors,
    required super.child,
    super.key,
  });

  final ExtendedColors colors;

  static ExtendedColors of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ExtendedColorsProvider>();
    if (provider == null) {
      throw FlutterError(
        'No ExtendedColorsProvider found in context. '
        'Ensure ExtendedColorsProvider wraps MaterialApp.',
      );
    }
    return provider.colors;
  }

  @override
  bool updateShouldNotify(ExtendedColorsProvider oldWidget) =>
      colors != oldWidget.colors;
}

/// Port of Theme.kt — Material 3 theme for EasyDiet.
class AppTheme {
  AppTheme._();

  static const _extendedColors = ExtendedColors(
    calorieGradient: LinearGradient(
      colors: [AppColors.gradientCalorieStart, AppColors.gradientCalorieEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    waterGradient: LinearGradient(
      colors: [AppColors.gradientWaterStart, AppColors.gradientWaterEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    primaryGradient: LinearGradient(
      colors: [AppColors.gradientGreenStart, AppColors.gradientGreenEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    purpleGradient: LinearGradient(
      colors: [AppColors.gradientPurpleStart, AppColors.gradientPurpleEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentAmber: AppColors.accentAmber,
    accentOrange: AppColors.accentOrange,
    waterBlue: AppColors.waterBlue,
    waterBlueLight: AppColors.waterBlueLight,
    accentPurple: AppColors.accentPurple,
    accentRose: AppColors.accentRose,
    breakfastColor: AppColors.breakfastColor,
    lunchColor: AppColors.lunchColor,
    dinnerColor: AppColors.dinnerColor,
    snackColor: AppColors.snackColor,
    successGreen: AppColors.successGreen,
  );

  static ExtendedColors get extendedColors => _extendedColors;

  // ── Light scheme ──────────────────────────────────────────────────────

  static final _lightColorScheme = ColorScheme.light(
    primary: AppColors.emeraldPrimary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.emeraldSurface,
    onPrimaryContainer: AppColors.emeraldDark,
    secondary: AppColors.tealSecondary,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.tealLight.withValues(alpha: 0.3),
    onSecondaryContainer: AppColors.emeraldDark,
    tertiary: AppColors.accentAmber,
    onTertiary: Colors.white,
    surface: Colors.white,
    onSurface: AppColors.gray900,
    surfaceContainerHighest: AppColors.gray100,
    onSurfaceVariant: AppColors.gray500,
    error: AppColors.errorRed,
    onError: Colors.white,
    outline: AppColors.gray300,
    outlineVariant: AppColors.gray200,
  );

  // ── Dark scheme ───────────────────────────────────────────────────────

  static final _darkColorScheme = ColorScheme.dark(
    primary: AppColors.emeraldPrimaryDark,
    onPrimary: AppColors.darkBackground,
    primaryContainer: AppColors.emeraldDark.withValues(alpha: 0.3),
    onPrimaryContainer: AppColors.emeraldPrimaryDark,
    secondary: AppColors.emeraldSecondaryDark,
    onSecondary: AppColors.darkBackground,
    secondaryContainer: AppColors.tealSecondary.withValues(alpha: 0.2),
    onSecondaryContainer: AppColors.emeraldSecondaryDark,
    tertiary: AppColors.accentAmber,
    onTertiary: AppColors.gray900,
    surface: AppColors.darkSurface,
    onSurface: AppColors.gray100,
    surfaceContainerHighest: AppColors.darkSurfaceVariant,
    onSurfaceVariant: AppColors.gray400,
    error: AppColors.errorRedDark,
    onError: AppColors.errorRed,
    outline: AppColors.gray600,
    outlineVariant: AppColors.gray700,
  );

  // ── Typography ────────────────────────────────────────────────────────

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.nunito(
        fontWeight: FontWeight.w800,
        fontSize: 32,
        height: 40 / 32,
      ),
      headlineLarge: GoogleFonts.nunito(
        fontWeight: FontWeight.w800,
        fontSize: 28,
        height: 36 / 28,
      ),
      headlineMedium: GoogleFonts.nunito(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        height: 32 / 24,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        height: 28 / 20,
      ),
      titleLarge: GoogleFonts.nunito(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        height: 24 / 18,
      ),
      titleMedium: GoogleFonts.nunito(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        height: 22 / 16,
      ),
      titleSmall: GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 20 / 14,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 24 / 16,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 20 / 14,
      ),
      bodySmall: GoogleFonts.nunito(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 16 / 12,
      ),
      labelLarge: GoogleFonts.nunito(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        fontSize: 10,
        height: 14 / 10,
        letterSpacing: 0.5,
      ),
    );
  }

  // ── Theme builders ────────────────────────────────────────────────────

  static ThemeData light() {
    final textTheme = _buildTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.gray50,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.gray900,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.gray900,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emeraldPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.emeraldPrimary,
          side: const BorderSide(color: AppColors.emeraldPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.emeraldPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: textTheme.labelLarge,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.emeraldPrimary,
        unselectedItemColor: AppColors.gray400,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
      ),
    );
  }

  static ThemeData dark() {
    final textTheme = _buildTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.gray100,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.gray100,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.darkSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.emeraldPrimaryDark,
          foregroundColor: AppColors.darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.emeraldPrimaryDark,
          side: const BorderSide(color: AppColors.emeraldPrimaryDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.emeraldPrimaryDark,
          foregroundColor: AppColors.darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: textTheme.labelLarge,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.emeraldPrimaryDark,
        unselectedItemColor: AppColors.gray500,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.darkSurface,
      ),
    );
  }
}

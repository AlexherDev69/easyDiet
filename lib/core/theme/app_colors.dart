import 'package:flutter/material.dart';

/// Port of Color.kt — full color palette for EasyDiet.
class AppColors {
  AppColors._();

  // Primary palette — Emerald vibrant
  static const emeraldPrimary = Color(0xFF10B981);
  static const emeraldDark = Color(0xFF059669);
  static const emeraldLight = Color(0xFF6EE7B7);
  static const emeraldSurface = Color(0xFFD1FAE5);
  static const emeraldBackground = Color(0xFFF0FDF4);

  // Secondary — Teal
  static const tealSecondary = Color(0xFF14B8A6);
  static const tealLight = Color(0xFF5EEAD4);

  // Accent — Amber/Orange (calories, energy)
  static const accentAmber = Color(0xFFF59E0B);
  static const accentOrange = Color(0xFFF97316);

  // Accent — Blue (water, hydration)
  static const waterBlue = Color(0xFF3B82F6);
  static const waterBlueLight = Color(0xFF93C5FD);
  static const waterBlueDark = Color(0xFF2563EB);

  // Accent — Purple (weight, progress)
  static const accentPurple = Color(0xFF8B5CF6);
  static const accentPurpleLight = Color(0xFFA78BFA);

  // Accent — Rose (snacks, desserts)
  static const accentRose = Color(0xFFF43F5E);
  static const accentRoseLight = Color(0xFFFDA4AF);

  // Gradient colors
  static const gradientGreenStart = Color(0xFF10B981);
  static const gradientGreenEnd = Color(0xFF059669);
  static const gradientCalorieStart = Color(0xFFF59E0B);
  static const gradientCalorieEnd = Color(0xFFEF4444);
  static const gradientWaterStart = Color(0xFF3B82F6);
  static const gradientWaterEnd = Color(0xFF06B6D4);
  static const gradientPurpleStart = Color(0xFF8B5CF6);
  static const gradientPurpleEnd = Color(0xFF6366F1);

  // Dark theme palette
  static const emeraldPrimaryDark = Color(0xFF6EE7B7);
  static const emeraldSecondaryDark = Color(0xFF5EEAD4);
  static const emeraldTertiaryDark = Color(0xFFA7F3D0);
  static const darkBackground = Color(0xFF0F1511);
  static const darkSurface = Color(0xFF1A2420);
  static const darkSurfaceVariant = Color(0xFF2A3632);

  // Neutral palette
  static const gray50 = Color(0xFFF9FAFB);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray500 = Color(0xFF6B7280);
  static const gray600 = Color(0xFF4B5563);
  static const gray700 = Color(0xFF374151);
  static const gray800 = Color(0xFF1F2937);
  static const gray900 = Color(0xFF111827);

  // Semantic colors
  static const errorRed = Color(0xFFEF4444);
  static const errorRedDark = Color(0xFFFCA5A5);
  static const successGreen = Color(0xFF10B981);
  static const warningAmber = Color(0xFFF59E0B);

  // Meal type colors
  static const breakfastColor = Color(0xFFF59E0B);
  static const lunchColor = Color(0xFF10B981);
  static const dinnerColor = Color(0xFF8B5CF6);
  static const snackColor = Color(0xFFF43F5E);

  // Macro nutrient colors
  static const macroProtein = accentRose;
  static const macroCarbs = Color(0xFFFBBF24); // amber-400
  static const macroFat = accentAmber;
}

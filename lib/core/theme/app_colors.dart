import 'package:flutter/material.dart';

/// App Color Palette - Ocean Blue & Sky (Water-Inspired Theme)
class AppColors {
  AppColors._();

  // Primary Colors - Ocean Blue
  static const Color primary = Color(0xFF1E88E5); // Ocean Blue
  static const Color primaryDark = Color(0xFF0D47A1); // Deep Ocean
  static const Color primaryLight = Color(0xFF64B5F6); // Light Ocean Blue

  // Secondary Colors - Sky Blue
  static const Color secondary = Color(0xFF42A5F5); // Sky Blue
  static const Color secondaryDark = Color(0xFF1976D2); // Deep Sky
  static const Color secondaryLight = Color(0xFF90CAF9); // Light Sky

  // Accent Colors - Bright Blue
  static const Color accent = Color(0xFF64B5F6); // Light Blue
  static const Color accentDark = Color(0xFF1976D2); // Deep Blue
  static const Color accentLight = Color(0xFFBBDEFB); // Very Light Blue

  // Background & Surface - Water-inspired
  static const Color background = Color(0xFFF5F9FF); // Very Light Blue tint
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceVariant = Color(0xFFE3F2FD); // Light Blue surface

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF2196F3);

  // Gradient Colors - Water-themed
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Water wave gradient - for special effects
  static const LinearGradient waterGradient = LinearGradient(
    colors: [Color(0xFF1E88E5), Color(0xFF42A5F5), Color(0xFF64B5F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Overlays
  static const Color overlay = Color(0x80000000);
  static const Color scrim = Color(0x4D000000);

  // Borders
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);

  // Shadow Colors
  static Color shadowLight = Colors.black.withValues(alpha: 0.05);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.1);
  static Color shadowHeavy = Colors.black.withValues(alpha: 0.15);
}

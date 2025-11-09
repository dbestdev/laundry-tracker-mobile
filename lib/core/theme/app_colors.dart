import 'package:flutter/material.dart';

/// App Color Palette - Fresh Teal & Coral Theme
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF00BFA5); // Fresh Teal
  static const Color primaryDark = Color(0xFF00897B);
  static const Color primaryLight = Color(0xFF5DF2D6);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF6B6B); // Coral Red
  static const Color secondaryDark = Color(0xFFD84545);
  static const Color secondaryLight = Color(0xFFFF9999);

  // Accent Colors
  static const Color accent = Color(0xFF4ECDC4); // Light Teal
  static const Color accentDark = Color(0xFF3AAFA9);
  static const Color accentLight = Color(0xFF80DEEA);

  // Background & Surface
  static const Color background = Color(0xFFF8FAFB); // Off-white
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
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

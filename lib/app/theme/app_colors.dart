import 'package:flutter/material.dart';

/// Centralized color palette tokens for GlamQ.
///
/// Designed with a modern, premium aesthetic suitable for salons, barbers,
/// beauty parlours, and lifestyle service marketplaces.
class AppColors {
  AppColors._();

  // Brand Primary & Accent
  static const Color primary = Color(0xFF9F1239); // Deep Rose / Wine
  static const Color primaryDark = Color(0xFF881337);
  static const Color primaryLight = Color(0xFFF43F5E);

  static const Color secondary = Color(0xFFD97706); // Warm Amber / Gold
  static const Color secondaryDark = Color(0xFFB45309);
  static const Color secondaryLight = Color(0xFFFBBF24);

  // Light Theme Neutrals
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Theme Neutrals
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  // Feedback & State Colors
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);
}

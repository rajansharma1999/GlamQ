/// Application-wide constants.
///
/// These values are static definitions used across the app.
/// Business rules or values that can change dynamically (such as platform fees)
/// must be managed via backend configuration or remote settings, NOT hardcoded.
class AppConstants {
  // Private constructor to prevent instantiation.
  AppConstants._();

  /// Application name.
  static const String appName = 'GlamQ';

  /// Application tagline.
  static const String appTagline = 'Your Premium Beauty & Grooming Marketplace';

  /// Initial fallback platform fee (in INR) per completed booking.
  ///
  /// IMPORTANT:
  /// This fee is dynamic and configurable from the backend/admin panel.
  /// Do NOT hardcode this value in calculations or business logic;
  /// always fetch the active platform fee from configuration service/backend.
  static const double initialPlatformFee = 8.0;

  /// Currency code and symbol.
  static const String currencyCode = 'INR';
  static const String currencySymbol = '₹';
}

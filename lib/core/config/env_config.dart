/// Environment configuration for the app
class EnvConfig {
  // Private constructor to prevent instantiation
  EnvConfig._();

  /// API Base URL
  /// For Android Emulator: use 10.0.2.2 to access localhost
  /// For iOS Simulator: use localhost or 127.0.0.1
  /// For Physical Device: use your computer's local IP address
  static String get apiBaseUrl {
    const bool isProduction = bool.fromEnvironment('PRODUCTION', defaultValue: false);

    if (isProduction) {
      return 'https://api.laundrytracker.com';
    }

    // Development - Android Emulator
    // If you're using iOS Simulator, change this to 'http://localhost:3000'
    // If you're using a physical device, use your computer's IP (e.g., 'http://192.168.1.100:3000')
    return 'http://10.0.2.2:3000';
  }

  /// API Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Environment mode
  static bool get isProduction => const bool.fromEnvironment('PRODUCTION', defaultValue: false);
  static bool get isDevelopment => !isProduction;
}

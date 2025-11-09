class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Laundry Tracker';
  static const String appTagline = 'Fresh Laundry, Tracked Perfectly';

  // Validation
  static const int minPasswordLength = 8;
  static const int minNameLength = 2;
  static const int otpLength = 6;
  static const int otpResendDelay = 60; // seconds

  // Regex Patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]',
  );

  static final RegExp nameRegex = RegExp(r'^[a-zA-Z\s]+$');

  static final RegExp phoneRegex = RegExp(r'^\+?[\d\s-()]+$');

  // Dummy OTP for testing
  static const String dummyOtp = '123456';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);

  // API Simulation Delay
  static const Duration apiDelay = Duration(seconds: 2);

  // Local Storage Keys
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String isLoggedInKey = 'is_logged_in';
  static const String userDataKey = 'user_data';
  static const String authTokenKey = 'auth_token';
  static const String rememberMeKey = 'remember_me';
}

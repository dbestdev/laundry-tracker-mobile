import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSource({required this.sharedPreferences});

  /// Save user data
  Future<void> saveUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await sharedPreferences.setString(AppConstants.userDataKey, userJson);
    await sharedPreferences.setBool(AppConstants.isLoggedInKey, true);
  }

  /// Get saved user
  UserModel? getSavedUser() {
    final userJson = sharedPreferences.getString(AppConstants.userDataKey);
    if (userJson == null) return null;

    final userMap = json.decode(userJson) as Map<String, dynamic>;
    return UserModel.fromJson(userMap);
  }

  /// Save auth token
  Future<void> saveAuthToken(String token) async {
    await sharedPreferences.setString(AppConstants.authTokenKey, token);
  }

  /// Get auth token
  String? getAuthToken() {
    return sharedPreferences.getString(AppConstants.authTokenKey);
  }

  /// Save remember me preference
  Future<void> saveRememberMe(bool rememberMe) async {
    await sharedPreferences.setBool(AppConstants.rememberMeKey, rememberMe);
  }

  /// Get remember me preference
  bool getRememberMe() {
    return sharedPreferences.getBool(AppConstants.rememberMeKey) ?? false;
  }

  /// Check if logged in
  bool isLoggedIn() {
    return sharedPreferences.getBool(AppConstants.isLoggedInKey) ?? false;
  }

  /// Clear all auth data
  Future<void> clearAuthData() async {
    await sharedPreferences.remove(AppConstants.userDataKey);
    await sharedPreferences.remove(AppConstants.authTokenKey);
    await sharedPreferences.setBool(AppConstants.isLoggedInKey, false);
  }

  /// Mock: Create a dummy user for testing
  UserModel createDummyUser({
    required String firstName,
    required String lastName,
    required String email,
    String? phoneNumber,
  }) {
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
      isEmailVerified: true,
    );
  }

  /// Mock: Verify OTP (always returns true for testing)
  Future<bool> verifyOtp(String otp) async {
    // Simulate API delay
    await Future.delayed(AppConstants.apiDelay);
    // Accept the dummy OTP or any 6-digit code for testing
    return otp == AppConstants.dummyOtp || otp.length == 6;
  }

  /// Mock: Validate credentials (simple email check for testing)
  Future<bool> validateCredentials(String email, String password) async {
    // Simulate API delay
    await Future.delayed(AppConstants.apiDelay);
    // For testing, accept any password with length >= 8
    return email.contains('@') && password.length >= 8;
  }
}

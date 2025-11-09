import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Sign up a new user - sends OTP email
  Future<Either<String, String>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  });

  /// Verify OTP and create user
  Future<Either<String, UserEntity>> verifyOtp({
    required String email,
    required String otp,
  });

  /// Resend OTP email
  Future<Either<String, String>> resendOtp({
    required String email,
  });

  /// Sign in a user
  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  /// Sign out current user
  Future<Either<String, void>> signOut();

  /// Request password reset OTP
  Future<Either<String, bool>> requestPasswordReset(String email);

  /// Reset password with OTP
  Future<Either<String, bool>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  /// Get current user
  Future<Either<String, UserEntity?>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();
}

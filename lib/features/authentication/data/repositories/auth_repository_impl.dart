import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<String, UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      // Create dummy user
      final userModel = localDataSource.createDummyUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
      );

      // Save user (but not logged in yet, needs OTP verification)
      await localDataSource.saveUser(userModel);

      // Generate dummy token
      final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
      await localDataSource.saveAuthToken(token);

      return Right(userModel.toEntity());
    } catch (e) {
      return Left('Failed to sign up: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final isValid = await localDataSource.verifyOtp(otp);

      if (!isValid) {
        return const Left('Invalid OTP');
      }

      return const Right(true);
    } catch (e) {
      return Left('Failed to verify OTP: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, UserEntity>> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      // Validate credentials
      final isValid = await localDataSource.validateCredentials(email, password);

      if (!isValid) {
        return const Left('Invalid email or password');
      }

      // Get or create dummy user
      var user = localDataSource.getSavedUser();

      if (user == null) {
        // Create a new dummy user if none exists
        user = localDataSource.createDummyUser(
          firstName: 'John',
          lastName: 'Doe',
          email: email,
        );
        await localDataSource.saveUser(user);
      }

      // Save remember me preference
      await localDataSource.saveRememberMe(rememberMe);

      return Right(user.toEntity());
    } catch (e) {
      return Left('Failed to sign in: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await localDataSource.clearAuthData();
      return const Right(null);
    } catch (e) {
      return Left('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> requestPasswordReset(String email) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // For dummy implementation, always succeed
      return const Right(true);
    } catch (e) {
      return Left('Failed to request password reset: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      // Verify OTP
      final isValid = await localDataSource.verifyOtp(otp);

      if (!isValid) {
        return const Left('Invalid OTP');
      }

      // For dummy implementation, just return success
      return const Right(true);
    } catch (e) {
      return Left('Failed to reset password: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, UserEntity?>> getCurrentUser() async {
    try {
      final user = localDataSource.getSavedUser();
      return Right(user?.toEntity());
    } catch (e) {
      return Left('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return localDataSource.isLoggedIn();
  }
}

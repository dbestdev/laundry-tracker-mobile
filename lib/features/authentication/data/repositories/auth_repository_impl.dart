import 'package:dartz/dartz.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<String, UserEntity>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      // Call backend API to register user
      final response = await remoteDataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

      // Save user data locally
      await localDataSource.saveUser(response.user);

      // Save auth token
      await localDataSource.saveAuthToken(response.accessToken);

      return Right(response.user.toEntity());
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
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
      // Call backend API to login
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save user data locally
      await localDataSource.saveUser(response.user);

      // Save auth token
      await localDataSource.saveAuthToken(response.accessToken);

      // Save remember me preference
      await localDataSource.saveRememberMe(rememberMe);

      return Right(response.user.toEntity());
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
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

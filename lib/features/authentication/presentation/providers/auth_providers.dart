import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';

// SharedPreferences provider - will be overridden in main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main.dart');
});

// Dio client provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// Auth local data source provider
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalDataSource(sharedPreferences: sharedPrefs);
});

// Auth remote data source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDataSourceImpl(dioClient: dioClient);
});

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

// Current user provider
final currentUserProvider = FutureProvider<UserEntity?>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final result = await repository.getCurrentUser();

  return result.fold(
    (error) => null,
    (user) => user,
  );
});

// Is logged in provider
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return await repository.isLoggedIn();
});

// Auth state notifier for managing authentication state
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthStateNotifier(this.repository) : super(const AuthState.initial());

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    state = const AuthState.loading();

    final result = await repository.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );

    state = result.fold(
      (error) => AuthState.error(error),
      (user) => AuthState.signUpSuccess(user),
    );
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    state = const AuthState.loading();

    final result = await repository.verifyOtp(email: email, otp: otp);

    state = result.fold(
      (error) => AuthState.error(error),
      (success) => const AuthState.otpVerified(),
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    state = const AuthState.loading();

    final result = await repository.signIn(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );

    state = result.fold(
      (error) => AuthState.error(error),
      (user) => AuthState.authenticated(user),
    );
  }

  Future<void> signOut() async {
    state = const AuthState.loading();

    final result = await repository.signOut();

    state = result.fold(
      (error) => AuthState.error(error),
      (_) => const AuthState.unauthenticated(),
    );
  }

  Future<void> requestPasswordReset(String email) async {
    state = const AuthState.loading();

    final result = await repository.requestPasswordReset(email);

    state = result.fold(
      (error) => AuthState.error(error),
      (_) => const AuthState.passwordResetRequested(),
    );
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    state = const AuthState.loading();

    final result = await repository.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );

    state = result.fold(
      (error) => AuthState.error(error),
      (_) => const AuthState.passwordResetSuccess(),
    );
  }

  void reset() {
    state = const AuthState.initial();
  }
}

// Auth state notifier provider
final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repository);
});

// Auth state sealed class
sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(UserEntity user) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.signUpSuccess(UserEntity user) = AuthSignUpSuccess;
  const factory AuthState.otpVerified() = AuthOtpVerified;
  const factory AuthState.passwordResetRequested() = AuthPasswordResetRequested;
  const factory AuthState.passwordResetSuccess() = AuthPasswordResetSuccess;
  const factory AuthState.error(String message) = AuthError;
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthSignUpSuccess extends AuthState {
  final UserEntity user;
  const AuthSignUpSuccess(this.user);
}

class AuthOtpVerified extends AuthState {
  const AuthOtpVerified();
}

class AuthPasswordResetRequested extends AuthState {
  const AuthPasswordResetRequested();
}

class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

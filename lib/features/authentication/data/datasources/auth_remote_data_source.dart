import '../../../../core/network/dio_client.dart';
import '../../../../core/config/api_constants.dart';
import '../models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? fcmToken,
  });

  Future<AuthResponse> verifyOtp({
    required String email,
    required String otp,
  });

  Future<RegisterResponse> resendOtp({
    required String email,
  });

  Future<AuthResponse> login({
    required String email,
    required String password,
  });

  Future<RegisterResponse> requestPasswordReset({
    required String email,
  });

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<UserModel> getProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? fcmToken,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          if (fcmToken != null) 'fcmToken': fcmToken,
        },
      );

      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.verifyOtp,
        data: {
          'email': email,
          'otp': otp,
        },
      );

      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RegisterResponse> resendOtp({
    required String email,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.resendOtp,
        data: {
          'email': email,
        },
      );

      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RegisterResponse> requestPasswordReset({
    required String email,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.forgotPassword,
        data: {
          'email': email,
        },
      );

      return RegisterResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.resetPassword,
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await dioClient.get(ApiConstants.profile);
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

/// Authentication response model
class AuthResponse {
  final String accessToken;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'user': user.toJson(),
    };
  }
}

/// Registration response model (for OTP flow)
class RegisterResponse {
  final String message;
  final String email;

  RegisterResponse({
    required this.message,
    required this.email,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'email': email,
    };
  }
}

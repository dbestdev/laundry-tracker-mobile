import '../../../../core/network/dio_client.dart';
import '../../../../core/config/api_constants.dart';
import '../models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
    String? fcmToken,
  });

  Future<AuthResponse> login({
    required String email,
    required String password,
  });

  Future<UserModel> getProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AuthResponse> register({
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

      return AuthResponse.fromJson(response.data);
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

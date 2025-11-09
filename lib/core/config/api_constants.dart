/// API endpoint constants
class ApiConstants {
  ApiConstants._();

  // Base paths
  static const String auth = '/auth';

  // Auth endpoints
  static const String register = '$auth/register';
  static const String login = '$auth/login';
  static const String profile = '$auth/profile';
  static const String logout = '$auth/logout';
  static const String refreshToken = '$auth/refresh';

  // Orders endpoints (for future use)
  static const String orders = '/orders';
  static const String createOrder = orders;
  static const String getOrders = orders;
  static String getOrder(String id) => '$orders/$id';
  static String updateOrder(String id) => '$orders/$id';
  static String cancelOrder(String id) => '$orders/$id/cancel';

  // User endpoints (for future use)
  static const String users = '/users';
  static const String updateProfile = '$users/profile';
  static const String updateFcmToken = '$users/fcm-token';

  // Headers
  static const String authorization = 'Authorization';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';

  static String bearerToken(String token) => 'Bearer $token';
}

# Environment Configuration Guide

## API Base URL Configuration

The app is configured to connect to the backend server based on the platform:

### Android Emulator
- **Base URL**: `http://10.0.2.2:3000`
- The Android emulator uses `10.0.2.2` to access the host machine's `localhost`

### iOS Simulator
- **Base URL**: `http://localhost:3000` or `http://127.0.0.1:3000`
- iOS Simulator can directly access localhost

### Physical Device
- **Base URL**: `http://YOUR_COMPUTER_IP:3000`
- Find your computer's local IP address:
  - **macOS/Linux**: Run `ifconfig | grep inet`
  - **Windows**: Run `ipconfig`
- Example: `http://192.168.1.100:3000`

## Changing the API URL

To change the API base URL, edit `lib/core/config/env_config.dart`:

```dart
static String get apiBaseUrl {
  const bool isProduction = bool.fromEnvironment('PRODUCTION', defaultValue: false);

  if (isProduction) {
    return 'https://api.laundrytracker.com';
  }

  // Update this line for your environment
  return 'http://10.0.2.2:3000'; // Android Emulator
  // return 'http://localhost:3000'; // iOS Simulator
  // return 'http://192.168.1.100:3000'; // Physical Device
}
```

## Production Build

To build the app for production with the production API:

```bash
flutter build apk --dart-define=PRODUCTION=true
flutter build ios --dart-define=PRODUCTION=true
```

## API Endpoints

All API endpoints are defined in `lib/core/config/api_constants.dart`:

### Authentication
- **POST** `/auth/register` - Register new user
- **POST** `/auth/login` - Login user
- **GET** `/auth/profile` - Get user profile (requires authentication)

### Orders (Coming Soon)
- **POST** `/orders` - Create new order
- **GET** `/orders` - Get all orders
- **GET** `/orders/:id` - Get specific order
- **PUT** `/orders/:id` - Update order
- **DELETE** `/orders/:id/cancel` - Cancel order

## Network Layer

The app uses Dio for HTTP requests with the following features:

### Features
- Automatic token management
- Request/Response logging in debug mode
- Error handling and user-friendly messages
- Connection timeout handling
- Retry logic (coming soon)

### Dio Client

The `DioClient` class (`lib/core/network/dio_client.dart`) provides:
- `get()` - GET requests
- `post()` - POST requests
- `put()` - PUT requests
- `delete()` - DELETE requests
- `setToken()` - Set authorization token
- `removeToken()` - Remove authorization token

### Usage Example

```dart
// Get Dio client from Riverpod
final dioClient = ref.watch(dioClientProvider);

// Make authenticated request
final response = await dioClient.get('/auth/profile');
```

## Timeouts

Default timeouts are configured in `env_config.dart`:

```dart
static const Duration connectTimeout = Duration(seconds: 30);
static const Duration receiveTimeout = Duration(seconds: 30);
static const Duration sendTimeout = Duration(seconds: 30);
```

## Debugging Network Requests

In debug mode, all HTTP requests and responses are logged to the console:

```
REQUEST[POST] => PATH: /auth/login
Headers: {Content-Type: application/json}
Data: {email: test@example.com, password: ****}

RESPONSE[200] => PATH: /auth/login
Data: {accessToken: eyJhbG..., user: {...}}
```

## Troubleshooting

### Cannot connect to backend

**Problem**: `Connection timeout` or `No internet connection` error

**Solutions**:
1. Make sure the backend server is running (`npm run start:dev`)
2. Check that you're using the correct IP address for your platform
3. For Android Emulator, verify you're using `10.0.2.2` not `localhost`
4. For physical device, ensure both device and computer are on the same WiFi network
5. Check firewall settings on your computer

### 401 Unauthorized error

**Problem**: Protected endpoints return 401

**Solutions**:
1. Make sure you're logged in
2. Check that the JWT token is being sent in the Authorization header
3. Verify token hasn't expired (7 days default)

### CORS errors

**Problem**: CORS policy errors in browser or web platform

**Solution**: The backend has CORS enabled with `origin: true`. If you still see CORS errors:
1. Check backend `main.ts` has `app.enableCors()` configured
2. Restart the backend server

## Production Checklist

Before deploying to production:

- [ ] Update production API URL in `env_config.dart`
- [ ] Test all API endpoints with production backend
- [ ] Enable SSL/TLS (HTTPS)
- [ ] Configure proper error handling
- [ ] Test on physical devices
- [ ] Test network error scenarios
- [ ] Configure retry logic for failed requests
- [ ] Add request caching if needed
- [ ] Set up proper logging/analytics

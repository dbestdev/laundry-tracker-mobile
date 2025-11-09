# Firebase Cloud Messaging (FCM) Setup Guide

This guide will help you complete the Firebase setup for push notifications.

## Prerequisites

- Local notifications are already configured and working
- Firebase dependencies have been added to the project
- Android app is ready for Firebase integration

## Steps to Complete Firebase Setup

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select an existing project
3. Enter project name: `laundry-tracker` (or your preferred name)
4. Disable Google Analytics (optional for this project)
5. Click "Create project"

### 2. Add Android App to Firebase

1. In Firebase Console, click the Android icon to add an Android app
2. Register your app with these details:
   - **Android package name**: Check your `android/app/build.gradle` file for `applicationId`
   - **App nickname**: Laundry Tracker Mobile (optional)
   - **Debug signing certificate SHA-1**: (optional for now, needed for Google Sign-In later)

3. Click "Register app"

### 3. Download google-services.json

1. Download the `google-services.json` file
2. Place it in: `android/app/google-services.json`

   ```
   laundry_tracker_mobile/
   └── android/
       └── app/
           └── google-services.json  ← Place file here
   ```

### 4. Update android/build.gradle

Add the Google services classpath to `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        // ... other dependencies
        classpath 'com.google.gms:google-services:4.4.2'
    }
}
```

### 5. Update android/app/build.gradle

Add the Google services plugin at the bottom of `android/app/build.gradle`:

```gradle
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"

// Add this line at the bottom
apply plugin: 'com.google.gms.google-services'
```

### 6. Test the Setup

1. Stop the app completely
2. Rebuild the app: `flutter clean && flutter pub get`
3. Run the app
4. Check console logs for: `Firebase initialized successfully`
5. Go to Notifications screen and tap "Test Notification" button
6. You should see a local notification

### 7. Get Your FCM Token

The FCM token is automatically printed in the console when the app starts. Look for:
```
FCM Token: [your-token-here]
```

You can also get it programmatically:
```dart
String? token = await NotificationService().getFCMToken();
print('FCM Token: $token');
```

### 8. Send Test Notification from Firebase Console

1. Go to Firebase Console > Cloud Messaging
2. Click "Send your first message"
3. Enter notification title and text
4. Click "Send test message"
5. Paste your FCM token
6. Click "Test"

## Notification Features Implemented

### Local Notifications
- ✅ Instant notifications
- ✅ Scheduled notifications
- ✅ Custom notification channels
- ✅ Notification icons and sounds
- ✅ Action buttons support
- ✅ Notification tap handling

### Firebase Cloud Messaging
- ✅ Foreground message handling
- ✅ Background message handling
- ✅ Notification opened app handling
- ✅ FCM token management
- ✅ Topic subscription support

## Notification Service Methods

```dart
// Show instant notification
await NotificationService().showNotification(
  title: 'Order Ready',
  body: 'Your order #1234 is ready for pickup',
  payload: 'order:1234',
);

// Schedule notification
await NotificationService().scheduleNotification(
  title: 'Reminder',
  body: 'Pick up your laundry today',
  scheduledDate: DateTime.now().add(Duration(hours: 2)),
);

// Order specific notifications
await NotificationService().showOrderStatusNotification(
  orderId: '#1234',
  status: 'Ready',
  message: 'Your laundry is ready for pickup',
);

// Schedule order reminder
await NotificationService().scheduleOrderReminder(
  orderId: '#1234',
  pickupTime: DateTime.now().add(Duration(hours: 3)),
  message: 'Don\'t forget to pick up your laundry',
);

// Get FCM token
String? token = await NotificationService().getFCMToken();

// Subscribe to topics
await NotificationService().subscribeToTopic('order_updates');

// Unsubscribe from topics
await NotificationService().unsubscribeFromTopic('order_updates');
```

## Troubleshooting

### Firebase initialization failed
- Make sure `google-services.json` is in the correct location
- Verify package name matches in Firebase Console and `build.gradle`
- Run `flutter clean && flutter pub get`

### Notifications not showing
- Check Android notification permissions are granted
- Verify notification channel is created
- Check device notification settings

### FCM token is null
- Make sure Firebase is initialized before getting token
- Check internet connection
- Verify Firebase configuration is correct

## Next Steps

After Firebase setup is complete:
1. Integrate notifications with your backend API
2. Send order status updates via FCM
3. Schedule pickup reminders
4. Implement in-app notification handling with navigation
5. Add notification preferences in Profile settings

## Production Considerations

- Store FCM tokens in your backend database
- Implement token refresh handling
- Set up server-side FCM sending
- Handle notification permissions properly
- Test on multiple Android versions
- Consider iOS setup when ready

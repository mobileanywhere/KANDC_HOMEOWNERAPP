import 'dart:convert';
import 'dart:io'; // Added for File class

// External Packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';

import '../network/rest_apis.dart';
import '../screens/dashboard/dashboard_screen.dart';

// Assume this is your encrypted preferences implementation
// Replace with your actual package if different

// Project Imports (Adjust paths as needed)
// The import below seems related to navigation targets, ensure path is correct

// --- FileService Class ---
class FileService {
  static const _fileName = 'slug_storage.txt';

  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  static Future<void> writeSlug(String slug) async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      await file.writeAsString(slug);
    } catch (e) {
      print('[FileService] Error writing slug: $e');
    }
  }

  static Future<String?> readSlug() async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      if (await file.exists()) {
        final content = await file.readAsString();
        return content.isNotEmpty ? content : null;
      }
      return null;
    } catch (e) {
      print('[FileService] Error reading slug: $e');
      return null;
    }
  }

  static Future<void> clearSlug() async {
    try {
      final path = await _getFilePath();
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('[FileService] Error clearing slug: $e');
    }
  }
}

// --- Global Variables & Top-Level Functions ---
String? deviceToken = '';

@pragma('vm:entry-point')
class NotificationHandler {

  static late NotificationHandler _instance;

  NotificationHandler() {
    _instance = this;
  }

  static NotificationHandler get instance => _instance;

  static late FirebaseMessaging _messaging;
  static late NotificationSettings notificationSettings;

  static final channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
    playSound: true,
  );
  static var flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initializeFirebaseAndNotifications() async {
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.requestPermission();
    firebaseNotificationSetup();
  }

  static void firebaseNotificationSetup() async {
    _messaging = FirebaseMessaging.instance;
    await _messaging
        .subscribeToTopic('Flutter_Library_Firebase_Messaging')
        .catchError((error) {
          log('Failed to subscribe to topic: $error');
        });

    notificationSettings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log(
      'Firebase Permission Status: ${notificationSettings.authorizationStatus}',
    );

    if (notificationSettings.authorizationStatus ==
            AuthorizationStatus.denied ||
        notificationSettings.authorizationStatus ==
            AuthorizationStatus.notDetermined) {
      toast('Notification Permission not granted');
      return;
    }

    try {
      deviceToken = await _messaging.getToken();
    } catch (error) {
      rethrow;
    }

    log('Firebase FCM token: $deviceToken');

    if (deviceToken == null) {
      log('Firebase FCM token is null');
      // toast('Firebase FCM token is not generated');
    } else {
      // Clipboard.setData(ClipboardData(text: deviceToken ?? ''));
      // toastLong('Copied to clipboard!');
      // toastLong(deviceToken);
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Listen for token refresh event
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      log('Firebase FCM token refreshed $newToken');
      deviceToken = newToken;

      // Update token on your server or database
      // sendTokenToServer(newToken);
    });
    registerNotification();
  }

  static void registerNotification() async {
    createNotificationChannel();
    // is called when a push notification is received.

    FirebaseMessaging.instance.getInitialMessage().then((remoteMessage) async {
      if (remoteMessage != null) {
        final slug = remoteMessage.data['slug'] ?? '/';
        if (slug != null && slug != 'login') {
          await FileService.writeSlug(slug);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((
      RemoteMessage remoteMessage,
    ) async {
      final slug = remoteMessage.data['slug'] ?? '/';
      if (slug != null && slug != 'login') {
        await FileService.writeSlug(slug);
      }
      _navigateToScreen(slug);
    });

    FirebaseMessaging.onMessage.listen(showLocalNotification);
  }

  static Future<void> createNotificationChannel() async {
    final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    const androidNotificationChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notification',
      importance: Importance.high,
    );
    var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse,
    );

    await flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  // Handles user tapping on the notification (forground or background)
  static void onNotificationResponse(NotificationResponse response) {
    log('Firebase Notification tapped: ${response.payload}');
    final messageData = response.payload != null ? response.payload! : '{}';
    final remoteMessage = RemoteMessage.fromMap(jsonDecode(messageData));
    log(
      'Firebase on Notification response: ${jsonEncode(remoteMessage.toMap())}',
    );
    final slug = remoteMessage.data['slug'] ?? '/';
    _navigateToScreen(slug);
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundNotificationResponse(
    NotificationResponse response,
  ) async {
    log('Firebase Notification tapped: ${response.payload}');
    final messageData = response.payload != null ? response.payload! : '{}';
    final remoteMessage = RemoteMessage.fromMap(jsonDecode(messageData));
    log(
      'Firebase on Notification response: ${jsonEncode(remoteMessage.toMap())}',
    );
    final slug = remoteMessage.data['slug'] ?? '/';
    if (slug != null && slug != 'login') {
      await FileService.writeSlug(slug);
    }
  }

  static Future<void> _navigateToScreen(String slug) async {
    DashboardScreen(redirectToBooking: true).launch(navigatorKey.currentContext!, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    //    _handleInitialRouting(slug);
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    log('Firebase onMessage.listenMessage ${message.toMap()}');
    final notification = message.notification;

    if (notification == null) {
      // Notification is siled - show a toast message
      toastLong('Silent notification');
    } else {
      // Notification is not silent - show local notification
      const androidNotificationChannel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notification',
        importance: Importance.high,
      );

      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          androidNotificationChannel.id,
          androidNotificationChannel.name,
          channelDescription: androidNotificationChannel.description,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      final payload = jsonEncode(message.toMap());

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        notification.title,
        notification.body,
        notificationDetails,
        payload: payload,
      );
    }
  }

  static Future<void> showBackgroundNotification(
    String title,
    String body,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'background_fetch',
          'Background Fetch',
          channelDescription: 'Background fetch events',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}

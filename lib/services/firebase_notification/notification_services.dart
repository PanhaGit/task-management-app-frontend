import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend_app_task/router/app_router.dart';
import 'package:get/get.dart';
import 'package:frontend_app_task/controllers/notification_controller.dart';
import 'package:go_router/go_router.dart';

class NotificationServices {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final NotificationController _notificationController = Get.find();


  // Initialize local notifications
  void initLocalNotifications(BuildContext context) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/mongkol_logo');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        _notificationController.markAsRead();
        context.pushToNotification();
      },
    );
  }

  // Firebase initialization and message handling
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        debugPrint("Title: ${message.notification?.title}");
        debugPrint("Body: ${message.notification?.body}");

        _notificationController.addNotification(message);
        showNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _notificationController.addNotification(message);
      _notificationController.markAsRead();
      final router = GoRouter.of(context);
      router.push('/notification');
      // Use GoRouter for navigation
      // final router = GoRouter.of(context);
      // router.push('/notification');
    });
  }

  // Show notification
  Future<void> showNotification(RemoteMessage message) async {

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,

    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: 'Your channel description',
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/mongkol_logo',
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000),
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  // Request notification permissions
  void requestNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("✅ User granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint("🟡 User granted provisional permission");
    } else {
      debugPrint("❌ User denied permission – redirecting to settings");
      AppSettings.openAppSettings();
    }
  }

  // Get device token
  Future<String?> getDeviceToken() async {
    String? getToken = await _messaging.getToken();
    return getToken;
  }

  // Handle token refresh
  Future<void> isTokenRefresh() async {
    _messaging.onTokenRefresh.listen((event) {
      debugPrint("Token refreshed: $event");
    });
  }
}
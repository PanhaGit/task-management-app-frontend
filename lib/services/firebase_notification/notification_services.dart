import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend_app_task/controllers/notification_controller.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

/**
 * Comprehensive Notification Service
 * @description Handles all notification-related operations
 * @author: Tho Panha
 */
class NotificationServices {
  static final NotificationServices _instance = NotificationServices._internal();
  factory NotificationServices() => _instance;
  NotificationServices._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  /// Initialize all notification services
  Future<void> initialize() async {
    try {
      await _setupTimezone();
      await _initLocalNotifications();
      await _requestPermissions();
      await _configureFirebaseMessaging();
      await _getInitialMessage();
    } catch (e) {
      debugPrint('Notification initialization error: $e');
      rethrow;
    }
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final location = tz.getLocation('Asia/Phnom_Penh'); // Adjust to your time zone
    tz.setLocalLocation(location);
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          final data = jsonDecode(payload);
          handleNotificationTapFromPayload(data);
        }
      },
    );

    await _createNotificationChannels();
  }

  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'task_reminder_channel',
      'Task Reminders',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _requestPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future<void> _configureFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotificationTap);
  }

  Future<void> _getInitialMessage() async {
    final RemoteMessage? message = await _firebaseMessaging.getInitialMessage();
    if (message != null) {
      handleNotificationTap(message);
    }
  }

  static Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
    await _instance._handleNotification(message);
    await _instance._showLocalNotification(message);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    await _handleNotification(message);
    await _showLocalNotification(message);
  }

  Future<void> _handleNotification(RemoteMessage message) async {
    try {
      final controller = Get.find<NotificationController>();
      controller.addNotification(message);

      // Handle specific notification types
      if (message.data['eventType'] == 'due_soon') {
        // Add your custom logic here
      }
    } catch (e) {
      debugPrint('Error handling notification: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        'task_reminder_channel',
        'Task Reminders',
        channelDescription: 'Important task reminders',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification'),
        styleInformation: BigTextStyleInformation(message.notification?.body ?? ''),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      await _localNotifications.show(
        message.hashCode,
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? 'You have a new notification',
        NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        ),
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  void handleNotificationTap(RemoteMessage message) {
    try {
      if (message.data['task_id'] != null) {
        Get.toNamed('/task_details', arguments: {
          'task_id': message.data['task_id']
        });
      }
    } catch (e) {
      debugPrint('Error handling notification tap: $e');
    }
  }

  void handleNotificationTapFromPayload(Map<String, dynamic> data) {
    try {
      if (data['task_id'] != null) {
        Get.toNamed('/task_details', arguments: {
          'task_id': data['task_id']
        });
      }
    } catch (e) {
      debugPrint('Error handling local notification tap: $e');
    }
  }

  Future<void> scheduleTaskNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_reminder_channel',
            'Task Reminders',
            channelDescription: 'Notifications for task deadlines',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        payload: jsonEncode({
          'task_id': id,
        }),
      );
      debugPrint('✅ Notification scheduled at $scheduledTime');
    } catch (e) {
      debugPrint('❌ Error scheduling notification: $e');
    }
  }

  Future<String?> getDeviceToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }
}


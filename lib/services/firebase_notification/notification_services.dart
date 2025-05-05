import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initLocalNotifications(BuildContext context, RemoteMessage message) async{
    var androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (payload){

      }
    );
  }

  void firebaseInit(){
    FirebaseMessaging.onMessage.listen((messages){
      print("Title "+ messages.notification!.title.toString());
      print("Title "+ messages.notification!.body.toString());
      showNotification(messages);
    });
  }

  Future<void> showNotification(RemoteMessage message)async {

    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      importance: Importance.max,
      "Hello Mongko Task Application , channel",
    ) ;

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      // Random.secure().nextInt(100000).toString(),
      channel.id.toString(),
      channel.name.toString(),
      channelDescription:'Your channel description',
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
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

    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails
      );
    });
  }

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
      print("✅ User granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("🟡 User granted provisional permission");
    } else {
      print("❌ User denied permission – redirecting to settings");
      AppSettings.openAppSettings();
    }
  }

  Future<String?> getDeviceToken() async{
    String? getToken = await _messaging.getToken();

    return getToken!;
  }

  Future<void> isTokenRefresh() async{
     _messaging.onTokenRefresh.listen((event){
      event.toString();
    });

  }

}

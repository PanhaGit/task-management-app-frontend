import 'package:flutter/material.dart';
import 'package:frontend_app_task/services/firebase_notification/notification_services.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  NotificationServices _notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    _notificationServices.requestNotificationPermission();
    _notificationServices.firebaseInit();
    // _notificationServices.isTokenRefresh();
    _notificationServices.getDeviceToken().then((value){
      print("🔐 Token: $value");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
    );
  }
}

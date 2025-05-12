import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend_app_task/router/routes.dart'; // Assuming you define GoRouter here
import 'package:frontend_app_task/services/firebase_notification/notification_services.dart';
import 'package:get/get.dart';
import 'package:frontend_app_task/controllers/notification_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize GetX controller
  Get.put(NotificationController());

  // Initialize notification service (context-independent)
  final notificationService = NotificationServices();
  notificationService.requestNotificationPermission();

  runApp(const MongKolApp());
}

class MongKolApp extends StatelessWidget {
  const MongKolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Mong Kol App Task",
      routerConfig: Routes.router, // This should be your GoRouter instance
    );
  }
}

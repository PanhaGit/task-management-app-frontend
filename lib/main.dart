import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/controllers/auth/auth_controllers.dart';
import 'package:frontend_app_task/router/routes.dart';
import 'package:frontend_app_task/services/firebase_notification/notification_services.dart';
import 'package:get/get.dart';
import 'package:frontend_app_task/controllers/notification_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /**
   * @anthor: Tho Panha
   * @Initialize GetX controller
   * */
  Get.put(NotificationController());
  Get.put(AuthControllers());

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
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
      ),
      title: "Mong Kol App Task",
      routerConfig: Routes.router, // This should be your GoRouter instance
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/controllers/auth/auth_controllers.dart';
import 'package:frontend_app_task/controllers/home_controller.dart';
import 'package:frontend_app_task/controllers/task_controller.dart';
import 'package:frontend_app_task/router/routes.dart';
import 'package:frontend_app_task/services/firebase_notification/notification_services.dart';
import 'package:get/get.dart';
import 'package:frontend_app_task/controllers/notification_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;

  // Initialize GetX controllers
  Get.put(AuthControllers());
  Get.put(HomeController());
  Get.put(TaskController());
  Get.put(NotificationController());

  // Initialize Firebase notification permissions
  final notificationService = NotificationServices();
  notificationService.requestNotificationPermission();

  runApp( MongKolApp());
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
      routerConfig: Routes.router,
    );
  }
}

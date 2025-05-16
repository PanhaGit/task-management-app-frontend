import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/controllers/auth/auth_controllers.dart';
import 'package:frontend_app_task/router/routes.dart';
import 'package:frontend_app_task/services/firebase_notification/notification_services.dart';
import 'package:get/get.dart';
import 'package:frontend_app_task/controllers/notification_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize cached_network_image
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;

  /**
   * @author: Tho Panha
   * @Initialize GetX controllers
   */
  Get.put(AuthControllers());
  Get.put(NotificationController());

  // Initialize notification service
  final notificationService = NotificationServices();
  notificationService.requestNotificationPermission();

  runApp(const MongKolApp());
}

class MongKolApp extends StatelessWidget {
  const MongKolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
      ),
      title: "Mong Kol App Task",
      routerDelegate: Routes.router.routerDelegate,
      routeInformationParser: Routes.router.routeInformationParser,
      routeInformationProvider: Routes.router.routeInformationProvider,
      enableLog: true,
    );
  }
}
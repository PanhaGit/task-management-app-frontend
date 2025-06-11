import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend_app_task/controllers/auth/verify_code_email_controller.dart';
import 'package:frontend_app_task/controllers/category_controller.dart';
import 'package:frontend_app_task/services/firebase_notification/notification_services.dart';
import 'package:get/get.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/controllers/auth/auth_controllers.dart';
import 'package:frontend_app_task/controllers/home_controller.dart';
import 'package:frontend_app_task/controllers/task_controller.dart';
import 'package:frontend_app_task/controllers/notification_controller.dart';
import 'package:frontend_app_task/router/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Configure cached network image
    CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;

    // Initialize controllers in proper order
    _initializeControllers();

    // Run the app
    runApp(const MongKolApp());
  } catch (e) {
    // Fallback UI if initialization fails
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Initialization failed: ${e.toString()}'),
          ),
        ),
      ),
    );
  }
}

void _initializeControllers() {
  // First register NotificationController
  Get.put(NotificationController());

  // Then register NotificationServices and initialize
  final notificationService = Get.put(NotificationServices());
  notificationService.initialize(); // Use the consolidated initialize method

  // Register other controllers
  Get.put(AuthControllers());
  Get.put(HomeController());
  Get.put(TaskController());
  Get.put(CategoryController());
  Get.put(VerifyCodeEmailController());
}

class MongKolApp extends StatelessWidget {
  const MongKolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Mong Kol App Task",
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
      ),
      routerConfig: Routes.router,
      supportedLocales: const [
        Locale('en'),
        Locale('kh', 'KH'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

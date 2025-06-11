import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_app_task/controllers/auth/auth_controllers.dart';
import 'package:frontend_app_task/main_screen.dart';
import 'package:frontend_app_task/screens/add_task/add_task_screen.dart';
import 'package:frontend_app_task/screens/auth/date_of_brithday_screen.dart';
import 'package:frontend_app_task/screens/auth/forget_password_screen.dart';
import 'package:frontend_app_task/screens/auth/login_screen.dart';
import 'package:frontend_app_task/screens/auth/signup_screen.dart';
import 'package:frontend_app_task/screens/auth/verify_code_email_screen.dart';
import 'package:frontend_app_task/screens/calendar/calendar_screen.dart';
import 'package:frontend_app_task/screens/get_start/get_start_screen.dart';
import 'package:frontend_app_task/screens/home/home_screen.dart';
import 'package:frontend_app_task/screens/notification/notification_screen.dart';
import 'package:frontend_app_task/screens/profile/profile_screen.dart';
import 'package:frontend_app_task/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

class Routes {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    // initialLocation: '/auth/verify_code',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/get_start',
        name: 'get_start',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const GetStartScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/signup',
        name: 'signup',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SignupScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/forget_password',
        name: 'forget_password',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ForgetPasswordScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/dob',
        name: 'dob',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DateOfBrithdayScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/verify_code',
        name: 'verify_code',
        pageBuilder: (context, state) {
          final email = state.extra as String;
          return MaterialPage(
            key: state.pageKey,
            child: VerifyCodeEmailScreen(email: email),
          );
        },
      ),

      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return MaterialPage(
            key: state.pageKey,
            child: ScaffoldWithNavBar(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                name: 'calendar',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: CalendarScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/add_task',
                name: 'add_task',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: AddTaskScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notification',
                name: 'notification',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child:  NotificationScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    /// Handles redirection logic for all routes.
    /// Redirects users based on authentication status and whether they've seen the Get Start screen.
    ///
    /// @author: Tho Panha
    redirect: (BuildContext context, GoRouterState state) async {
      final authController = Get.find<AuthControllers>();
      const storage = FlutterSecureStorage();
      final currentUri = state.uri.toString();
      final isLoggedIn = authController.currentUser.value != null;
      final isAuthRoute = currentUri.startsWith('/auth');
      final isInitialRoute = currentUri == '/splash' || currentUri == '/get_start';
      final isVerifyCodeRoute = currentUri.startsWith('/auth/verify_code');
      final hasSeenGetStart = await storage.read(key: 'has_seen_get_start') != null;

      // Always allow verify_code route
      if (isVerifyCodeRoute) return null;

      if (currentUri == '/splash') {
        if (isLoggedIn) return '/';
        if (!hasSeenGetStart) return '/get_start';
        return '/auth/login';
      }

      if (!isLoggedIn && !isAuthRoute && !isInitialRoute) {
        return '/auth/login';
      }

      if (isLoggedIn && (isAuthRoute || isInitialRoute)) {
        return '/';
      }

      return null;
    },

    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text(
            'Page not found: ${state.uri.toString()}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    ),
  );
}

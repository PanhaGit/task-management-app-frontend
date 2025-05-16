import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_app_task/main_screen.dart';
import 'package:frontend_app_task/screens/add_task/add_task_screen.dart';
import 'package:frontend_app_task/screens/auth/date_of_brithday_screen.dart';
import 'package:frontend_app_task/screens/auth/forget_password_screen.dart';
import 'package:frontend_app_task/screens/auth/login_screen.dart';
import 'package:frontend_app_task/screens/auth/signup_screen.dart';
import 'package:frontend_app_task/screens/calendar/calendar_screen.dart';
import 'package:frontend_app_task/screens/get_start/get_start_screen.dart';
import 'package:frontend_app_task/screens/notification/notification_screen.dart';
import 'package:frontend_app_task/screens/profile/profile_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app_task/screens/splash_screen.dart';
import 'package:frontend_app_task/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Routes {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      // Bottom Navigation Bar (MainScreen)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(
            child: navigationShell,
            selectedIndex: navigationShell.currentIndex,
          );
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (_, __) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/calendar',
              name: 'calendar',
              builder: (_, __) =>  CalendarScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/add_task',
              name: 'add_task',
              builder: (_, __) => const AddTaskScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/notification',
              name: 'notification',
              builder: (_, __) => const NotificationScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (_, __) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
      // Get Started Screen
      GoRoute(
        path: '/get_start',
        name: 'get_start',
        builder: (context, state) => const GetStartScreen(),
      ),
      // Authentication Routes
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
        path: '/auth/dob',
        name: 'dob',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const DateOfBrithdayScreen(),
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
    ],
    redirect: (context, state) async {
      const storage = FlutterSecureStorage();
      final prefs = await SharedPreferences.getInstance();
      final token = await storage.read(key: 'access_token');
      final isAuthenticated = token != null && token.isNotEmpty;
      final hasSeenGetStart = prefs.getBool('has_seen_get_start') ?? false;

      final isAuthRoute = state.uri.path.startsWith('/auth');
      final isSplashRoute = state.uri.path == '/splash';
      final isGetStartRoute = state.uri.path == '/get_start';

      // On splash, decide where to go
      if (isSplashRoute) {
        if (isAuthenticated) {
          return '/'; // Home screen
        } else if (!hasSeenGetStart) {
          return '/get_start';
        } else {
          return '/auth/login';
        }
      }

      // Redirect unauthenticated users to login (except auth and get_start)
      if (!isAuthenticated && !isAuthRoute && !isGetStartRoute) {
        return '/auth/login';
      }

      // Redirect authenticated users away from auth routes
      if (isAuthenticated && isAuthRoute) {
        return '/';
      }

      return null;
    },
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text(
            '404 - Page not found: ${state.uri.path}',
            style: const TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
      ),
    ),
  );
}
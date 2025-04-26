import 'package:flutter/material.dart';
import 'package:frontend_app_task/main_screen.dart';
import 'package:frontend_app_task/screens/add_task/add_task_screen.dart';
import 'package:frontend_app_task/screens/calendar/calendar_screen.dart';
import 'package:frontend_app_task/screens/notification/notification_screen.dart';
import 'package:frontend_app_task/screens/profile/profile_screen.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/home/home_screen.dart';

/**
 * @author: Panha
 * use for Bottom Navigation Bar
 * */

class Routes {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (BuildContext context, GoRouterState state) => MaterialPage(
          key: state.pageKey,
          child: SplashScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(
            child: navigationShell,
            selectedIndex: navigationShell.currentIndex,
          );
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/add_task', builder: (_, __) => const AddTaskScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/notification', builder: (_, __) => const NotificationScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          ]),
        ],
      ),
    ],
    errorPageBuilder: (BuildContext context, GoRouterState state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text(
            '404 - Page not found',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
      ),
    ),
  );
}
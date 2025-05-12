import 'package:flutter/material.dart';
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
import '../screens/splash_screen.dart';
import '../screens/home/home_screen.dart';

class Routes {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    // initialLocation: '/auth/login',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (BuildContext context, GoRouterState state) => MaterialPage(
          key: state.pageKey,
          child: SplashScreen(),
        ),
      ),

      /**
       * @author: Tho Panha
       * use for Bottom Navigation Bar
       * */
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(
            child: navigationShell,
            selectedIndex: navigationShell.currentIndex,
          );
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/', builder: (_, __) =>  HomeScreen()),
          ]),
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/add_task', builder: (_, __) => const AddTaskScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/notification',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const NotificationScreen(),
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          ]),
        ],
      ),


      // when user download app load get start screen or user create account other account
      GoRoute(path: "/get_start",builder: (context, state) => const GetStartScreen()),

      /**
       * @author Tho Panha
       * Authentication Main Route: auth
       * Sub Route: auth/login , auth/signup, auth/change_password, auth/email ,auth/verify_otp
       * */

      GoRoute(
        path: "/auth",
        redirect: (context, state) => '/auth/login',
      ),

      GoRoute(
        path: "/auth/login",
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child:  LoginScreen(),
        ),
      ),

      GoRoute(
        path: "/auth/signup",
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: SignupScreen(),
        ),
      ),

      GoRoute(
        path: "/auth/login",
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: LoginScreen(),
        ),
      ),

      // skip
      GoRoute(
        path: "/auth/dob",
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: DateOfBrithdayScreen(),
        ),
      ),
      GoRoute(path: "/auth/forget_password",
      pageBuilder:  (context, state) => MaterialPage(
      key: state.pageKey,
        child: ForgetPasswordScreen(),
      ),
      )
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
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_app_task/env.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants/app_colors.dart';
import '../constants/app_style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _version = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _startSplashTimer();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  void _startSplashTimer() {
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF9AD4FF),
              Color(0xFFD9EBFF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Image.asset(
                Env.logo,
                width: AppStyle.deviceWidth(context) * 0.75,
              ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  const Text(
                    "Mongkol-App © 2025",
                    style: TextStyle(fontSize: 12, color: AppColors.black),
                  ),
                  if (_version.isNotEmpty)
                    Text(
                      "App Version $_version",
                      style:
                      const TextStyle(fontSize: 12, color: AppColors.black),
                    ),
                  const Text(
                    "Team PLRS",
                    style: TextStyle(fontSize: 12, color: AppColors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

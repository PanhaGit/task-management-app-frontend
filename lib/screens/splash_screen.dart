import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend_app_task/router/app_router.dart';
// ignore: unused_import
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants/app_style.dart';
import '../env.dart';
import '../constants/app_colors.dart';
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
    _timeSplashScreen();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  Future<void> _timeSplashScreen()async {
    _timer = await Timer(const Duration(seconds: 3),(){
      if(mounted){
       context.pushToHome();
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
              Color(0xFF9AD4FF), // Top color
              Color(0xFFD9EBFF), // Bottom color
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
                      style: const TextStyle(fontSize: 12,  color: AppColors.black),
                    ),
                  const Text(
                    "Team PLRS",
                    style: TextStyle(fontSize: 12, color: AppColors.black),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

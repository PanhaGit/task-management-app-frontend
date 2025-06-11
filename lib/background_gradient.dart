import 'dart:ui';
import 'package:flutter/material.dart';
import './constants/app_colors.dart';

class BackgroundGradient extends StatelessWidget {
  final Widget child;

  const BackgroundGradient({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.white,
            AppColors.lightBlue,
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Adjust blur intensity
        child: Container(
          color: Colors.transparent, // Ensures the blur is visible
          child: child,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:get/get.dart';

class MyDialog {
  static void showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (Get.isSnackbarOpen) Get.back(); // Close any open snackbar

    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackPosition: SnackPosition.BOTTOM,
      duration: duration,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }

  static void info(String message) {
    showSnackbar(
      title: 'Info',
      message: message,
      backgroundColor: AppColors.skyBlue.withOpacity(0.9),
    );
  }

  static void success(String message) {
    showSnackbar(
      title: 'Success',
      message: message,
      backgroundColor: AppColors.successColor.withOpacity(0.9),
    );
  }

  static void error(String message) {
    showSnackbar(
      title: 'Error',
      message: message,
      backgroundColor: Colors.red.withOpacity(0.9),
      duration: const Duration(seconds: 4),
    );
  }
}
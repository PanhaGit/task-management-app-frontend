import 'package:flutter/material.dart';
import 'package:frontend_app_task/constants/app_colors.dart';

class MyDialog {
  static void showSnackbar({
    required BuildContext context,
    required String title,
    required String message,
    required Color backgroundColor,
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Use ScaffoldMessenger to show the Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              message,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void info(BuildContext context, String message) {
    showSnackbar(
      context: context,
      title: 'Info',
      message: message,
      backgroundColor: AppColors.skyBlue.withOpacity(0.9),
    );
  }

  static void success(BuildContext context, String message) {
    showSnackbar(
      context: context,
      title: 'Success',
      message: message,
      backgroundColor: AppColors.successColor.withOpacity(0.9),
    );
  }

  static void error(BuildContext context, String message) {
    showSnackbar(
      context: context,
      title: 'Error',
      message: message,
      backgroundColor: Colors.red.withOpacity(0.9),
      duration: const Duration(seconds: 4),
    );
  }
}

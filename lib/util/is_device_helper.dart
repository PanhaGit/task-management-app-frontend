import 'dart:io';
import 'package:flutter/material.dart';

class IsDeviceHelper {
  Widget isDevicesIosAndroidIcons({
    required Icon iconIos,
    required Icon iconAndroid,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Platform.isIOS ? iconIos : iconAndroid,
      onPressed: () {
        // print('Back button pressed'); // Debug log
        onPressed();
      },
      color: Colors.white, // Ensure icon color is applied
    );
  }
}
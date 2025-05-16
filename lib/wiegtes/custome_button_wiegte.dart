import 'package:flutter/material.dart';

class CustomButtonWidget {
  final Color backgroundColor;
  final Color textColor;
  final String buttonText;
  final VoidCallback? onPressed;

  CustomButtonWidget({
    required this.backgroundColor,
    required this.textColor,
    required this.buttonText,
    this.onPressed,
  });

  Widget buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}

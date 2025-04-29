import 'package:flutter/material.dart';

class CustomButtonWidget {
  final Color backgroundColor;
  final Color textColor;
  final String buttonText;
  final VoidCallback onPressed;

  CustomButtonWidget({
    required this.backgroundColor,
    required this.textColor,
    required this.buttonText,
    required this.onPressed,
  });

  Widget buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

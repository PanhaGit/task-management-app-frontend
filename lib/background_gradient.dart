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
            AppColors.lightBlue
          ],
        ),
      ),
      child: child,
    );
  }
}

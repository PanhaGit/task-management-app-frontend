import 'package:flutter/material.dart';
import 'package:frontend_app_task/constants/app_style.dart';
import 'package:frontend_app_task/router/app_router.dart';
import 'package:frontend_app_task/env.dart';
import 'package:frontend_app_task/wiegtes/custome_button_wiegte.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_colors.dart';
class GetStartScreen extends StatelessWidget {
  const GetStartScreen({super.key});
  Future<void> _markAsSeenAndNavigate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_get_start', true);
    if (context.mounted) {
      context.goToLogin();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Welcome to MongKol",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppStyle.deviceHeight(context) *0.05),
              Image.asset(
                Env.get_start,
                width: double.infinity,
                height: AppStyle.deviceHeight(context) *0.30,
                fit: BoxFit.fill,
              ),
               SizedBox(height: AppStyle.deviceHeight(context) *0.06),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Create an Account to Manage Tasks with Friends or Teams\n"
                      "Stay organized, work together seamlessly, and achieve more together.",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.charcoalGray,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButtonWidget(
                      backgroundColor: AppColors.brightSkyBlue,
                      textColor: AppColors.white,
                      buttonText: "Get Start",
                    onPressed: () => _markAsSeenAndNavigate(context),
                  ).buildButton(),
                ),
              ),
              SizedBox(height: AppStyle.deviceHeight(context) * 0.26),
            ],
          ),
        ),
      ),
    );
  }
}

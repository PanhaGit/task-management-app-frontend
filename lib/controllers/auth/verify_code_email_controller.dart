import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend_app_task/services/api/api_service.dart';
import 'package:frontend_app_task/util/helper/my_dialog.dart';
import 'package:go_router/go_router.dart';

class VerifyCodeEmailController extends GetxController {
  final ApiService _apiService = ApiService();
  RxBool isLoading = false.obs;
  RxInt resendTimer = 30.obs;

  @override
  void onInit() {
    super.onInit();
    startResendTimer();
  }

  void startResendTimer() {
    resendTimer.value = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (resendTimer.value > 0) {
        resendTimer.value--;
        return true;
      }
      return false;
    });
  }

  Future<void> verifyCodeEmail(BuildContext context, String otpCodeEmail) async {
    isLoading.value = true;
    try {
      final response = await _apiService.fetchData(
        method: "POST",
        endpoint: "/auth/verify_otp",
        data: {
          "otp_code": otpCodeEmail,
        },
      );

      final data = response.data as Map<String, dynamic>;
      MyDialog.success(context, data['message']);

      if (context.mounted) {
        context.go('/');
      }
    } catch (error) {
      // print("Error : $error");
      MyDialog.error(context, "Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
}
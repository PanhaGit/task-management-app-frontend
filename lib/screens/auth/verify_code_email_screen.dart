import 'package:flutter/material.dart';
import 'package:frontend_app_task/controllers/auth/verify_code_email_controller.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';

class VerifyCodeEmailScreen extends StatelessWidget {
  final String email;
  final VerifyCodeEmailController controller = Get.put(VerifyCodeEmailController());
  final TextEditingController pinController = TextEditingController();

  VerifyCodeEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 24,
        color: Color(0xFF3D5CFF),
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF3D5CFF), width: 1.5),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF3D5CFF).withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Verify your email',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                text: 'We sent a 6-digit code to ',
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 16,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: email,
                    style: const TextStyle(
                      color: Color(0xFF3D5CFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Pinput(
                length: 6,
                controller: pinController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                showCursor: true,
                keyboardType: TextInputType.number,
                onCompleted: (pin) {
                  controller.verifyCodeEmail(context, pin);
                },
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => Align(
              alignment: Alignment.center,
              child: Text(
                'Resend code in ${controller.resendTimer.value}s',
                style: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 14,
                ),
              ),
            )),
            const SizedBox(height: 40),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                  if (pinController.text.length == 6) {
                    controller.verifyCodeEmail(context, pinController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D5CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: const Color(0xFF3D5CFF).withOpacity(0.3),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: controller.resendTimer.value == 0
                    ? () {
                  controller.startResendTimer();
                  // Add resend OTP logic here
                }
                    : null,
                child: const Text.rich(
                  TextSpan(
                    text: "Didn't receive a code? ",
                    style: TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'Resend',
                        style: TextStyle(
                          color: Color(0xFF3D5CFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class VerifyCodeEmail extends StatelessWidget {
  const VerifyCodeEmail({super.key});

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
                    text: 'thopanha123@gmail.com',
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
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                // separatorBuilder: ,
                showCursor: true,
                keyboardType: TextInputType.number,
                onCompleted: (pin) {
                  debugPrint('Entered PIN: $pin');
                },
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.center,
              child: TweenAnimationBuilder(
                tween: Tween(begin: 30.0, end: 0.0),
                duration: const Duration(seconds: 30),
                builder: (context, value, child) {
                  return Text(
                    'Resend code in ${value.toInt()}s',
                    style: TextStyle(
                      color: const Color(0xFF757575),
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D5CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: const Color(0xFF3D5CFF).withOpacity(0.3),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(
                    text: "Didn't receive a code? ",
                    style: const TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 14,
                    ),
                    children: const [
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
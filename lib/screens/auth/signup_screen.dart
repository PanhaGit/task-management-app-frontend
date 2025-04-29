import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:frontend_app_task/constants/app_style.dart';
import 'package:frontend_app_task/router/app_router.dart';
import 'package:frontend_app_task/util/is_device_helper.dart';
import 'package:frontend_app_task/wiegtes/custome_button_wiegte.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final IsDeviceHelper _isDeviceHelper = IsDeviceHelper();
  final _formkey = GlobalKey<FormBuilderState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop();
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.only(left: 8),
            child: _isDeviceHelper.isDevicesIosAndroidIcons(
              iconIos: const Icon(Icons.arrow_back, color: AppColors.black),
              iconAndroid: const Icon(Icons.arrow_back_ios, color: AppColors.black),
              onPressed: () {
                context.pushToGetStart();
              },
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.white,
                    AppColors.lightBlue,
                  ],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(bottom: 80.0), // Added bottom padding
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - MediaQuery.of(context).padding.top,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min, // Prevent over-expansion
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            // Header Section
                            Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Enter your name as it appears in real life. Create a strong password",
                              style: TextStyle(
                                fontSize: 16,
                                  color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Form Section
                            FormBuilder(
                              key: _formkey,
                              child: Column(
                                children: [
                                  // First Name Field
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: FormBuilderTextField(
                                      name: 'first_name',
                                      decoration: InputDecoration(
                                        labelText: 'First name',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AppStyle.deviceHeight(context) * 0.03),
                                  // Last Name Field
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: FormBuilderTextField(
                                      name: 'last_name',
                                      decoration: InputDecoration(
                                        labelText: 'Last name',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AppStyle.deviceHeight(context) * 0.03),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: FormBuilderTextField(
                                      name: 'email',
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: AppStyle.deviceHeight(context) * 0.03),
                                  // Password Field
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: FormBuilderTextField(
                                      name: 'password',
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible = !_isPasswordVisible;
                                            });
                                          },
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                      obscureText: !_isPasswordVisible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Next Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: CustomButtonWidget(
                                backgroundColor: AppColors.brightSkyBlue,
                                textColor: AppColors.white,
                                buttonText: "Next",
                                onPressed: () => context.goToHome(),
                              ).buildButton(),
                            ),
                          ],
                        ),


                        Container(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () => context.pushToLogin(),
                            child: RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  color: AppColors.azureBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: const [
                                  TextSpan(
                                    text: "Sign in",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
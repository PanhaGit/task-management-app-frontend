import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/constants/app_style.dart';
import 'package:frontend_app_task/controllers/auth/auth_controllers.dart';
import 'package:frontend_app_task/models/auth/auth.dart';
import 'package:frontend_app_task/router/app_router.dart';
import 'package:frontend_app_task/services/firebase_notification/notification_services.dart';
import 'package:frontend_app_task/util/is_device_helper.dart';
import 'package:frontend_app_task/wiegtes/custome_button_wiegte.dart';
import 'package:frontend_app_task/wiegtes/custome_form_builder_text_field.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final IsDeviceHelper _isDeviceHelper = IsDeviceHelper();
  final AuthControllers _authController = Get.find<AuthControllers>();
  bool _isPasswordVisible = false;

  Future<void> _handleSignup() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      final fcmToken = await NotificationServices().getDeviceToken();
      if (fcmToken == null) {
        throw Exception('Could not get device token');
      }
      try {
        final response = await _authController.signUp(
          SignUpRequest(
              firstName: formData['first_name'],
              lastName: formData['last_name'],
              email: formData['email'],
              password: formData['password'],
              phoneNumber: formData['phone_number'],
              fcmToken: fcmToken
          ),
          context,
        );

        if (response != null) {
          final userEmail = formData['email'] as String;
          if (context.mounted) {
            context.goNamed(
              'verify_code',
              extra: userEmail,
            );
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.goBack();
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
                context.goBack();
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
                  padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 80),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - MediaQuery.of(context).padding.top,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
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
                            FormBuilder(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomFormBuilderTextField(
                                    name: 'first_name',
                                    label: 'First name',
                                    validators: [
                                      FormBuilderValidators.required(errorText: 'First name is required'),
                                    ],
                                  ),
                                  SizedBox(height: AppStyle.deviceHeight(context) * 0.03),
                                  CustomFormBuilderTextField(
                                    name: 'last_name',
                                    label: 'Last name',
                                    validators: [
                                      FormBuilderValidators.required(errorText: 'Last name is required'),
                                    ],
                                  ),
                                  SizedBox(height: AppStyle.deviceHeight(context) * 0.03),
                                  CustomFormBuilderTextField(
                                    name: 'phone_number',
                                    label: 'Phone Number',
                                    inputType: TextInputType.phone,
                                    validators: [
                                      FormBuilderValidators.required(errorText: 'Phone Number is required'),
                                    ],
                                  ),
                                  SizedBox(height: AppStyle.deviceHeight(context) * 0.03),
                                  CustomFormBuilderTextField(
                                    name: 'email',
                                    label: 'Email',
                                    inputType: TextInputType.emailAddress,
                                    validators: [
                                      FormBuilderValidators.required(errorText: 'Email is required'),
                                      FormBuilderValidators.email(errorText: 'Enter a valid email'),
                                    ],
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
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(errorText: 'Password is required'),
                                        FormBuilderValidators.minLength(6, errorText: 'Minimum 6 characters'),
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Obx(() => CustomButtonWidget(
                                backgroundColor: AppColors.brightSkyBlue,
                                textColor: AppColors.white,
                                buttonText: _authController.isLoading.value
                                    ? "Loading..."
                                    : "Next",
                                onPressed: _authController.isLoading.value
                                    ? null
                                    : _handleSignup,
                              ).buildButton()),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 50),
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () =>context.pushToLogin(),
                            child: RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  color: AppColors.azureBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                children:  [
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
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend_app_task/constants/app_style.dart';
import 'package:frontend_app_task/controllers/auth/auth_controllers.dart';
import 'package:frontend_app_task/router/app_router.dart';
import 'package:frontend_app_task/util/is_device_helper.dart';
import 'package:frontend_app_task/wiegtes/custome_button_wiegte.dart';
import 'package:frontend_app_task/wiegtes/custome_form_builder_text_field.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthControllers _authControllers = AuthControllers();
  final _formKey = GlobalKey<FormBuilderState>();
  final IsDeviceHelper _isDeviceHelper = IsDeviceHelper();

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
              onPressed: () => context.pushToGetStart(),
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
                                  CustomFormBuilderTextField(
                                    name: 'password',
                                    label: 'Password',
                                    isPassword: true,

                                    validators: [
                                      FormBuilderValidators.required(errorText: 'Password is required'),
                                      FormBuilderValidators.minLength(6, errorText: 'Minimum 6 characters'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: CustomButtonWidget(
                                backgroundColor: AppColors.brightSkyBlue,
                                textColor: AppColors.white,
                                buttonText: "Next",
                                onPressed: () async {
                                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                                    final formData = _formKey.currentState!.value;
                                    await _authControllers.signupAccount(formData);
                                    context.goToHome();
                                  }else{
                                    context.pushToSignup();
                                  }
                                },
                              ).buildButton(),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 50),
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

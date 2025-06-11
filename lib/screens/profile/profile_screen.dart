import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frontend_app_task/background_gradient.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/controllers/auth/auth_controllers.dart';
import 'package:frontend_app_task/router/app_router.dart';
import 'package:frontend_app_task/wiegtes/custome_button_wiegte.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final AuthControllers authController = Get.find<AuthControllers>();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BackgroundGradient(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Cover and Profile Image Section
                      Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[300],
                              image: const DecorationImage(
                                image: CachedNetworkImageProvider(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Node.js_logo.svg/1200px-Node.js_logo.svg.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt, color: Colors.white),
                                onPressed: () => _changeCoverImage(context),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -50,
                            child: GestureDetector(
                              onTap: () => _changeProfileImage(context),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                  color: Colors.grey[200],
                                  image: const DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Node.js_logo.svg/1200px-Node.js_logo.svg.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: const Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.blue,
                                    child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      // Change Password Option
                      _buildProfileField(
                        context,
                        leftIcon: Icons.lock,
                        label: "Change Password",
                        rightIcon: Icons.arrow_forward_ios,
                        color: AppColors.black,
                        onTap: () {
                          try {
                            context.goToForgetPassword();
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Navigation failed: $e',
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 3),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: CustomButtonWidget(
                          backgroundColor: AppColors.gray,
                          textColor: AppColors.black,
                          buttonText: "Log out",
                          onPressed: () {
                            authController.logout(context);
                          },
                        ).buildButton(),
                      ),
                      const SizedBox(height: 10),
                      // Delete Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: CustomButtonWidget(
                          backgroundColor: Colors.red,
                          textColor: AppColors.white,
                          buttonText: "Delete Account",
                          onPressed: () {
                            _showDeleteAccountModal(context);
                          },
                        ).buildButton(),
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteAccountModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Please provide your email and password to delete your account.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'email',
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: 'Email is required'),
                      FormBuilderValidators.email(errorText: 'Enter a valid email'),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'password',
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: 'Password is required'),
                      FormBuilderValidators.minLength(6, errorText: 'Password must be at least 6 characters'),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'confirmPassword',
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: 'Confirm password is required'),
                      FormBuilderValidators.minLength(6, errorText: 'Password must be at least 6 characters'),
                          (val) {
                        if (val != _formKey.currentState?.fields['password']?.value) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ]),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            Obx(() => ElevatedButton(
              onPressed: authController.isLoading.value
                  ? null // Disable button while loading
                  : () async {
                if (_formKey.currentState!.saveAndValidate()) {
                  final formData = _formKey.currentState!.value;
                  final email = formData['email'];
                  final password = formData['password'];
                  final confirmPassword = formData['confirmPassword'];

                  try {
                    await authController.deleteAccount(
                      email,
                      password,
                      confirmPassword,
                    );
                    Navigator.of(context).pop(); // Close the dialog
                    Get.snackbar(
                      'Success',
                      'Account deleted successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                    // Navigate to login screen
                    context.goToLogin(); // Ensure this method exists in AppRouter
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      e.toString(),
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: authController.isLoading.value
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text('Delete Account'),
            )),
          ],
        );
      },
    );
  }

  Widget _buildProfileField(
      BuildContext context, {
        required IconData leftIcon,
        required String label,
        required IconData rightIcon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(leftIcon, color: color),
                const SizedBox(width: 16),
                Text(label, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            Icon(rightIcon, color: color),
          ],
        ),
      ),
    );
  }

  void _changeProfileImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildImagePickerOptions(context, 'Profile'),
    );
  }

  void _changeCoverImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildImagePickerOptions(context, 'Cover'),
    );
  }

  Widget _buildImagePickerOptions(BuildContext context, String type) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Change $type Image',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Take Photo'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () => Navigator.pop(context),
          ),
          if (type == 'Profile')
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Remove Photo',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
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
                                icon: const Icon(Icons.camera_alt,
                                    color: Colors.white),
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
                                  border: Border.all(
                                      color: Colors.white, width: 4),
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
                                    child: Icon(Icons.camera_alt,
                                        size: 16, color: Colors.white),
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
                          }
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
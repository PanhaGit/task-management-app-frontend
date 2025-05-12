import 'package:flutter/material.dart';
import 'package:frontend_app_task/background_gradient.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/router/app_router.dart';
import 'package:frontend_app_task/wiegtes/custome_button_wiegte.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                          // Cover Image
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[300],
                              image: const DecorationImage(
                                image: NetworkImage('https://example.com/cover-image.jpg'),
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

                          // Profile Image
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
                                    image: NetworkImage('https://example.com/profile-image.jpg'),
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

                      const SizedBox(height: 60), // Space for profile image overlap

                      // User Information Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildProfileField(
                                context,
                                label: 'Username',
                                value: 'JohnDoe',
                                icon: Icons.person,
                              ),
                              const Divider(height: 20),
                              _buildProfileField(
                                context,
                                label: 'Email',
                                value: 'john.doe@example.com',
                                icon: Icons.email,
                              ),
                              const Divider(height: 20),
                              _buildProfileField(
                                context,
                                label: 'Phone Number',
                                value: '+1 (555) 123-4567',
                                icon: Icons.phone,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Change Password Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CustomButtonWidget(
                          backgroundColor: AppColors.brightSkyBlue,
                          textColor: AppColors.white,
                          buttonText: "Change Password",  // Changed from Text widget to String
                          onPressed: () {
                            context.pushToForgetPass();
                          },
                        ).buildButton(),
                      ),

                      // Add an empty SizedBox at the bottom to ensure content stays centered
                      // when there's extra space
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

  // Rest of your helper methods remain the same...
  Widget _buildProfileField(BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, size: 20),
          onPressed: () => _editField(context, label, value),
        ),
      ],
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
            onTap: () {
              Navigator.pop(context);
              // Implement camera functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              // Implement gallery picker functionality
            },
          ),
          if (type == 'Profile') ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              // Implement remove photo functionality
            },
          ),
        ],
      ),
    );
  }

  void _editField(BuildContext context, String field, String currentValue) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'New $field',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement save logic
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _changePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement password change logic
              Navigator.pop(context);
            },
            child: const Text('Update Password'),
          ),
        ],
      ),
    );
  }
}
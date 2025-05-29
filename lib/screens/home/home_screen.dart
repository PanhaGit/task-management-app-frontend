import 'package:flutter/material.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/util/format_date_helper.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:frontend_app_task/background_gradient.dart';
import 'package:frontend_app_task/controllers/auth/auth_controllers.dart';
import 'package:frontend_app_task/controllers/home_controller.dart';
import 'package:frontend_app_task/models/Task.dart';
import 'package:frontend_app_task/router/app_router.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  final AuthControllers authController = Get.find<AuthControllers>();
  final RefreshController refreshController = RefreshController();
  final formatDateHelper = FormatDateHelper();
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildUserGreeting(),
        actions: [_buildNotificationButton()],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BackgroundGradient(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: SmartRefresher(
                  controller: refreshController,
                  onRefresh: _onRefresh,
                  header: const WaterDropHeader(
                    waterDropColor: Colors.blue,
                    complete: Icon(Icons.check, color: Colors.blue),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTaskSummary(),
                        const SizedBox(height: 24),
                        _buildTaskCards(), // updated method here
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserGreeting() {
    return Obx(() {
      final user = authController.currentUser.value;
      final imageUrl = user?.imageProfile;

      return Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                ? NetworkImage(imageUrl)
                : null,
            child: (imageUrl == null || imageUrl.isEmpty)
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'Welcome, ${user?.fullName ?? 'Guest'}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNotificationButton() {
    return IconButton(
      icon: const Icon(Icons.notifications_outlined, color: Colors.black),
      onPressed: () => Get.context?.goToNotification(),
    );
  }

  Future<void> _onRefresh() async {
    await homeController.getAllTask();
    refreshController.refreshCompleted();
  }

  Widget _buildTaskSummary() {
    return Obx(() {
      final totalTasks = homeController.tasks.length;
      final completedTasks = homeController.tasks
          .where((task) => task.status.toLowerCase() == "complete")
          .length;
      final percentage =
      totalTasks > 0 ? (completedTasks / totalTasks * 100).round() : 0;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Progress ($completedTasks/$totalTasks)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: totalTasks > 0 ? completedTasks / totalTasks : 0,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTaskCards() {
    return Obx(() {
      if (homeController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      }

      if (homeController.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            homeController.errorMessage.value,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      if (homeController.tasks.isEmpty) {
        return const Center(
          child: Text(
            "No tasks available",
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return Column(
        children:
        homeController.tasks.map((task) => _buildTaskCard(task)).toList(),
      );
    });
  }

  Widget _buildTaskCard(Task task) {
    // Convert hex string to Color
    Color _getColorFromHex(String hexColor) {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor'; // add alpha if not present
      }
      return Color(int.parse(hexColor, radix: 16));
    }

    // Get color from task category
    final backgroundColor = _getColorFromHex(task.categories.color);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        color: backgroundColor, // ✅ use actual Color object
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.categories.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.brightSkyBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.status.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text("Time: ${formatDateHelper.formatTimeTask(task.endDate)} Hours"),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildDateChip(
                    icon: Icons.calendar_today_outlined,
                    label: 'Start: ${_formatDate(task.startDate)}',
                  ),
                  const SizedBox(width: 8),
                  _buildDateChip(
                    icon: Icons.event_available_outlined,
                    label: 'End: ${_formatDate(task.endDate)}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDateChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

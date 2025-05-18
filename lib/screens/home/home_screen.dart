import 'package:flutter/material.dart';
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
      return Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            backgroundImage: user != null
                ? const NetworkImage('https://via.placeholder.com/150')
                : null,
            child: user == null
                ? const Icon(Icons.person, color: Colors.white)
                : Text(
              '${user.firstName[0]}${user.lastName[0]}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
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

  // This builds a card for EACH task, regardless of category
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
        children: homeController.tasks
            .map((task) => _buildTaskCard(task))
            .toList(),
      );
    });
  }

  Widget _buildTaskCard(Task task) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.category.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.status,
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

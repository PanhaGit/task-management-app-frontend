import 'package:flutter/material.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/util/format_date_helper.dart';
import 'package:frontend_app_task/wiegtes/TextButtonCustom.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:frontend_app_task/background_gradient.dart';
import 'package:frontend_app_task/controllers/auth/auth_controllers.dart';
import 'package:frontend_app_task/controllers/home_controller.dart';
import 'package:frontend_app_task/models/Task.dart';
import 'package:frontend_app_task/router/app_router.dart';

class HomeScreen extends StatelessWidget {
  // Controller instances
  final HomeController homeController = Get.find<HomeController>();
  final AuthControllers authController = Get.find<AuthControllers>();

  // Refresh controller for pull-to-refresh functionality
  final RefreshController refreshController = RefreshController();

  // Helper for formatting dates
  final formatDateHelper = FormatDateHelper();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0, // No shadow
        title: _buildUserGreeting(), // Custom greeting widget
        actions: [_buildNotificationButton()], // Notification icon
        iconTheme: const IconThemeData(color: Colors.black), // Icon color
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
                  onRefresh: _onRefresh, // Refresh callback
                  header: const WaterDropHeader(
                    waterDropColor: Colors.blue,
                    complete: Icon(Icons.check, color: Colors.blue),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTaskSummary(), // Task progress summary
                        const SizedBox(height: 24),
                        _filterTaskByStatus(), // Filter buttons
                        const SizedBox(height: 24),
                        _buildTaskCards(context), // List of task cards
                        const SizedBox(height: 100), // Bottom padding
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

  /// Builds the user greeting widget with profile image and name
  Widget _buildUserGreeting() {
    return Obx(() {
      final user = authController.currentUser.value;
      final imageUrl = user?.imageProfile;

      return Row(
        children: [
          // User profile image
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
          // User name
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

  /// Builds the notification button in app bar
  Widget _buildNotificationButton() {
    return IconButton(
      icon: const Icon(Icons.notifications_outlined, color: Colors.black),
      onPressed: () => Get.context?.goToNotification(),
    );
  }

  /// Handles pull-to-refresh action
  Future<void> _onRefresh() async {
    await homeController.getAllTask(); // Refresh task data
    refreshController.refreshCompleted(); // Complete refresh animation
  }

  /// Builds the task summary card showing progress
  Widget _buildTaskSummary() {
    return Obx(() {
      // Get filtered tasks based on current selection
      final filteredTasks = homeController.filteredTasks;
      final totalTasks = filteredTasks.length;

      // Count completed tasks
      final completedTasks = filteredTasks
          .where((task) => task.status.toLowerCase() == "complete")
          .length;

      // Calculate completion percentage
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
            // Header with filter status
            Row(
              children: [
                const Text(
                  'My Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Text(
                  homeController.currentFilter.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress text and percentage
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

            // Progress bar
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

  /// Builds the horizontal filter buttons
  Widget _filterTaskByStatus() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // All tasks filter button
            TextButtonCustom(
              text: 'All',
              onPressed: () {
                homeController.setFilter('all');
              },
              backgroundColor: homeController.currentFilter == 'all'
                  ? Colors.blue
                  : Colors.grey[300]!,
              textColor: homeController.currentFilter == 'all'
                  ? Colors.white
                  : Colors.black,
            ),
            const SizedBox(width: 8),

            // Todo tasks filter button
            TextButtonCustom(
              text: 'Todo',
              onPressed: () {
                homeController.setFilter('todo');
              },
              backgroundColor: homeController.currentFilter == 'todo'
                  ? Colors.blue
                  : Colors.grey[300]!,
              textColor: homeController.currentFilter == 'todo'
                  ? Colors.white
                  : Colors.black,
            ),
            const SizedBox(width: 8),

            // Completed tasks filter button
            TextButtonCustom(
              text: 'Completed',
              onPressed: () {
                homeController.setFilter('complete');
              },
              backgroundColor: homeController.currentFilter == 'complete'
                  ? Colors.blue
                  : Colors.grey[300]!,
              textColor: homeController.currentFilter == 'complete'
                  ? Colors.white
                  : Colors.black,
            ),
          ],
        ),
      );
    });
  }

  /// Builds the list of task cards
  Widget _buildTaskCards(BuildContext context) {
    return Obx(() {
      // Show loading indicator while fetching data
      if (homeController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      }

      // Show error message if any
      if (homeController.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            homeController.errorMessage.value,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      // Get tasks based on current filter
      final tasksToShow = homeController.filteredTasks;

      // Show empty state message
      if (tasksToShow.isEmpty) {
        return Center(
          child: Text(
            homeController.currentFilter == 'all'
                ? "No tasks available"
                : "No ${homeController.currentFilter} tasks",
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }

      // Build list of task cards
      return Column(
        children: tasksToShow.map((task) => _buildTaskCard(context, task)).toList(),
      );
    });
  }

  /// Builds an individual task card
  Widget _buildTaskCard(BuildContext context, Task task) {
    return InkWell(
      onTap: () {
        context.goNamed('task_detail', pathParameters: {'id': task.id});
      },
      borderRadius: BorderRadius.circular(12), // Added for ripple effect
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task category and status
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

                // Task title
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Task duration
                Text("Time: ${formatDateHelper.formatTimeTask(task.endDate)} Hours"),
                const SizedBox(height: 8),

                // Task dates
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
      ),
    );
  }

  /// Builds a date chip with icon and text
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

  /// Formats date as dd/mm/yyyy
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
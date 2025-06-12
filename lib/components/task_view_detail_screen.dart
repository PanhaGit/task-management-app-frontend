import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app_task/controllers/task_controller.dart';
import 'package:frontend_app_task/models/Task.dart';
import 'package:frontend_app_task/router/app_router.dart';
import 'package:frontend_app_task/util/is_device_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:frontend_app_task/services/api/api_service.dart';

class TaskViewDetailScreen extends StatefulWidget {
  final String id;

  TaskViewDetailScreen({super.key, required this.id});

  @override
  _TaskViewDetailScreenState createState() => _TaskViewDetailScreenState();
}

class _TaskViewDetailScreenState extends State<TaskViewDetailScreen> {
  final TaskController _taskController = Get.find<TaskController>();
  late Future<Task?> taskFuture; // Allow null to handle errors gracefully

  @override
  void initState() {
    super.initState();
    taskFuture = _taskController.getOneTask(widget.id).catchError((error) {
      print('Error fetching task: $error');
      return Future.error(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IsDeviceHelper().isDevicesIosAndroidIcons(
          iconIos: const Icon(Icons.arrow_back_ios, color: Colors.white),
          iconAndroid: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            print('Navigating to home');
            context.go('/');
          },
        ),
        title: const Text(
          "Task Detail",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 4,
      ),
      body: FutureBuilder<Task?>(
        future: taskFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.blue));
          } else if (snapshot.hasError) {
            return _buildErrorScreen(snapshot.error.toString());
          } else if (snapshot.hasData) {
            final task = snapshot.data;
            if (task == null) {
              return _buildErrorScreen('Task data is null');
            }
            return _buildTaskDetail(task);
          } else {
            return _buildErrorScreen('Task not found');
          }
        },
      ),
    );
  }

  Widget _buildErrorScreen(String errorMessage) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Go Back', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskDetail(Task task) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title ?? 'Untitled',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailRow('Category', task.categories?.title ?? 'Unknown'),
              _buildDetailRow('Status', task.status?.toUpperCase() ?? 'UNKNOWN'),
              _buildDetailRow(
                'Start Date',
                task.startDate != null
                    ? DateFormat('MMM dd, yyyy HH:mm').format(task.startDate!)
                    : 'N/A',
              ),
              _buildDetailRow(
                'End Date',
                task.endDate != null
                    ? DateFormat('MMM dd, yyyy HH:mm').format(task.endDate!)
                    : 'N/A',
              ),
              const SizedBox(height: 20),
              Text(
                'Description:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.description ?? 'No description',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
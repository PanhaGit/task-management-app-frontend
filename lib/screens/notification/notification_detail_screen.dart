import 'package:flutter/material.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/constants/app_colors.dart';
import 'package:frontend_app_task/services/api/api_service.dart';
import 'package:frontend_app_task/util/format_date_helper.dart';
import 'package:frontend_app_task/util/is_device_helper.dart';
import 'package:go_router/go_router.dart';

class NotificationDetailScreen extends StatefulWidget {
  final String notifyId;
  const NotificationDetailScreen({super.key, required this.notifyId});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  Map<String, dynamic>? task;
  bool isLoading = true;
  final ApiService _apiService = ApiService();
  final FormatDateHelper _dateHelper = FormatDateHelper();

  @override
  void initState() {
    super.initState();
    fetchTask();
  }

  Future<void> fetchTask() async {
    try {
      final response = await _apiService
          .fetchData(endpoint: "/notifications/with_task/${widget.notifyId}");
      if (response.statusCode == 200) {
        setState(() {
          task = response.data['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching task: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDateSafe(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return _dateHelper.formatDateDOB(date);
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyleBody = TextStyle(color: AppColors.charcoalGray);

    return Scaffold(
      appBar: AppBar(
        leading: IsDeviceHelper().isDevicesIosAndroidIcons(
          iconIos: const Icon(Icons.arrow_back_ios),
          iconAndroid: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text("Notification Details"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : task != null
          ? SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.title, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task!['title'],
                        // style: textStyleTitle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.description, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task!['description'] ?? 'No description',
                        style: textStyleBody,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.green),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Date: ${formatDateSafe(task!['start_date'])}",
                          style: textStyleBody,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "End Date: ${formatDateSafe(task!['end_date'])}",
                          style: textStyleBody,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
          : Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
            SizedBox(height: 16),
            Text(
              "Task not found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
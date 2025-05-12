// lib/views/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend_app_task/controllers/notification_controller.dart';
import 'package:frontend_app_task/services/firebase_notification/notification_services.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationServices _notificationServices = NotificationServices();
  final NotificationController _notificationController = Get.find();

  final List<Map<String, String>> notifications = [
    {'name': 'Patrick Hill', 'description': 'Onboarding Screen UI Design', 'initials': 'PH'},
    {'name': 'Kyle Powell', 'description': 'Onboarding Screen UI Design', 'initials': 'KP'},
    {'name': 'Danielle Baker', 'description': 'Onboarding Screen UI Design', 'initials': 'DB'},
    {'name': 'Christine Brewer', 'description': 'Dashboard Screen UI Design', 'initials': 'CB'},
    {'name': 'Jose McCoy', 'description': 'Dashboard Screen UI Design', 'initials': 'JM'},
    {'name': 'Kyle Wagner', 'description': 'Food App UI Design', 'initials': 'KW'},
    {'name': 'Tyler Fox', 'description': 'Food App UI Design', 'initials': 'TF'},
    {'name': 'Natasha Lucas', 'description': 'Signup Screen UI Design', 'initials': 'NL'},
    {'name': 'Kelly Williamson', 'description': 'Onboarding Screen UI Design', 'initials': 'KW'},
  ];



  @override
  void initState() {
    super.initState();
    debugPrint("Initializing NotificationScreen");
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    debugPrint("Initializing notifications");
    _notificationServices.requestNotificationPermission();
    _notificationServices.firebaseInit(context);
    final token = await _notificationServices.getDeviceToken();
    debugPrint("🔐 Token: $token");
  }

  // Function to generate random color for avatar background
  Color _getAvatarColor(String initials) {
    final colors = [
      Colors.blue.shade400,
      Colors.red.shade400,
      Colors.green.shade400,
      Colors.purple.shade400,
      Colors.orange.shade400,
      Colors.teal.shade400,
    ];
    return colors[initials.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building NotificationScreen with ${_notificationController.notifications.length} notifications");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        elevation: 0,
        actions: [
          Obx(() => Badge(
            isLabelVisible: _notificationController.unreadCount > 0,
            label: Text(_notificationController.unreadCount.toString()),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                _notificationController.markAsRead();
              },
            ),
          )),
        ],
      ),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                // Profile avatar circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getAvatarColor(notification['initials']!),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      notification['initials']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Notification content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['description']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Time/status indicator could be added here
              ],
            ),
          );
        },



      ),
    );
  }
}
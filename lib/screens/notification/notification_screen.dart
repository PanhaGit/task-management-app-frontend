import 'package:flutter/material.dart';
import 'package:frontend_app_task/services/firebase_notification/notification_services.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationServices _notificationServices = NotificationServices();
  
  // Notification data with profile initials
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
    _notificationServices.requestNotificationPermission();
    _notificationServices.firebaseInit();
    _notificationServices.getDeviceToken().then((value) { 
      print("🔐 Token: $value");
    });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        elevation: 0,
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
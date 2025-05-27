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
  final NotificationServices _notificationServices = NotificationServices();
  final NotificationController _notificationController = Get.find();

  @override
  void initState() {
    super.initState();
    debugPrint("Initializing NotificationScreen");
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    debugPrint("Initializing notifications");
    _notificationServices.requestNotificationPermission();
    _notificationServices.firebaseInit();
    final token = await _notificationServices.getDeviceToken();
    debugPrint("🔐 Token: $token");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building NotificationScreen with ${_notificationController.notifications.length} notifications");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
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
      body: Obx(() {
        if (_notificationController.notifications.isEmpty) {
          return const Center(
            child: Text("No notifications yet"),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {

          },
          child: ListView.builder(
            itemCount: _notificationController.notifications.length,
            itemBuilder: (context, index) {
              final notification = _notificationController.notifications[index];
              final time = notification.sentTime ?? DateTime.now();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.notifications_active),
                  title: Text(
                    notification.notification?.title ?? 'No Title',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.notification?.body ?? 'No Body'),
                      const SizedBox(height: 4),
                      Text(
                        timeago.format(time),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Handle notification tap
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
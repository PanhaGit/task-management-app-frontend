import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend_app_task/models/Notification.dart';
import 'package:frontend_app_task/services/api/api_service.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final ApiService _apiService = ApiService();
  final _notifications = <NotificationModel>[].obs;
  RxBool isLoading = false.obs;
  final _unreadCount = 0.obs;

  List<NotificationModel> get notifications => _notifications.toList();
  int get unreadCount => _unreadCount.value;

  @override
  void onInit() {
    super.onInit();
    getAllNotification();
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    if (!notification.isRead) _unreadCount.value++;
    update();
  }

  void addFirebaseNotification(RemoteMessage message) {
    final notification = NotificationModel.fromRemoteMessage(message);
    addNotification(notification);
  }

  void markAsRead({NotificationModel? specificNotification}) {
    if (specificNotification != null) {
      specificNotification.isRead = true;
    } else {
      _notifications.forEach((n) => n.isRead = true);
    }
    _unreadCount.value = _notifications.where((n) => !n.isRead).length;
    _notifications.refresh();
    update();
  }

  void clearAll() {
    _notifications.clear();
    _unreadCount.value = 0;
    update();
  }

  Future<void> getAllNotification() async {
    try {
      isLoading.value = true;
      final response = await _apiService.fetchData(
          endpoint: "/notifications/get_all_notification");
      if (response.data != null && response.data['success'] == true) {
        final List<dynamic> notificationData = response.data['data'] ?? [];
        final notifications = notificationData
            .map((data) => NotificationModel.fromJson(data))
            .toList();
        _notifications.assignAll(notifications);
        _unreadCount.value = _notifications.where((n) => !n.isRead).length;
        debugPrint('Fetched notifications: ${notifications.length}');
      } else {
        Get.snackbar('Error', 'Failed to fetch notifications');
      }
    } catch (err) {
      debugPrint('Error fetching notifications: $err');
      Get.snackbar('Error', 'An error occurred while fetching notifications');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _notifications.close();
    super.onClose();
  }
}
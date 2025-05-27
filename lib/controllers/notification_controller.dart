import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final _notifications = <RemoteMessage>[].obs;
  final _unreadCount = 0.obs;

  List<RemoteMessage> get notifications => _notifications.toList();
  int get unreadCount => _unreadCount.value;

  void addNotification(RemoteMessage message) {
    _notifications.insert(0, message);
    _unreadCount.value++;
    update();
  }

  void markAsRead() {
    _unreadCount.value = 0;
    update();
  }

  void clearAll() {
    _notifications.clear();
    _unreadCount.value = 0;
    update();
  }

  @override
  void onClose() {
    _notifications.close();
    super.onClose();
  }
}
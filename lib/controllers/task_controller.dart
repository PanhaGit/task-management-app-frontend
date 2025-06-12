import 'package:flutter/cupertino.dart';
import 'package:frontend_app_task/models/Task.dart';
import 'package:frontend_app_task/services/api/api_service.dart';
import 'package:frontend_app_task/services/firebase_notification/notification_services.dart';
import 'package:frontend_app_task/util/helper/my_dialog.dart';
import 'package:get/get.dart';
import '../models/Categories.dart';

class TaskController extends GetxController {
  final ApiService _apiService = ApiService();
  final NotificationServices _notificationServices = Get.find<NotificationServices>();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingCategories = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Task> tasks = <Task>[].obs;
  final RxList<Categories> categories = <Categories>[].obs;
  final Rx<Task> selectedTask = Rx(Task.empty());

  Future<void> fetchCategories() async {
    try {
      isLoadingCategories.value = true;
      errorMessage.value = '';

      final response = await _apiService.fetchData<Map<String, dynamic>>(
        method: "GET",
        endpoint: "/category",
      );

      if (response.data != null &&
          response.data!["success"] == true &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final List<dynamic> jsonCategories = response.data!['data'];
        categories.assignAll(
            jsonCategories.map((cat) => Categories.fromJson(cat)).toList()
        );
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to load categories');
      }
    } catch (err) {
      errorMessage.value = err.toString();
      rethrow;
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<bool> createTask(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.fetchData<Map<String, dynamic>>(
        method: "POST",
        endpoint: "/task",
        data: payload,
      );

      if (response.data != null &&
          response.data!["success"] == true &&
          (response.statusCode == 201 || response.statusCode == 200)) {

        final endTime = DateTime.parse(payload['end_date']);
        final notificationTime = endTime.subtract(const Duration(minutes: 15));

        await _notificationServices.scheduleTaskNotification(
          id: response.data!['data']['_id'].hashCode,
          title: 'Task Reminder: ${payload['title']}',
          body: payload['description'] ?? 'Your task is about to end soon!',
          scheduledTime: notificationTime,
        );

        return true;
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to create task');
      }
    } catch (err) {
      errorMessage.value = err.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Task> getOneTask(String id) async {
    try {
      isLoading.value = true;
      final response = await _apiService.fetchData(endpoint: "/task/$id");

      if (response.data['success'] == true && response.data['data'] != null) {
        return Task.fromJson(response.data['data']);
      } else {
        throw Exception(response.data?['message'] ?? 'Task not found');
      }
    } catch (error) {
      throw Exception('Failed to fetch task: $error');
    } finally {
      isLoading.value = false;
    }
  }


}

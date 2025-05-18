import 'package:frontend_app_task/models/task.dart';
import 'package:frontend_app_task/services/api/api_service.dart';
import 'package:frontend_app_task/util/helper/my_dialog.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingCategories = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Task> tasks = <Task>[].obs;
  final RxList<Category> categories = <Category>[].obs;
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
            jsonCategories.map((cat) => Category.fromJson(cat)).toList()
        );
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to load categories');
      }
    } catch (err) {
      errorMessage.value = err.toString();
      // MyDialog.error(errorMessage.value);
      rethrow;
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<bool> postNewTask(Map<String, dynamic> payload) async {
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
        // MyDialog.success('Task created successfully');
        return true;
      } else {
        throw Exception(response.data?['message'] ?? 'Failed to create task');
      }
    } catch (err) {
      errorMessage.value = err.toString();
      // MyDialog.error(errorMessage.value);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
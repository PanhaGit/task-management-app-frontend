import 'package:frontend_app_task/models/Task.dart';
import 'package:frontend_app_task/services/api/api_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Task> tasks = <Task>[].obs;
  final Rx<Task> selectedTask = Rx(Task.empty());

  @override
  void onInit() {
    super.onInit();
    getAllTask();
  }
  /// Fetch all tasks from the API
  Future<void> getAllTask() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _apiService.fetchData<Map<String, dynamic>>(
        endpoint: '/task',
        headers: {
          "Authorization" :"Bearer"
        }
      );
      if (response.data != null && response.data!['success'] == true) {
        final List<dynamic> jsonTasks = response.data!['data'];
        final taskList = jsonTasks.map((e) => Task.fromJson(e)).toList();
        tasks.assignAll(taskList);
      } else {
        errorMessage.value = response.data?['message'] ?? 'Unknown error';
      }
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Unexpected error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}

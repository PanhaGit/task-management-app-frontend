import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_app_task/services/api/api_connect_backend.dart';
import 'package:get/get.dart';

class AuthControllers extends GetxController {
  final RxBool isLoading = false.obs;
  final ApiConnectBackend _apiConnectBackend = ApiConnectBackend();
  final String endpointAuth = '/auth';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final RxString signupMessage = ''.obs; // Add this line to store the message

  /// Sign up method
  Future<void> signupAccount(Map<String, dynamic> signupData) async {
    isLoading.value = true;
    signupMessage.value = ''; // Reset message before new signup attempt

    try {
      final response = await _apiConnectBackend.request<Map<String, dynamic>>(
        method: 'POST',
        endpoint: '$endpointAuth/signup',
        data: signupData,
      );

      final data = response.data;

      print('Signup response data: $data');

      if (data != null &&
          data['access_token'] != null &&
          data['refresh_token'] != null) {
        await _storage.write(key: 'access_token', value: data['access_token']);
        await _storage.write(key: 'refresh_token', value: data['refresh_token']);

        // Store success message to show later
        signupMessage.value = 'Account created successfully!';

        // Show immediate feedback (optional)
        _showSnackbar('Success', signupMessage.value);
      } else {
        signupMessage.value = 'Signup failed. Please try again.';
        _showSnackbar('Error', signupMessage.value);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ??
          e.message ??
          'An error occurred during signup';
      signupMessage.value = errorMessage;
      _showSnackbar('Error', errorMessage);
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      signupMessage.value = errorMessage;
      _showSnackbar('Error', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to safely show snackbar
  void _showSnackbar(String title, String message) {
    if (Get.context != null) {
      if (Get.isSnackbarOpen) {
        Get.back();
      }

      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } else {
      print('$title: $message');
    }
  }
}
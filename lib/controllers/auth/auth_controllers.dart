import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_app_task/router/app_router.dart';
import 'package:frontend_app_task/services/api/api_connect_backend.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthControllers extends GetxController {
  final RxBool isLoading = false.obs;
  final ApiConnectBackend _apiConnectBackend = ApiConnectBackend();
  final String endpointAuth = '/auth';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final RxString signupMessage = ''.obs;
  final RxString loginMessage = ''.obs;

  Future<bool> hasSeenGetStart() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_seen_get_start') ?? false;
  }

  Future<void> markGetStartSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_get_start', true);
  }

  Future<void> signupAccount(Map<String, dynamic> signupData) async {
    isLoading.value = true;
    signupMessage.value = '';

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
        await markGetStartSeen();

        signupMessage.value = 'Account created successfully!';
        _showSnackbar('Success', signupMessage.value);

        if (Get.context != null && Get.context!.mounted) {
          Get.context!.goToHome();
        }
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

  Future<void> loginAccount(Map<String, dynamic> loginData) async {
    isLoading.value = true;
    loginMessage.value = '';

    try {
      final response = await _apiConnectBackend.request<Map<String, dynamic>>(
        method: 'POST',
        endpoint: '$endpointAuth/login',
        data: loginData,
      );

      final data = response.data;

      print('Login response data: $data');

      if (data != null &&
          data['access_token'] != null &&
          data['refresh_token'] != null) {
        await _storage.write(key: 'access_token', value: data['access_token']);
        await _storage.write(key: 'refresh_token', value: data['refresh_token']);
        await markGetStartSeen();

        loginMessage.value = 'Logged in successfully!';
        _showSnackbar('Success', loginMessage.value);

        if (Get.context != null && Get.context!.mounted) {
          Get.context!.goToHome();
        }
      } else {
        loginMessage.value = 'Login failed. Please try again.';
        _showSnackbar('Error', loginMessage.value);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data?['message'] ??
          e.message ??
          'An error occurred during login';
      loginMessage.value = errorMessage;
      _showSnackbar('Error', errorMessage);
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      loginMessage.value = errorMessage;
      _showSnackbar('Error', errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackbar(String title, String message) {
    if (Get.overlayContext != null && Get.overlayContext!.mounted) {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 300),
      );
    } else {
      print('Snackbar not shown: $title: $message');
    }
  }
}
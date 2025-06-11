import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_app_task/router/app_router.dart';
import 'package:frontend_app_task/util/helper/my_dialog.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_app_task/models/auth/auth.dart';
import 'package:frontend_app_task/services/api/api_service.dart';
import 'package:frontend_app_task/services/firebase_notification/notification_services.dart';

class AuthControllers extends GetxController {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final NotificationServices _notificationServices = Get.find();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final String endPoint = "/auth";

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final accessToken = await storage.read(key: 'access_token');
      if (accessToken == null) return;

      final userData = await storage.read(key: 'user_data');
      if (userData != null) {
        currentUser.value = User.fromJson(Map<String, dynamic>.from(json.decode(userData)));
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    }
  }

  Future<AuthResponse?> signUp(SignUpRequest request, BuildContext context) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fcmToken = await _notificationServices.getDeviceToken();
      if (fcmToken == null) throw Exception('Could not get FCM token');

      final updatedRequest = SignUpRequest(
        firstName: request.firstName,
        lastName: request.lastName,
        email: request.email,
        password: request.password,
        phoneNumber: request.phoneNumber,
        fcmToken: fcmToken,
      );

      final response = await _apiService.fetchData(
        method: 'POST',
        endpoint: '$endPoint/signup',
        data: updatedRequest.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data as Map<String, dynamic>);
      await _storeAuthData(authResponse);
      await registerFcmToken(authResponse.user!.id, authResponse.accessToken);

      return authResponse;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(LoginRequest request, BuildContext context) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fcmToken = await _notificationServices.getDeviceToken();
      if (fcmToken == null) throw Exception('Could not get FCM token');

      final updatedRequest = LoginRequest(
        email: request.email,
        password: request.password,
        fcmToken: fcmToken,
      );

      final response = await _apiService.fetchData(
        method: 'POST',
        endpoint: '$endPoint/login',
        data: updatedRequest.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data as Map<String, dynamic>);
      await _storeAuthData(authResponse);
      await registerFcmToken(authResponse.user!.id, authResponse.accessToken);

      context.go('/'); // Navigate to home
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerFcmToken(String userId, String accessToken) async {
    try {
      final fcmToken = await _notificationServices.getDeviceToken();
      if (fcmToken == null) return;

      await _apiService.fetchData(
        method: 'POST',
        endpoint: '/notifications/register-fcm',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        data: {
          'userId': userId,
          'fcmToken': fcmToken,
        },
      );
      debugPrint('FCM token registered for user $userId');
    } catch (e) {
      debugPrint('Error registering FCM token: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    await storage.deleteAll();
    currentUser.value = null;
    context.go('/auth/login');
  }

  Future<void> _storeAuthData(AuthResponse authResponse) async {
    try {
      await storage.write(
        key: 'access_token',
        value: authResponse.accessToken,
      );
      await storage.write(
        key: 'refresh_token',
        value: authResponse.refreshToken,
      );
      if (authResponse.user != null) {
        await storage.write(
          key: 'user_data',
          value: json.encode(authResponse.user!.toJson()),
        );
        currentUser.value = authResponse.user;
      } else {
        debugPrint('Warning: authResponse.user is null');
        currentUser.value = null;
      }
    } catch (e) {
      debugPrint('Error storing auth data: $e');
      throw Exception('Failed to store auth data: $e');
    }
  }

  Future<void> deleteAccount(
      String email, String password, String confirmPassword) async {
    try {
      isLoading.value = true;
      final userId = currentUser.value!.id;
      final response = await _apiService.fetchData(
        method: "DELETE",
        endpoint: '/auth/delete/$userId',
        data: {
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        },
      );

      if (response.statusCode == 200) {
        await storage.deleteAll();
        currentUser.value = null;
      } else {
        throw response.data['message'] ?? 'Failed to delete account';
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
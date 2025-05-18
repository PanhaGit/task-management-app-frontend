import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_app_task/models/auth/auth.dart';
import 'package:frontend_app_task/services/api/api_service.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/**
 * AuthControllers handles authentication-related operations including
 * sign up, login, logout, and user data management.
 *
 * @author: Tho Panha
 */
class AuthControllers extends GetxController {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final String endPoint = "/auth";

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  /**
   * Loads user data from secure storage if available.
   * Called during controller initialization.
   */
  Future<void> loadUser() async {
    try {
      final accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) return;

      final userData = await _storage.read(key: 'user_data');
      if (userData != null) {
        currentUser.value = User.fromJson(Map<String, dynamic>.from(json.decode(userData)));
      }
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  /**
   * Handles user registration process.
   * @param request SignUpRequest containing user registration data
   * @param context BuildContext for navigation
   */
  Future<void> signUp(SignUpRequest request, BuildContext context) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.fetchData(
        method: 'POST',
        endpoint: '$endPoint/signup',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data as Map<String, dynamic>);
      await _storeAuthData(authResponse);

      context.go('/'); // Navigate to home
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /**
   * Handles user login process.
   * @param request LoginRequest containing user credentials
   * @param context BuildContext for navigation
   */
  Future<void> login(LoginRequest request, BuildContext context) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.fetchData(
        method: 'POST',
        endpoint: '$endPoint/login',
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data as Map<String, dynamic>);
      await _storeAuthData(authResponse);

      context.go('/'); // Navigate to home
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /**
   * Handles user logout process.
   * Clears all stored authentication data and navigates to login page.
   * @param context BuildContext for navigation
   */
  Future<void> logout(BuildContext context) async {
    await _storage.deleteAll();
    currentUser.value = null;
    context.go('/auth/login');
  }

  /**
   * Stores authentication data in secure storage.
   * @param authResponse AuthResponse containing tokens and user data
   * @throws Exception if storage operation fails
   */
  Future<void> _storeAuthData(AuthResponse authResponse) async {
    try {
      await _storage.write(
        key: 'access_token',
        value: authResponse.accessToken,
      );
      await _storage.write(
        key: 'refresh_token',
        value: authResponse.refreshToken,
      );
      if (authResponse.user != null) {
        await _storage.write(
          key: 'user_data',
          value: json.encode(authResponse.user!.toJson()),
        );
        currentUser.value = authResponse.user;
      } else {
        print('Warning: authResponse.user is null');
        currentUser.value = null;
      }
    } catch (e) {
      print('Error storing auth data: $e');
      throw Exception('Failed to store auth data: $e');
    }
  }
}
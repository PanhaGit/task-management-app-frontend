import 'package:get/get.dart';
import 'package:frontend_app_task/models/auth/sign_up.dart';
import '../../services/api/api_connect_backend.dart';

class AuthControllers extends GetxController {
  final ApiConnectBackend _apiConnectBackend = ApiConnectBackend();

  var isLoading = false.obs;
  var message = ''.obs;

  final String endpointAuth = "/auth";

  /// Method: Sign up Account
  Future<void> signupAccount(SignUp signupData) async {
    isLoading.value = true;

    try {
      final response = await _apiConnectBackend.fetchData(
        method: "POST",
        endpoint: "$endpointAuth/signup",
        data: signupData.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        message.value = "Signup successful!";
      } else {
        message.value = "Signup failed: ${response.data['message'] ?? 'Unknown error'}";
      }
    } catch (error) {
      message.value = 'Signup error: $error';
    } finally {
      isLoading.value = false;
    }
  }
}

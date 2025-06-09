import 'package:flutter/material.dart';
import 'package:frontend_app_task/models/Categories.dart';
import 'package:frontend_app_task/models/CategoryColor.dart';
import 'package:frontend_app_task/services/api/api_service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxBool isLoadingCategories = false.obs;
  final RxList<Categories> categories = <Categories>[].obs;
  final RxList<CategoryColor> categoryColor = <CategoryColor>[].obs;
  final RxString selectedColorHex = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAllColor(); // Fetch colors on initialization
  }

  Future<void> storeCategory(Map<String, dynamic> payload) async {
    try {
      isLoadingCategories.value = true;
      final response = await _apiService.fetchData<Map<String, dynamic>>(
        method: "POST",
        endpoint: "/category",
        data: payload,
      );
      if (response.data != null &&
          (response.data?['success'] == true || response.statusCode == 201)) {
        final newCategory = Categories.fromJson(response.data!['data'] ?? response.data!);
        categories.add(newCategory);
        // Get.snackbar('Success', 'Category added successfully', backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        // Get.snackbar('Error', 'Failed to add category: ${response.data?['message'] ?? 'Unknown error'}',
        //     backgroundColor: Colors.red, colorText: Colors.white);
      }
    } on ApiException catch (e) {
      // Get.snackbar('Error', 'Failed to add category: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } catch (err) {
      // Get.snackbar('Error', 'Unexpected error: $err', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> getAllColor() async {
    isLoadingCategories.value = true;
    try {
      final response = await _apiService.fetchData(
        endpoint: "/category/get_color",
      );
      if (response.data != null &&
          response.data!["success"] == true &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final List<dynamic> jsonCategoriesColor = response.data!['data'];
        categoryColor.value = jsonCategoriesColor
            .map((jsonItem) => CategoryColor.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
        if (categoryColor.isNotEmpty) {
          selectedColorHex.value = categoryColor[0].hex;
        } else {
          categoryColor.value = CategoryColor.fallbackColors;
          selectedColorHex.value = categoryColor[0].hex;
          // Get.snackbar('Warning', 'No colors from backend, using default colors',
          //     backgroundColor: Colors.orange, colorText: Colors.white);
        }
      } else {
        categoryColor.value = CategoryColor.fallbackColors;
        selectedColorHex.value = categoryColor[0].hex;
        // Get.snackbar('Error', 'Failed to fetch colors: ${response.data?['message'] ?? 'Unknown error'}',
        //     backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (error) {
      categoryColor.value = CategoryColor.fallbackColors;
      selectedColorHex.value = categoryColor[0].hex;
      // Get.snackbar('Error', 'Failed to fetch colors: $error, using default colors',
      //     backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingCategories.value = false;
    }
  }

  void changeSelectedColor(String hex) {
    selectedColorHex.value = hex;
  }
}
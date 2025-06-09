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
      }
    } on ApiException catch (e) {
      print(e);
    } catch (err) {
      print(err);
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
        }
      } else {
        categoryColor.value = CategoryColor.fallbackColors;
        selectedColorHex.value = categoryColor[0].hex;
      }
    } catch (error) {
      categoryColor.value = CategoryColor.fallbackColors;
      selectedColorHex.value = categoryColor[0].hex;

    } finally {
      isLoadingCategories.value = false;
    }
  }

  void changeSelectedColor(String hex) {
    selectedColorHex.value = hex;
  }
}
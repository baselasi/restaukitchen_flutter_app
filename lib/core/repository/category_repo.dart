import 'dart:convert';

import 'package:restaukitchen_app/core/models/category.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class CategoryRepo {
  Future<CategoriesResponse> getCategories() async {
    try {
      final response = await getIt<ApiService>().getPrivate('/api/categories');
      if (response.statusCode == 200) {
        return CategoriesResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> createCategory(CreateCategoryRequest payload) async {
    try {
      await getIt<ApiService>().postPrivate(
        '/api/create-category',
        payload.toJson(),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateCategory(CreateCategoryRequest payload) async {
    try {
      await getIt<ApiService>().putPrivate(
        '/api/category/${payload.id}',
        payload.toJson(),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await getIt<ApiService>().deletePrivate('/api/category/$id');
    } catch (e) {
      throw Exception(e);
    }
  }
}

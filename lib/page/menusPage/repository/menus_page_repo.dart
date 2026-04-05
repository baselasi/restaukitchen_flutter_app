import 'dart:convert';
import 'dart:io';

import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/menusPage/models/image.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

class MenusPageRepo {
  Future<MenuResponse> getMenus(String restaurantId) async {
    try {
      final ApiService apiService = getIt<ApiService>();
      final response = await apiService.getPrivate(
        '/api/menu/restaurant/$restaurantId?combination=false',
      );
      return MenuResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteDish(String dishId) async {
    try {
      final ApiService apiService = getIt<ApiService>();
      final response = await apiService.deletePrivate('/api/dish/$dishId');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete dish');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ImageResponse> uploadDishImage(String dishId, File image) async {
    try {
      final ApiService apiService = getIt<ApiService>();
      final response = await apiService.postFilePrivate(
        '/api/dish-image',
        image,
        fields: {'id': dishId},
      );

      if (!apiService.isSuccess(response)) {
        throw Exception('Failed to upload dish image: ${response.statusCode}');
      }
      return ImageResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Error uploading dish image: $e');
    }
  }

  Future<ImageResponse> updateDishImage(String dishId, File image) async {
    try {
      final ApiService apiService = getIt<ApiService>();
      final response = await apiService.patchFilePrivate(
        '/api/dish-image',
        image,
        fields: {'id': dishId},
      );

      if (!apiService.isSuccess(response)) {
        throw Exception('Failed to upload dish image: ${response.statusCode}');
      }
      return ImageResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Error uploading dish image: $e');
    }
  }

  Future<void> deleteMenu(String menuId) async {
    try {
      final ApiService apiService = getIt<ApiService>();
      final response = await apiService.deletePrivate('/api/menu/$menuId');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete menu');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/menusPage/models/image.dart';
import 'package:restaukitchen_app/page/settings_page/models/restaurant.dart';

class RestaurantRepo {
  final ApiService _apiService = getIt<ApiService>();
  Future<RestaurantResponse> getRestaurant(String restaurantId) async {
    try {
      final response = await _apiService.getPrivate(
        '/api/public/restaurant/$restaurantId',
      );
      return RestaurantResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ImageResponse> uploadRestaurantImage(
    String restaurantId,
    File image,
    File logo,
  ) async {
    try {
      final ApiService apiService = getIt<ApiService>();
      final response = await apiService.uploadRestaurantImage(
        '/api/dish-image',
        image,
        logo,
        fields: {'id': restaurantId},
      );

      if (!apiService.isSuccess(response)) {
        throw Exception('Failed to upload dish image: ${response.statusCode}');
      }
      return ImageResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Error uploading dish image: $e');
    }
  }
}

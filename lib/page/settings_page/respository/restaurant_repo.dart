import 'dart:convert';

import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
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
}

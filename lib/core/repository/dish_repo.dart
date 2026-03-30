import 'dart:convert';

import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class DishRepo {
  Future<Dish> getDish(String dishId) async {
    try {
      final response = await getIt<ApiService>().getPrivate(
        '/api/dish/$dishId',
      );
      if (response.statusCode == 200) {
        return Dish.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get dish');
      }
    } catch (e) {
      throw Exception('Failed to get dish: $e');
    }
  }
}

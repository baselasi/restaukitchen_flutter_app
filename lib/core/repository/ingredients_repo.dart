import 'dart:convert';

import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class IngredientsRepo {
  Future<List<Ingredient>> getIngredientsByRestaurantId(
    String restaurantId,
  ) async {
    try {
      final response = await getIt<ApiService>().getPrivate(
        '/api/public/ingredients/$restaurantId',
      );
      if (response.statusCode == 200) {
        return List<Ingredient>.from(
          jsonDecode(response.body).map((x) => Ingredient.fromJson(x)),
        );
      } else {
        throw Exception('Failed to get ingredients');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addIngredientsToMenu(
    String menuId,
    List<String> ingredients,
  ) async {
    try {
      await getIt<ApiService>().postRawPayload(
        '/api/create-ingredients/$menuId',
        jsonEncode(ingredients),
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}

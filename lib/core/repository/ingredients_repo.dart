import 'dart:convert';

import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/ingredients_list/model/ingredient_post_request.dart';

class IngredientsRepo {
  Future<IngredientResponse> getIngredientsByRestaurantId(
    String restaurantId,
  ) async {
    try {
      final response = await getIt<ApiService>().getPrivate(
        '/api/public/ingredients/$restaurantId',
      );
      if (response.statusCode == 200) {
        return IngredientResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get ingredients');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<IngredientResponse> addIngredientsToMenu(
    String menuId,
    List<String> ingredients,
  ) async {
    try {
      final response = await getIt<ApiService>().postRawPayload(
        '/api/create-ingredients/$menuId',
        jsonEncode(ingredients),
      );
      return IngredientResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<IngredientResponse> postIngredient(
    List<IngredientPostRequest> payload,
  ) async {
    try {
      final response = await getIt<ApiService>().postPrivate(
        '/api/create-ingredients',
        payload.map((e) => e.toJson()).toList(),
      );
      return IngredientResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UpdateIngredientResponse> updateIngredient(
    List<IngredientPostRequest> payload,
    String ingredientId,
  ) async {
    try {
      final response = await getIt<ApiService>().putPrivate(
        '/api/update-ingredient/$ingredientId',
        payload.map((e) => e.toJson()).toList().first,
      );
      return UpdateIngredientResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteIngredient(String ingredientId) async {
    try {
      await getIt<ApiService>().deletePrivate(
        '/api/remove-ingredient/$ingredientId',
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}

import 'dart:convert';

import 'package:restaukitchen_app/core/models/base_post_response.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/combination_form/models/add_dishes_to_combiantions_request.dart';
import 'package:restaukitchen_app/page/combination_form/models/create_combination_request.dart';
import 'package:restaukitchen_app/page/combination_form/models/create_combination_response.dart';
import 'package:restaukitchen_app/page/combination_form/models/create_menu_combination_request.dart';

class CombinationFormRepo {
  final ApiService _apiService = getIt<ApiService>();
  Future<CreateCombinationResponse> createCombination(
    CreateCombinationRequest payload,
  ) async {
    try {
      final response = await _apiService.postPrivate(
        '/api/create-combination',
        payload.toJson(),
      );
      return CreateCombinationResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateCombinationResponse> updateCombination(
    CreateCombinationRequest payload,
    String combinationId,
  ) async {
    try {
      final response = await _apiService.postPrivate(
        '/api/update-combination/$combinationId',
        payload.toJson(),
      );
      return CreateCombinationResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  Future<BasePostResponse> createMenuCombination(
    CreateMenuCombinationRequest payload,
  ) async {
    try {
      final response = await _apiService.postPrivate(
        '/api/create-menu-combination',
        payload.toJson(),
      );
      return BasePostResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  Future<DishResponse> addDishesToMenu(
    AddDishesToCombiantionsRequest payload,
  ) async {
    try {
      final response = await _apiService.postPrivate(
        '/api/create-dish-combination',
        payload.toJson(),
      );
      return DishResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:convert';

import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/combination_list/models/combination_list_item.dart';

class CombinationListRepo {
  final ApiService _apiService = getIt<ApiService>();
  Future<CombinationListItemResponse> getCombinations(
    String restaurantId,
  ) async {
    final response = await _apiService.getPublic(
      '/api/public/combinations/$restaurantId',
    );
    return CombinationListItemResponse.fromJson(jsonDecode(response.body));
  }
}

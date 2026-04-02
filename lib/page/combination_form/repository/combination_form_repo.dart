import 'dart:convert';

import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/combination_form/models/create_combination_request.dart';
import 'package:restaukitchen_app/page/combination_form/models/create_combination_response.dart';

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
}

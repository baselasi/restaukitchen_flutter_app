import 'dart:convert';

import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/combination_page/models/combination.dart';

class CombinationPageRepo {
  Future<CombinationResponse> getCombinations(String restaurantId) async {
    try {
      final response = await getIt<ApiService>().getPublic(
        '/api/public/combinations/$restaurantId',
      );
      return CombinationResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }
}

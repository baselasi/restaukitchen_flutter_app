import 'dart:convert';

import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class DimensionsRepo {
  final ApiService _apiService = getIt<ApiService>();
  Future<DimensionResponse> getDimensions() async {
    try {
      final response = await _apiService.getPrivate('/api/dimensions');
      return DimensionResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}

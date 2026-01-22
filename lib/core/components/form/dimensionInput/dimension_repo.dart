import 'dart:convert';

import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';

class DimensionRepo {
  Future<DimensionResponse> getDimensions() async {
    try {
      final response = await ApiService().getPrivate('/api/dimensions');
      return DimensionResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:convert';

import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/silverware_list/models/silverware_response.dart';

class SilverwareRepo {
  final ApiService _apiService = getIt<ApiService>();
  Future<SilverwareResponse> getSilverware() async {
    try {
      final response = await _apiService.getPrivate('/api/menu-silverware');
      return SilverwareResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}

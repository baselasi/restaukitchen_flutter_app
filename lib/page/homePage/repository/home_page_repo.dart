import 'dart:convert';

import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class HomePageRepo {
  final ApiService _apiService = getIt<ApiService>();

  Future<Map<String,dynamic>> getTablesCount() async {
    try {
      final response = await _apiService.getPublic("/api/order/count");
      return jsonDecode(response.body);
    } catch (e) {
      rethrow;
    }
  }


  Future<int> getOrdersCount() async {
    try {
      final response = await _apiService.getPublic("/api/order/count");
      return jsonDecode(response.body);
    } catch (e) {
      rethrow;
    }
  }
}

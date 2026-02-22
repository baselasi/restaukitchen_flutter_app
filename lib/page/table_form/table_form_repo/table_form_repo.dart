import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class TableFormRepo {
  final ApiService _apiService = getIt<ApiService>();

  Future<void> createTable(Map<String, dynamic> payload) async {
    try {
      await _apiService.postPrivate('/api/dinner-table', payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTable(Map<String, dynamic> payload) async {
    try {
      await _apiService.putPrivate('/api/dinner-table', payload);
    } catch (e) {
      rethrow;
    }
  }
}

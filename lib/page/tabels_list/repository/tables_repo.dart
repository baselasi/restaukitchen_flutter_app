import 'dart:convert';
import 'dart:typed_data';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/tabels_list/models/tabel.dart';

class TablesRepo {
  final ApiService _apiService = getIt<ApiService>();
  Future<TabelResponse> getTables() async {
    try {
      final response = await _apiService.getPrivate('/api/dinner-table');
      return TabelResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteTabel(String tabelId) async {
    try {
      await _apiService.deletePrivate('/api/dinner-table/$tabelId');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Uint8List> getTabelQrCode(String tabelId) async {
    try {
      final response = await _apiService.getPrivate('/api/qr-code/$tabelId');
      return response.bodyBytes;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Tabel> getTableByTableNumber(int tableNumber) async {
    try {
      final response = await _apiService.getPrivate(
        '/api/dinner-table/$tableNumber',
      );
      return Tabel.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }
}

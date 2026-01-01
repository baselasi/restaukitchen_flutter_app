import 'dart:convert';

import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

class MenusPageRepo {
  Future<MenuResponse> getMenus(String restaurantId) async {
    try {
      final ApiService apiService = getIt<ApiService>();
      final response = await apiService.getPrivate('/api/menu/restaurant/$restaurantId?combination=false');
      return MenuResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }
}

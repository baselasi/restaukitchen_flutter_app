import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class DishFormRepo {
  Future<void> createDish(Map<String, Object> payload) async {
    ApiService apiService = getIt<ApiService>();
    try {
      await apiService.postPrivate('/api/create-dish', payload);
    } catch (e) {
      rethrow;
    }
  }
}

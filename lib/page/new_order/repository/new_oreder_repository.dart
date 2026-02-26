import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class NewOrderRepository {
  final ApiService _apiService;
  NewOrderRepository() : _apiService = getIt<ApiService>();
  Future<void> createOrder(Map<String, dynamic> payload) async {
    // await Future.delayed(const Duration(seconds: 2));

    try {
      await _apiService.postPrivate('/api/create-order', payload);
    } catch (e) {
      rethrow;
    }
  }
}

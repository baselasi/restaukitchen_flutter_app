import 'package:restaukitchen_app/core/services/api_service.dart';

class NewOrderRepository {
  final ApiService _apiService;
  NewOrderRepository({required ApiService apiService})
    : _apiService = apiService;
  Future<void> createOrder(Map<String, dynamic> payload) async {
    // await Future.delayed(const Duration(seconds: 2));

    try {
      await _apiService.postPrivate('/api/create-order', payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrder(String orderId, Map<String, dynamic> payload) async {
    try {
      await _apiService.putPrivate('/api/order/$orderId', payload);
    } catch (e) {
      rethrow;
    }
  }
}

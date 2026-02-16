import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/order_list/repository/orders_list_repo.dart';

class OrderActionsCubit extends Cubit<OrderActionsState> {
  final OrdersListRepo _ordersListRepo;
  OrderActionsCubit({required OrdersListRepo ordersListRepo})
    : _ordersListRepo = ordersListRepo,
      super(OrderActionsState.initial());

  Future<void> deleteOrder(String orderId) async {
    emit(OrderActionsState.loading());
    try {
      await _ordersListRepo.deleteOrder(orderId);
      emit(OrderActionsState.success());
    } catch (e) {
      emit(OrderActionsState.error(e.toString()));
    }
  }

  Future<void> archiveOrder(String orderId) async {
    emit(OrderActionsState.loading());
    try {
      // await _ordersListRepo.archiveOrder(orderId);
      await Future.delayed(const Duration(seconds: 1));
      emit(OrderActionsState.success());
    } catch (e) {
      emit(OrderActionsState.error(e.toString()));
    }
  }
}

enum OrderActionsStatus { initial, loading, success, error }

class OrderActionsState extends Equatable {
  final OrderActionsStatus status;
  final String? errorMessage;

  const OrderActionsState({required this.status, this.errorMessage});

  factory OrderActionsState.initial() {
    return const OrderActionsState(status: OrderActionsStatus.initial);
  }

  factory OrderActionsState.loading() {
    return const OrderActionsState(status: OrderActionsStatus.loading);
  }

  factory OrderActionsState.success() {
    return const OrderActionsState(status: OrderActionsStatus.success);
  }

  factory OrderActionsState.error(String errorMessage) {
    return OrderActionsState(
      status: OrderActionsStatus.error,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/new_order/repository/new_order_repository.dart';
import 'package:restaukitchen_app/page/order_list/models/order.dart';
import 'package:restaukitchen_app/page/order_list/repository/orders_list_repo.dart';

class NewOrderCubit extends Cubit<NewOrderState> {
  final NewOrderRepository _newOrderRepo;
  final OrdersListRepo _ordersListRepo;
  NewOrderCubit({
    required NewOrderRepository newOrderRepo,
    required OrdersListRepo ordersListRepo,
  }) : _newOrderRepo = newOrderRepo,
       _ordersListRepo = ordersListRepo,
       super(NewOrderState.initial());

  Future<void> createOrder({
    required NewOrderFormState newOrderFormState,
  }) async {
    emit(NewOrderState.loading(newOrderFormState));
    try {
      // await Future.delayed(const Duration(seconds: 2));
      await _newOrderRepo.createOrder(newOrderFormState.toJson());
      emit(NewOrderState.postSuccess());
    } catch (e) {
      emit(NewOrderState.error(e.toString(), newOrderFormState));
    }
  }

  Future<void> updateOrder({
    required String orderId,
    required NewOrderFormState newOrderFormState,
  }) async {
    emit(NewOrderState.loading(newOrderFormState));
    try {
      await _newOrderRepo.updateOrder(
        orderId,
        newOrderFormState.toJson(id: orderId),
      );
      emit(NewOrderState.postSuccess());
    } catch (e) {
      emit(NewOrderState.error(e.toString(), newOrderFormState));
    }
  }

  Future<void> getOrder({
    required String orderId,
    required String dinnerTableNumber,
    required NewOrderFormState newOrderFormState,
  }) async {
    try {
      emit(NewOrderState.loading(newOrderFormState));
      final order = await _ordersListRepo.getOrderByDinnerTableNumber(
        dinnerTableNumber,
      );
      emit(NewOrderState.getSuccess(order.orders.first));
    } catch (e) {
      emit(NewOrderState.error(e.toString(), newOrderFormState));
    }
  }
}

enum NewOrderStatus { initial, loading, error, success, getSuccess }

class NewOrderState extends Equatable {
  final NewOrderStatus status;
  final String? errorMessage;
  final NewOrderFormState? newOrderFormState;
  final Order? order;
  const NewOrderState({
    required this.status,
    this.errorMessage,
    required this.newOrderFormState,
    this.order,
  });

  factory NewOrderState.initial() {
    return NewOrderState(
      status: NewOrderStatus.initial,
      newOrderFormState: null,
    );
  }

  factory NewOrderState.loading(NewOrderFormState newOrderFormState) {
    return NewOrderState(
      status: NewOrderStatus.loading,
      newOrderFormState: newOrderFormState,
    );
  }

  factory NewOrderState.error(
    String errorMessage,
    NewOrderFormState newOrderFormState,
  ) {
    return NewOrderState(
      status: NewOrderStatus.error,
      errorMessage: errorMessage,
      newOrderFormState: newOrderFormState,
    );
  }

  factory NewOrderState.getSuccess(Order order) {
    return NewOrderState(
      status: NewOrderStatus.getSuccess,
      newOrderFormState: null,
      order: order,
    );
  }

  factory NewOrderState.postSuccess() {
    return NewOrderState(
      status: NewOrderStatus.success,
      newOrderFormState: null,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, newOrderFormState, order];
}

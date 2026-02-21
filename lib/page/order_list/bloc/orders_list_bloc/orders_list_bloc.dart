import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_list_bloc/orders_list_events.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_list_bloc/orders_list_state.dart';
import 'package:restaukitchen_app/page/order_list/models/order.dart';
import 'package:restaukitchen_app/page/order_list/repository/orders_list_repo.dart';

class OrdersListBloc extends Bloc<OrdersListEvent, OrdersListState> {
  final OrdersListRepo _repo;
  StreamSubscription<Order>? _ordersSubscription;
  final String? categoryName;

  OrdersListBloc({required OrdersListRepo repo, this.categoryName})
    : _repo = repo,
      super(OrdersListInitial()) {
    on<OrdersListSubscribe>(_onSubscribe);
    on<OrdersListUpdated>(_onUpdated);
    on<OrdersListStreamError>(_onStreamError);
    on<OrdersListGetOrders>(_onGetOrders);
    on<OrdersListRemoveOrder>(_onRemoveOrder);
  }

  void _onSubscribe(OrdersListSubscribe event, Emitter<OrdersListState> emit) {
    emit(OrdersListLoading());

    // Cancel any previous subscription before starting a new one.
    _ordersSubscription?.cancel();

    _ordersSubscription = _repo
        .getOrdersStream(categoryName)
        .listen(
          (order) => add(OrdersListUpdated(orders: [order])),
          onError: (error) =>
              add(OrdersListStreamError(message: error.toString())),
        );
  }

  void _onUpdated(OrdersListUpdated event, Emitter<OrdersListState> emit) {
    if (state is OrdersListLoaded) {
      emit(
        OrdersListLoaded(
          orders: [
            ...event.orders,
            ...(state as OrdersListLoaded).orders.where(
              (order) => order.id != event.orders.first.id,
            ),
          ],
        ),
      );
    } else {
      emit(OrdersListLoaded(orders: event.orders));
    }
  }

  void _onStreamError(
    OrdersListStreamError event,
    Emitter<OrdersListState> emit,
  ) {
    emit(OrdersListError(errorMessage: event.message));
  }

  @override
  Future<void> close() {
    _ordersSubscription?.cancel();
    _repo.close();
    return super.close();
  }

  void _onGetOrders(
    OrdersListGetOrders event,
    Emitter<OrdersListState> emit,
  ) async {
    try {
      emit(OrdersListLoading());
      final OrderResponse orders = await _repo.getOrders(categoryName);
      add(OrdersListUpdated(orders: orders.orders));
    } catch (e) {
      emit(OrdersListError(errorMessage: e.toString()));
    }
  }

  void _onRemoveOrder(
    OrdersListRemoveOrder event,
    Emitter<OrdersListState> emit,
  ) async {
    try {
      if (state is OrdersListLoaded) {
        final orders = [...(state as OrdersListLoaded).orders];
        final newOrders = orders
            .where((order) => order.id != event.orderId)
            .toList();
        emit(OrdersListLoaded(orders: newOrders));
      }
    } catch (e) {
      emit(OrdersListError(errorMessage: e.toString()));
    }
  }
}

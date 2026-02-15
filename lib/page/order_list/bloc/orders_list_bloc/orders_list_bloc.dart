import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_list_bloc/orders_list_events.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_list_bloc/orders_list_state.dart';
import 'package:restaukitchen_app/page/order_list/models/order.dart';
import 'package:restaukitchen_app/page/order_list/repository/orders_list_repo.dart';

class OrdersListBloc extends Bloc<OrdersListEvent, OrdersListState> {
  final OrdersListRepo _repo;
  StreamSubscription<List<Order>>? _ordersSubscription;

  OrdersListBloc({required OrdersListRepo repo})
      : _repo = repo,
        super(OrdersListInitial()) {
    on<OrdersListSubscribe>(_onSubscribe);
    on<OrdersListUpdated>(_onUpdated);
    on<OrdersListStreamError>(_onStreamError);
  }

  void _onSubscribe(
    OrdersListSubscribe event,
    Emitter<OrdersListState> emit,
  ) {
    emit(OrdersListLoading());

    // Cancel any previous subscription before starting a new one.
    _ordersSubscription?.cancel();

    _ordersSubscription = _repo.getOrdersStream().listen(
      (orders) => add(OrdersListUpdated(orders: orders)),
      onError: (error) => add(
        OrdersListStreamError(message: error.toString()),
      ),
    );
  }

  void _onUpdated(
    OrdersListUpdated event,
    Emitter<OrdersListState> emit,
  ) {
    emit(OrdersListLoaded(orders: event.orders));
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

  // void _onGetOrders(
  //   OrdersListGetOrders event,
  //   Emitter<OrdersListState> emit,
  // ) {
  //   // emit(OrdersListLoaded(orders: orders));
  // }


}

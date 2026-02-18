import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/order_list/models/order.dart';

abstract class OrdersListEvent extends Equatable {
  const OrdersListEvent();

  @override
  List<Object> get props => [];
}

/// Triggers the SSE connection.
class OrdersListSubscribe extends OrdersListEvent {}

class OrdersListGetOrders extends OrdersListEvent {}

/// Internal event — fired each time the SSE stream emits new data.
class OrdersListUpdated extends OrdersListEvent {
  final List<Order> orders;
  const OrdersListUpdated({required this.orders});

  @override
  List<Object> get props => [orders];
}

/// Internal event — fired when the SSE stream emits an error.
class OrdersListStreamError extends OrdersListEvent {
  final String message;
  const OrdersListStreamError({required this.message});

  @override
  List<Object> get props => [message];
}

class OrdersListRemoveOrder extends OrdersListEvent {
  final String orderId;
  const OrdersListRemoveOrder({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

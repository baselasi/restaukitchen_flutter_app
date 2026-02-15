import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/order_list/models/order.dart';

abstract class OrdersListState extends Equatable {
  const OrdersListState();

  @override
  List<Object> get props => [];
}

class OrdersListInitial extends OrdersListState {}

class OrdersListLoading extends OrdersListState {}

class OrdersListLoaded extends OrdersListState {
  final List<Order> orders;
  const OrdersListLoaded({required this.orders});
  @override
  List<Object> get props => [orders];
}

class OrdersListError extends OrdersListState {
  final String errorMessage;
  const OrdersListError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

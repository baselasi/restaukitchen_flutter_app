import 'package:equatable/equatable.dart';

abstract class OrdersListState extends Equatable {
  const OrdersListState();

  @override
  List<Object> get props => [];
}

class OrdersListInitial extends OrdersListState {}

class OrdersListLoading extends OrdersListState {}

class OrdersListLoaded extends OrdersListState {}

class OrdersListError extends OrdersListState {}



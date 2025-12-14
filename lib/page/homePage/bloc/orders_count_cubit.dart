import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersCountCubit extends Cubit<OrdersCountState> {
  OrdersCountCubit()
    : super(OrdersCountState(status: OrdersCountStatus.initial));

  Future<void> getOrdersCount() async {
    try {
      emit(OrdersCountState(status: OrdersCountStatus.loading));
      Future.delayed(Duration(seconds: 2));
      emit(OrdersCountState(status: OrdersCountStatus.loaded, ordersCount: 10));
    } catch (e) {
      emit(OrdersCountState(status: OrdersCountStatus.error));
    }
  }
}

enum OrdersCountStatus { initial, loading, loaded, error }

class OrdersCountState extends Equatable {
  final OrdersCountStatus status;
  final int? ordersCount;

  const OrdersCountState({required this.status, this.ordersCount});

  @override
  List<Object?> get props => [ordersCount, status];
}

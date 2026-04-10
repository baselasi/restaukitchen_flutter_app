import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/homePage/repository/home_page_repo.dart';

class OrdersCountCubit extends Cubit<OrdersCountState> {
  OrdersCountCubit()
    : super(OrdersCountState(status: OrdersCountStatus.initial));

  Future<void> getOrdersCount() async {
    try {
      emit(OrdersCountState(status: OrdersCountStatus.loading));
      final ordersCount = await HomePageRepo().getOrdersCount();
      if (!isClosed) {
        emit(
          OrdersCountState(
            status: OrdersCountStatus.loaded,
            ordersCount: ordersCount,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) emit(OrdersCountState(status: OrdersCountStatus.error));
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

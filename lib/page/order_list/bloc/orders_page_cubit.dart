import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum OrderSubPage { kitchen, archive }

class OrdersPageCubit extends Cubit<OrdersPageState> {
  OrdersPageCubit() : super(const OrdersPageState(page: OrderSubPage.kitchen));

  void setPage(OrderSubPage page) {
    emit(OrdersPageState(page: page));
  }
}

class OrdersPageState extends Equatable {
  final OrderSubPage page;
  const OrdersPageState({required this.page});

  @override
  List<Object?> get props => [page];
}

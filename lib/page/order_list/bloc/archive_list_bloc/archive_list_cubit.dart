import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/order_list/models/order.dart';
import 'package:restaukitchen_app/page/order_list/repository/orders_list_repo.dart';

class ArchiveListCubit extends Cubit<ArchiveListState> {
  final OrdersListRepo _repo;
  ArchiveListCubit({required OrdersListRepo repo})
    : _repo = repo,
      super(ArchiveListState.initial());

  Future<void> getArchiveList(DateTime date) async {
    emit(ArchiveListState.loading());
    try {
      final orders = await _repo.getArchivedOrders(date);
      emit(ArchiveListState.loaded(orders.orders));
    } catch (e) {
      emit(ArchiveListState.error(e.toString()));
    }
  }
}

enum ArchiveListStatus { initial, loading, loaded, error }

class ArchiveListState extends Equatable {
  final List<Order> orders;
  final ArchiveListStatus status;
  final String? errorMessage;
  const ArchiveListState({
    required this.orders,
    required this.status,
    this.errorMessage,
  });

  factory ArchiveListState.initial() {
    return const ArchiveListState(
      orders: [],
      status: ArchiveListStatus.initial,
    );
  }

  factory ArchiveListState.loading() {
    return const ArchiveListState(
      orders: [],
      status: ArchiveListStatus.loading,
    );
  }

  factory ArchiveListState.loaded(List<Order> orders) {
    return ArchiveListState(orders: orders, status: ArchiveListStatus.loaded);
  }

  factory ArchiveListState.error(String error) {
    return ArchiveListState(
      orders: [],
      status: ArchiveListStatus.error,
      errorMessage: error,
    );
  }

  @override
  List<Object?> get props => [orders, status, errorMessage];
}

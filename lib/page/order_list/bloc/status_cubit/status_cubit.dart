import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/order_list/models/order.dart';
import 'package:restaukitchen_app/page/order_list/repository/orders_list_repo.dart';

class StatusCubit extends Cubit<StatusState> {
  final OrdersListRepo _ordersListRepo;
  StatusCubit({required OrdersListRepo ordersListRepo})
    : _ordersListRepo = ordersListRepo,
      super(StatusState.initial());

  void updateStatus(CourseStatus newStatus, Order order) async {
    emit(StatusState.loading());
    try {
      //  final response = await _ordersListRepo.updateStatus(newStatus);
      // final response = await ApiService().updateStatus(newStatus);
      final updatedOrder = order.copyWith(courseStatus: newStatus);
      await _ordersListRepo.updateOrder(order.id!, updatedOrder.toJson());
      emit(StatusState.success(updatedOrder));
    } catch (e) {
      emit(StatusState.error(e.toString()));
    }
  }
}

enum StatusCubitStatus { initial, loading, error, success }

class StatusState extends Equatable {
  final StatusCubitStatus status;
  final CourseStatus? newStatus;
  final Order? updatedOrder;
  final String? errorMessage;

  const StatusState({
    required this.status,
    this.newStatus,
    this.updatedOrder,
    this.errorMessage,
  });

  factory StatusState.initial() {
    return const StatusState(status: StatusCubitStatus.initial);
  }

  factory StatusState.loading() {
    return const StatusState(status: StatusCubitStatus.loading);
  }

  factory StatusState.error(String message) {
    return const StatusState(status: StatusCubitStatus.error);
  }

  factory StatusState.success(Order updatedOrder) {
    return StatusState(
      status: StatusCubitStatus.success,
      updatedOrder: updatedOrder,
    );
  }

  @override
  List<Object?> get props => [status, newStatus, errorMessage];
}

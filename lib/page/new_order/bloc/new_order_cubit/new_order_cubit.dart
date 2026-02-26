import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';

class NewOrderCubit extends Cubit<NewOrderState> {
  NewOrderCubit() : super(NewOrderState.initial());

  Future<void> createOrder(NewOrderFormState newOrderFormState) async {
    emit(NewOrderState.loading(newOrderFormState));
    try {
      // await Future.delayed(const Duration(seconds: 2));
      // await _newOrderRepo.createOrder(newOrderFormState);
      emit(NewOrderState.success());
    } catch (e) {
      emit(NewOrderState.error(e.toString(), newOrderFormState));
    }
  }
}

enum NewOrderStatus { initial, loading, error, success }

class NewOrderState extends Equatable {
  final NewOrderStatus status;
  final String? errorMessage;
  final NewOrderFormState? newOrderFormState;
  const NewOrderState({
    required this.status,
    this.errorMessage,
    required this.newOrderFormState,
  });

  factory NewOrderState.initial() {
    return NewOrderState(
      status: NewOrderStatus.initial,
      newOrderFormState: null,
    );
  }

  factory NewOrderState.loading(NewOrderFormState newOrderFormState) {
    return NewOrderState(
      status: NewOrderStatus.loading,
      newOrderFormState: newOrderFormState,
    );
  }

  factory NewOrderState.error(
    String errorMessage,
    NewOrderFormState newOrderFormState,
  ) {
    return NewOrderState(
      status: NewOrderStatus.error,
      errorMessage: errorMessage,
      newOrderFormState: newOrderFormState,
    );
  }

  factory NewOrderState.success() {
    return NewOrderState(
      status: NewOrderStatus.success,
      newOrderFormState: null,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, newOrderFormState];
}

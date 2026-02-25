import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_from_events.dart';

class NewOrderFormBloc extends Bloc<NewOrderFormEvent, NewOrderFormState> {
  NewOrderFormBloc()
    : super(
        NewOrderFormState(
          courses: [],
          tableNumber: 0,
          totalCovers: 0,
          total: 0,
          orderTime: DateTime.now(),
        ),
      );
}

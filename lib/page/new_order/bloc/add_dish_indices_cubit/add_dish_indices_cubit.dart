import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

class AddDishIndicesCubit extends Cubit<AddDishIndicesState> {
  AddDishIndicesCubit() : super(AddDishIndicesState());
}

class AddDishIndicesState extends Equatable {
  final CourseIndice? dishIndices;
  const AddDishIndicesState({this.dishIndices});
  @override
  List<Object?> get props => [dishIndices];
}

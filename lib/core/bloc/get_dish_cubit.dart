import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/repository/dish_repo.dart';

class GetDishCubit extends Cubit<GetDishState> {
  GetDishCubit() : super(GetDishState(status: GetDishStatus.initial));

  Future<void> getDish(String dishId) async {
    emit(GetDishState.loading());
    try {
      final dish = await DishRepo().getDish(dishId);
      emit(GetDishState.loaded(dish));
    } catch (e) {
      emit(GetDishState.error(e.toString()));
    }
  }

  Future<void> setDish(Dish dish) async {
    emit(GetDishState.loaded(dish));
  }
  

  @override
  Future<void> close() {
    emit(GetDishState.initial());
    return super.close();
  }

}

enum GetDishStatus { initial, loading, loaded, error }

class GetDishState extends Equatable {
  final Dish? dish;
  final GetDishStatus status;
  final String? errorMessage;
  const GetDishState({this.dish, required this.status, this.errorMessage});
  factory GetDishState.initial() {
    return const GetDishState(
      dish: null,
      status: GetDishStatus.initial,
      errorMessage: null,
    );
  }
  factory GetDishState.loading() {
    return const GetDishState(
      dish: null,
      status: GetDishStatus.loading,
      errorMessage: null,
    );
  }
  factory GetDishState.loaded(Dish dish) {
    return GetDishState(
      dish: dish,
      status: GetDishStatus.loaded,
      errorMessage: null,
    );
  }
  factory GetDishState.error(String error) {
    return GetDishState(
      dish: null,
      status: GetDishStatus.error,
      errorMessage: error,
    );
  }
  @override
  List<Object?> get props => [dish, status];
}

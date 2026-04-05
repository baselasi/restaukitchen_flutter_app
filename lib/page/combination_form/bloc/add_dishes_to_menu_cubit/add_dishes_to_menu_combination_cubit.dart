import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/page/combination_form/models/add_dishes_to_combiantions_request.dart';
import 'package:restaukitchen_app/page/combination_form/repository/combination_form_repo.dart';

class AddDishesToMenuCombinationCubit
    extends Cubit<AddDishesToMenuCombinationState> {
  final CombinationFormRepo _combinationFormRepo;
  AddDishesToMenuCombinationCubit({
    required CombinationFormRepo combinationFormRepo,
  }) : _combinationFormRepo = combinationFormRepo,
       super(AddDishesToMenuCombinationState.initial());

  Future<void> addDishesToMenu(String menuId, List<Dish> dishes) async {
    emit(AddDishesToMenuCombinationState.loading());
    try {
      final response = await _combinationFormRepo.addDishesToMenu(
        AddDishesToCombiantionsRequest(
          menuId: menuId,
          dishIds: dishes.map((e) => e.id!).toList(),
        ),
      );
      if (!isClosed) {
        emit(AddDishesToMenuCombinationState.success(response.dishes));
      }
    } catch (e) {
      if (!isClosed) {
        emit(AddDishesToMenuCombinationState.error(e.toString()));
      }
    }
  }
}

enum AddDishesToMenuCombinationStatus { initial, loading, success, error }

class AddDishesToMenuCombinationState extends Equatable {
  final AddDishesToMenuCombinationStatus status;
  final List<Dish> dishes;
  final String? errorMessage;

  const AddDishesToMenuCombinationState({
    required this.status,
    required this.dishes,
    this.errorMessage,
  });

  factory AddDishesToMenuCombinationState.initial() {
    return const AddDishesToMenuCombinationState(
      status: AddDishesToMenuCombinationStatus.initial,
      dishes: [],
    );
  }

  factory AddDishesToMenuCombinationState.loading() {
    return const AddDishesToMenuCombinationState(
      status: AddDishesToMenuCombinationStatus.loading,
      dishes: [],
    );
  }

  factory AddDishesToMenuCombinationState.success(List<Dish> dishes) {
    return AddDishesToMenuCombinationState(
      status: AddDishesToMenuCombinationStatus.success,
      dishes: dishes,
    );
  }

  factory AddDishesToMenuCombinationState.error(String errorMessage) {
    return AddDishesToMenuCombinationState(
      status: AddDishesToMenuCombinationStatus.error,
      dishes: [],
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, dishes];
}

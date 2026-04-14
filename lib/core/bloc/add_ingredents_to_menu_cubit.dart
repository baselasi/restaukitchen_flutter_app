import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/repository/ingredients_repo.dart';

class AddIngredientsToMenuCubit extends Cubit<AddIngredientsToMenuState> {
  final IngredientsRepo _ingredientsRepo;
  AddIngredientsToMenuCubit({required IngredientsRepo ingredientsRepo})
    : _ingredientsRepo = ingredientsRepo,
      super(AddIngredientsToMenuState.initial([]));

  Future<void> addIngredientsToMenu(
    String menuId,
    List<String> ingredientsIds,
  ) async {
    emit(AddIngredientsToMenuState.loading(ingredientsIds));
    try {
      final response = await _ingredientsRepo.addIngredientsToMenu(
        menuId,
        ingredientsIds,
      );
      if (!isClosed) {
        emit(
          AddIngredientsToMenuState.success(
            response.ingredients.map((e) => e.id!).toList(),
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(AddIngredientsToMenuState.error(ingredientsIds, e.toString()));
      }
    }
  }
}

enum AddIngredientsToMenuStatus { initial, loading, success, error }

class AddIngredientsToMenuState extends Equatable {
  final AddIngredientsToMenuStatus status;
  final List<String> ingredients;
  final String? errorMessage;
  const AddIngredientsToMenuState({
    required this.status,
    required this.ingredients,
    this.errorMessage,
  });
  factory AddIngredientsToMenuState.initial(List<String> ingredients) {
    return AddIngredientsToMenuState(
      status: AddIngredientsToMenuStatus.initial,
      ingredients: ingredients,
    );
  }
  factory AddIngredientsToMenuState.loading(List<String> ingredients) {
    return AddIngredientsToMenuState(
      status: AddIngredientsToMenuStatus.loading,
      ingredients: ingredients,
    );
  }
  factory AddIngredientsToMenuState.success(List<String> ingredients) {
    return AddIngredientsToMenuState(
      status: AddIngredientsToMenuStatus.success,
      ingredients: ingredients,
    );
  }
  factory AddIngredientsToMenuState.error(
    List<String> ingredients,
    String errorMessage,
  ) {
    return AddIngredientsToMenuState(
      status: AddIngredientsToMenuStatus.error,
      ingredients: ingredients,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, ingredients, errorMessage];
}

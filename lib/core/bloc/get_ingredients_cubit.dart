import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/core/repository/ingredients_repo.dart';

class GetIngredientsCubit extends Cubit<GetIngredientsState> {
  GetIngredientsCubit() : super(GetIngredientsState.initial());

  Future<void> getIngredientsByRestaurantId(String restaurantId) async {
    emit(GetIngredientsState.loading());
    try {
      final ingredients = await IngredientsRepo().getIngredientsByRestaurantId(
        restaurantId,
      );
      emit(GetIngredientsState.loaded(ingredients));
    } catch (e) {
      emit(GetIngredientsState.error(e.toString()));
    }
  }

  Future<void> setIngredients(List<Ingredient> ingredients) async {
    emit(GetIngredientsState.loaded(ingredients));
  }

  @override
  Future<void> close() {
    emit(GetIngredientsState.initial());
    return super.close();
  }
}

enum GetIngredientsStatus { initial, loading, loaded, error }

class GetIngredientsState extends Equatable {
  final List<Ingredient>? ingredients;
  final GetIngredientsStatus status;
  final String? errorMessage;
  const GetIngredientsState({
    this.ingredients,
    required this.status,
    this.errorMessage,
  });
  factory GetIngredientsState.initial() {
    return const GetIngredientsState(
      ingredients: [],
      status: GetIngredientsStatus.initial,
    );
  }
  factory GetIngredientsState.loading() {
    return const GetIngredientsState(
      ingredients: [],
      status: GetIngredientsStatus.loading,
    );
  }

  factory GetIngredientsState.loaded(List<Ingredient> ingredients) {
    return GetIngredientsState(
      ingredients: ingredients,
      status: GetIngredientsStatus.loaded,
    );
  }
  factory GetIngredientsState.error(String errorMessage) {
    return GetIngredientsState(
      ingredients: [],
      status: GetIngredientsStatus.error,
      errorMessage: errorMessage,
    );
  }
  @override
  List<Object?> get props => [ingredients, status, errorMessage];
}

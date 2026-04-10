import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/core/repository/ingredients_repo.dart';
import 'package:restaukitchen_app/page/ingredients_list/bloc/new_ingredient_form_cubit.dart';
import 'package:restaukitchen_app/page/ingredients_list/model/ingredient_post_request.dart';

class PostIngredientCubit extends Cubit<PostIngredientState> {
  final IngredientsRepo _ingredientsRepo;
  PostIngredientCubit({required IngredientsRepo ingredientsRepo})
    : _ingredientsRepo = ingredientsRepo,
      super(PostIngredientState.initial());

  void postIngredient(NewIngredientFormState ingredient) async {
    emit(PostIngredientState.loading());
    try {
      final payload = [IngredientPostRequest.fromFormState(ingredient)];
      final response = await _ingredientsRepo.postIngredient(payload);
      if (!isClosed) {
        emit(PostIngredientState.success(response.ingredients.first));
      }
    } catch (e) {
      if (!isClosed) emit(PostIngredientState.error(e.toString()));
    }
  }

  void updateIngredient(
    NewIngredientFormState ingredient,
    String ingredientId,
  ) async {
    emit(PostIngredientState.loading());
    try {
      final payload = [IngredientPostRequest.fromFormState(ingredient)];
      final response = await _ingredientsRepo.updateIngredient(
        payload,
        ingredientId,
      );
      if (!isClosed) emit(PostIngredientState.success(response.ingredient));
    } catch (e) {
      if (!isClosed) emit(PostIngredientState.error(e.toString()));
    }
  }
}

enum PostIngredientStatus { initial, loading, success, error }

class PostIngredientState extends Equatable {
  final PostIngredientStatus status;
  final Ingredient? ingredient;
  final String? errorMessage;
  const PostIngredientState({
    required this.status,
    this.ingredient,
    this.errorMessage,
  });
  factory PostIngredientState.initial() {
    return const PostIngredientState(status: PostIngredientStatus.initial);
  }
  factory PostIngredientState.loading() {
    return const PostIngredientState(status: PostIngredientStatus.loading);
  }
  factory PostIngredientState.success(Ingredient ingredient) {
    return PostIngredientState(
      status: PostIngredientStatus.success,
      ingredient: ingredient,
    );
  }
  factory PostIngredientState.error(String errorMessage) {
    return PostIngredientState(
      status: PostIngredientStatus.error,
      errorMessage: errorMessage,
    );
  }
  @override
  List<Object?> get props => [status, errorMessage];
}

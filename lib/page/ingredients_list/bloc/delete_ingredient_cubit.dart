import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/repository/ingredients_repo.dart';

class DeleteIngredientCubit extends Cubit<DeleteIngredientState> {
  final IngredientsRepo _ingredientsRepo;
  DeleteIngredientCubit({required IngredientsRepo ingredientsRepo})
    : _ingredientsRepo = ingredientsRepo,
      super(DeleteIngredientState.initial());

  Future<void> deleteIngredient(String ingredientId) async {
    emit(DeleteIngredientState.loading());
    try {
      await _ingredientsRepo.deleteIngredient(ingredientId);
      if (!isClosed) emit(DeleteIngredientState.success());
    } catch (e) {
      if (!isClosed) emit(DeleteIngredientState.error(e.toString()));
    }
  }
}

enum DeleteIngredientStatus { initial, loading, success, error }

class DeleteIngredientState extends Equatable {
  final DeleteIngredientStatus status;
  final String? errorMessage;
  const DeleteIngredientState({required this.status, this.errorMessage});

  factory DeleteIngredientState.initial() {
    return const DeleteIngredientState(status: DeleteIngredientStatus.initial);
  }
  factory DeleteIngredientState.loading() {
    return const DeleteIngredientState(status: DeleteIngredientStatus.loading);
  }
  factory DeleteIngredientState.success() {
    return const DeleteIngredientState(status: DeleteIngredientStatus.success);
  }
  factory DeleteIngredientState.error(String errorMessage) {
    return DeleteIngredientState(
      status: DeleteIngredientStatus.error,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/repository/category_repo.dart';

class DeleteCategoryCubit extends Cubit<DeleteCategoryState> {
  final CategoryRepo _categoryRepo;

  DeleteCategoryCubit({required CategoryRepo categoryRepo})
    : _categoryRepo = categoryRepo,
      super(DeleteCategoryState.initial());

  Future<void> deleteCategory(String id) async {
    emit(DeleteCategoryState.loading());
    try {
      await _categoryRepo.deleteCategory(id);
      emit(DeleteCategoryState.success());
    } catch (e) {
      emit(DeleteCategoryState.error(e.toString()));
    }
  }
}

class DeleteCategoryState extends Equatable {
  final DeleteCategoryStatus status;
  final String? error;

  const DeleteCategoryState({required this.status, required this.error});

  factory DeleteCategoryState.initial() {
    return const DeleteCategoryState(
      status: DeleteCategoryStatus.initial,
      error: null,
    );
  }

  factory DeleteCategoryState.loading() {
    return const DeleteCategoryState(
      status: DeleteCategoryStatus.loading,
      error: null,
    );
  }

  factory DeleteCategoryState.success() {
    return const DeleteCategoryState(
      status: DeleteCategoryStatus.success,
      error: null,
    );
  }

  factory DeleteCategoryState.error(String error) {
    return DeleteCategoryState(
      status: DeleteCategoryStatus.error,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}

enum DeleteCategoryStatus { initial, loading, success, error }

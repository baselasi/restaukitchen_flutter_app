import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/category.dart';
import 'package:restaukitchen_app/core/repository/category_repo.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  final CategoryRepo _categoryRepo;

  CreateCategoryCubit({required CategoryRepo categoryRepo})
    : _categoryRepo = categoryRepo,
      super(CreateCategoryState.initial());

  Future<void> createCategory(String name, String? id) async {
    emit(CreateCategoryState.loading());
    try {
      if (id != null) {
        await _categoryRepo.updateCategory(
          CreateCategoryRequest(name: name, id: id),
        );
      } else {
        await _categoryRepo.createCategory(
          CreateCategoryRequest(name: name, id: id),
        );
      }
      if (!isClosed) emit(CreateCategoryState.success());
    } catch (e) {
      if (!isClosed) emit(CreateCategoryState.error(e.toString()));
    }
  }
}

enum CreateCategoryStatus { initial, loading, success, error }

class CreateCategoryState extends Equatable {
  final CreateCategoryStatus status;
  final String? error;

  const CreateCategoryState({required this.status, required this.error});

  factory CreateCategoryState.initial() {
    return const CreateCategoryState(
      status: CreateCategoryStatus.initial,
      error: null,
    );
  }

  factory CreateCategoryState.loading() {
    return const CreateCategoryState(
      status: CreateCategoryStatus.loading,
      error: null,
    );
  }

  factory CreateCategoryState.success() {
    return CreateCategoryState(
      status: CreateCategoryStatus.success,
      error: null,
    );
  }

  factory CreateCategoryState.error(String error) {
    return CreateCategoryState(
      status: CreateCategoryStatus.error,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}

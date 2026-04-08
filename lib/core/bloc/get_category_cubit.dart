import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/repository/category_repo.dart';
import 'package:restaukitchen_app/core/models/category.dart';

class GetCategoryCubit extends Cubit<GetCategoryCubitState> {
  GetCategoryCubit()
    : super(
        GetCategoryCubitState(
          categories: [],
          status: CategorySelectorStatus.initial,
        ),
      );

  Future<void> getCategories() async {
    emit(
      GetCategoryCubitState(
        categories: [],
        status: CategorySelectorStatus.loading,
      ),
    );
    try {
      final categoriesResponse = await CategoryRepo().getCategories();
      final categories = categoriesResponse.categories;
      emit(
        GetCategoryCubitState(
          categories: categories,
          status: CategorySelectorStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        GetCategoryCubitState(
          categories: [],
          status: CategorySelectorStatus.error,
        ),
      );
    }
  }
}

enum CategorySelectorStatus { initial, loading, loaded, error }

class GetCategoryCubitState extends Equatable {
  final List<Category> categories;
  final CategorySelectorStatus status;

  const GetCategoryCubitState({required this.categories, required this.status});

  @override
  List<Object?> get props => [categories, status];
}

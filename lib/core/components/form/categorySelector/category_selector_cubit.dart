import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/repository/category_repo.dart';
import 'package:restaukitchen_app/core/models/category.dart';

class CategorySelectorCubit extends Cubit<CategorySelectorState> {
  CategorySelectorCubit()
    : super(
        CategorySelectorState(
          categories: [],
          selectedCategory: null,
          status: CategorySelectorStatus.initial,
        ),
      );

  Future<void> getCategories(Category? selectedCategory) async {
    emit(
      CategorySelectorState(
        categories: [],
        selectedCategory: null,
        status: CategorySelectorStatus.loading,
      ),
    );
    try {
      final categoriesResponse = await CategoryRepo().getCategories();
      final categories = categoriesResponse.categories;
      emit(
        CategorySelectorState(
          categories: categories,
          selectedCategory: selectedCategory,
          status: CategorySelectorStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        CategorySelectorState(
          categories: [],
          selectedCategory: null,
          status: CategorySelectorStatus.error,
        ),
      );
    }
  }

  Future<void> selectCategory(Category category) async {
    emit(
      CategorySelectorState(
        categories: state.categories,
        selectedCategory: category,
        status: CategorySelectorStatus.loaded,
      ),
    );
  }
}

enum CategorySelectorStatus { initial, loading, loaded, error }

class CategorySelectorState extends Equatable {
  final List<Category> categories;
  final Category? selectedCategory;
  final CategorySelectorStatus status;

  const CategorySelectorState({
    required this.categories,
    required this.selectedCategory,
    required this.status,
  });

  @override
  List<Object?> get props => [categories, selectedCategory, status];
}

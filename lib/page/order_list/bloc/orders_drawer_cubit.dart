import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_repo.dart';
import 'package:restaukitchen_app/core/models/category.dart';

class OrdersCategoryCubit extends Cubit<OrdersCategoryState> {
  final CategoryRepo _categoryRepo;
  OrdersCategoryCubit({required CategoryRepo categoryRepo})
    : _categoryRepo = categoryRepo,
      super(OrdersCategoryState.initial());

  Future<void> getCategories() async {
    emit(OrdersCategoryState.loading());
    try {
      final categories = await _categoryRepo.getCategories();
      emit(OrdersCategoryState.loaded(categories.categories));
    } catch (e) {
      emit(OrdersCategoryState.error(e.toString()));
    }
  }
}

enum OrdersCategoryStatus { initial, loading, loaded, error }

class OrdersCategoryState extends Equatable {
  final List<Category> categories;
  final OrdersCategoryStatus status;
  final String? errorMessage;
  @override
  List<Object?> get props => [categories, status, errorMessage];

  const OrdersCategoryState({
    required this.categories,
    required this.status,
    this.errorMessage,
  });

  factory OrdersCategoryState.initial() {
    return const OrdersCategoryState(
      categories: [],
      status: OrdersCategoryStatus.initial,
    );
  }

  factory OrdersCategoryState.loading() {
    return const OrdersCategoryState(
      categories: [],
      status: OrdersCategoryStatus.loading,
    );
  }

  factory OrdersCategoryState.loaded(List<Category> categories) {
    return OrdersCategoryState(
      categories: categories,
      status: OrdersCategoryStatus.loaded,
    );
  }

  factory OrdersCategoryState.error(String error) {
    return OrdersCategoryState(
      categories: [],
      status: OrdersCategoryStatus.error,
      errorMessage: error,
    );
  }
}

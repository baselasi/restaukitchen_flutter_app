import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';

class CombinationMenuCreationFormCubit
    extends Cubit<CombinationMenuCreationFormState> {
  CombinationMenuCreationFormCubit()
    : super(CombinationMenuCreationFormState.initial());

  void addMenu(CombinationMenuModel menu) {
    emit(state.copyWith(combinationMenus: [...state.combinationMenus, menu]));
  }

  void removeMenu(String menuId) {
    emit(
      state.copyWith(
        combinationMenus: state.combinationMenus
            .where((m) => m.id != menuId)
            .toList(),
      ),
    );
  }

  void addIngredientToMenu(String menuId, List<Ingredient> ingredient) {
    final menus = state.combinationMenus.map((menu) {
      if (menu.id != menuId) return menu;
      return menu.copyWith(ingredients: [...menu.ingredients, ...ingredient]);
    }).toList();
    emit(state.copyWith(combinationMenus: menus));
  }

  void addDishToMenu(String menuId, List<Dish> dish) {
    final menus = state.combinationMenus.map((menu) {
      if (menu.id != menuId) return menu;
      return menu.copyWith(dishes: [...menu.dishes, ...dish]);
    }).toList();
    emit(state.copyWith(combinationMenus: menus));
  }

  void removeDishAt(String menuId, int dishIndex) {
    final menus = state.combinationMenus.map((menu) {
      if (menu.id != menuId) return menu;
      final dishes = List<Dish>.from(menu.dishes)..removeAt(dishIndex);
      return menu.copyWith(dishes: dishes);
    }).toList();
    emit(state.copyWith(combinationMenus: menus));
  }
}

class CombinationMenuCreationFormState extends Equatable {
  final String combinationName;
  final String combinationId;
  final List<CombinationMenuModel> combinationMenus;

  const CombinationMenuCreationFormState({
    required this.combinationName,
    required this.combinationId,
    required this.combinationMenus,
  });

  factory CombinationMenuCreationFormState.initial() {
    return const CombinationMenuCreationFormState(
      combinationName: '',
      combinationId: '',
      combinationMenus: [],
    );
  }

  CombinationMenuCreationFormState copyWith({
    String? combinationName,
    String? combinationId,
    List<CombinationMenuModel>? combinationMenus,
  }) {
    return CombinationMenuCreationFormState(
      combinationName: combinationName ?? this.combinationName,
      combinationId: combinationId ?? this.combinationId,
      combinationMenus: combinationMenus ?? this.combinationMenus,
    );
  }

  bool get haveEmtyMenus => combinationMenus.every((menu) => !menu.haveDishes);

  @override
  List<Object?> get props => [combinationName, combinationId, combinationMenus];
}

class CombinationMenuModel extends Equatable {
  final String id;
  final String name;
  final List<Ingredient> ingredients;
  final List<Dish> dishes;

  const CombinationMenuModel({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.dishes,
  });

  CombinationMenuModel copyWith({
    List<Ingredient>? ingredients,
    List<Dish>? dishes,
  }) {
    return CombinationMenuModel(
      id: id,
      name: name,
      ingredients: ingredients ?? this.ingredients,
      dishes: dishes ?? this.dishes,
    );
  }

  bool get haveDishes => dishes.isNotEmpty;
  bool get haveIngredients => ingredients.isNotEmpty;

  @override
  List<Object?> get props => [id, name, ingredients, dishes];
}

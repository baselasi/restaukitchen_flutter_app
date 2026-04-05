import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/page/combination_page/models/combination.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

class CombinationMenuCreationFormCubit
    extends Cubit<CombinationMenuCreationFormState> {
  CombinationMenuCreationFormCubit()
    : super(CombinationMenuCreationFormState.initial());

  void addMenu(CombinationMenuModel menu) {
    emit(state.copyWith(combinationMenus: [...state.combinationMenus, menu]));
  }

  void createStateFromCombination(Combination combination) {
    emit(
      CombinationMenuCreationFormState(
        combinationName: combination.name,
        combinationId: combination.id,
        combinationMenus: combination.menuList
            .map((menu) => CombinationMenuModel.fromCombinationMenu(menu))
            .toList(),
        status: CombinationMenuCreationFormStatus.initial,
      ),
    );
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

  void removeDishAt(String menuId, String dishId) {
    final menus = state.combinationMenus.map((menu) {
      if (menu.id != menuId) return menu;
      final dishes = List<Dish>.from(menu.dishes)
        ..removeWhere((dish) => dish.id == dishId);
      return menu.copyWith(dishes: dishes);
    }).toList();
    emit(state.copyWith(combinationMenus: menus));
  }

  void replaceMenuDishes(String menuId, List<Dish> dishes) {
    final menu = state.combinationMenus.firstWhere((menu) => menu.id == menuId);
    emit(
      state.copyWith(
        combinationMenus: [
          ...state.combinationMenus,
          menu.copyWith(dishes: dishes),
        ],
      ),
    );
  }
}

enum CombinationMenuCreationFormStatus { initial, loading, success, error }

class CombinationMenuCreationFormState extends Equatable {
  final String combinationName;
  final String combinationId;
  final List<CombinationMenuModel> combinationMenus;
  final CombinationMenuCreationFormStatus status;

  const CombinationMenuCreationFormState({
    required this.combinationName,
    required this.combinationId,
    required this.combinationMenus,
    required this.status,
  });

  factory CombinationMenuCreationFormState.initial() {
    return const CombinationMenuCreationFormState(
      combinationName: '',
      combinationId: '',
      combinationMenus: [],
      status: CombinationMenuCreationFormStatus.initial,
    );
  }

  CombinationMenuCreationFormState copyWith({
    String? combinationName,
    String? combinationId,
    List<CombinationMenuModel>? combinationMenus,
    CombinationMenuCreationFormStatus? status,
  }) {
    return CombinationMenuCreationFormState(
      combinationName: combinationName ?? this.combinationName,
      combinationId: combinationId ?? this.combinationId,
      combinationMenus: combinationMenus ?? this.combinationMenus,
      status: status ?? this.status,
    );
  }

  bool get haveEmtyMenus => combinationMenus.every((menu) => !menu.haveDishes);

  @override
  List<Object?> get props => [
    combinationName,
    combinationId,
    combinationMenus,
    status,
  ];
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

  factory CombinationMenuModel.fromCombinationMenu(Menu menu) {
    return CombinationMenuModel(
      id: menu.id,
      name: menu.name,
      ingredients: menu.ingredients,
      dishes: menu.dishes,
    );
  }

  bool get haveDishes => dishes.isNotEmpty;
  bool get haveIngredients => ingredients.isNotEmpty;

  @override
  List<Object?> get props => [id, name, ingredients, dishes];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

/// Map value: ingredient id → how many + the [Ingredient] instance.
class IngredientSelection extends Equatable {
  final int quantity;
  final Ingredient ingredient;

  const IngredientSelection({required this.quantity, required this.ingredient});

  IngredientSelection copyWith({int? quantity, Ingredient? ingredient}) {
    return IngredientSelection(
      quantity: quantity ?? this.quantity,
      ingredient: ingredient ?? this.ingredient,
    );
  }

  @override
  List<Object?> get props => [quantity, ingredient];
}

/// Counts how many times each ingredient id appears across [dishes] (duplicate
/// ids in [DishesWithIngredients.ingredientsId] each add one). Resolves
/// [Ingredient] from [ingredientsCatalog], or builds one from parallel names.
Map<String, IngredientSelection> aggregateIngredientSelectionsFromDishes(
  Iterable<DishesWithIngredients> dishes,
  List<Ingredient> ingredientsCatalog,
) {
  final counts = <String, int>{};
  final nameById = <String, String>{};

  for (final dish in dishes) {
    final ids = dish.ingredientsId;
    final names = dish.ingredientsName;
    for (var i = 0; i < ids.length; i++) {
      final id = ids[i];
      counts[id] = (counts[id] ?? 0) + 1;
      if (i < names.length && names[i].isNotEmpty) {
        nameById[id] = names[i];
      }
    }
  }

  Ingredient ingredientForId(String id) {
    for (final ing in ingredientsCatalog) {
      if (ing.id == id) return ing;
    }
    return Ingredient(id: id, name: nameById[id] ?? '');
  }

  return {
    for (final MapEntry(:key, :value) in counts.entries)
      key: IngredientSelection(
        quantity: value,
        ingredient: ingredientForId(key),
      ),
  };
}

class CombinationMenuSectionCubit extends Cubit<CombinationMenuSectionState> {
  final Menu menu;

  CombinationMenuSectionCubit({required this.menu})
    : super(CombinationMenuSectionState());

  void initialize(DishesWithIngredients dishesWithIngredients) {
    emit(
      state.copyWith(
        selectedDish: menu.dishes.firstWhere(
          (dish) => dish.id == dishesWithIngredients.dishId,
        ),
        ingredientSelections: _getIngredientSelections(dishesWithIngredients),
      ),
    );
  }

  Map<String, IngredientSelection> _getIngredientSelections(
    DishesWithIngredients dishesWithIngredients,
  ) {
    return aggregateIngredientSelectionsFromDishes([
      dishesWithIngredients,
    ], menu.ingredients);
  }

  void selectDish(Dish dish) {
    emit(state.copyWith(selectedDish: dish, ingredientSelections: const {}));
  }

  void incrementIngredientQuantity(String ingredientId, Ingredient ingredient) {
    final existing = state.ingredientSelections[ingredientId];
    final current = existing?.quantity ?? 0;
    emit(
      state.copyWith(
        ingredientSelections: {
          ...state.ingredientSelections,
          ingredientId: IngredientSelection(
            quantity: current + 1,
            ingredient: ingredient,
          ),
        },
      ),
    );
  }

  void decrementIngredientQuantity(String ingredientId) {
    final existing = state.ingredientSelections[ingredientId];
    if (existing == null) return;
    final current = existing.quantity;
    if (current <= 1) {
      final next = Map<String, IngredientSelection>.from(
        state.ingredientSelections,
      )..remove(ingredientId);
      emit(state.copyWith(ingredientSelections: next));
    } else {
      emit(
        state.copyWith(
          ingredientSelections: {
            ...state.ingredientSelections,
            ingredientId: existing.copyWith(quantity: current - 1),
          },
        ),
      );
    }
  }

  // void toggleActive() {
  //   emit(state.copyWith(isActive: !state.isActive));
  // }
}

class CombinationMenuSectionState extends Equatable {
  final Dish? selectedDish;

  /// Ingredient id (or synthetic key) → quantity + [Ingredient].
  final Map<String, IngredientSelection> ingredientSelections;

  const CombinationMenuSectionState({
    this.selectedDish,
    this.ingredientSelections = const {},
  });

  CombinationMenuSectionState copyWith({
    Dish? selectedDish,
    Map<String, IngredientSelection>? ingredientSelections,
  }) {
    return CombinationMenuSectionState(
      selectedDish: selectedDish ?? this.selectedDish,
      ingredientSelections: ingredientSelections ?? this.ingredientSelections,
    );
  }

  @override
  List<Object?> get props => [selectedDish, ingredientSelections];
}

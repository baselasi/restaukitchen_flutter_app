import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

/// Map value: ingredient id → how many + the [Ingredient] instance.
class IngredientSelection extends Equatable {
  final int quantity;
  final Ingredient ingredient;

  const IngredientSelection({
    required this.quantity,
    required this.ingredient,
  });

  IngredientSelection copyWith({int? quantity, Ingredient? ingredient}) {
    return IngredientSelection(
      quantity: quantity ?? this.quantity,
      ingredient: ingredient ?? this.ingredient,
    );
  }

  @override
  List<Object?> get props => [quantity, ingredient];
}

class CombinationMenuSectionCubit extends Cubit<CombinationMenuSectionState> {
  final Menu menu;
  CombinationMenuSectionCubit({required this.menu})
    : super(CombinationMenuSectionState(isActive: false));

  void selectDish(Dish dish) {
    emit(
      state.copyWith(
        selectedDish: dish,
        ingredientSelections: const {},
      ),
    );
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
  final bool isActive;
  final Dish? selectedDish;
  /// Ingredient id (or synthetic key) → quantity + [Ingredient].
  final Map<String, IngredientSelection> ingredientSelections;

  const CombinationMenuSectionState({
    required this.isActive,
    this.selectedDish,
    this.ingredientSelections = const {},
  });

  CombinationMenuSectionState copyWith({
    bool? isActive,
    Dish? selectedDish,
    Map<String, IngredientSelection>? ingredientSelections,
  }) {
    return CombinationMenuSectionState(
      isActive: isActive ?? this.isActive,
      selectedDish: selectedDish ?? this.selectedDish,
      ingredientSelections:
          ingredientSelections ?? this.ingredientSelections,
    );
  }

  @override
  List<Object?> get props => [isActive, selectedDish, ingredientSelections];
}

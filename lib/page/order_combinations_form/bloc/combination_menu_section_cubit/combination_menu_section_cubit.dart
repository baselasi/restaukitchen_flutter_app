import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

class CombinationMenuSectionCubit extends Cubit<CombinationMenuSectionState> {
  final Menu menu;
  CombinationMenuSectionCubit({required this.menu})
    : super(CombinationMenuSectionState(isActive: false));

  void selectDish(Dish dish) {
    emit(
      state.copyWith(
        selectedDish: dish,
        ingredientQuantities: const {},
      ),
    );
  }

  void incrementIngredientQuantity(String ingredientKey) {
    final current = state.ingredientQuantities[ingredientKey] ?? 0;
    emit(
      state.copyWith(
        ingredientQuantities: {
          ...state.ingredientQuantities,
          ingredientKey: current + 1,
        },
      ),
    );
  }

  void decrementIngredientQuantity(String ingredientKey) {
    final current = state.ingredientQuantities[ingredientKey] ?? 0;
    if (current <= 1) {
      final next = Map<String, int>.from(state.ingredientQuantities)
        ..remove(ingredientKey);
      emit(state.copyWith(ingredientQuantities: next));
    } else {
      emit(
        state.copyWith(
          ingredientQuantities: {
            ...state.ingredientQuantities,
            ingredientKey: current - 1,
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
  /// Counts per ingredient (key from [ingredientKey] in the UI layer).
  final Map<String, int> ingredientQuantities;

  const CombinationMenuSectionState({
    required this.isActive,
    this.selectedDish,
    this.ingredientQuantities = const {},
  });

  CombinationMenuSectionState copyWith({
    bool? isActive,
    Dish? selectedDish,
    Map<String, int>? ingredientQuantities,
  }) {
    return CombinationMenuSectionState(
      isActive: isActive ?? this.isActive,
      selectedDish: selectedDish ?? this.selectedDish,
      ingredientQuantities: ingredientQuantities ?? this.ingredientQuantities,
    );
  }

  @override
  List<Object?> get props => [isActive, selectedDish, ingredientQuantities];
}

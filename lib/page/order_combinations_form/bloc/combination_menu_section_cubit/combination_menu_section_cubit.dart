import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

class CombinationMenuSectionCubit extends Cubit<CombinationMenuSectionState> {
  final Menu menu;
  CombinationMenuSectionCubit({required this.menu})
    : super(CombinationMenuSectionState(isActive: false));

  void selectDish(Dish dish) {
    emit(state.copyWith(selectedDish: dish));
  }

  void addIngredients(Ingredient ingredients) {
    final selectedIngredients = [...state.selectedIngredients, ingredients];
    emit(state.copyWith(selectedIngredients: selectedIngredients));
  }

  // void toggleActive() {
  //   emit(state.copyWith(isActive: !state.isActive));
  // }
}

class CombinationMenuSectionState extends Equatable {
  final bool isActive;
  final Dish? selectedDish;
  final List<Ingredient> selectedIngredients;
  const CombinationMenuSectionState({
    required this.isActive,
    this.selectedDish,
    this.selectedIngredients = const [],
  });

  CombinationMenuSectionState copyWith({
    bool? isActive,
    Dish? selectedDish,
    List<Ingredient>? selectedIngredients,
  }) {
    return CombinationMenuSectionState(
      isActive: isActive ?? this.isActive,
      selectedDish: selectedDish ?? this.selectedDish,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
    );
  }

  @override
  List<Object?> get props => [isActive, selectedDish, selectedIngredients];
}

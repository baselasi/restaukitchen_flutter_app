import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_dimension_creation_cubit/combination_dimension_creation_cubit.dart';

class NewIngredientFormCubit extends Cubit<NewIngredientFormState> {
  NewIngredientFormCubit() : super(NewIngredientFormState.initial());

  void setName(String name) {
    emit(state.copyWith(name: name));
  }

  void setDimensionEntry(String id, Dimension dimension, {String? price}) {
    emit(
      state.copyWith(
        dimensionsById: Map.from(state.dimensionsById)
          ..[id] = DimensionWithPrice(dimension: dimension, price: price ?? ''),
      ),
    );
  }

  void removeDimensionEntry(String id) {
    emit(
      state.copyWith(
        dimensionsById: Map.from(state.dimensionsById)..remove(id),
      ),
    );
  }

  void updatePrice(String id, String price) {
    final entry = state.dimensionsById[id];
    if (entry == null) return;
    final next = Map<String, DimensionWithPrice>.from(state.dimensionsById);
    next[id] = entry.copyWith(price: price);
    emit(state.copyWith(dimensionsById: next));
  }

  Future<void> createStateFromIngredient(Ingredient ingredient) async {
    final dimensionsById = <String, DimensionWithPrice>{};
    for (final dimensionAssignment in ingredient.dimensionAssignments) {
      dimensionsById[dimensionAssignment.dimension.id!] = DimensionWithPrice(
        dimension: dimensionAssignment.dimension,
        price: dimensionAssignment.price.toString(),
      );
    }
    emit(state.copyWith(name: ingredient.name, dimensionsById: dimensionsById));
  }
}

class NewIngredientFormState extends Equatable {
  final String name;
  final Map<String, DimensionWithPrice> dimensionsById;

  const NewIngredientFormState({
    required this.name,
    required this.dimensionsById,
  });

  factory NewIngredientFormState.initial() {
    return const NewIngredientFormState(name: '', dimensionsById: {});
  }

  NewIngredientFormState copyWith({
    String? name,
    Map<String, DimensionWithPrice>? dimensionsById,
  }) {
    return NewIngredientFormState(
      name: name ?? this.name,
      dimensionsById: dimensionsById ?? this.dimensionsById,
    );
  }

  bool get isValid {
    if (name.trim().isEmpty) return false;
    if (dimensionsById.isEmpty) return false;
    for (final entry in dimensionsById.values) {
      if (entry.dimension.id == null || entry.dimension.id!.trim().isEmpty) {
        return false;
      }
      if (double.tryParse(entry.price.trim()) == null ||
          double.parse(entry.price.trim()) <= 0) {
        return false;
      }
    }
    return true;
  }

  @override
  List<Object?> get props => [name, dimensionsById];
}
